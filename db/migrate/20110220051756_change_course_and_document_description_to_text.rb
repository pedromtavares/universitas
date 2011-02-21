class ChangeCourseAndDocumentDescriptionToText < ActiveRecord::Migration
  def self.up
		change_table :courses do |t|
			t.change :description, :text
		end
		change_table :documents do |t|
			t.change :description, :text
		end
  end

  def self.down
  end
end
