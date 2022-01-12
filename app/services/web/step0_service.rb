module Web
  class Step0Service
    attr_accessor :current_vaccine, :record, :booking, :browser, :ip_address
    def initialize(vaccine,browser,ip_address)
      @vaccine = vaccine
      @browser = browser
      @ip_address = ip_address
    end

    def call(current_booking)
      @record = current_booking&.patient || Patient.new
      @current_vaccine = current_booking&.vaccine || @vaccine
      @booking = current_booking || Booking.create(guid: SecureRandom.uuid, vaccine_id: @current_vaccine.id,
                                                   browser_name: @browser.name, ip_address: @ip_address, os_name: @browser.platform.name)
    end
  end
end