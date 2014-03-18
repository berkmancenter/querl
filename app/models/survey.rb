class Survey < ActiveRecord::Base
  belongs_to :project
  has_and_belongs_to_many :survey_items
  has_many :responses
end
