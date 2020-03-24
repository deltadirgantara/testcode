  class ModalsController < ApplicationController
  before_action :require_login

  def index
    search = filter_search params
    @search = search[0]
    @modals = search[1]
    @store = search[2]
    @params = params.to_s

    graphs = graph @modals
    gon.label = graphs[0]
    gon.debit = graphs[1]
    gon.kredit = graphs[2]
    gon.graph_name = "Modal"

    respond_to do |format|
      format.html do
        @modals = search[1].page param_page
      end
      format.pdf do
        new_params = eval(params[:option])
        filter = filter_search new_params
        @search = filter[0]
        @modals = filter[1]
        @store = filter[2]
        @recap_type = "fix_cost"
        render pdf: DateTime.now.to_i.to_s,
          layout: 'pdf_layout.html.erb',
          template: "modals/print.html.slim"
      end
    end
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
      CashFlow.create store: current_user.store, ref_id: modal.id, type_cash: 4, type_flow: 2
  	else
      CashFlow.create store: current_user.store, ref_id: modal.id, type_cash: 4, type_flow: 1
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
    return redirect_success modal_path(id: @modal.id), "Data - " + @modal.invoice + " - Berhasil Diubah"
  end

  private
    def filter_search params
      results = []
      modals = Modal.all
      modals = modals.where(store: current_user.store) if !["owner", "super_admin"].include? current_user.level?
      search_text = ""
      if params["search"].present?
        search_text += " '"+params["search"]+"'"
        search = params["search"].downcase
        modals = modals.where("lower(invoice) like ?", "%"+ search+"%")
      end

      store = nil
      if params["store_id"].present?
        store = Store.find_by(id: params["store_id"])
        if store.present?
          modals = modals.where(store: store)
          search_text += " - Toko '" + store.name + "'"
        end
      end

      if params["start_date"].present?
        start_date = params["start_date"].to_date
        modals = modals.where("date >= ?", start_date)
        search_text += " - Dari '" + start_date.strftime("%d/%m/%Y").to_s + "'"
      end

      if params["end_date"].present?
        end_date = params["end_date"].to_date
        modals = modals.where("date <= ?", end_date)
        search_text += " - Sampai '" + end_date.strftime("%d/%m/%Y").to_s + "'"
      end

      search_text = "Pencarian" + search_text if search_text != ""
      return search_text, modals, store
    end

    def graph data
      modals_data = data.group_by{ |m| m.date.beginning_of_day}
      graphs = {}

      modals_data.each do |modals|
        debit = 0
        kredit = 0
        day_idx = modals[0].day.to_i - 1
        modals[1].each do |modal|
          if modal.type_modal == "IN"
            debit += modal.nominal
          else
            kredit += modal.nominal
          end
        end
        graphs[modals[0].to_date] = [debit,kredit]
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

    def modal_params
      params.require(:modal).permit(
        :nominal, :date, :description, :type_modal
      )
    end

    def param_page
      params[:page]
    end
end