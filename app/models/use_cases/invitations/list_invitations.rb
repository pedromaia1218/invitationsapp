# frozen_string_literal: true

module UseCases
  module Invitations
    class ListInvitations < Micro::Case
      attributes :page, :per_page, :filters

      def call!
        invitations = Invitation.includes(:company)
                                .order(created_at: :desc)

        invitations = apply_filters(invitations)
        invitations = invitations.page(page || 1)
                                 .per(per_page || 10)

        Success result: { invitations: invitations }
      end

      private

      def apply_filters(invitations)
        invitations = invitations.by_username(filters[:username]) if filters[:username].present?
        invitations = invitations.by_company(filters[:company_id]) if filters[:company_id].present?

        if filters[:start_date].present? || filters[:end_date].present?
          invitations = invitations.active_in_period(filters[:start_date], filters[:end_date])
        end

        invitations
      end
    end
  end
end
