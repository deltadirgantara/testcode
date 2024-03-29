class AssetValuesController < ApplicationController
  before_action :require_login

  def index
    search = filter_search params

    @search = search[0]
    @asset_values = search[1]
    @store = search[2]
    @params = params.to_s

    graphs = graph @asset_values
    gon.label = graphs[0]
    gon.data = graphs[1]
    gon.graph_name = "Nilai Aset"

    

    respond_to do |format|
      format.html do
        @asset_values = search[1].page param_page
      end
      format.pdf do
        new_params = eval(params[:option])
        filter = filter_search new_params
        @search = filter[0]
        @asset_values = filter[1]
        @store = filter[2]
        @recap_type = "asset_values"
        render pdf: DateTime.now.to_i.to_s,
          layout: 'pdf_layout.html.erb',
          template: "asset_values/print.html.slim"
      end
    end
  end

  def refresh
    Refresh.asset_values
    return redirect_success asset_values_path, "Nilai Aset tanggal " + Date.today.to_s + " telah diperbarui "  
  end

  private
    def filter_search params
      results = []
      asset_values = AssetValue.all

      asset_values = asset_values.where(store: current_user.store) if !["owner", "super_admin"].include? current_user.level

      search_text = ""
      if params["search"].present?
        search_text += " '"+params["search"]+"'"
        search = params["search"].downcase
        asset_values = asset_values.where("lower(invoice) like ?", "%"+ search+"%")
      end

      store = nil
      if params["store_id"].present?
        store = Store.find_by(id: params["store_id"])
        if store.present?
          asset_values = asset_values.where(store: store)
          search_text += " - Toko '" + store.name + "'"
        end
      end

      if params["start_date"].present?
        start_date = params["start_date"].to_date
        asset_values = asset_values.where("date >= ?", start_date)
        search_text += " - Dari '" + start_date.strftime("%d/%m/%Y").to_s + "'"
      end

      if params["end_date"].present?
        end_date = params["end_date"].to_date
        asset_values = asset_values.where("date <= ?", end_date)
        search_text += " - Sampai '" + end_date.strftime("%d/%m/%Y").to_s + "'"
      end

      search_text = "Pencarian" + search_text if search_text != ""
      return search_text, asset_values, store
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

    def asset_value_params
      params.require(:asset_value).permit(
        :nominal, :date, :description
      )
    end


    def param_page
      params[:page]
    end
end