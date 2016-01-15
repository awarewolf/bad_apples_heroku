class User < ActiveRecord::Base

  before_create :confirmation_token

  has_many :reviews

  paginates_per 10

  has_secure_password

  validates :email,
    presence: true

  validates :firstname,
    presence: true

  validates :lastname,
    presence: true

  validates :password,
    length: { in: 6..20 }, on: :create

  def self.authenticate_with_salt(user_id,user_salt)
    User.where(id:user_id, salt:user_salt).first
  end

  def full_name
    "#{firstname} #{lastname}"
  end

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(validate: false)
  end

  private

  def confirmation_token
    if self.confirm_token.blank?
      self.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
  end

end