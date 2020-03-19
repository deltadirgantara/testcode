class TaxsController < ApplicationController
  before_action :require_login

  def index
    @taxs = Tax.page param_page
    
    store = current_user.store
    start_day = DateTime.now - 90.days
    end_day = DateTime.now + 1.day
    graphs = graph start_day, end_day, store
    gon.label = graphs[0]
    gon.data = graphs[1]
    gon.graph_name = "Pajak"
  end


  def show
  	return redirect_back_data_error taxs_path, "Data tidak ditemukan" if params[:id].nil?
  	@tax = Tax.find_by(id: params[:id])
  	return redirect_back_data_error taxs_path, "Data tidak ditemukan" if @tax.nil?
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
    def graph start_day, end_day, store
      taxs_data = Tax.where(store: store).where("date >= ? AND date <= ?", start_day, end_day).order("date ASC").group_by{ |m| m.date.beginning_of_day}
      
      graphs = {}

      taxs_data.each do |taxs|
        total = 0
        day_idx = taxs[0].day.to_i - 1
        taxs[1].each do |tax|
          total += tax.nominal
        end
        graphs[taxs[0].to_date] = total
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