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
# Indexes
#
#  index_photos_on_profile_id  (profile_id)
#

class Photo < ApplicationRecord
  belongs_to :profile

  mount_uploader :image, PhotoUploader
  validates_presence_of :image

  def next
    @next ||= self.class.where(profile: profile).where("id > ?", id).first
  end

  def previous
    @previous ||= self.class.where(profile: profile).where("id < ?", id).last
  end
end
