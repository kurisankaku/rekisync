# Tag model.
class Tag < ApplicationRecord
  validates :name, presence: true
  validates :name, length: { maximum: 64 }, if: "name.present?"
  validates_uniqueness_of :name
end
