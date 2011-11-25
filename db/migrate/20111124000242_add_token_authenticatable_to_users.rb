class AddTokenAuthenticatableToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.token_authenticatable
    end
    # there are not that many users
    User.all.each do |user|
      user.reset_authentication_token!
    end
  end

  def self.down
    remove_column :users, :authentication_token
  end
end
