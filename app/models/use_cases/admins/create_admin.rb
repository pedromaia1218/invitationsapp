# frozen_string_literal: true

module UseCases
  module Admins
    class CreateAdmin < Micro::Case
      attributes :params

      def call!
        admin = Admin.new(params)

        if admin.save
          Success result: { admin: admin }
        else
          Failure :invalid_admin, result: { errors: admin.errors.full_messages }
        end
      end
    end
  end
end
