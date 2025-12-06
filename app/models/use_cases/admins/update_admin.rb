# frozen_string_literal: true

module UseCases
  module Admins
    class UpdateAdmin < Micro::Case
      flow UseCases::Admins::ValidateParams,
           self.call!

      attributes :admin, :params, :current_admin

      def call!
        if admin.update(params)
          Success result: { admin: admin }
        else
          Failure :invalid_admin, result: { errors: admin.errors.full_messages }
        end
      end
    end
  end
end
