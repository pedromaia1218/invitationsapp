# frozen_string_literal: true

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
class Company < ApplicationRecord
  has_many :invitations, dependent: :destroy

  validates :name, presence: true
  validates :cnpj, presence: true, uniqueness: true
  validates :address, presence: true
  validate :cnpj_must_be_valid

  before_validation :clean_cnpj

  scope :active, -> { where(active: true) }

  private

  def clean_cnpj
    self.cnpj = cnpj.gsub(/\D/, '') if cnpj.present?
  end

  def cnpj_must_be_valid
    return if cnpj.blank?
    errors.add(:cnpj, 'não é válido') unless CNPJ.valid?(cnpj)
  end
end
