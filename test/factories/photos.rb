# == Schema Information
#
# Table name: photos
#
#  id             :integer          not null, primary key
#  image          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  album_id       :integer
#  comments_count :integer          default("0")
#  likes_count    :integer          default("0")
#  description    :text
#
# Indexes
#
#  index_photos_on_album_id  (album_id)
#

FactoryBot.define do
  factory :photo do
    album
    description { Faker::RickAndMorty.quote }
    remote_image_url { Faker::LoremPixel.image('1280x720') }
    created_at { Faker::Time.backward(6) }
    tags { Tag.all.sample(Random.rand(4)) }

    factory :photo_with_likes do
      transient do
        likes_count { Random.rand(10) }
      end

      after(:create) do |photo, evaluator|
        Profile.ids.sample(evaluator.likes_count).each do |profile_id|
          create(:like_for_photo, likeable: photo, profile_id: profile_id)
        end
      end
    end
  end
end
