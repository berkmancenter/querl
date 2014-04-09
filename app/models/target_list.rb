class TargetList < ActiveRecord::Base
  
  belongs_to :project
  has_many :targets, -> { order('id') }
  has_one :survey
end
