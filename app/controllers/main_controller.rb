require "browser"

class MainController < ApplicationController
  before_action :fetch_booking, only: %i[current_step next_step prev_step]
  before_action :clear_booking

  def index
    @vaccine_items = VaccinesItem.active

    @bu_unit = BusinessUnitSlot.active

    @slot_service = Slots::SlotService.new(current_user)
    @slots = @slot_service.sql(@bu_unit)
  end

  def browser
    @browser = Browser.new(request.env["HTTP_USER_AGENT"])
    @user_ip = request.remote_ip
  end

  def current_step

    browser

    result = Web::CurrentStepService.call(booking: @booking, params: params, user_ip:@user_ip, browser:@browser)


    if result.success? && result.record.present?
      assign_step_variables({vaccine: result.current_vaccine,record: result.record})



      cookies.signed[:booking_uuid] = {value: result.booking.guid, expires: 30.minutes.from_now}

      render "main/steps/step#{result.render_step}"

    else
      cookies.delete(:booking_uuid)

      redirect_to root_url, notice: result.message
    end

  end

  def next_step
    return redirect_to root_url, notice: I18n.t('web.main.session_expired') unless @booking

    result = Web::NextStepService.call(booking: @booking, params: params)

    if result.success?
      if result.last_step?
        cookies.delete(:booking_uuid)

        return redirect_to root_url, notice: I18n.t('web.main.booking_success')
      end

      redirect_to current_step_path(result.booking.vaccine&.name&.downcase)
    else
      assign_step_variables({ vaccine: result.booking.vaccine, record: result.record })

      render "main/steps/step#{result.current_step}"
    end
  end

  def prev_step
    return redirect_to root_url, notice: I18n.t('web.main.session_expired') unless @booking

    result = Web::PrevStepService.call(booking: @booking, params: params)

    if result.success?
      if result.first_step?
        cookies.delete(:booking_uuid)

        return redirect_to root_url
      end

      redirect_to current_step_path(result.booking.vaccine&.name&.downcase)
    else
      assign_step_variables({ vaccine: result.booking.vaccine, record: result.record })

      render "main/steps/step#{result.current_step}"
    end
  end

  private

  def fetch_booking
    booking_uuid = cookies.signed[:booking_uuid]


    if booking_uuid.present?
      @booking = Booking.find_by(guid: booking_uuid)
    end
  end

  def assign_step_variables(attrs)
    @current_vaccine = attrs[:vaccine]
    @record = attrs[:record]
  end

  def clear_booking
    if @booking&.finished?
      cookies.delete(:booking_uuid)
      redirect_to root_url
    end
  end

end