module Orders
  class OrderService
    attr_reader :current_user, :result

    def initialize(current_user)
      @current_user = current_user
      @result = OpenStruct.new(success?: false, order: Order.new)
    end

    def list
      Order.all
    end
  end
end
