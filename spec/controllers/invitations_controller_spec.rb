# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvitationsController, type: :controller do
  let(:admin) { create(:admin) }
  let(:company) { create(:company) }

  before do
    sign_in admin
  end

  describe 'when requesting the index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'when requesting the new invitation form' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'when creating a new invitation' do
    context 'with valid params' do
      let(:valid_attributes) do
        {
          username: 'João Silva',
          invitation_type: 'cpf',
          cpf: '17598201056',
          company_id: company.id,
          active: true
        }
      end

      it 'creates a new Invitation' do
        expect {
          post :create, params: { invitation: valid_attributes }
        }.to change(Invitation, :count).by(1)
      end

      it 'redirects to the invitations list' do
        post :create, params: { invitation: valid_attributes }
        expect(response).to redirect_to(invitations_path)
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) do
        {
          username: '',
          invitation_type: 'cpf',
          company_id: company.id
        }
      end

      it 'does not create a new Invitation' do
        expect {
          post :create, params: { invitation: invalid_attributes }
        }.not_to change(Invitation, :count)
      end

      it 'renders the new template' do
        post :create, params: { invitation: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'when destroying a invitation' do
    let!(:invitation) { create(:invitation, company: company) }

    it 'destroys the requested invitation' do
      expect {
        delete :destroy, params: { id: invitation.id }
      }.to change(Invitation, :count).by(-1)
    end

    it 'redirects to the invitations list' do
      delete :destroy, params: { id: invitation.id }
      expect(response).to redirect_to(invitations_path)
    end
  end

  describe 'authentication' do
    before do
      sign_out admin
    end

    it 'redirects to sign in when not authenticated' do
      get :index
      expect(response).to redirect_to(new_admin_session_path)
    end
  end
end
