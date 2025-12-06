# frozen_string_literal: true

module UseCases
  module Companies
    class DeleteCompany < Micro::Case
      attributes :company

      def call!
        if company.destroy
          Success result: { company: company }
        else
          Failure :cannot_delete, result: { errors: company.errors.full_messages }
        end
      end
    end
  end
end
