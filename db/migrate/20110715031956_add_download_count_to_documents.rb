class AddDownloadCountToDocuments < ActiveRecord::Migration
  def self.up
    add_column :documents, :download_count, :integer, :default => 0
  end

  def self.down
    remove_column :documents, :download_count
  end
end
