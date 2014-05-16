class TargetList < ActiveRecord::Base
  
  belongs_to :project
  has_many :targets, -> { order('id') }, dependent: :destroy
  has_one :survey
end
