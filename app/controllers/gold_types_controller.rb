class GoldTypesController < ApplicationController
  before_action :require_login

  def index
  	search = filter_search params
    @search = search[0]
    @gold_types = search[1]
    @params = params.to_s

    respond_to do |format|
      format.html do
        @gold_types = search[1].page param_page
      end
      format.pdf do
        @recap_type = "fix cost"
        new_params = eval(params[:option])
        filter = filter_search new_params
        @search = filter[0]
        @gold_types = filter[1]
        render pdf: DateTime.now.to_i.to_s,
          layout: 'pdf_layout.html.erb',
          template: "gold_types/print.html.slim"
      end
    end
  end

  def show
  	return redirect_back_data_error gold_types_path, "Data tidak ditemukan" if params[:id].nil?
  	@gold_type = GoldType.find_by(id: params[:id])
  	return redirect_back_data_error gold_types_path, "Data tidak ditemukan" if @gold_type.nil?
  end

  def new
  end

  def create
  	gold_type = GoldType.new gold_params
    return redirect_back_data_error new_user_path, "Data tidak valid!" if gold_type.invalid?
    gold_type.save!
    gold_type.create_activity :create, owner: current_user
    return redirect_success gold_type_path(id: gold_type.id), "Jenis Emas berhasil ditambahkan"
  end

  def destroy
  	return redirect_back_data_error gold_types_path, "Data tidak ditemukan" if params[:id].nil?
  	gold = GoldType.find_by(id: params[:id])
  	return redirect_back_data_error gold_types_path, "Data tidak ditemukan" if gold.nil?
  	return redirect_back_data_error gold_types_path, "Data tidak dapat dihapus" if gold.items.count > 0
  	gold_name = gold.name
  	gold.destroy
  	return redirect_success gold_types_path, "Data Jenis Emas - " + gold_name + " berhasil dihapus"
  end

  def edit
  	return redirect_back_data_error gold_types_path, "Data tidak ditemukan" if params[:id].nil?
  	@gold = GoldType.find_by(id: params[:id])
  	return redirect_back_data_error gold_types_path, "Data tidak ditemukan" if @gold.nil?
  end

  def update
  	return redirect_back_data_error gold_types_path, "Data tidak ditemukan" if params[:id].nil?
  	gold = GoldType.find_by(id: params[:id])
  	return redirect_back_data_error gold_types_path, "Data tidak ditemukan" if gold.nil?
  	gold.assign_attributes gold_params
  	changes = gold.changes
    gold.save! if gold.changed?
    gold.create_activity :edit, owner: current_user, parameters: changes
    return redirect_success gold_type_path(id: gold.id), "Data Jenis Emas - " + gold.name + " - Berhasil Diubah"

  end

  private
    def filter_search params
      results = []
      gold_types = GoldType.all
      search_text = ""
      if params["search"].present?
        search_text += " '"+params["search"]+"'"
        search = params["search"].downcase
        gold_types = gold_types.where("lower(name) like ?", "%"+ search+"%")
      end

      search_text = "Pencarian" + search_text if search_text != ""
      return search_text, gold_types
    end

    def gold_params
      params.require(:gold).permit(
        :name
      )
    end

    def param_page
      params[:page]
    end
end