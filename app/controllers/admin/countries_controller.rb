module Admin
  class CountriesController < ApplicationController
    before_action :init_service
    def index
      @pagy, @countries=pagy(@country_service.list)
    end

    def new
      result=@country_service.new

      @country=result.country
    end

    def edit
      result=@country_service.edit(params[:id])

      @country=result.country
    end

    def create
      result = @country_service.create(create_country_params)
      @country= result.country
      if result.success?
        redirect_to admin_countries_path, notice: I18n.t('admin.countries.notices.created')
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      result = @country_service.update(params[:id], update_country_params)

      @country= result.country

      if result.success?
        redirect_to admin_countries_path, notice: I18n.t('admin.countries.notices.updated')
      else
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      result = @country_service.delete(params[:id])
      if result.success?
        redirect_to admin_countries_path, notice: I18n.t('admin.countries.notices.destroyed')
      end
    end

    private

    def init_service
      @country_service = Countries::CountryService.new(current_user)
    end

    def create_country_params
      params.require(:country).permit(:name, :code, :active)
    end

    def update_country_params
      params.require(:country).permit(:id, :name, :code, :active)
    end
  end
end