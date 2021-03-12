class Listing < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_one_attached :photo

  # Validations
  validates_associated :user
  validates :title, presence: true
  validates :title, length: { maximum: 30 }
  validates :description, length: { maximum: 500 }
  validates :price, presence: true
  validates :price, numericality: { only_integer: true }
end
