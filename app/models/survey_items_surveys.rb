class SurveyItemsSurveys < ActiveRecord::Base
  
  belongs_to :survey_item
  belongs_to :survey
  
  acts_as_list :scope => :survey
end
