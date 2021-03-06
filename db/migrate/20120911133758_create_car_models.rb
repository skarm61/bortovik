class CreateCarModels < ActiveRecord::Migration
  def change
    create_table :car_models do |t|
      t.string :name
      t.references :car_brand

      t.timestamps
    end
    add_index :car_models, :car_brand_id
    add_index :car_models, :name
  end
end
