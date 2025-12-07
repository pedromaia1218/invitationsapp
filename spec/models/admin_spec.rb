# == Schema Information
#
# Table name: admins
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_admins_on_email                 (email) UNIQUE
#  index_admins_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe 'validations' do
    subject { build(:admin) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value('admin@example.com').for(:email) }
    it { should_not allow_value('invalid_email').for(:email) }

    context 'password validations' do
      it { should validate_presence_of(:password) }
      it { should validate_length_of(:password).is_at_least(6) }
      it { should validate_confirmation_of(:password) }
    end
  end

  describe 'database persistence' do
    it 'saves admin to database' do
      expect {
        create(:admin)
      }.to change(Admin, :count).by(1)
    end

    it 'encrypts password' do
      admin = create(:admin, password: 'testpassword', password_confirmation: 'testpassword')
      expect(admin.encrypted_password).to be_present
      expect(admin.encrypted_password).not_to eq('testpassword')
    end
  end

  describe 'authentication' do
    let(:admin) { create(:admin, password: 'password123') }

    it 'authenticates with valid password' do
      expect(admin.valid_password?('password123')).to be true
    end

    it 'does not authenticate with invalid password' do
      expect(admin.valid_password?('wrongpassword')).to be false
    end
  end
end
