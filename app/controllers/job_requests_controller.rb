class JobRequestsController < ApplicationController
  def index
    @job_requests = current_user.active_job_requests
    
    add_breadcrumb "Task Management", 'job_requests_url'
  end
end
