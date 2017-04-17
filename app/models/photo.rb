# == Schema Information
#
# Table name: photos
#
#  id         :integer          not null, primary key
#  image      :string
#  profile_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Photo < ApplicationRecord
  belongs_to :profile

  mount_uploader :image, PhotoUploader
end
