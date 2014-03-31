class Response < ActiveRecord::Base
  belongs_to :user
  belongs_to :survey
  belongs_to :survey_item
end
