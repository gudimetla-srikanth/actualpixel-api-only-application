class EcommerceController < ApplicationController 
  def signup
   @user = User.new(full_name:params[:full_name],country_code:params[:country_code],mobile_no:params[:mobile_no],email_id:params[:email_id],password:params[:password],terms_of_conditions:params[:terms_of_conditions])
   if @user.save
    # UserMailer.welcome_user(@user.email_id).deliver_now
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
      else
        @user = User.find_by(country_code:params[:country_code],mobile_no:params[:mobile_no])
      end
      if @user.present?
        if @user.authenticate(params[:password])
          return render json:{success:true,user:{
          full_name:@user.full_name,email_id:@user.email_id,country_code:@user.country_code,mobile_no:@user.mobile_no
          }}
        else
          return render json:{success:false,error:"Incorrect password"}
        end
      else 
        return render json: {success:false,error:"No user found"}
      end
      
    else
      return render json:{success:false,error:"empty fields are not okay"}
    end
  end
end