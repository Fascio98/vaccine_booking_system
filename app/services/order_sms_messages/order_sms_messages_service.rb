module OrderSmsMessages
  class OrderSmsMessagesService
    attr_reader :current_user, :result
    def initialize(current_user)
      @current_user = current_user
      @result = OpenStruct.new(success?: false, order_sms_message: OrderSmsMessage.new)
    end

    def list
      OrderSmsMessage.all
    end
  end
end