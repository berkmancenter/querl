class TargetList < ActiveRecord::Base
  
  belongs_to :project
  has_many :targets
  has_one :survey
end
