# frozen_string_literal: true

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
class Invitation < ApplicationRecord
  belongs_to :company

  enum invitation_type: { cpf: 0, email: 1, code: 2 }

  validates :username, presence: true
  validates :invitation_type, presence: true
  validates :cpf, presence: true, if: :cpf?
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, if: :email?
  validates :code, presence: true, if: :code?
  validate :cpf_must_be_valid, if: :cpf?

  scope :active, -> { where(active: true) }
  scope :by_company, -> (company_id) { where(company_id: company_id) if company_id.present? }
  scope :by_username, -> (name) { where('username ILIKE ?', "%#{name}%") if name.present? }
  scope :active_in_period, -> (start_date = nil, end_date = nil) {
    start_date = start_date.to_date.beginning_of_day if start_date.present?
    end_date = end_date.to_date.end_of_day if end_date.present?

    if start_date.present? && end_date.present?
      query = all.where('activated_at <= ?', end_date)
                   .where('deactivated_at IS NULL OR deactivated_at >= ?', start_date)
    elsif start_date.present?
      query = all.where('activated_at >= ?', start_date)
                   .where('deactivated_at IS NULL OR deactivated_at >= ?', start_date)
    elsif end_date.present?
      query = all.where('activated_at <= ?', end_date)
                   .where('deactivated_at IS NULL OR deactivated_at >= ?', end_date)
    end

    query
  }

  before_validation :clean_cpf
  before_create :set_activated_at

  private

  def clean_cpf
    self.cpf = cpf.gsub(/\D/, '') if cpf.present?
  end

  def cpf_must_be_valid
    return if cpf.blank?
    errors.add(:cpf, 'não é válido') unless CPF.valid?(cpf)
  end

  def set_activated_at
    self.activated_at ||= Time.current if active?
  end
end
