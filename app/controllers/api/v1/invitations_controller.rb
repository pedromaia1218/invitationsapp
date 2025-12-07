# frozen_string_literal: true

module Api
  module V1
    class InvitationsController < BaseController
      before_action :set_invitation, only: [:show, :update, :destroy]

      def index
        result = UseCases::Invitations::ListInvitations.call(
          page: params[:page],
          per_page: params[:per_page] || 20,
          filters: filter_params
        )

        render json: {
          invitations: result[:invitations].as_json(include: :company),
          pagination: pagination_for(result[:invitations])
        }
      end

      def show
        render json: @invitation.as_json(include: :company)
      end

      def create
        UseCases::Invitations::CreateInvitation
          .call(params: invitation_params)
          .on_success { |result| render json: result[:invitation], status: :created }
          .on_failure { |result| render json: { errors: result[:errors] }, status: :unprocessable_entity }
      end

      def update
        UseCases::Invitations::UpdateInvitation
          .call(invitation: @invitation, params: invitation_params)
          .on_success { |result| render json: result[:invitation] }
          .on_failure { |result| render json: { errors: result[:errors] }, status: :unprocessable_entity }
      end

      def destroy
        UseCases::Invitations::DeleteInvitation
          .call(invitation: @invitation)
          .on_success { head :no_content }
          .on_failure { |result| render json: { errors: result[:errors] }, status: :unprocessable_entity }
      end

      private

      def set_invitation
        @invitation = Invitation.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Invitation not found' }, status: :not_found
      end

      def invitation_params
        params.require(:invitation).permit(:username, :invitation_type, :cpf, :email, :code, :company_id, :active)
      end

      def filter_params
        params.permit(:username, :company_id, :start_date, :end_date).to_h
      end

      def pagination_for(invitations)
        {
          current_page: invitations.current_page,
          next_page: invitations.next_page,
          prev_page: invitations.prev_page,
          total_pages: invitations.total_pages,
          total_count: invitations.total_count
        }
      end
    end
  end
end
