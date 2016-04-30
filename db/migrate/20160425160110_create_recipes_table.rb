class CreateRecipesTable < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :name
      t.integer :prep_time
      t.text :directions
      
      t.integer :user_id
    end
  end
end
