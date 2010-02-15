class CreateLanguages < ActiveRecord::Migration
  def self.up
    create_table :languages do |t|
      t.string :name
    end
    add_column :blocks, :language_id, :integer
  end

  def self.down
    drop_table :languages
    remove_column :blocks, :language_id
  end
end
