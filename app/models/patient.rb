class Patient < ApplicationRecord
  validates :first_name, :last_name, :birth_date, :pin, :mobile_phone, presence:true
  validates :pin, length: {is: 11}, unless: Proc.new {|rec| rec.non_resident?}


end
