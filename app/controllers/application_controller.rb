class ApplicationController < ActionController::API
  def response_ok data, status
    render json: { message: "success", data: data }, status: status
  end

  def response_error message, status 
    render json: { message: message }, status: status
  end

  def pagination data
    {
      prev_page: data.prev_page,
      next_page: data.next_page,
      current_page: data.current_page,
      total_pages: data.total_pages
    }
  end
end
