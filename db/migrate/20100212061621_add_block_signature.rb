class AddBlockSignature < ActiveRecord::Migration
  def self.up
    rename_column :blocks, :private, :is_private
    add_column :blocks, :signature, :string
  end

  def self.down
    rename_column :blocks, :is_private, :private
    remove_column :blocks, :signature
  end
end
