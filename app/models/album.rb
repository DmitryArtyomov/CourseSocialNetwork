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

class Album < ApplicationRecord
  belongs_to :profile

  has_many :taggings, as: :taggable
  has_many :tags, through: :taggings, dependent: :destroy

  has_many :photos, dependent: :destroy

  validates :name, presence: true

  scope :main, -> { find_by(is_main: true) }
end
