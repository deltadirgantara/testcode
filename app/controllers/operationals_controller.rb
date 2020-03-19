class OperationalsController < ApplicationController
  before_action :require_login

  def index
  	@operationals = Operational.page param_page

    start_day = DateTime.now - 90.days
    end_day = DateTime.now + 1.day
    graphs = graph start_day, end_day
    gon.label = graphs[0]
    gon.data = graphs[1]
  end

  def show
  	return redirect_back_data_error operationals_path, "Date tidak ditemukan" if params[:id].nil?
  	@operational = Operational.find_by(id: params[:id])
  	return redirect_back_data_error operationals_path, "Data tidak ditemukan" if @operational.nil?
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
    CashFlow.create ref_id: operational.id, type_cash: 2, type_flow: 2
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
      @operational.create_activity :edit, owner: current_user, parameters: changes
    end
    return redirect_success operational_path(id: @operational.id), "Data Operasional - " + @operational.invoice + " - Berhasil Diubah"
  end

  private
    def graph start_day, end_day
      operationals_data = Operational.where("date >= ? AND date <= ?", start_day, end_day).order("date ASC").group_by{ |m| m.date.beginning_of_day}
      
      graphs = {}

      operationals_data.each do |operationals|
        total = 0
        day_idx = operationals[0].day.to_i - 1
        operationals[1].each do |operational|
          total += operational.nominal
        end
        graphs[operationals[0].to_date] = total
      end
      vals = graphs.values
      days = graphs.keys
      days.each_with_index do |day, idx|
        days[idx] = day.to_date.to_s
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