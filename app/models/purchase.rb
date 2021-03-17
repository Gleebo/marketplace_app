class Purchase < ApplicationRecord
  belongs_to :user
  belongs_to :listing

  validates_associated :user
  validates_associated :listing
end