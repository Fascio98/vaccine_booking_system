module Districts
  class DistrictService
    attr_reader :current_user, :result
    def initialize(current_user)
      @current_user = current_user
      @result = OpenStruct.new(success?: false, district: District.new)
    end

    def list
      District.all
    end

    def new
      result
    end

    def edit(id)
      find_record(id)
    end

    def create(params)
      result.tap do |r|
        r.district=District.new(params)
        r.send("success?=", r.district.save)
      end
    rescue ActiveRecord::RecordNotUnique
      result.tap do |r|
        r.district.errors.add(:base, I18n.t('admin.districts.notices.errors.duplicate_key_error'))
      end
    end

    def update(id,params)
      find_record(id)
      result.tap do |r|
        r.send("success?=", r.district.update(params))
      end
    rescue ActiveRecord::RecordNotUnique
      result.tap do |r|
        r.district.errors.add(:base, I18n.t('admin.districts.notices.errors.duplicate_key_error'))
      end
    end

    def delete(id)
      find_record(id)
      result.tap do |r|
        r.send("success?=", r.district.destroy)
      end
    end

    def find_record(id)
      result.district=District.find(id)
      result
    end
  end
end