require 'csv'

class ResponsesController < ApplicationController
  load_and_authorize_resource
  
  def index
    
  end
  
  def show
    
  end  
  
  def new
    @response = Response.new
  end
  
  def edit
    
  end
  
  def create
    @response = Response.new(project_params)
    respond_to do |format|
      if @response.save
        format.html { redirect_to root_url, notice: 'Response was successfully created.' }
        format.json { render json: @response, status: :created, author: @response }
      else
        format.html { render action: "new" }
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @response = Response.find(params[:id])
    
    respond_to do |format|
      if @response.update_attributes(params[:response])
        format.html { redirect_to root_url, notice: 'Response was successfully updated.' }
        format.json { head :no_content }  
      else
        format.html { render action: "edit" }
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @response = Response.find(params[:id])
    @response.destroy
    
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end
  
  def reports
    @survey = Survey.find(params[:survey_id])
    @target_lists = @survey.project.target_lists
    unless params[:csv].nil?
      @csv = true
    end  
  end  
  
  def export
    @survey = Survey.find(params[:survey_id])
    @survey_items = @survey.survey_items
    @headers = @survey_items.collect {|item| item.field_name }
    @target_list = TargetList.find(params[:target_list_id])
    @responses = Response.all(:conditions => ["survey_id = ? and target_id IN (?)", @survey.id, @target_list.targets.collect{|target| target.id}])
    @grouped = @responses.group_by { |i| [i.user_id, i.target_id] }
    p "headers"
    p @headers
    p "responses"
    p @responses
    p "grouped"
    p @grouped
 
    CSV.open("#{Rails.root}/public/uploads/report.csv", "w") do |csv|
      header = ["coder_id", "target"]
      @survey_items.each do |item|
        header << item.field_name
      end  
      p "header"
      p header  
      csv << header
      @grouped.each do |key, value|
        row = Array.new
        p "key"
        p key
        row << [User.find(key[0]).username, Target.find(key[1]).link_text]
        @survey_items.each do |item|
          response = value.select{|resp| resp.survey_item_id == item.id}[0]
          unless response.nil?
            row << [response.response_text]
          else
            row << [""]  
          end  
        end
        row.flatten!
        csv << row
      end

    end
    flash[:notice] = 'Exported!'
    @csv = true
    redirect_to reports_responses_path(:survey_id => @survey.id, :csv => @csv)
  end  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_response
      @response = Response.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def response_params
      params.require(:response).permit!
    end
end
