class VerifySmsMessage < ApplicationRecord
  belongs_to :booking

  def self.verify_order_message(search)
    if search
      verify_order_message = VerifySmsMessage.find_by(code: search)

      if verify_order_message
        self.where(id: verify_order_message)
      end
    else
      @that_sms_verify=VerifySmsMessage.all
    end
  end
end
