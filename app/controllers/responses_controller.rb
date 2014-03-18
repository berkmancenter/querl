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
