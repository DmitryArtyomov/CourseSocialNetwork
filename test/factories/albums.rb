# == Schema Information
#
# Table name: albums
#
#  id           :integer          not null, primary key
#  name         :string           not null
#  description  :text
#  is_main      :boolean          default("false")
#  profile_id   :integer
#  photos_count :integer          default("0")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_albums_on_profile_id  (profile_id)
#

FactoryBot.define do
  factory :album do
    profile
    name { Faker::Book.title }
    description { Faker::Book.author }
    tags { Tag.all.sample(Random.rand(4)) }

    factory :album_with_photos do
      transient do
        photos_count 2
      end

      after(:create) do |album, evaluator|
        create_list(:photo_with_likes, evaluator.photos_count, album: album)
      end
    end
  end
end
