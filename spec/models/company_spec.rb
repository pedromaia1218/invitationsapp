# == Schema Information
#
# Table name: companies
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(TRUE), not null
#  address    :string
#  cnpj       :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_companies_on_cnpj  (cnpj) UNIQUE
#
require 'rails_helper'

RSpec.describe Company, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:cnpj) }
    it { should validate_presence_of(:address) }

    it 'validates uniqueness of cnpj' do
      create(:company)
      should validate_uniqueness_of(:cnpj).case_insensitive
    end

    context 'CNPJ validation' do
      it 'accepts valid CNPJ' do
        company = build(:company)
        expect(company).to be_valid
      end

      it 'rejects invalid CNPJ' do
        company = build(:company, cnpj: '12345678901234')
        expect(company).not_to be_valid
        expect(company.errors[:cnpj]).to include('não é válido')
      end

      it 'cleans CNPJ before validation' do
        company = build(:company, cnpj: '11.222.333/0001-81')
        company.valid?
        expect(company.cnpj).to eq('11222333000181')
      end
    end
  end

  describe 'associations' do
    it { should have_many(:invitations).dependent(:destroy) }
  end

  describe 'factory' do
    it 'creates a valid company' do
      company = build(:company)
      expect(company).to be_valid
    end
  end

  describe 'database persistence' do
    it 'saves company to database' do
      company = create(:company)
      expect(Company.find(company.id)).to eq(company)
    end
  end
end
