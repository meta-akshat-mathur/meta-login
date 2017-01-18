module SendSms
  extend ActiveSupport::Concern

    # register_interceptor Shortener::ShortenUrlInterceptor.new
  module ClassMethods


    def send_sms(mobile, message)
      # url = 'http://smsbox.in/SecureApi.aspx?usr=tpohubstaging&key=6B64F5E0-4EB0-4C8C-AE4F-383F631CD091&smstype=TextSMS&to='+mobileno+'&msg='+message+'&rout=Transactional&from=tpohub'
      url = "http://smsbox.in/SecureApi.aspx?usr=#{ENV['smsbox_usr']}&key=#{ENV['smsbox_key']}&smstype=TextSMS&to=#{mobile}&msg=#{message}&rout=Transactional&from=tpohub"
      uri = URI.parse(URI.encode(url.strip))
      res = Net::HTTP.get(uri)
      puts res
    end
    handle_asynchronously :send_sms
  end

end
