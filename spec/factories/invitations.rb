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
FactoryBot.define do
  factory :invitation do
    sequence(:username) { |n| "Usuário #{n}" }
    company
    invitation_type { :cpf }
    cpf { '07522106370' }
    active { true }

    trait :email_type do
      invitation_type { :email }
      cpf { nil }
      email { Faker::Internet.email }
    end

    trait :code_type do
      invitation_type { :code }
      cpf { nil }
      code { SecureRandom.hex(8) }
    end

    trait :inactive do
      active { false }
      deactivated_at { Time.current }
    end
  end
end
