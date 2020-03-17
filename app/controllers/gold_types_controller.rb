class GoldTypesController < ApplicationController
  before_action :require_login

  def index
  	@gold_types = GoldType.page param_page
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
    def gold_params
      params.require(:gold).permit(
        :name
      )
    end

    def param_page
      params[:page]
    end
end