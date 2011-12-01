class AddScribdToDocuments < ActiveRecord::Migration
  def self.up
    change_table :documents do |t|
      t.string :scribd_doc_id
      t.string :scribd_access_key
      t.string :extension
    end
  end

  def self.down
    remove_column :documents, :scribd_doc_id
    remove_column :documents, :scribd_access_key
    remove_column :documents, :extension
  end
end
