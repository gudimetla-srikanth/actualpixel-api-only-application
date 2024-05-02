Rails.application.routes.draw do
  post 'signup',to:"ecommerce#signup"
  get 'login',to:"ecommerce#login"
end
