class AddFieldsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :first_name, :string, index: true
    add_column :users, :last_name, :string, index: true
    add_column :users, :date_of_birth, :datetime
    add_column :users, :gender, :integer, default: 0, index: true
  end
end
