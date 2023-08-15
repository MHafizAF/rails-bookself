class ApplicationController < ActionController::API
  SECRET = ENV["ACCESS_TOKEN_SECRET"]

  def authentication 
    decode_data = decode_user_data(request.headers["token"])
    user_data   = decode_data[0]["user_id"] unless !decode_data
    @user       = User.find(user_data.id)

    render json: { message: "You need to login to access" } unless @user
  end

  def encode_user_data(payload)
    JWT.encode payload, SECRET, "HS256"
  end

  def decode_user_data(token)
    begin 
      JWT.decode token, SECRET, true, { algorithm: "HS256" }
    rescue => errors 
      render json: { message: errors }
    end
  end

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
