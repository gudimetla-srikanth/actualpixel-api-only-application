class EcommerceController < ApplicationController 
  def signup 
   @user = User.new(full_name:params[:full_name],country_code:params[:country_code],mobile_no:params[:mobile_no],email_id:params[:email_id],password:params[:password],terms_of_conditions:params[:terms_of_conditions])
   if @user.save
    # UserMailer.welcome_user(@user.email_id).deliver_now
    render json:{success:true,user:{
      full_name:@user.full_name,email_id:@user.email_id,mobile_no:@user.mobile_no
    }}
   else 
    if @user.errors.any?
      render json: {errors:@user.errors.full_messages}
    else
      render json: {errors:"Incorrect fields data"}
    end
   end
  end
  def login
    
  end
end