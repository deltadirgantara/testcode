class TaxsController < ApplicationController
  before_action :require_login

  def index
  	@taxs = Taxs.page param_page
  end

  def show
  	return redirect_back_data_error taxs_path, "Date tidak ditemukan" if params[:id].nil?
  	@taxs = Taxs.find_by(id: params[:id])
  	return redirect_back_data_error taxs_path, "Data tidak ditemukan" if @tax.nil?
  end

  def new
  	@taxs = Taxs.all
  end

  def create
  	tax = Taxs.new tax_params
  	return redirect_back_data_error new_taxs_path, "Data error" if tax.invalid?
  	tax.save!
  	tax.create_activity :create, owner: current_user
  	return redirect_success tax_path(id: tax.id), "Data disimpan"
  end

  def destroy
  	return redirect_back_data_error taxs_path, "Data tidak ditemukan" if params[:id].nil?
  	tax = Taxs.find_by(id: params[:id])
  	return redirect_back_data_error taxs_path, "Data tidak ditemukan" if tax.nil?
  	tax.destroy
  	return redirect_success taxs_path, "Data " + tax.name + " dihapus"
  end

  def edit
  	return redirect_back_data_error taxs_path, "Date tidak ditemukan" if params[:id].nil?
  	@tax = Taxs.find_by(id: params[:id])
  	return redirect_back_data_error taxs_path, "Data tidak ditemukan" if @tax.nil?
  	@stores = Store.all
  end

  def update
  	return redirect_back_data_error taxs_path, "Date tidak ditemukan" if params[:id].nil?
  	@tax = Taxs.find_by(id: params[:id])
  	return redirect_back_data_error taxs_path, "Data tidak ditemukan" if @tax.nil?
  	@tax.assign_attributes tax_params
  	return redirect_success taxs_path(id: @tax.id), "Data tidak ada perubahan" if !@tax.changed
  	@tax.save!
  	changes = @tax.changes
  	@tax.create_activity :edit, owner: current_user, params: changes
  	return redirect_success tax_path(id: @tax.id), "Data disimpan" if !@tax.changed
  end

  private
    def tax_params
      params.require(:tax).permit(
        :user_id, :store_id, :nominal, :invoice
      )
    end

    def param_page
      params[:page]
    end
end