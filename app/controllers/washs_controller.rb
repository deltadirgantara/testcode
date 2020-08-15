class WashsController < ApplicationController
	before_action :require_login
  	before_action :require_fingerprint

  	def index
  		search = filter_search params
    	@search = search[0]
    	@washs = search[1]
    	@store = search[2]
    	@params = params.to_s

    	respond_to do |format|
      		format.html do
        		@washs = search[1].page param_page
      		end
      		format.pdf do
        		@recap_type = "washs"
        		new_params = eval(params[:option])
        		filter = filter_search new_params
        		@search = filter[0]
        		@washs = filter[1]
        		@store = filter[2]
        		render pdf: DateTime.now.to_i.to_s,
          			layout: 'pdf_layout.html.erb',
         			template: "washs/print.html.slim"
      		end
    	end
  	end

  	def show
  		return redirect_back_data_error washs_path, "Date tidak ditemukan" if params[:id].nil?
  		@wash = Wash.find_by(id: params[:id])
  		return redirect_back_data_error washs_path, "Data tidak ditemukan" if @wash.nil?
    
    	respond_to do |format|
      	format.html do
      	end
      	format.pdf do
        	@recap_type = "invoice"
        	render pdf: DateTime.now.to_i.to_s,
          		layout: 'pdf_layout.html.erb',
          		template: "washs/invoice.html.slim"
      		end
    	end
  	end

  def new
  	@suppliers = Supplier.all
  end

  private
  	def filter_search params
      results = []
      washs = Wash.all
      washs = washs.where(store: current_user.store) if !["owner", "super_admin"].include? current_user.level
      search_text = ""
      if params["search"].present?
        search_text += " '"+params["search"]+"'"
        search = params["search"].downcase
        washs = washs.where("lower(invoice) like ?", "%"+ search+"%")
      end

      store = nil
      if params["store_id"].present?
        store = Store.find_by(id: params["store_id"])
        if store.present?
          washs = washs.where(store: store)
          search_text += " - Toko '" + store.name + "'"
        end
      end

      search_text = "Pencarian" + search_text if search_text != ""
      return search_text, washs, store
    end

  	def wash_params
      params.require(:wash).permit(
        :wash_item, :description
      )
    end

    def param_page
      params[:page]
    end
end