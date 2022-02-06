module Web
  class DeleteOrderSmsService
    attr_reader :booking

    def initialize(booking)
      @booking = booking
    end

    def call
      VerifySmsMessage.create!(booking_id: booking.id, code: order_code, sent_at: sent_at, approved_at: approved_at)
    end

    private

    def order_code
      rand(10000)
    end

    def sent_at
      DateTime.now
    end

    def approved_at
      DateTime.now
    end
  end
end