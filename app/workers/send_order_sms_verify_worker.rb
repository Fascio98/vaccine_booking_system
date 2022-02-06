class SendOrderSmsVerifyWorker
  include Sidekiq::Worker

  def perform(sms_id)
    record = VerifySmsMessage.find(sms_id)
    record.update!(sent_at: Time.current, approved_at: Time.current)
  end
end