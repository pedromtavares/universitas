class AddPolymorphicReferenceToUpdates < ActiveRecord::Migration
  def self.up
    add_column :updates, :reference_type, :string
    add_column :updates, :reference_id, :integer
    remove_column :updates, :content
  end

  def self.down
    remove_column :updates, :reference_type
    remove_column :updates, :reference_id
    add_column :updates, :content, :string
  end
end
