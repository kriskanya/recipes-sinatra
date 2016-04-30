class CreateIngredientsTable < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.string :name
      t.integer :cost
      t.integer :amount

      t.integer :recipe_id
    end
  end
end
