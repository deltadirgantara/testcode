class SuppliersController < ApplicationController
  before_action :require_login

  def index
    search = filter_search params
    @search = search[0]
    @suppliers = search[1]
    @params = params.to_s

    respond_to do |format|
      format.html do
        @suppliers = search[1].page param_page
      end
      format.pdf do
        @recap_type = "customer"
        new_params = eval(params[:option])
        filter = filter_search new_params
        @search = filter[0]
        @suppliers = filter[1]
        render pdf: DateTime.now.to_i.to_s,
          layout: 'pdf_layout.html.erb',
          template: "suppliers/print.html.slim"
      end
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
    def filter_search params
      results = []
      suppliers = Supplier.all
      suppliers = suppliers.where(store: current_user.store) if !["owner", "super_admin"].include? current_user.level
      search_text = ""
      if params["search"].present?
        search_text += " '"+params["search"]+"'"
        search = params["search"].downcase
        suppliers = suppliers.where("lower(name) like ?", "%"+ search+"%")
      end

      search_text = "Pencarian Supplier -" + search_text if search_text != ""
      return search_text, suppliers
    end

    def supplier_params
      params.require(:supplier).permit(
        :name, :address, :phone
      )
    end

    def param_page
      params[:page]
    end

end
