# Tag model.
class Tag < ApplicationRecord

  acts_as_paranoid

  validates :name, presence: true
  validates :name, length: { maximum: 64 }, if: "name.present?"
  validates_uniqueness_of :name, conditions: -> { with_deleted }
end
