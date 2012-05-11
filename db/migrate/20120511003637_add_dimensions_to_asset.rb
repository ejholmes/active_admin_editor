class AddDimensionsToAsset < ActiveRecord::Migration
  def change
    add_column :assets, :dimensions, :string
  end
end
