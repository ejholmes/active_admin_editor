class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :storage
      t.string :type

      t.timestamps
    end
  end
end
