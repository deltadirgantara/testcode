class MeltsController < ApplicationController
	before_action :require_login
  	before_action :require_fingerprint

  	def index
  		search = filter_search params
    	@search = search[0]
    	@melts = search[1]
    	@store = search[2]
    	@params = params.to_s

    	respond_to do |format|
      		format.html do
        		@melts = search[1].page param_page
      		end
      		format.pdf do
        		@recap_type = "melts"
        		new_params = eval(params[:option])
        		filter = filter_search new_params
        		@search = filter[0]
        		@melts = filter[1]
        		@store = filter[2]
        		render pdf: DateTime.now.to_i.to_s,
          			layout: 'pdf_layout.html.erb',
         			template: "melts/print.html.slim"
      		end
    	end
  	end

  	def show
  		return redirect_back_data_error melts_path, "Date tidak ditemukan" if params[:id].nil?
  		@melt = Melt.find_by(id: params[:id])
  		return redirect_back_data_error melts_path, "Data tidak ditemukan" if @melt.nil?
    
    	respond_to do |format|
      	format.html do
      	end
      	format.pdf do
        	@recap_type = "invoice"
        	render pdf: DateTime.now.to_i.to_s,
          		layout: 'pdf_layout.html.erb',
          		template: "melts/invoice.html.slim"
      		end
    	end
  	end

  def new
  	@suppliers = Supplier.all
  end

  private
  	def filter_search params
      results = []
      melts = Melt.all
      melts = melts.where(store: current_user.store) if !["owner", "super_admin"].include? current_user.level
      search_text = ""
      if params["search"].present?
        search_text += " '"+params["search"]+"'"
        search = params["search"].downcase
        melts = melts.where("lower(invoice) like ?", "%"+ search+"%")
      end

      store = nil
      if params["store_id"].present?
        store = Store.find_by(id: params["store_id"])
        if store.present?
          melts = melts.where(store: store)
          search_text += " - Toko '" + store.name + "'"
        end
      end

      search_text = "Pencarian" + search_text if search_text != ""
      return search_text, melts, store
    end

  	def melt_params
      params.require(:melt).permit(
        :melt_item, :description
      )
    end

    def param_page
      params[:page]
    end
end
  