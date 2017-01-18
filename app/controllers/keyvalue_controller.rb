class KeyvalueController < ApplicationController
  def generate_otp_for_sign_up
  otp = OneTimePassword.find_by(mobile: params[:mobile])
   if otp.present?
     if otp.send_count >= 5
       if otp.updated_at <  10.minutes.ago
         generated_otp = OneTimePassword.generate_otp(params[:email_id], params[:mobile], params[:name], 1, Time.zone.now)
         render json: {status: "otp sent"}
       else
         render json: {errors: ["Check your mobile number or try again after few minutes."]}, status: :unprocessable_entity
       end
     else
       otp.suspended_at = Time.zone.now if otp.suspended_at < 10.minutes.ago
       generated_otp = OneTimePassword.generate_otp(params[:email_id], params[:mobile], params[:name], otp.send_count+1, otp.suspended_at)
       render json: {status: "otp sent"}
     end
   else
    generated_otp = OneTimePassword.generate_otp(params[:email_id], params[:mobile], params[:name], 1, Time.zone.now)
    render json: {status: "otp sent"}
   end
end

def otp_verification
  is_verified = OneTimePassword.verify_otp(params[:mobile], params[:otp_code])
  if is_verified
    user = User.find_by(mobile: params[:mobile])
    user.update!(mobile_confirmed_at: Time.zone.now, skip_suspended_at: nil)
    render json: {status: "otp verified"}
  else
    render json: {errors: ["Enter valid OTP."] },  status: :unprocessable_entity
  end
end
end
