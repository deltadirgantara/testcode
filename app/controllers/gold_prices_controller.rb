class GoldPricesController < ApplicationController
  before_action :require_login

  def index
  	@gold_prices = GoldPrice.page param_page
  end

  def new
    @gold_types = GoldType.where.not(id: GoldPrice.all.pluck(:gold_type_id).uniq)
  end

  def create
  	gold_price = GoldPrice.new gold_params
    return redirect_back_data_error new_user_path, "Data tidak valid!" if gold_price.invalid?
    gold_price.save!
    gold_price.create_activity :create, owner: current_user
    return redirect_success gold_prices_path, "Harga Emas berhasil ditambahkan"
  end

  def edit
  	return redirect_back_data_error gold_prices_path, "Data tidak ditemukan" if params[:id].nil?
  	@gold = GoldPrice.find_by(id: params[:id])
  	return redirect_back_data_error gold_prices_path, "Data tidak ditemukan" if @gold.nil?
  end

  def update
  	return redirect_back_data_error gold_prices_path, "Data tidak ditemukan" if params[:id].nil?
  	gold = GoldPrice.find_by(id: params[:id])
  	return redirect_back_data_error gold_prices_path, "Data tidak ditemukan" if gold.nil?
  	gold.assign_attributes gold_params
  	changes = gold.changes
    if gold.changed?
      gold.save! 
      gold.create_activity :edit, owner: current_user, parameters: changes
    end
    return redirect_success gold_prices_path, "Data Harga Emas - " + gold.gold_type.name + " - Berhasil Diubah"

  end

  private
    def gold_params
      params.require(:gold).permit(
        :buy, :sell, :gold_type_id
      )
    end

    def param_page
      params[:page]
    end
end