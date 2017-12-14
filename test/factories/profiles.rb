# == Schema Information
#
# Table name: profiles
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  first_name    :string
#  last_name     :string
#  date_of_birth :datetime
#  gender        :integer
#  avatar_id     :integer
#
# Indexes
#
#  index_profiles_on_avatar_id   (avatar_id)
#  index_profiles_on_first_name  (first_name)
#  index_profiles_on_gender      (gender)
#  index_profiles_on_last_name   (last_name)
#  index_profiles_on_user_id     (user_id) UNIQUE
#

FactoryBot.define do
  factory :profile do
    user
    gender { Random.rand(3) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    date_of_birth { Faker::Date.birthday(18, 30) }

    after(:create) do |profile, evaluator|
      UsersConfirmService.new(profile.user).execute
    end

    factory :profile_with_photos do
      transient do
        photos_count 3
        albums_count { Random.rand(2) }
      end

      after(:create) do |profile, evaluator|
        albums_count = evaluator.albums_count
        if albums_count.zero?
          photos_per_album = 0
        else
          photos_per_album = (evaluator.photos_count - 1) / albums_count
        end
        photos_in_main = evaluator.photos_count - photos_per_album * albums_count
        create_list(:album_with_photos, albums_count, profile: profile, photos_count: photos_per_album)
        create_list(:photo_with_likes, photos_in_main, album: profile.albums.main)
        profile.avatar = profile.photos.sample
        profile.save
      end
    end
  end
end
