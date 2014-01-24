class Project < ActiveRecord::Base
  
  has_many :surveys
  has_and_belongs_to_many :user_roles
  has_and_belongs_to_many :users
end
