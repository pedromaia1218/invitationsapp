# == Schema Information
#
# Table name: invitations
#
#  id              :bigint           not null, primary key
#  activated_at    :datetime
#  active          :boolean          default(TRUE), not null
#  code            :string
#  cpf             :string
#  deactivated_at  :datetime
#  email           :string
#  invitation_type :integer          default("cpf"), not null
#  username        :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  company_id      :bigint           not null
#
# Indexes
#
#  index_invitations_on_active      (active)
#  index_invitations_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
require 'rails_helper'

RSpec.describe Invitation, type: :model do
  describe 'associations' do
    it { should belong_to(:company) }
  end

  describe 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:invitation_type) }

    context 'when invitation_type is cpf' do
      subject { build(:invitation, invitation_type: :cpf) }
      it { should validate_presence_of(:cpf) }
    end

    context 'when invitation_type is email' do
      subject { build(:invitation, :email_type) }
      it { should validate_presence_of(:email) }
    end

    context 'when invitation_type is code' do
      subject { build(:invitation, :code_type) }
      it { should validate_presence_of(:code) }
    end

    it 'validates CPF format' do
      invitation = build(:invitation, cpf: '12345678900')
      expect(invitation).not_to be_valid
      expect(invitation.errors[:cpf]).to include('não é válido')
    end

    it 'accepts valid CPF' do
      invitation = build(:invitation, cpf: '17598201056')
      expect(invitation).to be_valid
    end
  end

  describe 'scopes' do
    let!(:company) { create(:company) }
    let!(:active_invitation) { create(:invitation, company: company, active: true) }
    let!(:inactive_invitation) { create(:invitation, :inactive, company: company) }

    describe 'active' do
      it 'returns only active invitations' do
        expect(Invitation.active).to include(active_invitation)
        expect(Invitation.active).not_to include(inactive_invitation)
      end
    end

    describe 'by_company' do
      let!(:other_company) { create(:company, cnpj: '78241857000190') }
      let!(:other_invitation) { create(:invitation, company: other_company) }

      it 'returns invitations from specific company' do
        expect(Invitation.by_company(company.id)).to include(active_invitation)
        expect(Invitation.by_company(company.id)).not_to include(other_invitation)
      end
    end

    describe 'by_username' do
      let!(:pedro_invitation) { create(:invitation, company: company, username: 'Pedro Silva') }
      let!(:maria_invitation) { create(:invitation, company: company, username: 'Maria Santos') }

      it 'returns invitations matching username' do
        expect(Invitation.by_username('Pedro')).to include(pedro_invitation)
        expect(Invitation.by_username('Pedro')).not_to include(maria_invitation)
      end
    end
  end

  describe 'callbacks' do
    describe 'clean_cpf' do
      it 'removes non number characters from CPF' do
        invitation = build(:invitation, cpf: '175.982.010-56')
        invitation.valid?
        expect(invitation.cpf).to eq('17598201056')
      end
    end

    describe 'set_activated_at' do
      it 'sets activated_at on creation when active' do
        invitation = create(:invitation, active: true)
        expect(invitation.activated_at).to be_present
      end

      it 'does not set activated_at when inactive' do
        invitation = create(:invitation, active: false, activated_at: nil)
        expect(invitation.activated_at).to be_nil
      end
    end
  end

  describe 'database persistence' do
    it 'saves a valid invitation' do
      invitation = build(:invitation)
      expect(invitation.save).to be true
    end
  end
end
