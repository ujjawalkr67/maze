class ChangeDefaultForPostsPublic < ActiveRecord::Migration[7.0]
  def change
    change_column_default :posts, :public, from: nil, to: true
  end
end

