# frozen_string_literal: true

module UseCases
  module Companies
    class CreateCompany < Micro::Case
      attributes :params

      def call!
        company = Company.new(params)

        if company.save
          Success result: { company: company }
        else
          Failure :invalid_company, result: { errors: company.errors.full_messages }
        end
      end
    end
  end
end
