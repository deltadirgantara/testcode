class TaxsController < ApplicationController
  before_action :require_login

  def index
    search = filter_search params
    @search = search[0]
    @taxs = search[1]
    @store = search[2]
    @params = params.to_s
    
    graphs = graph @taxs
    gon.label = graphs[0]
    gon.data = graphs[1]
    gon.graph_name = "Pajak"

    respond_to do |format|
      format.html do
        @taxs = search[1].page param_page
      end
      format.pdf do
        @recap_type = "pajak"
        new_params = eval(params[:option])
        filter = filter_search new_params
        @search = filter[0]
        @taxs = filter[1]
        @store = filter[2]
        render pdf: DateTime.now.to_i.to_s,
          layout: 'pdf_layout.html.erb',
          template: "taxs/print.html.slim"
      end
    end
  end


  def show
  	return redirect_back_data_error taxs_path, "Data tidak ditemukan" if params[:id].nil?
  	@tax = Tax.find_by(id: params[:id])
  	return redirect_back_data_error taxs_path, "Data tidak ditemukan" if @tax.nil?

    respond_to do |format|
      format.html do
      end
      format.pdf do
        @recap_type = "invoice"
        render pdf: DateTime.now.to_i.to_s,
          layout: 'pdf_layout.html.erb',
          template: "taxs/invoice.html.slim"
      end
    end
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
    cf = CashFlow.find_by(ref_id: tax.id, type_cash: CashFlow::TAX)
    cf.destroy
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
    return redirect_success tax_path(id: @tax.id), "Data Pajak - " + @tax.invoice + " - Berhasil Diubah"
  end

  private
    def filter_search params
      results = []
      taxs = Tax.all
      taxs = taxs.where(store: current_user.store) if ["owner", "super_admin"].include? current_user.level
      search_text = ""
      if params["search"].present?
        search_text += " '"+params["search"]+"'"
        search = params["search"].downcase
        taxs = taxs.where("lower(invoice) like ?", "%"+ search+"%")
      end

      store = nil
      if params["store_id"].present?
        store = Store.find_by(id: params["store_id"])
        if store.present?
          taxs = taxs.where(store: store)
          search_text += " - Toko '" + store.name + "'"
        end
      end

      if params["start_date"].present?
        start_date = params["start_date"].to_date
        taxs = taxs.where("date >= ?", start_date)
        search_text += " - Dari '" + start_date.strftime("%d/%m/%Y").to_s + "'"
      end

      if params["end_date"].present?
        end_date = params["end_date"].to_date
        taxs = taxs.where("date <= ?", end_date)
        search_text += " - Sampai '" + end_date.strftime("%d/%m/%Y").to_s + "'"
      end

      search_text = "Pencarian" + search_text if search_text != ""
      return search_text, taxs, store
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

    def tax_params
      params.require(:tax).permit(
        :nominal, :date, :description
      )
    end

    def param_page
      params[:page]
    end
end