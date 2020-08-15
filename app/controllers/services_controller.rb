class ServicesController < ApplicationController
	before_action :require_login
  	before_action :require_fingerprint

  	def index
  		search = filter_search params
    	@search = search[0]
    	@services = search[1]
    	@store = search[2]
    	@params = params.to_s

    	respond_to do |format|
      		format.html do
        		@services = search[1].page param_page
      		end
      		format.pdf do
        		@recap_type = "services"
        		new_params = eval(params[:option])
        		filter = filter_search new_params
        		@search = filter[0]
        		@services = filter[1]
        		@store = filter[2]
        		render pdf: DateTime.now.to_i.to_s,
          			layout: 'pdf_layout.html.erb',
         			template: "services/print.html.slim"
      		end
    	end
  	end

  	def show
  		return redirect_back_data_error services_path, "Date tidak ditemukan" if params[:id].nil?
  		@service = Service.find_by(id: params[:id])
  		return redirect_back_data_error services_path, "Data tidak ditemukan" if @service.nil?
    
    	respond_to do |format|
      	format.html do
      	end
      	format.pdf do
        	@recap_type = "invoice"
        	render pdf: DateTime.now.to_i.to_s,
          		layout: 'pdf_layout.html.erb',
          		template: "services/invoice.html.slim"
      		end
    	end
  	end

  def new
  	@suppliers = Supplier.all
  end

  private
  	def filter_search params
      results = []
      services = Service.all
      services = services.where(store: current_user.store) if !["owner", "super_admin"].include? current_user.level
      search_text = ""
      if params["search"].present?
        search_text += " '"+params["search"]+"'"
        search = params["search"].downcase
        services = services.where("lower(invoice) like ?", "%"+ search+"%")
      end

      store = nil
      if params["store_id"].present?
        store = Store.find_by(id: params["store_id"])
        if store.present?
          services = services.where(store: store)
          search_text += " - Toko '" + store.name + "'"
        end
      end

      search_text = "Pencarian" + search_text if search_text != ""
      return search_text, services, store
    end

  	def service_params
      params.require(:service).permit(
        :service_item, :description
      )
    end

    def param_page
      params[:page]
    end
end
  