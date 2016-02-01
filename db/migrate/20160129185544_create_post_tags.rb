class CreatePostTags < ActiveRecord::Migration
  def change
    create_table :post_tags do |t|

      t.timestamps
    end

    add_column :post_tags, :post_id, :integer
    add_column :post_tags, :tag_id, :integer
  end
end
