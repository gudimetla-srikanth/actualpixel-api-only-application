Rails.application.routes.draw do
  post 'signup',to:"ecommerce#signup"
  get 'login',to:"ecommerce#login"
  get 'otp',to:"ecommerce#otp_generator"
  get 'otp/validation',to:"ecommerce#otp_validator"
end
