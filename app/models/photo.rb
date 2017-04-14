class Photo < ApplicationRecord
  belongs_to :profile

  mount_uploader :image, PhotoUploader
end
