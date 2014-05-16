class Project < ActiveRecord::Base
  
  has_many :surveys, dependent: :destroy
  has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles
  has_many :survey_items, dependent: :destroy
  has_many :target_lists, dependent: :destroy
  
  def get_role(user)
    unless user.user_roles.where(:project_id => self.id)[0].nil? 
      user.user_roles.where(:project_id => self.id)[0].name
    end  
  end  
end
