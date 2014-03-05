class CreateBikeracks < ActiveRecord::Migration
  def change
    create_table :bikeracks do |t|
      t.integer :rack_id
      t.string :name
      t.string :address
      t.point :latlng, :geographic => true
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
