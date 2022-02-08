class CancelOrderController < ApplicationController
  before_action :init_service
  before_action :catch_errors

  def cancel_order
    if @that_order.present?
      if @that_order.last.patient.mobile_phone == @that_patient.mobile_phone
        @that_business_unit = BusinessUnit.find_by(id: @that_order.last.business_unit_slot&.business_unit&.id)
        @booking = Booking.find_by(order_id: @that_order.last.id)
        @sms = Web::DeleteOrderSmsService.new(@booking).call
        SendOrderSmsVerifyWorker.perform_async(@sms.id)
      end
    end
  rescue
    catch_errors
  end

  def cancel_order_finalize

    @that_sms_verify=VerifySmsMessage.verify_order_message(params[:search_sms_message])

    if @that_sms_verify.present?
      if VerifySmsMessage.where(booking_id: @that_sms_verify.last.booking.id).last == @that_sms_verify.last
        @that_sms_verify.last.booking.order.update!(finished: false)
        redirect_to root_path
      end
    end
  end

  def catch_errors
    @record = 'Record Not Found'
  end

  private

  def init_service
    @that_order = Order.finished.order_code_find(params[:search_order])
    @that_patient = Patient.search_patient(params[:search_patient]).last
  rescue
    catch_errors
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