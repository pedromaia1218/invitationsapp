# frozen_string_literal: true

module UseCases
  module Invitations
    class UpdateInvitation < Micro::Case
      attributes :invitation, :params

      def call!
        update_params = prepare_params

        if invitation.update(update_params)
          Success result: { invitation: invitation }
        else
          Failure :invalid_invitation, result: { errors: invitation.errors.full_messages }
        end
      end

      private

      def prepare_params
        update_params = params.dup

        if params.key?(:active) && params[:active] != invitation.active
          if params[:active]
            update_params[:activated_at] = Time.current
            update_params[:deactivated_at] = nil
          else
            update_params[:deactivated_at] = Time.current
            update_params[:activated_at] = nil
          end
        end

        update_params
      end
    end
  end
end
