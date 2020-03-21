class OtherOutcomesController < ApplicationController
  before_action :require_login

  def index
  	search = filter_search params
    @search = search[0]
    @other_outcomes = search[1]
    @store = search[2]
    @params = params.to_s

    graphs = graph @other_outcomes
    gon.label = graphs[0]
    gon.data = graphs[1]
    gon.graph_name = "Biaya Pengeluaran Lainnya"

    respond_to do |format|
      format.html do
        @other_outcomes = search[1].page param_page
      end
      format.pdf do
        @recap_type = "other_outcome"
        new_params = eval(params[:option])
        filter = filter_search new_params
        @search = filter[0]
        @other_outcomes = filter[1]
        @store = filter[2]
        render pdf: DateTime.now.to_i.to_s,
          layout: 'pdf_layout.html.erb',
          template: "other_outcomes/print.html.slim"
      end
    end
  end

  def show
  	return redirect_back_data_error other_outcomes_path, "Data tidak ditemukan" if params[:id].nil?
  	@other_outcome = OtherOutcome.find_by(id: params[:id])
  	return redirect_back_data_error other_outcomes_path, "Data tidak ditemukan" if @other_outcome.nil?

    respond_to do |format|
      format.html do
      end
      format.pdf do
        @recap_type = "invoice"
        render pdf: DateTime.now.to_i.to_s,
          layout: 'pdf_layout.html.erb',
          template: "other_outcomes/invoice.html.slim"
      end
    end
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
    CashFlow.create ref_id: other_outcome.id, type_cash: 6, type_flow: 2, nominal: other_outcome.nominal, date: other_outcome.date
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
      cf = CashFlow.find_by(ref_id: @other_outcome.id, type_cash: CashFlow::OTHEROUTCOME)
      cf.nominal = @other_outcome.nominal
      cf.save!
      @other_outcome.create_activity :edit, owner: current_user, parameters: changes
    end
    return redirect_success other_outcome_path(id: @other_outcome.id), "Data Pengeluaran Lain - " + @other_outcome.invoice + " - Berhasil Diubah"
  end

private
    def filter_search params
      results = []
      other_outcomes = OtherOutcome.all
      other_outcomes = other_outcomes.where(store: current_user.store) if ["owner", "super_admin"].include? current_user.level
      search_text = ""
      if params["search"].present?
        search_text += " '"+params["search"]+"'"
        search = params["search"].downcase
        other_outcomes = other_outcomes.where("lower(invoice) like ?", "%"+ search+"%")
      end

      store = nil
      if params["store_id"].present?
        store = Store.find_by(id: params["store_id"])
        if store.present?
          other_outcomes = other_outcomes.where(store: store)
          search_text += " - Toko '" + store.name + "'"
        end
      end

      if params["start_date"].present?
        start_date = params["start_date"].to_date
        other_outcomes = other_outcomes.where("date >= ?", start_date)
        search_text += " - Dari '" + start_date.strftime("%d/%m/%Y").to_s + "'"
      end

      if params["end_date"].present?
        end_date = params["end_date"].to_date
        other_outcomes = other_outcomes.where("date <= ?", end_date)
        search_text += " - Sampai '" + end_date.strftime("%d/%m/%Y").to_s + "'"
      end

      search_text = "Pencarian" + search_text if search_text != ""
      return search_text, other_outcomes, store
    end

    def graph data
      
      grouping_datas = data.order("date ASC").group_by{ |m| m.date.beginning_of_day}
      
      graphs = {}

      grouping_datas.each do |datas|
        total = 0
        day_idx = datas[0].day.to_i - 1
        datas[1].each do |data|
          total += data.nominal
        end
        graphs[datas[0].to_date] = total
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