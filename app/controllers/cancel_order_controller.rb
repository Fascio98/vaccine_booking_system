class CancelOrderController < ApplicationController
  #before_action :fetch_booking, only: %i[cancel_order]
  attr_reader :that_order

  def cancel_order
    @that_order = Order.order_code(params[:search_order]).finished.first
    @that_patient = Patient.search_patient(params[:search_patient]).first

    if @that_order.patient.mobile_phone == @that_patient.mobile_phone
      @that_business_unit = BusinessUnit.find_by(id: @that_order.business_unit_slot&.business_unit&.id)
      @booking = Booking.find_by(order_id: @that_order.id)
      @result1 = result.call(booking)
      @result = Web::DeleteStepService.new(current_user)
    end
  rescue => e
    @record = e.exception('Record Not Found')
  end

  def cancel_order_finalize
    #@booking = Booking.find_by(order_id: @that_order.id)
    @that_sms_verify=VerifySmsMessage.verify_order_message(params[:search_sms_message]).first
  rescue => e
    @record1 = e.exception('Record Not Found')
  end

  private

  # def fetch_booking
  #   booking_uuid = cookies.signed[:booking_uuid]
  #
  #
  #   if booking_uuid.present?
  #     @booking = Booking.find_by(guid: booking_uuid)
  #   end
  # end

  def order_params
    params.require(:order).permit(:id,:order_code, :search_order)
  end

  def patient_params
    params.require(:patient).permit(:id,:mobile_phone, :search_patient)
  end

  def verify_sms_message_params
    params.require(:verify_sms_message).permit(:id, :search_sms_message)
  end
end