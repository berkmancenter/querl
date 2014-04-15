class SurveyItem < ActiveRecord::Base
  
  has_and_belongs_to_many :surveys
  has_many :responses
  belongs_to :project
  
  validates_presence_of :field_name, :field_type
  validates_uniqueness_of :field_name
  validates_format_of :field_name, :with => /^\S+\w{2,32}\S{1,}/, :multiline => true, :message => "cannot contain spaces or special characters"
  
  FIELD_TYPES = ['Checkbox', 'Dropdown', 'File', 'Radio', 'String (Text box)', 'Textarea (Paragraph)', 'Date', 'Label' ]
  FIELD_OPTIONS = ['']
  
  def to_s
    self.field_name
  end  
  
  def formtastic_field_map
    as_param = ""
    if self.field_type == "Checkbox"
      as_param = "check_boxes"  
    elsif self.field_type == "Dropdown"
      as_param = "select"
    elsif self.field_type == "File"
      as_param = "file"
    elsif self.field_type == "Radio"
      as_param = "radio"
    elsif self.field_type == "String (Text box)"
      as_param = "string"
    elsif self.field_type == "Textarea (Paragraph)"
      as_param = "text"
    elsif self.field_type == "Date"
      as_param = "date_select"  
    end            
  end 
end
