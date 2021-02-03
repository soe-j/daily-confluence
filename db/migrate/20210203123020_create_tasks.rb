class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :source_page_id
      t.string :target_parent_page_id

      t.timestamps
    end
  end
end
