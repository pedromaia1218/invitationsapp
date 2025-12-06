# frozen_string_literal: true

module UseCases
  module Admins
    class DeleteAdmin < Micro::Case
      attributes :admin, :current_admin

      def call!
        if admin.id == current_admin.id
          return Failure :cannot_delete_self, result: { errors: ["Não é possível excluir sua própria conta"] }
        end

        if admin.destroy
          Success result: { admin: admin }
        else
          Failure :deletion_failed, result: { errors: admin.errors.full_messages }
        end
      end
    end
  end
end
