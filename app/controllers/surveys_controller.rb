class SurveysController < ApplicationController
  load_and_authorize_resource
  
  def index
    
  end
  
  def show
    @project = @survey.project
    @survey_items = @project.survey_items
    @current_items = @survey.survey_items
    @target_lists = @project.target_lists

    if @project.get_role(current_user) == 'coder'
      @next_target = @survey.next_target(current_user)
      if @next_target.blank?
        redirect_to project_url(@project), notice: 'Coding is Complete!'
      end  
    end  
    
    unless params[:gather_response].nil?
      redirect_to gather_response_surveys_url(:answers => params[:gather_response], :target_id => params[:target_id], :survey_id => @survey.id)
    end
  end  
  
  def new
    @survey = Survey.new
    @project = Project.find(params[:project_id])
  end
  
  def edit
    @project = Project.find(params[:project_id])
  end
  
  def create
    @survey = Survey.new(survey_params)
    respond_to do |format|
      if @survey.save
        format.html { redirect_to project_url(@survey.project), notice: 'Survey was successfully created.' }
        format.json { render json: @survey, status: :created, author: @survey }
      else
        format.html { render action: "new" }
        format.json { render json: @survey.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @survey = Survey.find(params[:id])
    unless params[:survey][:survey_item_ids].nil?
      all_items = SurveyItemsSurveys.all(:conditions => {:survey_id => @survey.id})
    end
    respond_to do |format|
      if @survey.update_attributes(params[:survey])
        unless params[:survey][:survey_item_ids].nil?
          nil_items = SurveyItemsSurveys.all(:conditions => {:survey_id => @survey.id, :position => nil})
          i = 0
          if all_items.last.nil? || all_items.last.position.nil?
            pos = 1
          else  
            pos = all_items.last.position + 1
          end  
          while i < nil_items.length  do
             nil_items[i].position = pos
             nil_items[i].save
             i +=1
             pos +=1
          end 
        end
        unless params[:survey_id].nil?
          format.html { redirect_to survey_url(Survey.find(params[:id].to_i)), notice: 'Survey was successfully updated.' }
        else  
          format.html { redirect_to root_url, notice: 'Survey was successfully updated.' }
        end  
        format.json { head :no_content }  
      else
        format.html { render action: "edit" }
        format.json { render json: @survey.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @survey = Survey.find(params[:id])
    @project = @survey.project
    @survey.destroy
    
    respond_to do |format|
      format.html { redirect_to project_url(@project) }
      format.json { head :no_content }
    end
  end
  
  def gather_response
    @survey = Survey.find(params[:survey_id].to_i)
    @project = @survey.project
    params[:answers].each_value do |value|
      response = Response.create(value)
    end  
    pool = TargetPool.first(:conditions => {:target_id => params[:target_id], :survey_id => @survey.id, :user_id => current_user.id, :locked => true})

    pool.completed = true
    pool.save
    params[:gather_response] = nil
    
    @next_target = @survey.next_target(current_user)
    if @next_target.blank?
      redirect_to project_url(@project), notice: 'Response was successfully recorded. Coding is Complete!'
    else
      redirect_to survey_url(@survey.id), notice: 'Response was successfully recorded.'
    end
  end
  
  def remove_survey_item
    @survey = Survey.find(params[:survey_id])
    @item_to_remove = SurveyItem.find(params[:survey_item_id])
    @current_survey_items = @survey.survey_items
    @survey.survey_items = @current_survey_items.delete_if {|item| item.id == @item_to_remove.id }
    
    redirect_to survey_url(@survey), notice: 'Survey item was removed.'
  end
  
  def preview
    @project = @survey.project
    @current_items = @survey.survey_items
    
  end
  
  def move
    survey = Survey.find(params[:survey_id])
    survey_items_surveys_item = SurveyItemsSurveys.first(:conditions => {:survey_id => survey.id, :survey_item_id => params[:survey_item_id]})
    if ["increment_position", "decrement_position", "move_to_top", "move_to_bottom", "remove_from_list"].include?(params[:method]) and !survey_items_surveys_item.nil?
      survey_items_surveys_item.send(params[:method])
      if params[:method] == "remove_from_list"
        survey.survey_items = survey.survey_items.delete_if {|item| item.id == params[:survey_item_id].to_i }
      end  
    end
    redirect_to survey_url(survey)#, notice: 'Survey item was repositioned.'
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey
      @survey = Survey.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def survey_params
      params.require(:survey).permit!
    end
end
