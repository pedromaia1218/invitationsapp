# frozen_string_literal: true

module UseCases
  module Companies
    class UpdateCompany < Micro::Case
      attributes :company, :params

      def call!
        if company.update(params)
          Success result: { company: company }
        else
          Failure :invalid_company, result: { errors: company.errors.full_messages }
        end
      end
    end
  end
end
