class User < ApplicationRecord
  has_secure_password
  validates :full_name,presence: true
  validates :email_id,presence: true,uniqueness: true 
  COUNTRY_CODE_REGEX = /\+\d{1,2}/
  PHONE_NUMBER_REGEX = /\d{9,12}/ 
  validates :country_code,format: {with:  COUNTRY_CODE_REGEX, message: "Inavlid country code for mobile number"}
  validates :mobile_no,length:{minimum:10,maximum:12},format: { with: PHONE_NUMBER_REGEX,
                          message: 'Invalid phone number format' }
  validates :terms_of_conditions,presence: true
end
