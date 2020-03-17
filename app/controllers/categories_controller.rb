class CategoriesController < ApplicationController
  before_action :require_login

  def index
  	@categories = Category.page param_page
  end

  def show
  	return redirect_back_data_error categories_path, "Data tidak ditemukan" if params[:id].nil?
  	@category = Category.find_by(id: params[:id])
  	return redirect_back_data_error categories_path, "Data tidak ditemukan" if @category.nil?
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
    def category_params
      params.require(:category).permit(
        :name
      )
    end

    def param_page
      params[:page]
    end
end