class SurveysController < ApplicationController
  load_and_authorize_resource
  
  def index
    
  end
  
  def show
    @survey_items = SurveyItem.all
    @current_items = @survey.survey_items
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
    
    respond_to do |format|
      if @survey.update_attributes(params[:survey])
        format.html { redirect_to root_url, notice: 'Survey was successfully updated.' }
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
