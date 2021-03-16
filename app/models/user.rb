class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :listings, dependent: :destroy

  has_many :written_reviews, class_name: 'Review', foreign_key: 'reviewer_id'
  has_many :reviews, class_name: 'Review', foreign_key: 'reviewee_id'
  has_many :purchases

  # Validations
  validates :username, uniqueness: true
end
