class BanksController < ApplicationController
  before_action :require_login

  def index
  	search = filter_search params
    @search = search[0]
    @banks = search[1]
    @params = params.to_s

    respond_to do |format|
      format.html do
        @banks = search[1].page param_page
      end
    end
  end

  def show
  	return redirect_back_data_error banks_path, "Data tidak ditemukan" if params[:id].nil?
  	@bank = Bank.find_by(id: params[:id])
  	return redirect_back_data_error banks_path, "Data tidak ditemukan" if @bank.nil?
  end

  def new
  end

  def create
  	bank = Bank.new bank_params
    return redirect_back_data_error new_user_path, "Data tidak valid!" if bank.invalid?
    bank.save!
    bank.create_activity :create, owner: current_user
    return redirect_success bank_path(id: bank.id), "Bank berhasil ditambahkan"
  end

  def destroy
  	return redirect_back_data_error banks_path, "Data tidak ditemukan" if params[:id].nil?
  	bank = Bank.find_by(id: params[:id])
  	return redirect_back_data_error banks_path, "Data tidak ditemukan" if bank.nil?
  	return redirect_back_data_error banks_path, "Data tidak dapat dihapus" if bank.store_banks.count > 0
  	bank_name = bank.name
  	bank.destroy
  	return redirect_success banks_path, "Data Bank - " + bank_name + " berhasil dihapus"
  end

  def edit
  	return redirect_back_data_error banks_path, "Data tidak ditemukan" if params[:id].nil?
  	@bank = Bank.find_by(id: params[:id])
  	return redirect_back_data_error banks_path, "Data tidak ditemukan" if @bank.nil?
  end

  def update
  	return redirect_back_data_error banks_path, "Data tidak ditemukan" if params[:id].nil?
  	bank = Bank.find_by(id: params[:id])
  	return redirect_back_data_error banks_path, "Data tidak ditemukan" if bank.nil?
  	bank.assign_attributes bank_params
  	changes = bank.changes
    bank.save! if bank.changed?
    bank.create_activity :edit, owner: current_user, parameters: changes
    return redirect_success bank_path(id: bank.id), "Data Bank - " + bank.name + " - Berhasil Diubah"

  end

  private
    def filter_search params
      results = []
      banks = Bank.all
      search_text = ""
      if params["search"].present?
        search_text += " '"+params["search"]+"'"
        search = params["search"].downcase
        banks = banks.where("lower(name) like ?", "%"+ search+"%")
      end

      search_text = "Pencarian" + search_text if search_text != ""
      return search_text, banks
    end

    def bank_params
      params.require(:bank).permit(
        :name
      )
    end

    def param_page
      params[:page]
    end
end