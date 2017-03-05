# Following user model.
class Following < ApplicationRecord
  acts_as_paranoid

  belongs_to :owner, foreign_key: :owner_id, class_name: User.name
  belongs_to :user

  validates_uniqueness_of :owner, scope: [:user_id], conditions: -> { with_deleted }
  validates :owner, presence: true
  validates :user, presence: true
  validate :not_eq_owner_and_user

  private

  # Do not insert same value as owner_id in user_id.
  def not_eq_owner_and_user
    self.errors.add(:user, "not_eq_owner_and_user") if self.owner_id == self.user_id
  end
end
