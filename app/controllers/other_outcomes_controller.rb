class OtherOutcomesController < ApplicationController
  before_action :require_login

  def index
  	@other_outcomes = OtherOutcome.page param_page
  end

  def show
  	return redirect_back_data_error other_outcomes_path, "Data tidak ditemukan" if params[:id].nil?
  	@other_outcome = OtherOutcome.find_by(id: params[:id])
  	return redirect_back_data_error other_outcomes_path, "Data tidak ditemukan" if @other_outcome.nil?
  end

  def new
  end

  def create
    other_outcome = OtherOutcome.new other_outcome_params
    other_outcome.store = current_user.store
    other_outcome.user = current_user
    return redirect_back_data_error new_other_outcome_path, "Data error" if other_outcome.nominal < 10000  || other_outcome.date > Date.today
    other_outcome.invoice = "OUT-" + DateTime.now.to_i.to_s + current_user.store.id.to_s
    return redirect_back_data_error new_other_outcome_path, "Data error" if other_outcome.invalid?  
  	other_outcome.save!
    CashFlow.create ref_id: other_outcome.id, type_cash: 1, type_flow: 2
  	other_outcome.create_activity :create, owner: current_user
  	return redirect_success other_outcome_path(id: other_outcome.id), "Data disimpan"
  end

  def destroy
  	return redirect_back_data_error other_outcomes_path, "Data tidak ditemukan" if params[:id].nil?
  	other_outcome = OtherOutcome.find_by(id: params[:id])
  	return redirect_back_data_error outcomes_path, "Data tidak ditemukan" if other_outcome.nil?
    cf = CashFlow.find_by(ref_id: other_outcome.id, type_cash: CashFlow::OUTCOME)
    cf.destroy
  	other_outcome.destroy
  	return redirect_success other_outcomes_path, "Data " + other_outcome.invoice + " dihapus"
  end

  def edit
  	return redirect_back_data_error other_outcomes_path, "Data tidak ditemukan" if params[:id].nil?
  	@other_outcome = OtherOutcome.find_by(id: params[:id])
  	return redirect_back_data_error other_outcomes_path, "Data tidak ditemukan" if @other_outcome.nil?
  end

  def update
  	return redirect_back_data_error other_outcomes_path, "Data tidak ditemukan" if params[:id].nil?
  	@other_outcome = OtherOutcome.find_by(id: params[:id])
  	return redirect_back_data_error other_outcome_path, "Data tidak ditemukan" if @other_outcome.nil?
  	@other_outcome.assign_attributes outcome_params
    return redirect_back_data_error other_outcome_path(id: other_outcome.id), "Data error" if @other_outcome.nominal < 10000  || @outcome.date > Date.today
  	return redirect_success other_outcome_path(id: other_outcome.id), "Data tidak ada perubahan" if !@other_outcome.changed
  	changes = @other_outcome.changes
    if @other_outcome.changed?
      @outcome.save! 
      @outcome.create_activity :edit, owner: current_user, parameters: changes
    end
    return redirect_success other_outcome_path(id: @other_outcome.id), "Data Pajak - " + @other_outcome.invoice + " - Berhasil Diubah"
  end

  private
    def other_outcome_params
      params.require(:other_outcome).permit(
        :nominal, :date, :description
      )
    end

    def param_page
      params[:page]
    end
end