class OperationalsController < ApplicationController
  before_action :require_login

  def index
  	search = filter_search params
    @search = search[0]
    @operationals = search[1]
    @store = search[2]
    @params = params.to_s

    graphs = graph @operationals
    gon.label = graphs[0]
    gon.data = graphs[1]
    gon.graph_name = "Biaya Operasional"

    respond_to do |format|
      format.html do
        @operationals = search[1].page param_page
      end
      format.pdf do
        @recap_type = "operational"
        new_params = eval(params[:option])
        filter = filter_search new_params
        @search = filter[0]
        @operationals = filter[1]
        @store = filter[2]
        render pdf: DateTime.now.to_i.to_s,
          layout: 'pdf_layout.html.erb',
          template: "operationals/print.html.slim"
      end
    end
  end

  def show
  	return redirect_back_data_error operationals_path, "Date tidak ditemukan" if params[:id].nil?
  	@operational = Operational.find_by(id: params[:id])
  	return redirect_back_data_error operationals_path, "Data tidak ditemukan" if @operational.nil?
    
    respond_to do |format|
      format.html do
      end
      format.pdf do
        @recap_type = "invoice"
        render pdf: DateTime.now.to_i.to_s,
          layout: 'pdf_layout.html.erb',
          template: "operationals/invoice.html.slim"
      end
    end
  end

  def new
  end

  def create
    operational = Operational.new operational_params
    operational.store = current_user.store
    operational.user = current_user
    return redirect_back_data_error new_operational_path, "Data error" if operational.nominal < 10000   || operational.date > Date.today
    operational.invoice = "OPR-" + DateTime.now.to_i.to_s + current_user.store.id.to_s
    return redirect_back_data_error new_operational_path, "Data error" if operational.invalid?  
  	operational.save!
    CashFlow.create store: current_user.store, ref_id: operational.id, type_cash: 2, type_flow: 2, nominal: other_income.nominal, date: other_income.date
  	operational.create_activity :create, owner: current_user
  	return redirect_success operational_path(id: operational.id), "Data disimpan"
  end

  def destroy
  	return redirect_back_data_error operationals_path, "Data tidak ditemukan" if params[:id].nil?
  	operational = Operational.find_by(id: params[:id])
  	return redirect_back_data_error operationals_path, "Data tidak ditemukan" if operational.nil?
    cf = CashFlow.find_by(ref_id: operational.id, type_cash: CashFlow::OPERATIONAL)
    cf.destroy
  	operational.destroy
  	return redirect_success operationals_path, "Data " + operational.invoice + " dihapus"
  end

  def edit
  	return redirect_back_data_error operationals_path, "Data tidak ditemukan" if params[:id].nil?
  	@operational = Operational.find_by(id: params[:id])
  	return redirect_back_data_error operationals_path, "Data tidak ditemukan" if @operational.nil?
  end

  def update
  	return redirect_back_data_error operationals_path, "Data tidak ditemukan" if params[:id].nil?
  	@operational = Operational.find_by(id: params[:id])
  	return redirect_back_data_error operationals_path, "Data tidak ditemukan" if @operational.nil?
  	@operational.assign_attributes operational_params
    return redirect_back_data_error operational_path(id: operational.id), "Data error" if @operational.nominal < 10000   || @operational.date > Date.today
  	return redirect_success operational_path(id: @operational.id), "Data tidak ada perubahan" if !@operational.changed
  	changes = @operational.changes
    if @operational.changed?
      @operational.save! 
      cf = CashFlow.find_by(ref_id: operational.id, type_cash: CashFlow::OPERATIONAL)
      cf.nominal = @operational.nominal
      cf.save!
      @operational.create_activity :edit, owner: current_user, parameters: changes
    end
    return redirect_success operational_path(id: @operational.id), "Data Operasional - " + @operational.invoice + " - Berhasil Diubah"
  end

  private
    def filter_search params
      results = []
      operationals = Operational.all
      operationals = operationals.where(store: current_user.store) if !["owner", "super_admin"].include? current_user.level
      search_text = ""
      if params["search"].present?
        search_text += " '"+params["search"]+"'"
        search = params["search"].downcase
        operationals = operationals.where("lower(invoice) like ?", "%"+ search+"%")
      end

      store = nil
      if params["store_id"].present?
        store = Store.find_by(id: params["store_id"])
        if store.present?
          operationals = operationals.where(store: store)
          search_text += " - Toko '" + store.name + "'"
        end
      end

      if params["start_date"].present?
        start_date = params["start_date"].to_date
        operationals = operationals.where("date >= ?", start_date)
        search_text += " - Dari '" + start_date.strftime("%d/%m/%Y").to_s + "'"
      end

      if params["end_date"].present?
        end_date = params["end_date"].to_date
        operationals = operationals.where("date <= ?", end_date)
        search_text += " - Sampai '" + end_date.strftime("%d/%m/%Y").to_s + "'"
      end

      search_text = "Pencarian" + search_text if search_text != ""
      return search_text, operationals, store
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

    def operational_params
      params.require(:operational).permit(
        :nominal, :date, :description
      )
    end

    def param_page
      params[:page]
    end
end