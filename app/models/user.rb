class User < ApplicationRecord
  require "securerandom"

  has_secure_password 

  validates :username, presence: true, uniqueness: true
  validates :name, presence: true, format: { with: /\A[a-zA-Z]+\z/, message: "Only allows letters" }
  validates :password, presence: true 
end
