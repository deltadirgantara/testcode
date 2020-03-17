class SuppliersController < ApplicationController
  before_action :require_login

  def index
    @suppliers = Supplier.page param_page
    if params[:search].present?
      @search = "Pencarian '"+params[:search].upcase+"'"
      search = "%"+params[:search].downcase+"%"
      @suppliers = @suppliers.where("lower(name) like ? OR phone like ?", search, search)
    end
  end

  def new

  end

  def destroy
    return redirect_back_data_error suppliers_path, "Data Penyuplai Tidak Ditemukan" unless params[:id].present?
    supplier = Supplier.find params[:id]
    return redirect_back_data_error suppliers_path, "Data Penyuplai Tidak Ditemukan" unless supplier.present?
    supplier.destroy
    return redirect_success suppliers_path, "Data Penyuplai - " + supplier.name + " - Berhasil Dihapus"
  end

  def create
    supplier = Supplier.new supplier_params
    supplier.name = params[:supplier][:name].camelize
    supplier.address = params[:supplier][:address].camelize
    supplier.save!
    supplier.create_activity :create, owner: current_user
    return redirect_success supplier_path(id: supplier.id), "Penyuplai - " + supplier.name + " - Berhasil Disimpan"
  end

  def edit
    return redirect_back_data_error suppliers_path, "Data Penyuplai Tidak Ditemukan " unless params[:id].present?
    @supplier = Supplier.find_by_id params[:id]
    return redirect_success suppliers_path, "Penyuplai - " + supplier.name + " - Berhasil Diubah" unless @supplier.present?
  end

  def update
    return redirect_back_data_error suppliers_path, "Data Penyuplai Tidak Ditemukan " unless params[:id].present?
    supplier = Supplier.find_by_id params[:id]
    return redirect_back_data_error suppliers_path, "Data Penyuplai Tidak Ditemukan " unless supplier.present?
    supplier.assign_attributes supplier_params
    supplier.name = params[:supplier][:name].camelize
    supplier.address = params[:supplier][:address].camelize
    changes = supplier.changes
    supplier.save! if supplier.changed?
    supplier.create_activity :edit, owner: current_user, parameters: changes
    return redirect_success supplier_path(supplier.id), "Data Penyuplai - " + supplier.name + " - Berhasil Diubah"
  end

  def show
    return redirect_back_data_error suppliers_path, "Data Penyuplai Tidak Ditemukan" unless params[:id].present?
    @supplier = Supplier.find_by_id params[:id]
    return redirect_back_data_error suppliers_path, "Data Penyuplai Tidak Ditemukan " unless @supplier.present?
  end

  private
    def supplier_params
      params.require(:supplier).permit(
        :name, :address, :phone
      )
    end

    def param_page
      params[:page]
    end

end
