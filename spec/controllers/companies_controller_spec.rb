# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompaniesController, type: :controller do
  let(:admin) { create(:admin) }
  let(:company) { create(:company) }

  before do
    sign_in admin
  end

  describe "when requesting the index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "when requesting the new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "when creating a company" do
    context "with valid params" do
      let(:valid_attributes) do
        {
          name: 'Empresa Teste',
          cnpj: build(:company).cnpj,
          address: 'Rua Teste, 123',
          active: true
        }
      end

      it "creates a new Company" do
        expect {
          post :create, params: { company: valid_attributes }
        }.to change(Company, :count).by(1)
      end

      it "redirects to companies index" do
        post :create, params: { company: valid_attributes }
        expect(response).to redirect_to(companies_path)
      end
    end

    context "with invalid params" do
      let(:invalid_attributes) do
        {
          name: '',
          cnpj: '',
          address: ''
        }
      end

      it "does not create a new Company" do
        expect {
          post :create, params: { company: invalid_attributes }
        }.not_to change(Company, :count)
      end
    end
  end

  describe "when destroying a company" do
    let!(:company_to_delete) { create(:company) }

    it "destroys the company" do
      expect {
        delete :destroy, params: { id: company_to_delete.id }
      }.to change(Company, :count).by(-1)
    end

    it "redirects to companies index" do
      delete :destroy, params: { id: company_to_delete.id }
      expect(response).to redirect_to(companies_path)
    end
  end

  describe "authentication" do
    context "when not logged in" do
      before do
        sign_out admin
      end

      it "redirects to login" do
        get :index
        expect(response).to redirect_to(new_admin_session_path)
      end
    end
  end
end
