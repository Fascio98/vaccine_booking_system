module Admin
  class CitiesController < ApplicationController
    before_action :init_service
    def index
      @pagy, @cities=pagy(@city_service.list)
    end

    def new
      result=@city_service.new

      @city=result.city
    end

    def edit
      result=@city_service.edit(params[:id])

      @city=result.city
    end

    def create
      result = @city_service.create(city_params)
      @city= result.city
      if result.success?
        redirect_to admin_cities_path, notice: I18n.t('admin.cities.notices.created')
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      result = @city_service.update(params[:id], city_params)

      @city= result.city

      if result.success?
        redirect_to admin_cities_path, notice: I18n.t('admin.cities.notices.updated')
      else
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      result = @city_service.delete(params[:id])
      if result.success?
        redirect_to admin_cities_path, notice: I18n.t('admin.cities.notices.destroyed')
      end
    end

    private

    def init_service
      @city_service = Cities::CityService.new(current_user)
    end


    def city_params
      params.require(:city).permit(:id, :name, :code, :active, :country_id)
    end
  end
end