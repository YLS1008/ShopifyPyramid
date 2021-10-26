class PointTransaction < ApplicationRecord
  REFERRAL_POINTS = 25_000.to_d
  PER_DOLAR_POINTS = 10_000.to_d
  GET_LUCKY_MAX = 420.to_d
  PYRAMID_PERCENTAGE = 0.1

  after_create :pyramid_scheming, unless: :user_is_orphan?

  belongs_to :user

  enum source: { referral: 0, purchase: 1, lucky: 2, child: 3 }

  def self.new_referral(user)
    PointTransaction.create(user_id: user.id, value: REFERRAL_POINTS, source: :referral)
  end

  def self.get_lucky(user)
    current_count = user.get_lucky_count

    value = rand(GET_LUCKY_MAX)
    points = PointTransaction.create(user_id: user.id, value: value, source: :lucky)

    user.update(get_lucky_count: current_count + 1, last_get_lucky_date: Date.current) if points
    value if points
  end

  private

  def user_is_orphan?
    user.parent_id.nil?
  end

  def pyramid_scheming
    upstream_value = value * PYRAMID_PERCENTAGE
    return if upstream_value < 1 # so not to deal with fractions of points

    self.class.create(user_id: user.parent_id, value: upstream_value, source: :child)
  end
end
