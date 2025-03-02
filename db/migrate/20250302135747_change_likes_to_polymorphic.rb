class ChangeLikesToPolymorphic < ActiveRecord::Migration[7.1]
  def change
    remove_column :likes, :post_id, :integer  # Remove direct post_id reference

    add_column :likes, :likeable_type, :string  # Add polymorphic type
    add_column :likes, :likeable_id, :bigint    # Add polymorphic ID
    add_index :likes, [:likeable_type, :likeable_id]  # Add index for faster queries
  end
end
