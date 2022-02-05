class Patient < ApplicationRecord
  validates :first_name, :last_name, :birth_date, :pin, :mobile_phone, presence:true
  validates :pin, length: {is: 11}, unless: Proc.new {|rec| rec.non_resident?}

  validates_presence_of :search_patient

  def self.search_patient(search)
    if search
      mobile_phone = Patient.find_by(mobile_phone: search)

      if mobile_phone
        self.where(id: mobile_phone)
      end
    else
      @that_patient=Patient.all
    end
  end

end
