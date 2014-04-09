class CreateTargetPools < ActiveRecord::Migration
  def change
    create_table :target_pools do |t|
      t.references :user
      t.references :target
      t.references :survey
      t.boolean :locked
      t.boolean :completed
      t.timestamps
    end
  end
end
