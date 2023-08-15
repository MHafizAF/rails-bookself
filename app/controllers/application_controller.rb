class ApplicationController < ActionController::API
  ACCESS_TOKEN_SECRET  = ENV["ACCESS_TOKEN_SECRET"]
  REFRESH_TOKEN_SECRET = ENV["REFRESH_TOKEN_SECRET"]

  def authenticate 
    decode_data = decode_user_data(request.headers["Authorization"], ACCESS_TOKEN_SECRET)
    user_data   = decode_data[0]["user_id"] unless !decode_data
    @user       = User.find_by(id: user_data) 

    return response_error("You need to sign in to continue", 401) unless @user
  end

  def encode_user_data(payload, secret)
    JWT.encode payload, secret, "HS256"
  end

  def decode_user_data(token_params, secret)
    if token_params
      split_token = token_params.split(" ")
      token       = split_token[0] != "Bearer" ? split_token[0] : split_token[1] 
      
      begin 
        JWT.decode token, secret, true, { algorithm: "HS256" }
      rescue => errors 
        puts errors
      end
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
