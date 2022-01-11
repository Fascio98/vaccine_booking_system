module Admin
  class VaccinesItemsController < ApplicationController
    before_action :init_service
    def index
      @pagy, @vaccines=pagy(@vaccine_service.list)
    end

    def new
      result=@vaccine_service.new

      @vaccine=result.vaccines_item
    end

    def edit
      result=@vaccine_service.edit(params[:id])

      @vaccine=result.vaccines_item
    end

    def create
      result = @vaccine_service.create(create_vaccine_params)
      @vaccine= result.vaccines_item
      if result.success?
        redirect_to admin_vaccines_items_path, notice: I18n.t('admin.vaccinesitems.notices.created')
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      result = @vaccine_service.update(params[:id], update_vaccine_params)

      @vaccine= result.vaccines_item

      if result.success?
        redirect_to admin_vaccines_items_path, notice: I18n.t('admin.vaccinesitems.notices.updated')
      else
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      result = @vaccine_service.delete(params[:id])
      if result.success?
        redirect_to admin_vaccines_items_path, notice: I18n.t('admin.vaccinesitems.notices.destroyed')
      end
    end

    private

    def init_service
      @vaccine_service = Vaccinesitems::VaccinesitemService.new(current_user)
    end

    def create_vaccine_params
      params.require(:vaccines_item).permit(:name,:active,:description)
    end

    def update_vaccine_params
      params.require(:vaccines_item).permit(:id,:name,:active,:description)
    end
  end
end