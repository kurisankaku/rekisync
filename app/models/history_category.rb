# History category
class HistoryCategory < ApplicationRecord
  belongs_to :large_category, foreign_key: :large_category_id, class_name: HistoryCategory
  belongs_to :middle_category, foreign_key: :middle_category_id, class_name: HistoryCategory

  validates :name,
            presence: true,
            length: { maximum: 64 }
  validates :name,
            uniqueness: true,
            if: "large_category.nil? && middle_category.nil?"
  validates :name,
            uniqueness: { scope: [:name, :large_category_id] },
            if: "large_category.present? && middle_category.nil?"
  validates :name,
            uniqueness: { scope: [:name, :large_category_id, :middle_category_id] },
            if: "large_category.present? && middle_category.present?"
  validates :large_category, presence: true, if: "middle_category.present?"
  validate :should_middle_category_belongs_to_large_category, if: "middle_category.present? && large_category.present?"

  # Fetch middle categories
  #
  # @return [ActiveRecord::Relation] history categories.
  def middle_categories
    HistoryCategory.where(large_category: self).where(middle_category: nil)
  end

  # Fetch small categories
  #
  # @return [ActiveRecord::Relation] history categories.
  def small_categories
    if large_category?
      HistoryCategory.where(large_category: self).where.not(middle_category: nil)
    else
      HistoryCategory.where(middle_category: self)
    end
  end

  # Check if the category type is large.
  #
  # @return [bool] true: large type.
  def large_category?
    self.large_category.nil? && self.middle_category.nil?
  end

  # Check if the category type is middle.
  #
  # @return [bool] true: middle type.
  def middle_category?
    self.large_category.present? && self.middle_category.nil?
  end

  private

  # Should middle category belongs to large category.
  def should_middle_category_belongs_to_large_category
    unless self.large_category.middle_categories.where(id: self.middle_category_id).exists?
      self.errors.add(:middle_category, "should_middle_category_belongs_to_large_category")
    end
  end
end
