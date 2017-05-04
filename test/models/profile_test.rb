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

require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
