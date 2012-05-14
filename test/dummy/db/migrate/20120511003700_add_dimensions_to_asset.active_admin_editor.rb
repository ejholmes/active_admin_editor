# This migration comes from active_admin_editor (originally 20120511003637)
class AddDimensionsToAsset < ActiveRecord::Migration
  def change
    add_column :assets, :dimensions, :string
  end
end
