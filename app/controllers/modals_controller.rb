  class ModalsController < ApplicationController
  before_action :require_login

  def index
  	@modals = Modal.page param_page
  end

  def show
  	return redirect_back_data_error modals_path, "Date tidak ditemukan" if params[:id].nil?
  	@modal = Modal.find_by(id: params[:id])
  	return redirect_back_data_error modals_path, "Data tidak ditemukan" if @modal.nil?
  end

  def new
  end

  def create
    modal = Modal.new modal_params
    modal.store = current_user.store
    modal.user = current_user
    return redirect_back_data_error new_modal_path, "Data error" if modal.nominal < 10000  || modal.date > Date.today
    modal.invoice = "MDL-" + DateTime.now.to_i.to_s + current_user.store.id.to_s
    return redirect_back_data_error new_modal_path, "Data error" if modal.invalid?  
  	modal.save!
    if modal.type_modal == "OUT"
      CashFlow.create ref_id: modal.id, type_cash: 4, type_flow: 2
  	else
      CashFlow.create ref_id: modal.id, type_cash: 4, type_flow: 1
    end
    modal.create_activity :create, owner: current_user
  	return redirect_success modal_path(id: modal.id), "Data disimpan"
  end

  def destroy
  	return redirect_back_data_error modals_path, "Data tidak ditemukan" if params[:id].nil?
  	modal = Modal.find_by(id: params[:id])
  	return redirect_back_data_error modals_path, "Data tidak ditemukan" if modal.nil?
    cf = CashFlow.find_by(ref_id: modal.id, type_cash: CashFlow::MODAL)
    cf.destroy
  	modal.destroy
  	return redirect_success modals_path, "Data " + modal.invoice + " dihapus"
  end

  def edit
  	return redirect_back_data_error modals_path, "Data tidak ditemukan" if params[:id].nil?
  	@modal = Modal.find_by(id: params[:id])
  	return redirect_back_data_error modals_path, "Data tidak ditemukan" if @modal.nil?
  end

  def update
  	return redirect_back_data_error modals_path, "Data tidak ditemukan" if params[:id].nil?
  	@modal = Modal.find_by(id: params[:id])
  	return redirect_back_data_error modals_path, "Data tidak ditemukan" if @modal.nil?
  	@modal.assign_attributes modal_params
    return redirect_back_data_error modal_path(id: modal.id), "Data error" if @modal.nominal < 10000  || @modal.date > Date.today
  	return redirect_success modal_path(id: modal.id), "Data tidak ada perubahan" if !@modal.changed
  	changes = @modal.changes
    if @modal.changed?
      @modal.save! 
      cf = CashFlow.find_by(ref_id: @modal.id, type_cash: CashFlow::MODAL)
      cf.type_flow = 1 
      cf.type_flow = 2 if @modal.type_modal == "OUT"
      cf.save!
      @modal.create_activity :edit, owner: current_user, parameters: changes
    end
    return redirect_success modal_path(id: @modal.id), "Data Pajak - " + @modal.invoice + " - Berhasil Diubah"
  end

  private
    def modal_params
      params.require(:modal).permit(
        :nominal, :date, :description, :type_modal
      )
    end

    def param_page
      params[:page]
    end
end