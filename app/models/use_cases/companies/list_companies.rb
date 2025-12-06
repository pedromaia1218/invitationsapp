# frozen_string_literal: true

module UseCases
  module Companies
    class ListCompanies < Micro::Case
      attributes :page, :per_page

      def call!
        companies = Company.order(created_at: :desc)
                          .page(page || 1)
                          .per(per_page || 10)

        Success result: { companies: companies }
      end
    end
  end
end
