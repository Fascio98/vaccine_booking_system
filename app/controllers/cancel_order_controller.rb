class CancelOrderController < ApplicationController
  def cancel_order
    @that_order = Order.order_code(params[:search_order]).finished.first
    @that_patient = Patient.search_patient(params[:search_patient]).first

    if @that_order.patient.mobile_phone == @that_patient.mobile_phone
      @that_business_unit = BusinessUnit.find_by(id: @that_order.business_unit_slot&.business_unit&.id)
    end
  rescue => e
    @record = e.exception('Record Not Found')
  end

  def cancel_order_finalize
    # if @that_order.exists? && @that_patient
    #   if @that_order.patient_id == @that_patient.__id__
    #     @that_order
    #   end
    # end
  end

  private

  def order_params
    params.require(:order).permit(:id,:order_code, :search_order)
  end

  def patient_params
    params.require(:patient).permit(:id,:mobile_phone, :search_patient)
  end
end