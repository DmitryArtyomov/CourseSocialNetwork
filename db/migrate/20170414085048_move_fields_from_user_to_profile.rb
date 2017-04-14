class MoveFieldsFromUserToProfile < ActiveRecord::Migration[5.0]
  def self.up
    add_column :profiles, :first_name, :string
    add_column :profiles, :last_name, :string
    add_column :profiles, :date_of_birth, :datetime
    add_column :profiles, :gender, :integer

    User.find_each do |user|
      Profile.create(
        first_name: user.first_name,
        last_name: user.last_name,
        date_of_birth: user.date_of_birth,
        gender: user.gender,
        user: user
      )
    end

    add_index :profiles, :first_name
    add_index :profiles, :last_name
    add_index :profiles, :gender
    remove_index :profiles, :user_id
    add_index :profiles, :user_id, unique: true

    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :date_of_birth
    remove_column :users, :gender
  end

  def self.down
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :date_of_birth, :datetime
    add_column :users, :gender, :integer

    Profile.find_each do |profile|
      profile.user.update_attributes(
        first_name: profile.first_name,
        last_name: profile.last_name,
        date_of_birth: profile.date_of_birth,
        gender: profile.gender
      )
    end
    
    Profile.delete_all

    remove_index :profiles, :first_name
    remove_index :profiles, :last_name
    remove_index :profiles, :gender
    remove_index :profiles, :user_id
    add_index :profiles, :user_id
    
    remove_column :profiles, :first_name
    remove_column :profiles, :last_name
    remove_column :profiles, :date_of_birth
    remove_column :profiles, :gender
  end
end
