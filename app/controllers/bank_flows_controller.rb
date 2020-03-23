class BankFlowsController < ApplicationController
  before_action :require_login

  def index
    search = filter_search params
    @search = search[0]
    @bank_flows = search[1]
    @store = search[2]
    @bank = search[3]
    @params = params.to_s

    graphs = graph @bank_flows
    gon.label = graphs[0]
    gon.debit = graphs[1]
    gon.kredit = graphs[2]
    gon.graph_name = "Bank Flow"

    respond_to do |format|
      format.html do
        @bank_flows = search[1].page param_page
      end
      format.pdf do
        new_params = eval(params[:option])
        filter = filter_search new_params
        @search = filter[0]
        @bank_flows = filter[1]
        @store = filter[2]
        @bank = filter[3]
        @recap_type = "fix_cost"
        render pdf: DateTime.now.to_i.to_s,
          layout: 'pdf_layout.html.erb',
          template: "bank_flows/print.html.slim"
      end
    end
  end

  def show
  	return redirect_back_data_error bank_flows_path, "Date tidak ditemukan" if params[:id].nil?
  	@bank_flow = BankFlow.find_by(id: params[:id])
  	return redirect_back_data_error bank_flows_path, "Data tidak ditemukan" if @bank_flow.nil?
  end

  def new
    @banks = Bank.all
  end

  def create
    bank_flow = BankFlow.new bank_flow_params
    bank_flow.store = current_user.store
    bank_flow.user = current_user
    return redirect_back_data_error new_bank_flow_path, "Data error" if bank_flow.nominal < 10000  || bank_flow.date > Date.today
    bank_flow.invoice = "BF-" + DateTime.now.to_i.to_s + current_user.store.id.to_s
    return redirect_back_data_error new_bank_flow_path, "Data error" if bank_flow.invalid?  
  	bank_flow.save!
    if bank_flow.type_flow == "OUT"
      CashFlow.create ref_id: bank_flow.id, type_cash: 5, type_flow: 1
    else
      CashFlow.create ref_id: bank_flow.id, type_cash: 5, type_flow: 2
    end
    bank_flow.create_activity :create, owner: current_user
  	return redirect_success bank_flow_path(id: bank_flow.id), "Data disimpan"
  end

  def destroy
  	return redirect_back_data_error bank_flows_path, "Data tidak ditemukan" if params[:id].nil?
  	bank_flow = BankFlow.find_by(id: params[:id])
  	return redirect_back_data_error bank_flows_path, "Data tidak ditemukan" if bank_flow.nil?
    cf = CashFlow.find_by(ref_id: bank_flow.id, type_cash: CashFlow::BANK)
    cf.destroy
  	bank_flow.destroy
  	return redirect_success bank_flows_path, "Data " + bank_flow.invoice + " dihapus"
  end

  def edit
  	return redirect_back_data_error bank_flows_path, "Data tidak ditemukan" if params[:id].nil?
  	@bank_flow = BankFlow.find_by(id: params[:id])
  	return redirect_back_data_error bank_flows_path, "Data tidak ditemukan" if @bank_flow.nil?
    @banks = Bank.all
  end

  def update
  	return redirect_back_data_error bank_flows_path, "Data tidak ditemukan" if params[:id].nil?
  	@bank_flow = BankFlow.find_by(id: params[:id])
  	return redirect_back_data_error bank_flows_path, "Data tidak ditemukan" if @bank_flow.nil?
  	@bank_flow.assign_attributes bank_flow_params
    return redirect_back_data_error bank_flow_path(id: bank_flow.id), "Data error" if @bank_flow.nominal < 10000  || @bank_flow.date > Date.today
  	return redirect_success bank_flow_path(id: bank_flow.id), "Data tidak ada perubahan" if !@bank_flow.changed
  	changes = @bank_flow.changes
    if @bank_flow.changed?
      @bank_flow.save! 
      cf = CashFlow.find_by(ref_id: @bank_flow.id, type_cash: CashFlow::BANK)
      cf.type_flow = 2 
      cf.type_flow = 1 if @bank_flow.type_flow == "OUT"
      cf.save!
      @bank_flow.create_activity :edit, owner: current_user, parameters: changes
    end
    return redirect_success bank_flow_path(id: @bank_flow.id), "Data - " + @bank_flow.invoice + " - Berhasil Diubah"
  end

  private
    def filter_search params
      results = []
      bank_flows = BankFlow.all
      bank_flows = bank_flows.where(store: current_user.store) if !["owner", "super_admin"].include? current_user.level?
      bank_flows = bank_flows.order("created_at DESC")
      search_text = ""
      if params["search"].present?
        search_text += " '"+params["search"]+"'"
        search = params["search"].downcase
        bank_flows = bank_flows.where("lower(invoice) like ?", "%"+ search+"%")
      end

      store = nil
      if params["store_id"].present?
        store = Store.find_by(id: params["store_id"])
        if store.present?
          bank_flows = bank_flows.where(store: store)
          search_text += " - Toko '" + store.name + "'"
        end
      end

      bank = nil
      if params["bank_id"].present?
        bank = Bank.find_by(id: params["bank_id"])
        if bank.present?
          bank_flows = bank_flows.where(bank: bank)
          search_text += " - Bank '" + bank.name + "'"
        end
      end

      if params["start_date"].present?
        start_date = params["start_date"].to_date
        bank_flows = bank_flows.where("date >= ?", start_date)
        search_text += " - Dari '" + start_date.strftime("%d/%m/%Y").to_s + "'"
      end

      if params["end_date"].present?
        end_date = params["end_date"].to_date
        bank_flows = bank_flows.where("date <= ?", end_date)
        search_text += " - Sampai '" + end_date.strftime("%d/%m/%Y").to_s + "'"
      end

      search_text = "Pencarian" + search_text if search_text != ""
      return search_text, bank_flows, store, bank
    end

    def graph data
      bank_flows_data = data.group_by{ |m| m.date.beginning_of_day}
      graphs = {}

      bank_flows_data.each do |bank_flows|
        debit = 0
        kredit = 0
        day_idx = bank_flows[0].day.to_i - 1
        bank_flows[1].each do |bank_flow|
          if bank_flow.type_flow == "IN"
            debit += bank_flow.nominal
          else
            kredit += bank_flow.nominal
          end
        end
        graphs[bank_flows[0].to_date] = [debit,kredit]
      end
      vals = graphs.values
      debit = vals.collect {|ind| ind[0]}
      kredit = vals.collect {|ind| ind[1]}
      days = graphs.keys
      days.each_with_index do |day, idx|
        days[idx] = day.strftime("%d-%m-%Y")
      end
      return days, debit, kredit
    end


    def bank_flow_params
      params.require(:bank_flow).permit(
        :bank_id, :type_flow, :nominal, :invoice, :date, :description
      )
    end

    def param_page
      params[:page]
    end
end