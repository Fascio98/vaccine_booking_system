class CancelOrderController < ApplicationController
  #before_action :fetch_booking, only: %i[cancel_order]
  before_action :init_service

  def cancel_order
    if @that_order.patient.mobile_phone == @that_patient.mobile_phone
      @that_business_unit = BusinessUnit.find_by(id: @that_order.business_unit_slot&.business_unit&.id)
    end
  rescue => e
    @record = e.exception('Record Not Found')
  end

  def cancel_order_finalize
    @booking = Booking.find_by(order_id: @that_order.id)
    @sms = Web::DeleteOrderSmsService.new(@booking).call
    SendOrderSmsVerifyWorker.perform_async(@sms.id)
    @that_sms_verify=VerifySmsMessage.verify_order_message(params[:search_sms_message]).last
  rescue => e
    @record1 = e.exception('Record Not Found')
  end

  private

  def init_service
    @that_order = Order.order_code(params[:search_order]).finished.last
    @that_patient = Patient.search_patient(params[:search_patient]).last
  end

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