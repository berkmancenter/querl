class Survey < ActiveRecord::Base
  belongs_to :project
  has_and_belongs_to_many :survey_items, -> { order('survey_items_surveys.position') }
  has_many :responses
  belongs_to :target_list
  has_many :target_pools, -> { order('target_id') }
  
  def next_target(user)
    behavior = self.behavior
    locked_targets = Array.new
    self.target_pools.collect {|pool| locked_targets << pool.target_id }
    if behavior == "Sequential Distinct"
      if self.target_pools.empty?
        TargetPool.create(:user_id => user.id, :target_id => self.target_list.targets.first.id, :survey_id => self.id, :locked => true)
        return self.target_list.targets.first
      else  
        self.target_list.targets.each do |target|
          unless locked_targets.include?(target.id)
            TargetPool.create(:user_id => user.id, :target_id => target.id, :survey_id => self.id, :locked => true)
            return target
          else
            return nil  
          end  
        end  
      end  
    end  
    
  end  
end
