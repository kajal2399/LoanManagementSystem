class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { user: 0, admin: 1 }

  has_one :wallet, dependent: :destroy
  has_many :loans, dependent: :destroy
end
