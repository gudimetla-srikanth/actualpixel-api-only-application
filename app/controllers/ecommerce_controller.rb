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
      return render json: {success:false,message:"Incorrect fields data"}
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
          return render json:{success:false,message:"Incorrect password"}
        end
      else 
        return render json: {success:false,message:"No user found"}
      end
      
    else
      return render json:{success:false,message:"Fields are empty"}
    end
  end


  def otp_generator
    token = request.headers['Authorization']&.split(' ')&.last
    if token.present?
      decoded_token = JWT.decode(token, Rails.application.credentials.secret_key)
      @current_user = User.find(decoded_token[0]['user_id'])
      if @current_user.present?
        otp = rand(1000...9999).to_s
        Otp.create(otps:otp,user_id:@current_user.id)
        @user_details_with_otp = {email:@current_user.email_id,otp:otp}
        UserMailer.welcome_user(@user_details_with_otp).deliver_now
        return render json:{success:true,message:"Email sent successfully to registered mail id"}
      else
        return render json:{success:false,message:"You are not a registered in the app"}
      end
    else
      return render json:{success:false,message:'Token is not present'}
    end
  end

def otp_validator
  token = request.headers['Authorization']&.split(' ')&.last
  if token.present? && params[:otp].present?
    decoded_token = JWT.decode(token, Rails.application.credentials.secret_key)
    @current_user = User.find(decoded_token[0]['user_id'])
    if @current_user.present?
      database_otp = @current_user&.otps&.last&.otps 
      if database_otp.present? && database_otp == params[:otp] 
        time1 = @current_user.otps.last.created_at
        time2 = Time.now
        seconds_diff = time_difference_in_seconds(time1, time2)
        puts "++++++++++++++++++++++++++++++++++++++++"
        puts seconds_diff
        puts "+++++++++++++++++++++++++++++++++++++++"
        if seconds_diff == false
          @current_user.otps.destroy_all
          return render json:{success:false,message:"otp validation time expired"}
        end
        @current_user.otps.destroy_all
        return render json:{success:true,message:"otp validated"}
      end
      return render json:{success:false,message:"entered wrong otp or the otp you have sent is expired"}
    else
      return render json:{success:false,message:"You are not a registered in the app"}
    end
  else
    return render json:{success:false,message:'missing fields'}
  end
end

private 
  def time_difference_in_seconds(time1, time2)
    seconds_diff = (time2 - time1).to_i.abs
    if seconds_diff <= 60
      return seconds_diff
    else
      return false
    end
  end

end