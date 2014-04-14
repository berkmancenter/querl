class Target < ActiveRecord::Base
  
  belongs_to :target_list
  has_many :target_pools
  has_many :responses
end
