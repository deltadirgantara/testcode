class TrxBuysController < ApplicationController
  before_action :require_login
  skip_before_action :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  def index
    filter = filter_search params, "html"
    @search = "Rekap transaksi " + filter[0]
    @trx_buys = filter[1]
    @params = params.to_s

    if params[:customer_id].present?
      @customer = Customer.find_by(id: params[:customer_id])
      if @customer.present?
        @customer_name = " - "+@customer.name
        @trx_buys = @trx_buys.where(customer: @customer)
      end
    end
    
    respond_to do |format|
      format.html
      format.pdf do
        new_params = eval(params[:option])
        filter = filter_search new_params, "pdf"
        @search = filter[0]
        @trx_buys = filter[1]
        @store_name= filter[2]
        render pdf: DateTime.now.to_i.to_s,
          layout: 'pdf_layout.html.erb',
          template: "trx_buys/print_all.html.slim"
      end
    end

    start_day = DateTime.now.beginning_of_month
    end_day = DateTime.now.end_of_day

    if params["date_start"].present?
      start_day = params["date_start"].to_datetime.beginning_of_day
      if params["date_end"].present?
        end_day = params["date_end"].to_datetime.end_of_day
      else
        end_day = (start_day + 7.days).end_of_day
      end 
    end

    trx_buys = transactions_profit_graph start_day, end_day
    gon.grand_totals = trx_buys[0]
    gon.hpp_totals = trx_buys[1]
    gon.profits = trx_buys[2]
    gon.days = trx_buys[3]
  end

  def show
  	return redirect_back_data_error trx_buys_path, "Data tidak ditemukan" if params[:id].nil?
  	@trx = TrxBuy.find_by(id: params[:id])
  	return redirect_back_data_error trx_buys_path, "Data tidak ditemukan" if @trx.nil?

    respond_to do |format|
      format.html do
      end
      format.pdf do
        @recap_type = "invoice"
        render pdf: DateTime.now.to_i.to_s,
          layout: 'pdf_layout.html.erb',
          template: "trx_buys/invoice.html.slim"
      end
    end
  end

  def monthly_recap
    start_day = (params[:month] + params[:year]).to_datetime
    end_day = start_day.end_of_month
    @desc = "Rekap bulanan - "+ start_day.month.to_s + "/" + start_day.year.to_s
    @transaction_datas = TrxBuy.where("date >= ? AND date <= ?", start_day, end_day).group_by{ |m| m.date.beginning_of_day}
    if @transaction_datas.empty?
      return redirect_back_data_error trx_buys_path, "Data tidak ditemukan" if params[:id].nil?
    else
      render pdf: DateTime.now.to_i.to_s,
        layout: 'pdf_layout.html.erb',
        template: "trx_buys/print_recap_monthly.html.slim"
    end
  end


  def daily_recap
    curr_date = DateTime.now
    end_day = (params[:date].to_s + " 00:00:00 +0700").to_time.end_of_day
    start_day = end_day.beginning_of_day
    @end = end_day
    @start = start_day
    cirata = Store.find_by(id: 2)
    plered = Store.find_by(id: 3)

    cash_flow = CashFlow.where("date >= ? AND date <= ?", start_day, end_day)
    trx = TrxBuy.where("date >= ? AND date <= ?", start_day, end_day)
    
    grand_total_plered = trx.where(store: plered).sum(:nominal)
    hpp_total_plered = 0
    trx.where(store: plered).each do |trx|
      hpp_total_plered += trx.trx_items.sum(:buy)
    end

    @margin_plered = grand_total_plered - hpp_total_plered
  
    cash_flow = CashFlow.where("date >= ? AND date <= ?", start_day, end_day)
    @operational = Operational.where("date >= ? AND date <= ?", start_day, end_day).sum(:nominal)
    @tax = Tax.where("date >= ? AND date <= ?", start_day, end_day).sum(:nominal)
    @fix_cost = FixCost.where("date >= ? AND date <= ?", start_day, end_day).sum(:nominal)
    @other_income = FixCost.where("date >= ? AND date <= ?", start_day, end_day).sum(:nominal)

    @other_outcome = FixCost.where("date >= ? AND date <= ?", start_day, end_day).sum(:nominal)
    
    @total_outcome = @operational + @fix_cost + @tax + @other_outcome
    @total_income = @margin_plered + @other_income

    start_day = (params[:date].to_s + " 00:00:00 +0700").to_time
    end_day = start_day.end_of_day
    @trx_buys = TrxBuy.where("date >= ? AND date <= ?", start_day, end_day)
    @trx_buys = @trx_buys.order("date DESC")
    @start_day = start_day
    @kriteria = "Rekap Harian - "+Date.today.to_s
    @cashiers = @trx_buys.pluck(:user_id)
    render pdf: DateTime.now.to_i.to_s,
      layout: 'pdf_layout.html.erb',
      template: "trx_buys/print_recap.html.slim"
  end

  def daily_recap_item
    start_day = params[:date].to_time
    end_day = start_day.end_of_day
    @transaction_items = TrxBuyItem.where(trx: TrxBuy.where("date >= ? AND date <= ?", start_day, end_day)).group(:item_id).count
    @transaction_items = @transaction_items.sort_by(&:last).reverse
    @item_cats = {}
    @transaction_items.each do |trx_item|
      item = Item.find_by(id: trx_item.first)
      item_cat = item.sub_category
      if @item_cats[item_cat.name].nil?
        @item_cats[item_cat.name] = trx_item[1] 
      else
        @item_cats[item_cat.name] = @item_cats[item_cat.name] + trx_item[1]
      end
    end
    @item_cats = Hash[@item_cats.sort_by{|k, v| v}.reverse]
    @start_day = start_day
    @kriteria = "Rekap Item Terjual - "+Date.today.to_s
    render pdf: DateTime.now.to_i.to_s,
      layout: 'pdf_layout.html.erb',
      template: "trx_buys/print_item_recap.html.slim"
  end

  private
   	def param_page	
   		params[:page]
   	end

    def transactions_profit_graph start_day, end_day
      transaction_datas = TrxBuy.where("date >= ? AND date <= ?", start_day, end_day).group_by{ |m| m.date.beginning_of_day}
      
      graphs = {}

      transaction_datas.each do |trxs|
        grand_total = 0
        hpp_total = 0
        day_idx = trxs[0].day.to_i - 1
        trxs[1].each do |trx|
          grand_total += trx.nominal
          hpp_total += trx.trx_items.sum(:buy)
        end
        profit = grand_total - hpp_total
        graphs[trxs[0].to_date] = [grand_total, hpp_total, profit]
      end
      vals = graphs.values
      grand_totals = vals.collect {|ind| ind[0]}
      hpp_totals = vals.collect {|ind| ind[1]}
      profits = vals.collect {|ind| ind[2]}
      days = graphs.keys
      days.each_with_index do |day, idx|
        days[idx] = day.to_date.to_s
      end

      return grand_totals, hpp_totals, profits, days
    end

    def filter_search params, r_type
      results = []
      @transactions = TrxBuy.all.order("date DESC")
      if params[:from].present?
        if params[:from] == "complain"
          curr_date = Date.today - 3.days
          @from = " Komplain ("+curr_date.to_s+" - "+Date.today.to_s+")"
          @transactions = @transactions.where("date > ?", curr_date)
        end
      end
      if r_type == "html"
        @transactions = @transactions.page param_page if r_type=="html"
      end
      @transactions = @transactions.where(store: current_user.store) if  !["owner", "super_admin", "finance"].include? current_user.level
      
      @search = ""
      if params["search"].present?
        @search += "Pencarian "+params["search"]
        search = params["search"].downcase
        @transactions =@transactions.where("invoice like ?", "%"+ search+"%")
      end

      date_start = params["date_start"]
      date_end = params["date_end"]
      if date_start.present?
        date_start += " " + params["hour_start"]
        date_end += " " + params["hour_end"]
        @search += " pada " + params["date_start"] + " hingga " + params["date_end"]
        @transactions = @transactions.where("date >= ? AND date <= ?", date_start.to_time ,date_end.to_time)
      end

      if params["user_id"].present?
        user = User.find_by(id: params["user_id"].to_i)
        if user.present?
          @search += " dengan user '" + user.name + "'"
          @transactions = @transactions.where(user: user)
        end
      end 

      store_name = "SEMUA TOKO"
      if params["store_id"].present?
        store = Store.find_by(id: params["store_id"])
        if store.present?
          @transactions = @transactions.where(store: store)
          store_name = store.name
          @search += "Pencarian" if @search==""
          @search += " di Toko '"+store.name+"'"
        else
          @search += "Pencarian" if @search==""
          @search += " di Semua Toko"
        end
      end

      results << @search
      results << @transactions
      results << store_name
      return results
    end

    def trx_items
      items = []
      par_items = params[:items].values
      par_items.each do |item|
        items << item.values
      end
      items
    end

end
