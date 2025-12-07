# frozen_string_literal: true

module UseCases
  module Invitations
    class DeleteInvitation < Micro::Case
      attributes :invitation

      def call!
        if invitation.destroy
          Success result: { invitation: invitation }
        else
          Failure :cannot_delete, result: { errors: invitation.errors.full_messages }
        end
      end
    end
  end
end
