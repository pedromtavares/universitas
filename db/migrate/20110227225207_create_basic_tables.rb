class CreateBasicTables < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login, :null => false
      t.string :name, :null => false
			t.string :status
      t.string :cached_slug
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable
      t.timestamps
    end
    add_index :users, :login,                :unique => true
    add_index :users, :reset_password_token, :unique => true

    create_table :slugs do |t|
      t.string :name
      t.integer :sluggable_id
      t.integer :sequence, :null => false, :default => 1
      t.string :sluggable_type, :limit => 40
      t.string :scope
      t.datetime :created_at
    end
    add_index :slugs, :sluggable_id
    add_index :slugs, [:name, :sluggable_type, :sequence, :scope], :name => "index_slugs_on_n_s_s_and_s", :unique => true

		create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id
      t.boolean :blocked, :default => false
      t.timestamps
    end
    
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id

		create_table :groups do |t|
			t.string :name
			t.text :description
			t.integer :user_id
			t.string :cached_slug
			t.string :image
			t.string :status
			t.timestamps
		end
		
		create_table :group_members do |t|
			t.integer :group_id
			t.integer :user_id
      t.timestamps
		end
		add_index :group_members, [:group_id, :user_id]
		
		create_table :updates do |t|
			t.references :creator, :polymorphic => true
			t.references :target, :polymorphic => true
			t.string :custom_message
			t.timestamps
		end
		add_index :updates, [ :creator_type, :creator_id, :target_type, :target_id ], :name => "index_updates_on_c_and_t"
		
		create_table :documents do |t|
      t.string :name
      t.text :description
      t.string :file
			t.integer :user_id
			t.string :content_type
			t.integer :file_size
      t.timestamps
    end
		add_index :documents, [:user_id]
		
		create_table :group_modules do |t|
			t.integer :group_id
			t.string :name
			t.text :description
			t.timestamps
		end
		add_index :group_modules, :group_id

		create_table :group_documents do |t|
			t.integer :user_id
			t.integer :group_id
			t.integer :document_id
			t.integer :group_module_id
			t.boolean :pending, :default => false
			t.timestamps
		end
		add_index :group_documents, [:group_id, :document_id]
		
		create_table :user_documents do |t|
			t.integer :user_id
			t.integer :document_id
			t.timestamps
		end
		add_index :user_documents, [:user_id, :document_id]
		
		create_table :authentications do |t|
			t.integer :user_id
			t.string :provider
			t.string :uid
		end
				
  end

  def self.down
		[:users, :slugs, :relationships, :groups, :group_members, :updates, :documents, :group_modules, :group_documents, :user_documents].each do |name|
			drop_table name
		end
  end
end
