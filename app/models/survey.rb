class Survey < ActiveRecord::Base
  belongs_to :project
  has_and_belongs_to_many :survey_items, -> { order('survey_items_surveys.position') }
  has_many :responses
  has_one :target_list
end
