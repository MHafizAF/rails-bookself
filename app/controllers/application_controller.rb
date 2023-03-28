class ApplicationController < ActionController::API
  def response_ok data, status
    render json: { message: "success", data: data }, status: status
  end

  def response_error message, status 
    render json: { message: message }, status: status
  end
end
