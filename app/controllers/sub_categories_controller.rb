class SubCategoriesController < ApplicationController
  before_action :require_login

  def index
    return redirect_back_data_error sub_categories_path, "Data tidak ditemukan" if params[:id].nil?
    @category = Category.find_by(id: params[:id])
    return redirect_back_data_error sub_categories_path, "Data tidak ditemukan" if @category.nil?
    @sub_categories = SubCategory.where(category: @category).page param_page
  end

  def show
  	return redirect_back_data_error sub_categories_path, "Data tidak ditemukan" if params[:id].nil?
  	@sub_category = SubCategory.find_by(id: params[:id])
  	return redirect_back_data_error sub_categories_path, "Data tidak ditemukan" if @sub_category.nil?
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
    def sub_category_params
      params.require(:sub_category).permit(
        :name
      )
    end

    def param_page
      params[:page]
    end
end