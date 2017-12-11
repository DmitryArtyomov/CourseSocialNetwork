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

require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
