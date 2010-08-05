class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
      t.string :name
      t.integer :teacher_id
      t.string :description
      t.boolean :closed, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :courses
  end
end
