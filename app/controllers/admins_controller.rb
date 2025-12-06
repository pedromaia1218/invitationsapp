# frozen_string_literal: true

class AdminsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_admin, only: [:edit, :update, :destroy]

  def index
    result = UseCases::Admins::ListAdmins.call(
      page: params[:page],
      per_page: params[:per_page]
    )

    @admins = result[:admins]
  end

  def new
    @admin = Admin.new
  end

  def create
    UseCases::Admins::CreateAdmin
      .call(params: admin_params)
      .on_success { |result| redirect_to admins_path, notice: 'Administrador criado com sucesso.' }
      .on_failure { |result| @errors = result[:errors]; render :new, status: :unprocessable_entity }
  end

  def edit
  end

  def update
    UseCases::Admins::UpdateAdmin
      .call(admin: @admin, params: admin_params, current_admin: current_admin)
      .on_success { |result| redirect_to admins_path, notice: 'Administrador atualizado com sucesso.' }
      .on_failure { |result| @errors = result[:errors]; render :edit, status: :unprocessable_entity }
  end

  def destroy
    UseCases::Admins::DeleteAdmin
      .call(admin: @admin, current_admin: current_admin)
      .on_success { |result| redirect_to admins_path, notice: 'Administrador excluído com sucesso.' }
      .on_failure { |result| redirect_to admins_path, alert: result[:errors].first }
  end

  private

  def set_admin
    @admin = Admin.find(params[:id])
  end

  def admin_params
    params.require(:admin).permit(:email, :password, :password_confirmation)
  end
end
