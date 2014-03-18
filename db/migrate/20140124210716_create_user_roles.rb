class CreateUserRoles < ActiveRecord::Migration
  def change
    create_table :user_roles do |t|
      t.string :name
      t.belongs_to :project
      t.belongs_to :user
      t.timestamps
    end
  end
end
