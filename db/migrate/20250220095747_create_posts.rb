class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :description
      t.boolean :public

      t.timestamps
    end
  end
end
