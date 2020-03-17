class CustomOrdersController < ApplicationController
  before_action :require_login

  def index
  	@custom_orders = CustomOrder.page param_page
  end


  private

    def param_page
      params[:page]
    end

end