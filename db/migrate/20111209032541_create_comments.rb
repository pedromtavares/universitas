class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.references :target, :polymorphic => true
      t.text :text
      t.timestamps
    end
    add_index :comments, [:user_id, :target_id, :target_type]
  end
end
