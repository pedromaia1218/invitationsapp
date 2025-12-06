# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UseCases::Admins::ValidateParams, type: :model do
  describe '#call' do
    context 'with valid params' do
      let(:valid_params) do
        {
          email: 'teste@teste.com',
          password: 'qwe123',
          password_confirmation: 'qwe123'
        }
      end

      it 'returns success' do
        result = described_class.call(params: valid_params)
        expect(result).to be_success
      end
    end

    context 'with invalid email' do
      it 'fails when email is blank' do
        result = described_class.call(params: { email: '' })
        expect(result).to be_failure
        expect(result[:errors]).to include('Email é obrigatório')
      end

      it 'fails when email format is invalid' do
        result = described_class.call(params: { email: 'invalid.email' })
        expect(result).to be_failure
        expect(result[:errors]).to include('Email inválido')
      end
    end

    context 'with invalid password' do
      it 'fails when password is too short' do
        params = { email: 'test@teste.com', password: 'qwe', password_confirmation: 'qwe' }
        result = described_class.call(params: params)
        expect(result).to be_failure
        expect(result[:errors]).to include('Senha deve ter no mínimo 6 caracteres')
      end

      it 'fails when password confirmation does not match' do
        params = { email: 'test@teste.com', password: 'qwe', password_confirmation: '123' }
        result = described_class.call(params: params)
        expect(result).to be_failure
        expect(result[:errors]).to include('Confirmação de senha não confere')
      end
    end
  end
end
