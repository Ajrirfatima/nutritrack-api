class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :validatable, :jwt_authenticatable,
         jwt_revocation_strategy: self

  has_many :children, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
