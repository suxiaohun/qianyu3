class CreateNovels < ActiveRecord::Migration[5.2]
  def change
    create_table :novels do |t|
      t.string :title
      t.text :content
      t.date :biz_date

      t.timestamps
    end
  end
end
