class TargetListsController < ApplicationController
  load_and_authorize_resource
  
  def index
    
  end
  
  def show
    @project = @target_list.project
    @current_items = @target_list.targets
  end  
  
  def new
    @target_list = TargetList.new
    @project = Project.find(params[:project_id])
  end
  
  def edit
    @project = Project.find(params[:project_id])
  end
  
  def create
    @target_list = TargetList.new(target_list_params)
    respond_to do |format|
      if @target_list.save
        format.html { redirect_to target_list_url(@target_list), notice: 'Target List was successfully created.' }
        format.json { render json: @target_list, status: :created, author: @target_list }
      else
        format.html { render action: "new" }
        format.json { render json: @target_list.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @target_list = TargetList.find(params[:id])
    
    respond_to do |format|
      if @target_list.update_attributes(params[:target_list])
        format.html { redirect_to root_url, notice: 'Target List was successfully updated.' }
        format.json { head :no_content }  
      else
        format.html { render action: "edit" }
        format.json { render json: @target_list.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @target_list = TargetList.find(params[:id])
    @project = @target_list.project
    @target_list.destroy
    
    respond_to do |format|
      format.html { redirect_to project_url(@project) }
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_target_list
      @target_list = TargetList.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def target_list_params
      params.require(:target_list).permit!
    end
end
