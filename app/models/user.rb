# frozen_string_literal: true

class User < ApplicationRecord
  GET_LUCKY_MAX_PER_DAY = 10
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable, :rememberable

  before_save :ensure_authentication_token_is_present

  validates :name, :email, presence: true
  validates :email, uniqueness: true

  has_many :invitations, dependent: :destroy
  has_many :point_transactions, dependent: :destroy

  after_create :deliver_invitation_points

  def super_admin?
    role == "super_admin"
  end

  def as_json(options = {})
    new_options = options.merge(only: %i[email name current_sign_in_at total_points])

    super new_options
  end

  def total_points
    point_transactions.pluck(:value).sum
  end

  def valid_for_get_lucky?
    get_lucky_count < GET_LUCKY_MAX_PER_DAY || last_get_lucky_date != Date.current
  end

  private

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later(queue: "devise_email")
  end

  def ensure_authentication_token_is_present
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end

    if invite_token.blank?
      self.invite_token = generate_authentication_token
    end
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

  def deliver_invitation_points
    return unless parent_id

    user = User.find_by(id: parent_id)
    return unless user

    PointTransaction.new_referral(user)
  end
end
