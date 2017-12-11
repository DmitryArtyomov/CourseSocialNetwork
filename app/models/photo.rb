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

class Photo < ApplicationRecord
  belongs_to :album, counter_cache: true
  has_one :profile, through: :album

  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  mount_uploader :image, PhotoUploader
  validates_presence_of :image

  def next(all_photos_context = false)
    @next ||= {}
    if (all_photos_context)
      @next[:all] ||= self.class.joins(:album).where(albums: { profile_id: album.profile_id })
                            .where("photos.id > ?", id).first
    else
      @next[:album] ||= self.class.where(album_id: album_id).where("id > ?", id).first
    end
  end

  def previous(all_photos_context = false)
    @previous ||= {}
    if (all_photos_context)
      @previous[:all] ||= self.class.joins(:album).where(albums: { profile_id: album.profile_id })
                                .where("photos.id < ?", id).last
    else
      @previous[:album] ||= self.class.where(album_id: album_id).where("id < ?", id).last
    end
  end

  def has_like?(profile)
    profile && likes.where(profile_id: profile.id).exists?
  end
end
