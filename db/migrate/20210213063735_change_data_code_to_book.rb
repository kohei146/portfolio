class ChangeDataCodeToBook < ActiveRecord::Migration[5.2]
  def change
    change_column :books, :code, :string
  end
end
