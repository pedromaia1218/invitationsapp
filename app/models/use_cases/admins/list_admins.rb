# frozen_string_literal: true

module UseCases
  module Admins
    class ListAdmins < Micro::Case
      attributes :page, :per_page

      def call!
        page_num = page&.to_i || 1
        per_page_num = per_page&.to_i || 25

        admins = Admin.all.page(page_num).per(per_page_num)

        Success result: { admins: admins }
      end
    end
  end
end
