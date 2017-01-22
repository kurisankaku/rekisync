require "securerandom"

class Profile < ApplicationRecord
  acts_as_paranoid
  mount_uploader :avator_image, AvatorImgUploader
  mount_uploader :background_image, BackgroundImgUploader

  before_create :generate_img_dir_prefix, if: "self.img_dir_prefix.blank?"

  belongs_to :user
  belongs_to :country
  belongs_to :birthday_access_scope, foreign_key: :birthday_access_scope_id, class_name: AccessScope.name

  validates :user,
            presence: true
  validates :name,
            presence: true,
            length: { maximum: 128 }
  validates :img_dir_prefix,
            length: { is: 4 },
            if: "self.img_dir_prefix.present?"
  validates :img_dir_prefix,
            presence: true,
            on: :update
  validates :birthday_access_scope,
            presence: true
  validates :state_city,
            length: { maximum: 255 }
  validates :street,
            length: { maximum: 255 }
  validates :website,
            length: { maximum: 1024 }
  validates :twitter,
            length: { maximum: 1024 }
  validates :facebook,
            length: { maximum: 1024 }
  validates :google_plus,
            length: { maximum: 1024 }

  private

  # Generate img_dir_prefix. Format is hex.
  def generate_img_dir_prefix
    self.img_dir_prefix = SecureRandom.hex(2)
  end
end
