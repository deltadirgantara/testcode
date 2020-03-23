class UsersController < ApplicationController
  before_action :require_login
  before_action :require_fingerprint
  
  def index
    search = filter_search params
    @search = search[0]
    @users = search[1]
    @store = search[2]
    @params = params.to_s

    respond_to do |format|
      format.html do
        @users = search[1].page param_page
      end
      format.pdf do
        @recap_type = "user"
        new_params = eval(params[:option])
        filter = filter_search new_params
        @search = filter[0]
        @users = filter[1]
        @store = filter[2]
        render pdf: DateTime.now.to_i.to_s,
          layout: 'pdf_layout.html.erb',
          template: "users/print.html.slim"
      end
    end
  end

  def show
    return redirect_back_data_error users_path, "Data Pengguna Tidak Ditemukan" unless params[:id].present?
    @user = User.find_by_id params[:id]
    if !["owner", "super_admin", "finance"].include? current_user.level
      if @user != current_user
        return redirect_back_data_error users_path, "Data Pengguna Tidak Ditemukan" unless @user.present?
      end
    end
    return redirect_back_data_error users_path, "Data Pengguna Tidak Ditemukan" unless @user.present?
  end

  def new
    @stores = Store.all
  end

  def create
    user = User.new user_params
    return redirect_back_data_error new_user_path, "Data Pengguna Tidak Ditemukan" if user.invalid?
    user.save!
    user.create_activity :create, owner: current_user
    return redirect_success users_path, "Pengguna - " + user.name + " - Berhasil Ditambahkan"
  end

  def edit
    return redirect_back_data_error users_path, "Data Pengguna Tidak Ditemukan" unless params[:id].present?
    @user = User.find_by_id params[:id]
    if !["owner", "super_admin"].include? current_user.level
      if @user != current_user
        return redirect_back_data_error users_path, "Data Pengguna Tidak Ditemukan" unless @user.present?
      end
    end
    @stores = Store.all
    return redirect_back_data_error users_path, "Data Pengguna Tidak Ditemukan" unless @user.present?
  end

  def update
    return redirect_back_data_error users_path, "Data Pengguna Tidak Ditemukan" unless params[:id].present?
    user = User.find_by_id params[:id]
    return redirect_back_data_error users_path, "Data Pengguna Tidak Ditemukan" unless user.present?
    file = params[:user][:image]
    upload_io = params[:user][:image]
    if file.present?
      filename = Digest::SHA1.hexdigest([Time.now, rand].join).to_s+File.extname(file.path).to_s
      File.open(Rails.root.join('public', 'uploads', 'profile_picture', filename), 'wb') do |file|
        file.write(upload_io.read)
      end
      user.image = filename
    end

    param = user_params
    if user != current_user
      param = user_params.delete("password")
    end

    user.assign_attributes user_params
    changes = user.changes
    user.save! if user.changed?
    user.create_activity :edit, owner: current_user, parameters: changes
    return redirect_success user_path(id: user.id), "Data Pengguna - " + user.name + " - Berhasil Diubah"
  end

  def destroy
    return redirect_back_data_error users_path, "Data Tidak Valid" unless params[:id].present?
    user = User.find params[:id]
    return redirect_back_data_error users_path, "Data Tidak Valid" unless user.present?
    if user.level == "owner" || user.level == "super_admin"
      return redirect_back_data_error users_path, "Data Tidak Valid" 
    else 
      user.destroy
      return redirect_success users_path, "Data Pengguna - " + user.name + " - Berhasil Dihapus"
    end
  end

  def recap
    return redirect_back_data_error users_path, "Data Pengguna Tidak Ditemukan" unless params[:id].present?
    @user = User.find_by_id params[:id]
    @kasbon = 0
    @piutang = 0

  end

  private
    def filter_search params
      results = []
      users = User.all
      users = users.where(store: current_user.store) if !["owner", "super_admin"].include? current_user.level
      search_text = ""
      if params["search"].present?
        search_text += " '"+params["search"]+"'"
        search = params["search"].downcase
        users = users.where("lower(name) like ?", "%"+ search+"%")
      end

      store = nil
      if params["store_id"].present?
        store = Store.find_by(id: params["store_id"])
        if store.present?
          users = users.where(store: store)
          search_text += " di Toko '" + store.name + "'"
        end
      end

      search_text = "Pencarian" + search_text if search_text != ""
      return search_text, users , store
    end

    def user_params
      params.require(:user).permit(
        :name, :email, :password, :level, :phone, :sex, :store_id, :id_card, :address, :fingerprint, :salary
      )
    end

    def param_page
      params[:page]
    end
end
