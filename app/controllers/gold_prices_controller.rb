class GoldPricesController < ApplicationController
  before_action :require_login

  def index
    search = filter_search params
    @search = search[0]
    @gold_prices = search[1].page param_page
    @params = params.to_s
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
    def filter_search params
      results = []
      gold_types = GoldType.all
      search_text = ""
      if params["search"].present?
        search_text += " '"+params["search"]+"'"
        search = params["search"].downcase
        gold_types = gold_types.where("lower(name) like ?", "%"+ search+"%")
      end

      gold_prices = GoldPrice.where(gold_type: gold_types)
      search_text = "Pencarian" + search_text if search_text != ""
      return search_text, gold_prices
    end

    def gold_params
      params.require(:gold).permit(
        :buy, :sell, :gold_type_id
      )
    end

    def param_page
      params[:page]
    end
end