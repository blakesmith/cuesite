class CreateCuesheets < ActiveRecord::Migration
  def self.up
    create_table :cuesheets do |t|
      t.string :performer
      t.string :title
      t.string :file
      t.integer :download_count, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :cuesheets
  end
end
