require "securerandom"

class Profile < ApplicationRecord
  acts_as_paranoid

  before_create :generate_img_dir_prefix, if: "self.img_dir_prefix.blank?"

  belongs_to :user

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
