# frozen_string_literal: true

module UseCases
  module Invitations
    class CreateInvitation < Micro::Case
      attributes :params

      def call!
        invitation = Invitation.new(params)

        if invitation.save
          Success result: { invitation: invitation }
        else
          Failure :invalid_invitation, result: { errors: invitation.errors.full_messages }
        end
      end
    end
  end
end
