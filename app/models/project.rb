class Project < ActiveRecord::Base
  
  has_many :surveys
  has_many :user_roles
  has_many :users, through: :user_roles
end
