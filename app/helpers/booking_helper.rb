module BookingHelper
  def vaccine_name(vaccine_item)
    if VaccinesItem.exists?(vaccine_item)
      VaccinesItem.find(vaccine_item).name
    end
  end

  def patient_pin(booking)
    if Patient.exists?(booking)
      Patient&.find(booking).pin
    end
  end
end