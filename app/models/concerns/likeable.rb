module Likeable
  extend ActiveSupport::Concern

  included do
    has_many :likes, as: :likeable, dependent: :destroy
  end

  def has_like?(profile)
    profile && likes.where(profile_id: profile.id).exists?
  end
end
