module Admin
  class PatientsController < ApplicationController
    before_action :init_service
    def index
      @pagy, @patients=pagy(@patient_service.list)
    end

    def edit
      result=@patient_service.edit(params[:id])

      @patient=result.patient
    end

    def create
      result = @user_service.create(create_user_params)
      @user= result.user
      if result.success?
        redirect_to admin_users_path, notice: I18n.t('admin.users.notices.created')
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      result = @patient_service.update(params[:id], update_patient_params)

      @patient = result.patient

      if result.success?
        redirect_to admin_patients_path, notice: I18n.t('admin.users.notices.updated')
      else
        render :new, status: :unprocessable_entity
      end
    end

    def show
      @patient = Patient.find(params[:id])
    end


    private

    def init_service
      @patient_service = Patients::PatientService.new(current_user)
    end


    def update_patient_params
      params.require(:patient).permit(:id, :mobile_phone)
    end
  end
end