class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  
  layout :layout_by_resource
  def layout_by_resource
    if devise_controller? && resource_name == :user && action_name == 'new'
      "devise"
    else
      "application"
    end
  end
  
  
  def set_breadcrumb_for object, destination_path, opening_words
    add_breadcrumb "#{opening_words}", destination_path
  end
  
  def extract_date_time( params_deadline_datetime, params_hour , params_minute , offset)
    if params_deadline_datetime.nil? or params_deadline_datetime.length ==0 
      return DateTime.now.in_time_zone(school.get_time_zone)
    end
    
    time_array = params_deadline_datetime.split("/")
  
    hour = 0 
    if params_hour.nil? || params_hour.length ==0  
      hour = 0
    else
      hour = params_hour.to_i
    end
    
    minute = 0 
    if params_minute.nil? || params_minute.length ==0  
      minute = 0
    else
      minute = params_minute.to_i
    end        
              
    new_datetime =''
    begin
      new_datetime =  DateTime.new(time_array[2].to_i, time_array[0].to_i, time_array[1].to_i,
                            hour, minute, 0,
                            Rational(offset , 24) )
    rescue
      new_datetime =  nil
    end
    
    return new_datetime
  end
  
  

  protected 
  
  def add_breadcrumb name, url = ''
    @breadcrumbs ||= []
    url = eval(url) if url =~ /_path|_url|@/
    @breadcrumbs << [name, url]
  end

  def self.add_breadcrumb name, url, options = {}
    before_filter options do |controller|
      controller.send(:add_breadcrumb, name, url)
    end
  end
end
