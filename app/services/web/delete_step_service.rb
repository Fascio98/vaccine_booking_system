module Web
  class DeleteStepService

    attr_reader :current_user, :result
    def initialize(current_user)
      @current_user = current_user
    end

    def call(booking)
      ActiveRecord::Base.transaction do
        booking.order.update!(finished: false)
        booking.finish!
        @sms = Web::DeleteOrderSmsService.new(booking.id).call
      end
      SendOrderSmsVerifyWorker.perform_async(@sms.id)
    end

    # private
    #
    # def create_booking!
    #   context.booking = Booking.create!(guid: SecureRandom.uuid, vaccine_id: context.current_vaccine.id,
    #                                     ip_address: context.user_ip, browser_name: context.browser.name,
    #                                     os_name: context.browser.platform.name)
    #
    # rescue => e
    #   context.fail!(message: e)
    # end
    #
    # def check_vaccine
    #   context.selected_vaccine = fetch_current_vaccine
    #
    #   if context.selected_vaccine.blank?
    #     context.fail!(message: I18n.t('web.main.no_vaccine'))
    #   else
    #     context.booking = nil if context.booking&.vaccine && context.selected_vaccine.name != context.booking.vaccine.name
    #   end
    # end
    #
    # def prepare_current_step
    #   context.record = context._step.record
    #
    #   context.current_vaccine = context.booking&.vaccine || context.selected_vaccine
    #
    # end
    #
    # def fetch_current_vaccine
    #   name = context.params[:vaccine]&.downcase
    #
    #   return nil unless name
    #
    #   VaccinesItem.active.where('lower(name) = ?', name).take
    # end
    #
    # def fetch_current_step
    #   context.render_step = context._step.step_number
    # end
  end
end