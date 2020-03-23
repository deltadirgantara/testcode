class CustomersController < ApplicationController
  before_action :require_login

  def index
  	search = filter_search params
    @search = search[0]
    @customers = search[1]
    @params = params.to_s

    respond_to do |format|
      format.html do
        @customers = search[1].page param_page
      end
      format.pdf do
        @recap_type = "customer"
        new_params = eval(params[:option])
        filter = filter_search new_params
        @search = filter[0]
        @customers = filter[1]
        render pdf: DateTime.now.to_i.to_s,
          layout: 'pdf_layout.html.erb',
          template: "customers/print.html.slim"
      end
    end
  end

  def show
  	return redirect_back_data_error customers_path, "Data tidak ditemukan" if params[:id].nil?
  	@customer = Customer.find_by(id: params[:id])
  	return redirect_back_data_error customers_path, "Data tidak ditemukan" if @customer.nil?
  end

  def new
  end

  def create
  	customer = Customer.new customer_params
    customer.user = current_user
    return redirect_back_data_error new_user_path, "Data tidak valid!" if customer.invalid?
    customer.save!
    customer.create_activity :create, owner: current_user
    return redirect_success customer_path(id: customer.id), "Pelanggan berhasil ditambahkan"
  end

  def destroy
  	return redirect_back_data_error customers_path, "Data tidak ditemukan" if params[:id].nil?
  	customer = Customer.find_by(id: params[:id])
  	return redirect_back_data_error customers_path, "Data tidak ditemukan" if customer.nil?
  	return redirect_back_data_error customers_path, "Data tidak dapat dihapus" if customer.sub_categories.count > 0
  	customer_name = customer.name
  	customer.destroy
  	return redirect_success customers_path, "Pelanggan - " + customer_name + " berhasil dihapus"
  end

  def edit
  	return redirect_back_data_error customers_path, "Data tidak ditemukan" if params[:id].nil?
  	@customer = Customer.find_by(id: params[:id])
  	return redirect_back_data_error customers_path, "Data tidak ditemukan" if @customer.nil?
  end

  def update
  	return redirect_back_data_error customers_path, "Data tidak ditemukan" if params[:id].nil?
  	customer = Customer.find_by(id: params[:id])
  	return redirect_back_data_error customers_path, "Data tidak ditemukan" if customer.nil?
  	customer.assign_attributes customer_params
  	changes = customer.changes
    customer.save! if customer.changed?
    customer.create_activity :edit, owner: current_user, parameters: changes
    return redirect_success customer_path(id: customer.id), "Pelanggan - " + customer.name + " - Berhasil Diubah"

  end

  private
    def filter_search params
      results = []
      customers = Customer.all
      customers = customers.where(store: current.customer.store) if !["owner", "super_admin"].include? current_user.level
      search_text = ""
      if params["search"].present?
        search_text += " '"+params["search"]+"'"
        search = params["search"].downcase
        customers = customers.where("lower(name) like ?", "%"+ search+"%")
      end

      store = nil
      if params["store_id"].present?
        store = Store.find_by(id: params["store_id"])
        if store.present?
          customers = customers.where(store: current.customer.store) if !["owner", "super_admin"].include? current_user.level
          search_text += " di Toko '" + store.name + "'"
        end
      end

      search_text = "Pencarian" + search_text if search_text != ""
      return search_text, customers , store
    end

    def customer_params
      params.require(:customer).permit(
        :name, :phone, :email, :address
      )
    end

    def param_page
      params[:page]
    end
end