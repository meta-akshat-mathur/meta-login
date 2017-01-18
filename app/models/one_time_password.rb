class OneTimePassword < ActiveRecord::Base
    include SendSms

     validates :mobile, presence: true

    # genrate and send otp by sms on mobile and by email
    #
    # @param [Type] email_id
    # @param [Type] mobile
    # @param [Type] name
    # @param [Type] send_count
    # @param [Type] suspended_at
    def self.generate_otp(email_id, mobile, name, send_count, suspended_at)
      otp = OneTimePassword.find_or_initialize_by(mobile: mobile)
      unless otp.otp_code.present? && otp.suspended_at > 10.minutes.ago
        totp = ROTP::TOTP.new("base32secret3232")
        otp_code = totp.now
        otp.otp_code = otp_code
      end
      otp.suspended_at = suspended_at
      otp.send_count = send_count
      otp_code = otp.otp_code
      otp.save
      message = "Hi #{name}, #{otp_code} is your OTP, valid for 10 minutes to verify your sign-up on tpohub.com" if name.present?
      message = "Use #{otp_code} as OTP, valid for 10 minutes to verify your mobile number on tpohub.com. Please don't share this with anyone." unless name.present?
      send_sms(mobile, message)
      # RegistrationNotifier.delay.otp_acknowledgment(email_id, otp_code, name) if email_id.present?
    end

    # verifies otp
    #
    # @param [String] mobile
    # @param [String] actual_otp
    # @return [Boolean] true for verified otp otherwise false
    def self.verify_otp(mobile, actual_otp)
      otp = OneTimePassword.find_by(mobile: mobile)
      expected_otp = otp.try(:otp_code)
      if otp.nil? && User.find_by(mobile: mobile).mobile_confirmed_at.present?
        true
      elsif (otp.present? && otp.try(:updated_at) > 10.minutes.ago) && (actual_otp.to_i == expected_otp.to_i)
        otp.destroy
        true
      else
        false
      end
    end

end
