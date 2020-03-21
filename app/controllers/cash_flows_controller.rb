class CashFlowsController < ApplicationController
  before_action :require_login

  def index
    search = filter_search params
    @search = search[0]
    @cash_flows = search[1]
    @store = search[2]
    @params = params.to_s

    graphs = graph @cash_flows
    gon.label = graphs[0]
    gon.debit = graphs[1]
    gon.kredit = graphs[2]

    respond_to do |format|
      format.html do
        @cash_flows = search[1].page param_page
      end
      format.pdf do
        new_params = eval(params[:option])
        filter = filter_search new_params
        @search = filter[0]
        @cash_flows = filter[1]
        @store = filter[2]
        @recap_type = "fix_cost"
        render pdf: DateTime.now.to_i.to_s,
          layout: 'pdf_layout.html.erb',
          template: "cash_flows/print.html.slim"
      end
    end
  end

  
  private
    def filter_search params
      results = []
      cash_flows = CashFlow.all
      cash_flows = cash_flows.where(store: current_user.store) if ["owner", "super_admin"].include? current_user.level?
      search_text = ""
      if params["search"].present?
        search_text += " '"+params["search"]+"'"
        search = params["search"].downcase
        cash_flows = cash_flows.where("lower(invoice) like ?", "%"+ search+"%")
      end

      store = nil
      if params["store_id"].present?
        store = Store.find_by(id: params["store_id"])
        if store.present?
          cash_flows = cash_flows.where(store: store)
          search_text += " - Toko '" + store.name + "'"
        end
      end

      if params["start_date"].present?
        start_date = params["start_date"].to_date
        cash_flows = cash_flows.where("date >= ?", start_date)
        search_text += " - Dari '" + start_date.strftime("%d/%m/%Y").to_s + "'"
      end

      if params["end_date"].present?
        end_date = params["end_date"].to_date
        cash_flows = cash_flows.where("date <= ?", end_date)
        search_text += " - Sampai '" + end_date.strftime("%d/%m/%Y").to_s + "'"
      end

      search_text = "Pencarian" + search_text if search_text != ""
      return search_text, cash_flows, store
    end

    def graph data
      return nil, nil, nil if data.nil?
      grouping_datas = data.order("date ASC").group_by{ |m| m.date.beginning_of_day}
      
      graphs = {}

      grouping_datas.each do |datas|
        debit = 0
        kredit = 0
        day_idx = datas[0].day.to_i - 1
        datas[1].each do |data|
          if data.type_flow == "IN"
          	debit += data.nominal
          else
          	kredit += data.nominal
          end
        end
        graphs[datas[0].to_date] = [debit, kredit]
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

    def param_page
      params[:page]
    end
end