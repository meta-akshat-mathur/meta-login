class User < ActiveRecord::Base
    # Include default devise modules.
    include Concerns::User
    include SendSms
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable

    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :confirmable, :omniauthable

    has_many :user_logins

    # validates_presence_of :email
    # scope :provider, -> { joins(:user_login).where(user_login.user_id = '21').pluck(:provider) }

    # default_scope { lambda { |provider='email'| joins(:user_logins).select('*',"user_logins.id as user_login_id","users.id as id").where('user_logins.provider = ?', provider) } }
    # default_scope { joins(:user_logins).select('*',"user_logins.id as user_login_id","users.id as id") }
    # scope :uid, -> { where(first_name: 'Akshat Mathur')}


    # Description of method
    # => Get the details from omniauth(auth) find or initialize user and userlogin
    # @param [Type] auth describe auth
    # @param [Type] current_user describe current_user
    # @return [Type] description of returned object
    def self.from_omniauth(auth, current_user)
        user_logins = UserLogin.where(provider: auth['provider'], uid: auth['uid'].to_s).first_or_initialize
        if user_logins.user.blank?
            user = current_user || User.where('email = ?', auth['info']['email']).first
            if user.blank?
                user = User.new
                user.password = Devise.friendly_token[0, 10]
                user.first_name = auth['info']['first_name']
                user.email = auth['info']['email']
                if  auth['provider'] == 'twitter'
                    user.save(validate: false)
                else
                    user.save
                end
            end
            user_logins.token = auth['credentials']['token']
            user_logins.secret = auth['credentials']['secret']
            user_logins.user_id = user.id
            user_logins.save
       end
       User.joins(:user_logins).select('*',"user_logins.id as user_login_id","users.id as id").find_by('user_logins.provider = ? AND user_logins.uid = ?', auth['provider'],auth['uid'])
    end

    def send_devise_notification(notification, *args)
      devise_mailer.send(notification, self, *args).deliver_later
    end

    def self.current=(user)
        Thread.current[:current_user] = user
      end

    def self.current
        Thread.current[:current_user]
    end

    # def self.provider
    #
    # end
end
