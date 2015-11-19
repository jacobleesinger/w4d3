# require 'bcrypt'

class User < ActiveRecord::Base
  # include BCrypt
  attr_reader :password

  validates :user_name, :password_digest, :session_token, presence: true
  after_initialize :ensure_session_token

  has_many(
  :cats,
  class_name: "Cat",
  foreign_key: :owner_id,
  primary_key: :id
  )


  #Class method generates session token
  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  #self.session_token grabs instances token and changes it to new generated token
  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
    self.session_token
  end

  #password=(password) setter method that writes the password_digest attribute with the hash of the given password.
  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by( user_name: user_name )
    return nil if user.nil?

    user.is_password?(password) ? user : nil
  end

  private

  def ensure_session_token
     self.session_token ||= SecureRandom::urlsafe_base64
  end
end
