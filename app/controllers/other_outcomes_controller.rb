class OtherOutcomesController < ApplicationController
  before_action :require_login

  def index
  	@other_outcomes = OtherOutcome.page param_page
    
    store = current_user.store
    start_day = DateTime.now - 90.days
    end_day = DateTime.now + 1.day
    graphs = graph start_day, end_day, store
    gon.label = graphs[0]
    gon.data = graphs[1]
    gon.graph_name = "Pengeluaran Lainnya"
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
    CashFlow.create ref_id: other_outcome.id, type_cash: 6, type_flow: 2
  	other_outcome.create_activity :create, owner: current_user
  	return redirect_success other_outcome_path(id: other_outcome.id), "Data disimpan"
  end

  def destroy
  	return redirect_back_data_error other_outcomes_path, "Data tidak ditemukan" if params[:id].nil?
  	other_outcome = OtherOutcome.find_by(id: params[:id])
  	return redirect_back_data_error outcomes_path, "Data tidak ditemukan" if other_outcome.nil?
    cf = CashFlow.find_by(ref_id: other_outcome.id, type_cash: CashFlow::OTHEROUTCOME)
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
  	@other_outcome.assign_attributes other_outcome_params
    return redirect_back_data_error other_outcome_path(id: other_outcome.id), "Data error" if @other_outcome.nominal < 10000  || @other_outcome.date > Date.today
  	return redirect_success other_outcome_path(id: other_outcome.id), "Data tidak ada perubahan" if !@other_outcome.changed
  	changes = @other_outcome.changes
    if @other_outcome.changed?
      @other_outcome.save! 
      @other_outcome.create_activity :edit, owner: current_user, parameters: changes
    end
    return redirect_success other_outcome_path(id: @other_outcome.id), "Data Pengeluaran Lain - " + @other_outcome.invoice + " - Berhasil Diubah"
  end

  private
    def graph start_day, end_day, store
      fix_costs_data = OtherOutcome.where(store: store).where("date >= ? AND date <= ?", start_day, end_day).order("date ASC").group_by{ |m| m.date.beginning_of_day}
      
      graphs = {}

      fix_costs_data.each do |fix_costs|
        total = 0
        day_idx = fix_costs[0].day.to_i - 1
        fix_costs[1].each do |fix_cost|
          total += fix_cost.nominal
        end
        graphs[fix_costs[0].to_date] = total
      end
      vals = graphs.values
      days = graphs.keys
      days.each_with_index do |day, idx|
        days[idx] = day.strftime("%d-%m-%Y")
      end

      return days, vals
    end

    def other_outcome_params
      params.require(:other_outcome).permit(
        :nominal, :date, :description
      )
    end

    def param_page
      params[:page]
    end
end