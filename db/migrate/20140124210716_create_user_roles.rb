class CreateUserRoles < ActiveRecord::Migration
  def change
    create_table :user_roles do |t|
      t.string :name
      t.text :description
      t.timestamps
    end
    
    create_table :project_user_user_roles do |t|
      t.references :project
      t.references :user
      t.references :user_role
      t.timestamps
    end
  end
end
