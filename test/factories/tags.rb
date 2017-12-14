# == Schema Information
#
# Table name: tags
#
#  id             :integer          not null, primary key
#  text           :string(20)       not null
#  taggings_count :integer          default("0")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_tags_on_text  (text) UNIQUE
#

FactoryBot.define do
  factory :tag do
    text { "##{Faker::Internet.unique.user_name(3..10).gsub(/[^\da-zA-Z]/, '')}" }
  end
end
