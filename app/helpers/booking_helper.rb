module BookingHelper
  def vaccine_name(vaccine_item)
    VaccinesItem.find(vaccine_item).name
  end

  def patient_pin(booking)
    Patient.find(booking).pin
  end
end