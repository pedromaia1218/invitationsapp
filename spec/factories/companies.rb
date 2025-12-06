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
#  index_companies_on_name  (name)
#
FactoryBot.define do
  factory :company do
    name { Faker::Company.name }
    cnpj { '11222333000181' }
    address { Faker::Address.full_address }
    active { true }
  end
end
