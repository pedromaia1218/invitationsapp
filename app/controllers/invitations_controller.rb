# frozen_string_literal: true

class InvitationsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_invitation, only: [:edit, :update, :destroy]
  before_action :set_active_companies, only: [:new, :edit]

  def index
    result = UseCases::Invitations::ListInvitations.call(
      page: params[:page],
      per_page: params[:per_page],
      filters: filter_params
    )

    @invitations = result[:invitations]
    @companies = Company.order(:name)
  end

  def new
    @invitation = Invitation.new
  end

  def create
    UseCases::Invitations::CreateInvitation
      .call(params: invitation_params)
      .on_success { |result| redirect_to invitations_path, notice: 'Convite criado com sucesso.' }
      .on_failure { |result|
        @invitation = Invitation.new(invitation_params)
        @companies = Company.active.order(:name)
        @errors = result[:errors]
        render :new, status: :unprocessable_entity
      }
  end

  def edit; end

  def update
    UseCases::Invitations::UpdateInvitation
      .call(invitation: @invitation, params: invitation_params)
      .on_success { |result| redirect_to invitations_path, notice: 'Convite atualizado com sucesso.' }
      .on_failure { |result|
        @errors = result[:errors]
        @companies = Company.active.order(:name)
        render :edit, status: :unprocessable_entity
      }
  end

  def destroy
    UseCases::Invitations::DeleteInvitation
      .call(invitation: @invitation)
      .on_success { |result| redirect_to invitations_path, notice: 'Convite excluído com sucesso.' }
      .on_failure { |result| redirect_to invitations_path, alert: result[:errors].first }
  end

  private

  def set_invitation
    @invitation = Invitation.find(params[:id])
  end

  def set_active_companies
    @companies = Company.active.order(:name)
  end

  def invitation_params
    permitted_params = params.require(:invitation).permit(:username, :invitation_type, :cpf, :email, :code, :company_id, :active)

    if permitted_params[:active].present?
      permitted_params[:active] = ActiveModel::Type::Boolean.new.cast(permitted_params[:active])
    end

    permitted_params
  end

  def filter_params
    params.permit(:username, :company_id, :start_date, :end_date).to_h
  end
end
