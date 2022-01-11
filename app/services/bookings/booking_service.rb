module Bookings
  class BookingService
    attr_reader :current_user, :result
    def initialize(current_user)
      @current_user = current_user
      @result = OpenStruct.new(success?: false, booking: Booking.new)
    end

    def list
      Booking.all
    end

    def new
      result
    end
  end
end