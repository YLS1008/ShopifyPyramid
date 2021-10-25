# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable, :rememberable

  before_save :ensure_authentication_token_is_present

  validates :name, :email, presence: true
  validates :email, uniqueness: true

  has_many :invitations, dependent: :destroy

  def super_admin?
    role == "super_admin"
  end

  def current_auth
    authentication_tokens.valid.first
  end

  def create_auth_token
    AuthenticationToken.create(user_id: id, token: generate_authentication_token, expires_at: 5.hours.from_now, valid: true)
  end

  def as_json(options = {})
    new_options = options.merge(only: [:email, :name, :current_sign_in_at])

    super new_options
  end

  private

    def send_devise_notification(notification, *args)
      devise_mailer.send(notification, self, *args).deliver_later(queue: "devise_email")
    end

    def ensure_authentication_token_is_present
      if authentication_token.blank?
        self.authentication_token = generate_authentication_token
      end
    end

    def generate_authentication_token
      loop do
        token = Devise.friendly_token
        break token unless User.where(authentication_token: token).first
      end
    end
end
