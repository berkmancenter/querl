class ProjectsController < ApplicationController
  load_and_authorize_resource
  
  def index
    
  end
  
  def show
    @surveys = @project.surveys
  end  
  
  def new
    @project = Project.new
  end
  
  def edit
    
  end
  
  def create
    @project = Project.new(project_params)
    @project.user_roles = [UserRole.create(:user_id => current_user.id, :name => "owner")]
    respond_to do |format|
      if @project.save
        format.html { redirect_to root_url, notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, author: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @project = Project.find(params[:id])
    
    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to root_url, notice: 'Project was successfully updated.' }
        format.json { head :no_content }  
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def show_users
    @current_users = @project.users
    @all_users = User.all
  end
  
  def remove_user
    @project = Project.find(params[:project_id])
    @user = User.find(params[:user_id])
    @role = UserRole.find(:first, :conditions => {:project_id => @project.id, :user_id => @user.id})
    @role.destroy
    redirect_to show_users_projects_url(:id => @project.id)
  end
  
  def add_owner
    @project = Project.find(params[:project_id])
    @user = User.find(params[:user_id])
    @project.user_roles << [UserRole.create(:user_id => @user.id, :name => "owner")]
    redirect_to show_users_projects_url(:id => @project.id)
  end
  
  def add_coder
    @project = Project.find(params[:project_id])
    @user = User.find(params[:user_id])
    @project.user_roles << [UserRole.create(:user_id => @user.id, :name => "coder")]
    redirect_to show_users_projects_url(:id => @project.id)
  end
  
  def destroy
    @project = Project.find(params[:id])
    @roles = ProjectUserUserRoles.find(:all, :conditions => {:project_id => @project.id})
    @project.destroy
    @roles.each{|role| role.destroy}
    
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit!
    end
end
