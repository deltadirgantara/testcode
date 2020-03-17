class CustomersController < ApplicationController
  before_action :require_login

  def index
  	@customers = Customer.page param_page
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
    def customer_params
      params.require(:customer).permit(
        :name, :phone, :email, :address
      )
    end

    def param_page
      params[:page]
    end
end