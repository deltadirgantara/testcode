class SubCategoriesController < ApplicationController
  before_action :require_login

  def index
    search = filter_search params

    @search = search[0]
    @sub_categories = search[1]
    @category = search[2]

    return redirect_back_data_error sub_categories_path, "Data tidak ditemukan" if @search.nil?
      

    respond_to do |format|
      format.html do
        @sub_categories = @sub_categories.page param_page
      end
    end

end

  def show
  	return redirect_back_data_error sub_categories_path, "Data tidak ditemukan" if params[:id].nil?
  	@sub_category = SubCategory.find_by(id: params[:id])
  	return redirect_back_data_error sub_categories_path, "Data tidak ditemukan" if @sub_category.nil?
    @category = @sub_category.category
    respond_to do |format|
      format.html do
      end
      format.pdf do
        @recap_type = "sub_category"
        render pdf: DateTime.now.to_i.to_s,
          layout: 'pdf_layout.html.erb',
          template: "categories/print.html.slim"
      end
    end

  end

  def new
    return redirect_back_data_error sub_categories_path, "Data tidak ditemukan" if params[:id].nil?
    @category = Category.find_by(id: params[:id])
    return redirect_back_data_error sub_categories_path, "Data tidak ditemukan" if @category.nil?
  end

  def create
  	return redirect_back_data_error sub_categories_path, "Data tidak ditemukan" if params[:id].nil?
    @category = Category.find_by(id: params[:id])
    return redirect_back_data_error sub_categories_path, "Data tidak ditemukan" if @category.nil?
    sub_category = SubCategory.new sub_category_params
    sub_category.category = @category
    return redirect_back_data_error new_user_path, "Data tidak valid!" if sub_category.invalid?
    sub_category.save!
    sub_category.create_activity :create, owner: current_user
    return redirect_success sub_category_path(id: sub_category.id), "Jenis Emas berhasil ditambahkan"
  end

  def destroy
  	return redirect_back_data_error sub_categories_path, "Data tidak ditemukan" if params[:id].nil?
  	sub_category = SubCategory.find_by(id: params[:id])
  	return redirect_back_data_error sub_categories_path, "Data tidak ditemukan" if sub_category.nil?
  	return redirect_back_data_error sub_categories_path, "Data tidak dapat dihapus" if sub_category.items.count > 0
  	sub_category_name = sub_category.name
  	sub_category.destroy
  	return redirect_success sub_categories_path(id: sub_category.category.id), "Data Jenis Emas - " + sub_category_name + " berhasil dihapus"
  end

  def edit
  	return redirect_back_data_error sub_categories_path, "Data tidak ditemukan" if params[:id].nil?
  	@sub_category = SubCategory.find_by(id: params[:id])
  	return redirect_back_data_error sub_categories_path, "Data tidak ditemukan" if @sub_category.nil?
  end

  def update
  	return redirect_back_data_error sub_categories_path, "Data tidak ditemukan" if params[:id].nil?
  	sub_category = SubCategory.find_by(id: params[:id])
  	return redirect_back_data_error sub_categories_path, "Data tidak ditemukan" if sub_category.nil?
  	sub_category.assign_attributes sub_category_params
  	changes = sub_category.changes
    sub_category.save! if sub_category.changed?
    sub_category.create_activity :edit, owner: current_user, parameters: changes
    return redirect_success sub_category_path(id: sub_category.id), "Data Sub Kategori - " + sub_category.name + " - Berhasil Diubah"
  end

  private
    def filter_search params
      results = []
      return nil, nil, nil if params["id"].nil?
      category = Category.find_by(id: params["id"])
      return nil, nil, nil if category.nil?
      sub_categories = category.sub_categories

      search_text = ""
      if params["search"].present?
        search_text += " '"+params["search"]+"'"
        search = params["search"].downcase
        sub_categories = sub_categories.where("lower(name) like ?", "%"+ search+"%")
      end

      search_text = "Pencarian" + search_text if search_text != ""
      return search_text, sub_categories, category
    end

    def sub_category_params
      params.require(:sub_category).permit(
        :name
      )
    end

    def param_page
      params[:page]
    end
end