class Response < ActiveRecord::Base
  belongs_to :user
  belongs_to :survey
  belongs_to :survey_item
  belongs_to :target
end
