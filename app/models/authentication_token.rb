class AuthenticationToken < ApplicationRecord
  belongs_to :user

  def expire
    update(valid: false)
  end
end
