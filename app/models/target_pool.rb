class TargetPool < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :survey
  belongs_to :target
end
