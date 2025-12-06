require 'rails_helper'

RSpec.describe "Admin authentication", type: :request do
  let(:admin) { create(:admin) }

  describe "request to login" do
    context "with valid credentials" do
      it "logs in the admin" do
        post admin_session_path, params: {
          admin: {
            email: admin.email,
            password: 'password123'
          }
        }
        expect(response).to have_http_status(:redirect)
        follow_redirect!
        expect(response.body).to include(admin.email)
      end
    end

    context "with invalid credentials" do
      it "does not log in the admin" do
        post admin_session_path, params: {
          admin: {
            email: admin.email,
            password: 'wrongpassword'
          }
        }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "request to log out" do
    before do
      sign_in admin
    end

    it "logs out the admin" do
      delete destroy_admin_session_path
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "authenticated access" do
    before do
      sign_in admin
    end

    it "allows access to admins index" do
      get admins_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "unauthenticated access" do
    it "redirects to sign in when accessing admins index" do
      get admins_path
      expect(response).to redirect_to(new_admin_session_path)
    end
  end
end
