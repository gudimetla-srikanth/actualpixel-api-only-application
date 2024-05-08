class EcommerceController < ApplicationController 
  def signup
   @user = User.new(full_name:params[:full_name],country_code:params[:country_code],mobile_no:params[:mobile_no],email_id:params[:email_id],password:params[:password],terms_of_conditions:params[:terms_of_conditions])
   if @user.save
    return render json:{success:true,user:{
      full_name:@user.full_name,email_id:@user.email_id,country_code:@user.country_code,mobile_no:@user.mobile_no
    }}
   else 
    if @user.errors.any?
      return render json: {errors:@user.errors.full_messages}
    else
      return render json: {success:false,errors:"Incorrect fields data"}
    end
   end
  end


  def login
    if (params[:mobile_no].present? && params[:country_code].present? || params[:email_id].present?) && params[:password].present?
      @user = ""
      if params[:email_id].present?
        @user = User.find_by(email_id:params[:email_id])
      elsif params[:country_code].present? && params[:mobile_no].present?
        @user = User.find_by(country_code:params[:country_code],mobile_no:params[:mobile_no])
      end
      if @user.present?
        if @user.authenticate(params[:password])
          secret_key = Rails.application.credentials.secret_key
          payload = {user_id:@user.id}
          token = JWT.encode payload,secret_key
          return render json:{success:true,user:{
          full_name:@user.full_name,email_id:@user.email_id,country_code:@user.country_code,mobile_no:@user.mobile_no,token:token
          }}
        else
          return render json:{success:false,error:"Incorrect password"}
        end
      else 
        return render json: {success:false,error:"No user found"}
      end
      
    else
      return render json:{success:false,error:"Fields are empty"}
    end
  end


  def otp_generator
    puts "++++++++++++++++++++++++++++++++++++"
    puts Rails.application.credentials.g_mail
    puts Rails.application.credentials.g_password
    puts "++++++++++++++++++++++++++++++++++++++"
    token = request.headers['Authorization']&.split(' ')&.last
    if token.present?
      decoded_token = JWT.decode(token, Rails.application.credentials.secret_key)
      @current_user = User.find(decoded_token[0]['user_id'])
      if @current_user.present?
        otp = rand(1000...9999).to_s
        @user_details_with_otp = {email:@current_user.email_id,otp:otp}
        UserMailer.welcome_user(@user_details_with_otp).deliver_now
        return render json:{one_time_password:otp}
      else
        return render json:{error:"You are not a registered in the app"}
      end
    else
      return render json:{error:'Token is not present'}
    end
  end


end