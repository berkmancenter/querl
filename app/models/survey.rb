class Survey < ActiveRecord::Base
  belongs_to :project
  has_and_belongs_to_many :survey_items, -> { order('survey_items_surveys.position') }
  has_many :responses
  belongs_to :target_list
  has_many :target_pools, -> { order('target_id') }
  
  def next_target(user)
    nxttar = ""
    behavior = self.behavior
    completed_targets = Array.new
    all_locked = Array.new
    locked_target = self.target_pools.where(:user_id => user.id, :completed => false)
    self.target_pools.where(:locked => true, :completed => false).collect {|pool| all_locked << pool.target_id }
    
    if behavior == "Unicode"
      self.target_pools.where(:locked => true).collect {|pool| completed_targets << pool.target_id }
    elsif behavior == "Multicode"
      self.target_pools.where(:user_id => user.id, :locked => true).collect {|pool| completed_targets << pool.target_id }
    end  
    
    if self.target_pools.empty?
      TargetPool.create(:user_id => user.id, :target_id => self.target_list.targets.first.id, :survey_id => self.id, :locked => true, :completed => false)
      return self.target_list.targets.first
    elsif !locked_target[0].nil? 
      return Target.find(locked_target[0].target_id)  
    else  
      self.target_list.targets.each do |target|
        unless completed_targets.include?(target.id) || all_locked.include?(target.id)
          TargetPool.create(:user_id => user.id, :target_id => target.id, :survey_id => self.id, :locked => true, :completed => false)
          nxttar = target
        end  
      end
      return nxttar  
    end  
  end 
  
  def clone_with_associations
      new_survey = self.dup
      new_survey.target_list = nil
      new_survey.behavior = nil
      new_survey.save
      #simple association
      new_survey.project = self.project
      new_survey.survey_items = self.survey_items
      new_survey
    end 
end
