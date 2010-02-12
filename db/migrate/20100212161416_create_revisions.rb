class CreateRevisions < ActiveRecord::Migration
  def self.up
    create_table :revisions do |t|
      t.integer :block_id
      t.text :snippet
      t.timestamps
    end
    remove_column :blocks, :snippet
  end

  def self.down
    drop_table :revisions
    add_column :blocks, :snippet, :text
  end
end
