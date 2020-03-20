class CategoriesController < ApplicationController
  before_action :require_login

  def index
    search = filter_search params

    @search = search[0]
    @categories = search[1]

    respond_to do |format|
      format.html do
        @categories = search[1].page param_page
      end
    end

  end

  def show
  	return redirect_back_data_error categories_path, "Data tidak ditemukan" if params[:id].nil?
  	@category = Category.find_by(id: params[:id])
  	return redirect_back_data_error categories_path, "Data tidak ditemukan" if @category.nil?

    respond_to do |format|
      format.html do
      end
      format.pdf do
        @recap_type = "category"
        render pdf: DateTime.now.to_i.to_s,
          layout: 'pdf_layout.html.erb',
          template: "categories/print.html.slim"
      end
    end

  end

  def new
  end

  def create
  	category = Category.new category_params
    return redirect_back_data_error new_user_path, "Data tidak valid!" if category.invalid?
    category.save!
    category.create_activity :create, owner: current_user
    return redirect_success category_path(id: category.id), "Jenis Emas berhasil ditambahkan"
  end

  def destroy
  	return redirect_back_data_error categories_path, "Data tidak ditemukan" if params[:id].nil?
  	category = Category.find_by(id: params[:id])
  	return redirect_back_data_error categories_path, "Data tidak ditemukan" if category.nil?
  	return redirect_back_data_error categories_path, "Data tidak dapat dihapus" if category.sub_categories.count > 0
  	category_name = category.name
  	category.destroy
  	return redirect_success categories_path, "Data Jenis Emas - " + category_name + " berhasil dihapus"
  end

  def edit
  	return redirect_back_data_error categories_path, "Data tidak ditemukan" if params[:id].nil?
  	@category = Category.find_by(id: params[:id])
  	return redirect_back_data_error categories_path, "Data tidak ditemukan" if @category.nil?
  end

  def update
  	return redirect_back_data_error categories_path, "Data tidak ditemukan" if params[:id].nil?
  	category = Category.find_by(id: params[:id])
  	return redirect_back_data_error categories_path, "Data tidak ditemukan" if category.nil?
  	category.assign_attributes category_params
  	changes = category.changes
    category.save! if category.changed?
    category.create_activity :edit, owner: current_user, parameters: changes
    return redirect_success category_path(id: category.id), "Data Jenis Emas - " + category.name + " - Berhasil Diubah"

  end

  private
    def filter_search params
      results = []
      categories = Category.all

      search_text = ""
      if params["search"].present?
        search_text += " '"+params["search"]+"'"
        search = params["search"].downcase
        categories = categories.where("lower(name) like ?", "%"+ search+"%")
      end

      search_text = "Pencarian" + search_text if search_text != ""
      return search_text, categories
    end

    def category_params
      params.require(:category).permit(
        :name
      )
    end

    def param_page
      params[:page]
    end
end