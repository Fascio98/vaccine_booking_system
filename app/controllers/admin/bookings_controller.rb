module Admin
  class BookingsController < ApplicationController
    before_action :init_service

    def index
      @pagy, @bookings=pagy(@booking_service.list)
    end

    def new
      result=@booking_service.new

      @booking=result.booking
    end

    def init_service
      @booking_service = Bookings::BookingService.new(current_user)
    end
  end
end