class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.string :published_date
      t.text :description
      t.text :review
      t.string :image
      t.integer :code
      t.float :rate
      t.integer :user_id
      t.timestamps
    end
  end
end
