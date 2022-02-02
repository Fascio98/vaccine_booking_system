module Slots
  class SlotService
    attr_reader :current_user, :result
    def initialize(current_user)
      @current_user = current_user
      @result = OpenStruct.new(success?: false, slot: BusinessUnitSlot.new)
    end

    def list
      BusinessUnitSlot.active.order(created_at: :desc)
    end

    def new
      result
    end

    def edit(id)
      find_record(id)
    end

    def create(params)
      params[:user_id]=current_user.id
      result.tap do |r|
        r.slot=BusinessUnitSlot.new(params)
        r.send("success?=", r.slot.save)
      end
    rescue ActiveRecord::StatementInvalid
      result.tap do |r|
        r.slot.errors.add(:base, I18n.t('admin.countries.notices.errors.duplicate_key_error'))
      end
    end

    def update(id,params)
      params[:user_id]=current_user.id

      find_record(id)
      result.tap do |r|
        r.send("success?=", r.slot.update(params))
      end
    rescue ActiveRecord::StatementInvalid
      result.tap do |r|
        r.slot.errors.add(:base, I18n.t('admin.slots.notices.errors.duplicate_slot_error'))
      end
    end

    def delete(id)
      find_record(id)
      result.tap do |r|
        r.send("success?=", r.slot.destroy)
      end
    end

    def find_record(id)
      result.slot=BusinessUnitSlot.find(id)
      result
    end

    def sql(bu_unit)
      BusinessUnitSlot
        .select('bus.id, bus.duration, bus.start_date::date AS current_start_date, slots.item AS slot_item')
        .from(bu_unit, 'bus')
        .joins("LEFT JOIN LATERAL (Select generate_series(bus.start_date, bus.end_date, bus.duration * '1 minutes'::interval)::timestamp AS item) slots ON true")
        .joins('LEFT JOIN orders o ON o.business_unit_slot_id = bus.id AND o.finished = true and o.order_date::timestamp = slots.item')
        .where('o.id IS NULL')
    end
  end
end