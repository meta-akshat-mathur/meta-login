module Concerns::UserOmniauthCallbacks
  extend ActiveSupport::Concern

  included do
    validates :email, presence: true, email: true
    # validates :mobile, presence: true, mobile: true, if: Proc.new { |u| u.mobile == 'mobile' }
    # validates_presence_of :uid, if: Proc.new { |u| u.provider != 'email' }

    # only validate unique emails among email registration users
    validate :unique_email_user, on: :create if 'email.present?'
    # validate :unique_mobile_user, on: :create if 'mobile.present?'
    # keep uid in sync with email/mobile
    before_save :sync_uid
    before_create :sync_uid
  end

  protected

  # only validate unique email among users that registered by email
  def unique_email_user
    if self.class.where(email: email).count > 0
      errors.add(:email, :taken)
    end
  end

  # only validate unique mobile among users that registered by mobile
  def unique_mobile_user
    if self.class.where(mobile: mobile).count > 0
      errors.add(:mobile, :taken)
    end
  end

  def sync_uid
    # self.uid = email if provider == 'email'
    # self.uid = mobile if provider == 'mobile'
  end
end
