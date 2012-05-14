# This migration comes from active_admin_editor (originally 20120510000541)
class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :storage
      t.string :type

      t.timestamps
    end
  end
end
