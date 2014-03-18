class Project < ActiveRecord::Base
  
  has_many :surveys
  has_many :user_roles
  has_many :users, through: :user_roles
  
  def get_role(user)
    unless user.user_roles.where(:project_id => self.id)[0].nil? 
      user.user_roles.where(:project_id => self.id)[0].name
    end  
  end  
end
