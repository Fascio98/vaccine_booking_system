module Admin
  class DistrictsController < ApplicationController
    before_action :init_service
    def index
      @pagy, @districts=pagy(@district_service.list)
    end

    def new
      result=@district_service.new

      @district=result.district
    end

    def edit
      result=@district_service.edit(params[:id])

      @district=result.district
    end

    def create
      result = @district_service.create(district_params)
      @district= result.district
      if result.success?
        redirect_to admin_districts_path, notice: I18n.t('admin.districts.notices.created')
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      result = @district_service.update(params[:id], district_params)

      @district = result.district

      if result.success?
        redirect_to admin_districts_path, notice: I18n.t('admin.districts.notices.updated')
      else
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      result = @district_service.delete(params[:id])
      if result.success?
        redirect_to admin_districts_path, notice: I18n.t('admin.districts.notices.destroyed')
      end
    end

    private

    def init_service
      @district_service = Districts::DistrictService.new(current_user)
    end


    def district_params
      params.require(:district).permit(:id, :name, :code, :active, :city_id)
    end
  end
end