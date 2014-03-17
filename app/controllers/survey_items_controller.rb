class SurveyItemsController < ApplicationController
  
  def index
    
  end
  
  def show
    
  end  
  
  def new
    @survey = Survey.find(params[:survey_id])
    @survey_item = SurveyItem.new
  end
  
  def edit
    
  end
  
  def create
    @survey_item = SurveyItem.new(survey_item_params)
    respond_to do |format|
      if @survey_item.save
        format.html { redirect_to root_url, notice: 'Survey Item was successfully created.' }
        format.json { render json: @survey_item, status: :created, author: @survey_item }
      else
        format.html { render action: "new" }
        format.json { render json: @survey_item.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @survey_item = SurveyItem.find(params[:id])
    
    respond_to do |format|
      if @survey_item.update_attributes(params[:survey_item])
        format.html { redirect_to root_url, notice: 'Survey Item was successfully updated.' }
        format.json { head :no_content }  
      else
        format.html { render action: "edit" }
        format.json { render json: @survey_item.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @survey_item = SurveyItem.find(params[:id])
    @survey_item.destroy
    
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey
      @survey_item = SurveyItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def survey_item_params
      params.require(:survey_item).permit!
    end
end
