class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :user_roles
  has_many :projects, through: :user_roles
  has_many :responses
  has_many :target_pools
  
  ROLES = %w[owner coder]
  
  def get_role(project)
    self.user_roles.where(:project_id => project.id)[0].name
  end 
end
