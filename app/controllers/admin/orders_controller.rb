module Admin
  class OrdersController < ApplicationController
    before_action :init_service
    def index
      @pagy, @orders=pagy(@order_service.list)
    end

    private

    def init_service
      @order_service = Orders::OrderService.new(current_user)
    end

  end
end