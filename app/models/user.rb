class User < ApplicationRecord
  validates :full_name,presence: true
  validates :email_id,presence: true,uniqueness: true 
  validates :mobile_no,presence: true
  validates :terms_of_conditions,presence: true
  validates :password_digest,presence: true
  has_secure_password
end
