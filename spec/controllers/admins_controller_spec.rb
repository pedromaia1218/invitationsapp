require 'rails_helper'

RSpec.describe AdminsController, type: :controller do
  let(:admin) { create(:admin) }

  before do
    sign_in admin
  end

  describe "when requesting the index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "when requesting the new admin form" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "when creating a new admin" do
    context "with valid params" do
      let(:valid_attributes) do
        {
          email: 'teste@teste.com',
          password: 'qwe123',
          password_confirmation: 'qwe123'
        }
      end

      it "creates a new Admin" do
        expect {
          post :create, params: { admin: valid_attributes }
        }.to change(Admin, :count).by(1)
      end

      it "redirects to admins index" do
        post :create, params: { admin: valid_attributes }
        expect(response).to redirect_to(admins_path)
      end
    end

    context "with invalid params" do
      let(:invalid_attributes) do
        {
          email: '',
          password: 'qwe123',
          password_confirmation: 'qwe321'
        }
      end

      it "does not create a new Admin" do
        expect {
          post :create, params: { admin: invalid_attributes }
        }.not_to change(Admin, :count)
      end
    end
  end

  describe "when destroying an admin" do
    let!(:admin_to_delete) { create(:admin) }

    it "destroys the admin" do
      expect {
        delete :destroy, params: { id: admin_to_delete.id }
      }.to change(Admin, :count).by(-1)
    end

    it "does not destroy yourself" do
      expect {
        delete :destroy, params: { id: admin.id }
      }.not_to change(Admin, :count)
    end
  end
end
