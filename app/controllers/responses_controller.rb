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
  end  
  
  def export
    @survey = Survey.find(params[:survey_id])
    @survey_items = @survey.survey_items
    @responses = Response.all(:conditions => {:survey_id => @survey.id})
    CSV.open("#{Rails.root}/public/uploads/report.csv", "w") do |csv|
      csv << ["title", "subject", "course number", "affiliation", "contact first name", "contact last name", "contact username", "contact email", "contact phone", "pre class appt", "timeframe", "repository", "room", "staff involvement", "number of students", "status", "file", "external syllabus", "duration", "comments", "course sessions", "session count", "goal", "instruction session", "date submitted"]
      @courses.each do |course|
        row = Array.new
        row << [course.title, course.subject, course.course_number, course.affiliation, course.contact_first_name, course.contact_last_name, course.contact_username, course.contact_email, course.contact_phone, course.pre_class_appt, course.timeframe] 
        unless course.repository.nil?
          row << [course.repository.name]
        else 
          row << ["None"]
        end
        unless course.room.nil?
          row << [course.room.name]
        else
          row << ["None"]
        end
        row << [course.staff_involvement, course.number_of_students, course.status, course.file, course.external_syllabus, course.duration, course.comments, course.course_sessions, course.session_count, course.goal, course.instruction_session, course.created_at]
        row.flatten!
        csv << row
      end
    end
    flash[:notice] = 'Exported!'
    @csv = true
    redirect_to courses_path(:csv => @csv)
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
