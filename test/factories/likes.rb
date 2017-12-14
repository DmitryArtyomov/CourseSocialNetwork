# == Schema Information
#
# Table name: likes
#
#  id            :integer          not null, primary key
#  profile_id    :integer
#  likeable_type :string
#  likeable_id   :integer
#
# Indexes
#
#  index_likes_on_likeable_type_and_likeable_id  (likeable_type,likeable_id)
#  index_likes_on_profile_id                     (profile_id)
#

FactoryBot.define do
  factory :like do
    profile

    factory :like_for_photo do
      association :likeable, factory: :photo
    end

    factory :like_for_comment do
      association :likeable, factory: :comment
    end
  end
end
