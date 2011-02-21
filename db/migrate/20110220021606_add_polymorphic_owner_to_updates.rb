class AddPolymorphicOwnerToUpdates < ActiveRecord::Migration
  def self.up
    add_column :updates, :owner_type, :string
    add_column :updates, :owner_id, :integer
    remove_column :updates, :user_id
  end

  def self.down
    remove_column :updates, :owner
    remove_column :updates, :owner
    add_column :updates, :user_id, :integer
  end
end
