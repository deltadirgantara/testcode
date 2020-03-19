class TaxsController < ApplicationController
  before_action :require_login

  def index
  	@taxs = Tax.page param_page
  end

  def show
  	return redirect_back_data_error taxs_path, "Data tidak ditemukan" if params[:id].nil?
  	@tax = Tax.find_by(id: params[:id])
  	return redirect_back_data_error taxs_path, "Data tidak ditemukan" if @tax.nil?
  end

  def new
  end

  def create
    tax = Tax.new tax_params
    tax.store = current_user.store
    tax.user = current_user
    return redirect_back_data_error new_tax_path, "Data error" if tax.nominal < 10000  || tax.date > Date.today
    tax.invoice = "TAX-" + DateTime.now.to_i.to_s + current_user.store.id.to_s
    return redirect_back_data_error new_tax_path, "Data error" if tax.invalid?  
  	tax.save!
    CashFlow.create ref_id: tax.id, type_cash: 1, type_flow: 2
  	tax.create_activity :create, owner: current_user
  	return redirect_success tax_path(id: tax.id), "Data disimpan"
  end

  def destroy
  	return redirect_back_data_error taxs_path, "Data tidak ditemukan" if params[:id].nil?
  	tax = Tax.find_by(id: params[:id])
  	return redirect_back_data_error taxs_path, "Data tidak ditemukan" if tax.nil?
  	tax.destroy
  	return redirect_success taxs_path, "Data " + tax.invoice + " dihapus"
  end

  def edit
  	return redirect_back_data_error taxs_path, "Data tidak ditemukan" if params[:id].nil?
  	@tax = Tax.find_by(id: params[:id])
  	return redirect_back_data_error taxs_path, "Data tidak ditemukan" if @tax.nil?
  end

  def update
  	return redirect_back_data_error taxs_path, "Data tidak ditemukan" if params[:id].nil?
  	@tax = Tax.find_by(id: params[:id])
  	return redirect_back_data_error taxs_path, "Data tidak ditemukan" if @tax.nil?
  	@tax.assign_attributes tax_params
    return redirect_back_data_error tax_path(id: tax.id), "Data error" if @tax.nominal < 10000  || @tax.date > Date.today
  	return redirect_success tax_path(id: tax.id), "Data tidak ada perubahan" if !@tax.changed
  	changes = @tax.changes
    if @tax.changed?
      @tax.save! 
      @tax.create_activity :edit, owner: current_user, parameters: changes
    end
    return redirect_success tax_path(id: tax.id), "Data Pajak - " + @tax.invoice + " - Berhasil Diubah"
  end

  private
    def tax_params
      params.require(:tax).permit(
        :nominal, :date, :description
      )
    end

    def param_page
      params[:page]
    end
end