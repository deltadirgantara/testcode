class FixCostsController < ApplicationController
  before_action :require_login

  def index
    @fix_costs = FixCost.page param_page
    binding.pry
  end

  def show
    return redirect_back_data_error fix_costs_path, "Data tidak ditemukan" if params[:id].nil?
    @fix_cost = FixCost.find_by(id: params[:id])
    return redirect_back_data_error fix_costs_path, "Data tidak ditemukan" if @fix_cost.nil?
  end

  def new
  end

  def create
    fix_cost = FixCost.new fix_cost_params
    fix_cost.store = current_user.store
    fix_cost.user = current_user
    return redirect_back_data_error new_fix_cost_path, "Data error" if fix_cost.nominal < 10000  || fix_cost.date > Date.today
    fix_cost.invoice = "FIX-" + DateTime.now.to_i.to_s + current_user.store.id.to_s
    return redirect_back_data_error new_fix_cost_path, "Data error" if fix_cost.invalid?  
    fix_cost.save!
    CashFlow.create ref_id: fix_cost.id, type_cash: 1, type_flow: 2
    fix_cost.create_activity :create, owner: current_user
    return redirect_success fix_cost_path(id: fix_cost.id), "Data disimpan"
  end

  def destroy
    return redirect_back_data_error fix_costs_path, "Data tidak ditemukan" if params[:id].nil?
    fix_cost = FixCost.find_by(id: params[:id])
    return redirect_back_data_error fix_costs_path, "Data tidak ditemukan" if fix_cost.nil?
    fix_cost.destroy
    return redirect_success fix_costs_path, "Data " + fix_cost.invoice + " dihapus"
  end

  def edit
    return redirect_back_data_error fix_costs_path, "Data tidak ditemukan" if params[:id].nil?
    @fix_cost = FixCost.find_by(id: params[:id])
    return redirect_back_data_error fix_costs_path, "Data tidak ditemukan" if @fix_cost.nil?
  end

  def update
    return redirect_back_data_error fix_costs_path, "Data tidak ditemukan" if params[:id].nil?
    @fix_cost = FixCost.find_by(id: params[:id])
    return redirect_back_data_error fix_costs_path, "Data tidak ditemukan" if @fix_cost.nil?
    @fix_cost.assign_attributes fix_cost_params
    return redirect_back_data_error fix_cost_path(id: fix_cost.id), "Data error" if @fix_cost.nominal < 10000  || @fix_cost.date > Date.today
    return redirect_success fix_cost_path(id: fix_cost.id), "Data tidak ada perubahan" if !@fix_cost.changed
    changes = @fix_cost.changes
    if @fix_cost.changed?
      @fix_cost.save! 
      @fix_cost.create_activity :edit, owner: current_user, parameters: changes
    end
    return redirect_success fix_cost_path(id: fix_cost.id), "Data Pajak - " + @fix_cost.invoice + " - Berhasil Diubah"
  end

  private
    def fix_cost_params
      params.require(:fix_cost).permit(
        :nominal, :date, :description
      )
    end

    def param_page
      params[:page]
    end
end