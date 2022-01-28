module Admin
  class OrderSmsMessagesController < ApplicationController
    before_action :init_service
    def index
      @pagy, @sms_messages=pagy(@sms_message_service.list)
    end

    private

    def init_service
      @sms_message_service = OrderSmsMessages::OrderSmsMessagesService.new(current_user)
    end

  end
end