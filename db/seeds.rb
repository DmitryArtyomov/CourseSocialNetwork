FactoryBot.create_list(:tag, 20)
FactoryBot.create_list(:profile_with_photos, 10)

# Creating friendships
existing_friends = FriendRequest.where(status: 1).pluck(:sender_id, :recipient_id)
temp_friends = Profile.ids.combination(2).to_a.sample(22)
new_friends = temp_friends - existing_friends
new_friends.each do |pair|
  FactoryBot.create(:friendship, sender_id: pair[0], recipient_id: pair[1])
end

# Creating messages
my_profile = Profile.find(1)
Profile.offset(2).order(:id).sample(5).each do |profile|
  conversation = FactoryBot.create(:conversation, profiles: [profile, my_profile].shuffle)
  messages_count = Random.rand(1..6)
  messages_count.times.map do |i|
    sender = i.even? ? profile : my_profile
    FactoryBot.create(:message, sender: sender, conversation: conversation)
  end.first(messages_count - 1).each do |message|
    message.update_attributes(is_read: true)
  end
end

# Create comments
profile_ids = Profile.ids
Photo.all.sample(Photo.count / 2).each do |photo|
  FactoryBot.create(:comment_with_likes_for_photo, commentable: photo, profile_id: profile_ids.sample)
end
