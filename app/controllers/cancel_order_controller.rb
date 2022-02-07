class CancelOrderController < ApplicationController
  before_action :init_service

  def cancel_order
    if @that_order.length == 1
      if @that_order.last.patient.mobile_phone == @that_patient.mobile_phone
        @that_business_unit = BusinessUnit.find_by(id: @that_order.last.business_unit_slot&.business_unit&.id)
      end
    end
  rescue => e
    @record = e.exception('Record Not Found')
  end

  def cancel_order_finalize
    @booking = Booking.find_by(order_id: @that_order.last.id)
    @sms = Web::DeleteOrderSmsService.new(@booking).call
    SendOrderSmsVerifyWorker.perform_async(@sms.id)
    @that_sms_verify=VerifySmsMessage.verify_order_message(params[:search_sms_message])

    if @that_sms_verify.length == 1
      if @booking.id == @that_sms_verify.last.booking.id
        @that_order.last.update!(finished: false)
        redirect_to root_path
      end
    end

  rescue => e
    @record = e.exception('Record Not Found')
  end

  private

  def init_service
    @that_order = Order.order_code_find(params[:search_order]).finished
    @that_patient = Patient.search_patient(params[:search_patient]).last
  rescue => e
    @record = e.exception('Record Not Found')
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