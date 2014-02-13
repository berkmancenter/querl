class DashboardController < ApplicationController
  
  def index
    @all_projects = Project.all
    unless current_user.nil?
      @your_projects = current_user.projects
    end  
  end  
end
