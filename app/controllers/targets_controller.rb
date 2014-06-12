require 'csv'
class TargetsController < ApplicationController
  load_and_authorize_resource
  
  def index
    
  end
  
  def show
    @target_list = @target.target_list
  end  
  
  def new
    @target = Target.new
    @target_list = TargetList.find(params[:target_list_id])
  end
  
  def edit
    @target_list = TargetList.find(params[:target_list_id])
  end
  
  def create
    @target = Target.new(target_params)
    respond_to do |format|
      if @target.save
        format.html { redirect_to target_list_url(@target.target_list), notice: 'Target was successfully created.' }
        format.json { render json: @target, status: :created, author: @target }
      else
        format.html { render action: "new" }
        format.json { render json: @target.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @target = Target.find(params[:id])
    
    respond_to do |format|
      if @target.update_attributes(params[:target])
        format.html { redirect_to root_url, notice: 'Target was successfully updated.' }
        format.json { head :no_content }  
      else
        format.html { render action: "edit" }
        format.json { render json: @target.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @target = Target.find(params[:id])
    @target_list = @target.target_list
    @target.destroy
    
    respond_to do |format|
      format.html { redirect_to target_list_url(@target_list) }
      format.json { head :no_content }
    end
  end
  
  def import
    @file = params[:upload][:datafile] unless params[:upload].blank?
    
    if @file.nil?
      flash[:error] = 'No file chosen.'
      redirect_to :back and return
    end
      
    CSV.parse(@file.read, {:headers => true, :header_converters=> lambda {|f| f.strip},
   :converters=> lambda {|f| f ? f.strip : nil}}).each do |cell|
        
        target={}
        
        target[:name] = cell["name"]
        target[:display_text] = cell["display_text"]
        target[:description] = cell["description"]
        target[:link_text] = cell["link_text"]
        target[:target_type] = cell["target_type"]
        target[:target_list_id] = params[:target_list_id]
        
        @target = Target.new
 
        @target.attributes = target
        @target.save
        @target_list = @target.target_list
    end
    redirect_to target_list_path(@target_list)
  end 
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_target
      @target = TargetList.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def target_params
      params.require(:target).permit!
    end
end
