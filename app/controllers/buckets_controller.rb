class BucketsController < ApplicationController
  before_action :require_login

  def index
  	search = filter_search params

    @search = search[0]
    @buckets = search[1]

    respond_to do |format|
      format.html do
        @buckets = search[1].page param_page
      end
    end

  end

  def show
  	return redirect_back_data_error buckets_path, "Data tidak ditemukan" if params[:id].nil?
  	@bucket = Bucket.find_by(id: params[:id])
  	return redirect_back_data_error buckets_path, "Data tidak ditemukan" if @bucket.nil?
    
    respond_to do |format|
      format.html do
      end
      format.pdf do
        @items = @bucket.items.order("code ASC")
        @recap_type = "bucket"
        render pdf: DateTime.now.to_i.to_s,
          layout: 'pdf_layout.html.erb',
          template: "buckets/print.html.slim"
      end
    end
  end

  def new
  end

  def create
  	bucket = Bucket.new bucket_params
    bucket.store = current_user.store
    return redirect_back_data_error new_user_path, "Data tidak valid!" if bucket.invalid?
    bucket.save!
    bucket.create_activity :create, owner: current_user
    return redirect_success bucket_path(id: bucket.id), "Jenis Emas berhasil ditambahkan"
  end

  def destroy
  	return redirect_back_data_error buckets_path, "Data tidak ditemukan" if params[:id].nil?
  	bucket = Bucket.find_by(id: params[:id])
  	return redirect_back_data_error buckets_path, "Data tidak ditemukan" if bucket.nil?
  	return redirect_back_data_error buckets_path, "Data tidak dapat dihapus" if bucket.items.count > 0
  	bucket_name = bucket.name
  	bucket.destroy
  	return redirect_success buckets_path, "Data Baki - " + bucket_name + " berhasil dihapus"
  end

  def edit
  	return redirect_back_data_error buckets_path, "Data tidak ditemukan" if params[:id].nil?
  	@bucket = Bucket.find_by(id: params[:id])
  	return redirect_back_data_error buckets_path, "Data tidak ditemukan" if @bucket.nil?
  end

  def update
  	return redirect_back_data_error buckets_path, "Data tidak ditemukan" if params[:id].nil?
  	bucket = Bucket.find_by(id: params[:id])
  	return redirect_back_data_error buckets_path, "Data tidak ditemukan" if bucket.nil?
  	bucket.assign_attributes bucket_params
  	changes = bucket.changes
    bucket.save! if bucket.changed?
    bucket.create_activity :edit, owner: current_user, parameters: changes
    return redirect_success bucket_path(id: bucket.id), "Data Jenis Emas - " + bucket.name + " - Berhasil Diubah"

  end

  private
    def filter_search params
      results = []
      buckets = Bucket.all
      buckets = buckets.where(store: current_user.store) if !["owner", "super_admin"].include? current_user.level
      search_text = ""
      if params["search"].present?
        search_text += " '"+params["search"]+"'"
        search = params["search"].downcase
        buckets = buckets.where("lower(name) like ?", "%"+ search+"%")
      end

      if params["store_id"].present?
        store = Store.find_by(id: params["store_id"])
        if store.present?
          buckets = buckets.where(store: store)
          search_text += " pada Toko '" + store.name + "'"
        end
      end

      search_text = "Pencarian" + search_text if search_text != ""
      return search_text, buckets
    end

    def bucket_params
      params.require(:bucket).permit(
        :name
      )
    end

    def param_page
      params[:page]
    end
end