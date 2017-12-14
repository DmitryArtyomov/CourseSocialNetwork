# == Schema Information
#
# Table name: conversations
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :conversation do
    profiles []
  end
end
