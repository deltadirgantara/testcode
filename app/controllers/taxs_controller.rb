class TaxsController < ApplicationController
  before_action :require_login

  def index
  	@taxs = Tax.page param_page
  end

  def show
  	return redirect_back_data_error taxs_path, "Date tidak ditemukan" if params[:id].nil?
  	@taxs = Tax.find_by(id: params[:id])
  	return redirect_back_data_error taxs_path, "Data tidak ditemukan" if @tax.nil?
  end

  def new
  	# @users = User.all
   #  @stores = Store.all
  end

  def create
    tax = Tax.new tax_params
    nominal = params[:tax][:nominal]
    tax.invoice = "TAX-" + DateTime.now.to_i.to_s + current_user.store.id.to_s
    return redirect_back_data_error new_tax_path, "Data error" if tax.invalid?  
  	tax.save!
  	tax.create_activity :create, owner: current_user
  	return redirect_success tax_path(id: tax.id), "Data disimpan"
  end

  def destroy
  	return redirect_back_data_error taxs_path, "Data tidak ditemukan" if params[:id].nil?
  	tax = Tax.find_by(id: params[:id])
  	return redirect_back_data_error taxs_path, "Data tidak ditemukan" if tax.nil?
  	tax.destroy
  	return redirect_success taxs_path, "Data " + tax.name + " dihapus"
  end

  def edit
  	return redirect_back_data_error taxs_path, "Date tidak ditemukan" if params[:id].nil?
  	@tax = Tax.find_by(id: params[:id])
  	return redirect_back_data_error taxs_path, "Data tidak ditemukan" if @tax.nil?
  	@taxs = Tax.all
  end

  def update
  	return redirect_back_data_error taxs_path, "Date tidak ditemukan" if params[:id].nil?
  	@tax = Tax.find_by(id: params[:id])
  	return redirect_back_data_error taxs_path, "Data tidak ditemukan" if @tax.nil?
  	@tax.assign_attributes tax_params
  	return redirect_success taxs_path(id: @tax.id), "Data tidak ada perubahan" if !@tax.changed
  	@tax.save!
  	changes = @tax.changes
  	@tax.create_activity :edit, owner: current_user, params: changes
  	return redirect_success tax_path(id: @tax.id), "Data disimpan" if !@tax.changed
  end

  private
    def tax_params
      params.require(:tax).permit(
        :nominal, :date
      )
    end

    def param_page
      params[:page]
    end
end