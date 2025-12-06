# frozen_string_literal: true

module UseCases
  module Admins
    class ValidateParams < Micro::Case
      attributes :params

      def call!
        errors = validate_params

        return Failure result: { errors: errors } if errors.any?

        Success result: { params: params }
      end

      private

      def validate_params
        errors = []

        errors << 'Email é obrigatório' if params[:email].blank?
        errors << 'Email inválido' if params[:email].present? && !valid_email?(params[:email])

        if params[:password].present?
          errors << 'Senha deve ter no mínimo 6 caracteres' if params[:password].length < 6
          errors << 'Confirmação de senha não confere' if params[:password] != params[:password_confirmation]
        end

        errors
      end

      def valid_email?(email)
        email.match?(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
      end
    end
  end
end
