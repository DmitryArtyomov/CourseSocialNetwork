# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  text             :string
#  profile_id       :integer
#  commentable_type :string
#  commentable_id   :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  likes_count      :integer          default("0")
#
# Indexes
#
#  index_comments_on_commentable_type_and_commentable_id  (commentable_type,commentable_id)
#  index_comments_on_profile_id                           (profile_id)
#

FactoryBot.define do
  factory :comment do
    profile
    text { Faker::RickAndMorty.quote }

    factory :comment_with_likes_for_photo do
      association :commentable, factory: :photo

      transient do
        likes_count { Random.rand(4) }
      end

      after(:create) do |comment, evaluator|
        Profile.ids.sample(evaluator.likes_count).each do |profile_id|
          create(:like_for_comment, likeable: comment, profile_id: profile_id)
        end
      end
    end
  end
end
