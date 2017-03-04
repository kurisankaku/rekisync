require 'securerandom'

# User model.
class User < ApplicationRecord
  include SecureAccount

  acts_as_paranoid

  has_many :third_party_access_tokens, dependent: :destroy
  has_many :followings, foreign_key: :owner_id, class_name: Following.name, dependent: :destroy
  has_many :followers, foreign_key: :user_id, class_name: Following.name, dependent: :destroy
  has_one :profile, dependent: :destroy

  PASSWORD_FORMAT = /\A(?=.*\d)(?=.*[a-zA-Z])/x
  EMAIL_FORMAT = /\A[a-zA-Z0-9_.+-]+[@][a-zA-Z0-9.-]+\z/
  NAME_FORMAT = /\A[a-z0-9_+-]*\z/

  validates :password,
            length: { minimum: 8 },
            format: { with: PASSWORD_FORMAT },
            confirmation: true,
            unless: "password.nil?"
  validates :password_confirmation, presence: true, unless: "password.nil?"
  validates :name,
            presence: true,
            format: { with: NAME_FORMAT }
  validates :name, length: { minimum: 3, maximum: 128 }, if: "name.present?"
  validate :reserved_word
  validates_uniqueness_of :name, conditions: -> { with_deleted }
  validates :email, presence: true
  validates :email, format: { with: EMAIL_FORMAT }, if: 'email.present?'
  validates_uniqueness_of :email, conditions: -> { with_deleted }
  validate :password_digest_presence

  private

  def password_digest_presence
    self.errors.add(:password, :blank) if self.password_digest.blank? && self.third_party_access_tokens.blank?
  end

  def reserved_word
    self.errors.add(:name, :reserved_word) if self.name.present? && ::ReservedWords::NAME.include?(self.name.downcase.singularize)
  end
end
