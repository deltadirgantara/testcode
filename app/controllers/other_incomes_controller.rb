class OtherIncomesController < ApplicationController
  before_action :require_login

  def index
  	@other_incomes = OtherIncome.page param_page
    
    store = current_user.store
    start_day = DateTime.now - 90.days
    end_day = DateTime.now + 1.day
    graphs = graph start_day, end_day, store
    gon.label = graphs[0]
    gon.data = graphs[1]
  end

  def show
  	return redirect_back_data_error other_incomes_path, "Data tidak ditemukan" if params[:id].nil?
  	@other_income = OtherIncome.find_by(id: params[:id])
  	return redirect_back_data_error other_incomes_path, "Data tidak ditemukan" if @other_income.nil?
  end

  def new
  end

  def create
    other_income = OtherIncome.new other_income_params
    other_income.store = current_user.store
    other_income.user = current_user
    return redirect_back_data_error new_other_income_path, "Data error" if other_income.nominal < 10000  || other_income.date > Date.today
    other_income.invoice = "IN-" + DateTime.now.to_i.to_s + current_user.store.id.to_s
    return redirect_back_data_error new_other_income_path, "Data error" if other_income.invalid?  
  	other_income.save!
    CashFlow.create ref_id: other_income.id, type_cash: 7, type_flow: 1
  	other_income.create_activity :create, owner: current_user
  	return redirect_success other_income_path(id: other_income.id), "Data disimpan"
  end

  def destroy
  	return redirect_back_data_error other_incomes_path, "Data tidak ditemukan" if params[:id].nil?
  	other_income = OtherIncome.find_by(id: params[:id])
  	return redirect_back_data_error incomes_path, "Data tidak ditemukan" if other_income.nil?
    cf = CashFlow.find_by(ref_id: other_income.id, type_cash: CashFlow::OTHERINCOME)
    cf.destroy
  	other_income.destroy
  	return redirect_success other_incomes_path, "Data " + other_income.invoice + " dihapus"
  end

  def edit
  	return redirect_back_data_error other_incomes_path, "Data tidak ditemukan" if params[:id].nil?
  	@other_income = OtherIncome.find_by(id: params[:id])
  	return redirect_back_data_error other_incomes_path, "Data tidak ditemukan" if @other_income.nil?
  end

  def update
  	return redirect_back_data_error other_incomes_path, "Data tidak ditemukan" if params[:id].nil?
  	@other_income = OtherIncome.find_by(id: params[:id])
  	return redirect_back_data_error other_income_path, "Data tidak ditemukan" if @other_income.nil?
  	@other_income.assign_attributes other_income_params
    return redirect_back_data_error other_income_path(id: other_income.id), "Data error" if @other_income.nominal < 10000  || @other_income.date > Date.today
  	return redirect_success other_income_path(id: other_income.id), "Data tidak ada perubahan" if !@other_income.changed
  	changes = @other_income.changes
    if @other_income.changed?
      @other_income.save! 
      @other_income.create_activity :edit, owner: current_user, parameters: changes
    end
    return redirect_success other_income_path(id: @other_income.id), "Data Pengeluaran Lain - " + @other_income.invoice + " - Berhasil Diubah"
  end

  private
    def graph start_day, end_day, store
      other_incomes_data = OtherIncome.where(store: store).where("date >= ? AND date <= ?", start_day, end_day).order("date ASC").group_by{ |m| m.date.beginning_of_day}
      
      graphs = {}

      other_incomes_data.each do |other_incomes|
        total = 0
        day_idx = other_incomes[0].day.to_i - 1
        other_incomes[1].each do |other_incomes|
          total += other_incomes.nominal
        end
        graphs[other_incomes[0].to_date] = total
      end
      vals = graphs.values
      days = graphs.keys
      days.each_with_index do |day, idx|
        days[idx] = day.strftime("%d-%m-%Y")
      end

      return days, vals
    end

    def other_income_params
      params.require(:other_income).permit(
        :nominal, :date, :description
      )
    end

    def param_page
      params[:page]
    end
end