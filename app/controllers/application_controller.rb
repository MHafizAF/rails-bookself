class ApplicationController < ActionController::API
  ACCESS_TOKEN_SECRET  = ENV["ACCESS_TOKEN_SECRET"]
  REFRESH_TOKEN_SECRET = ENV["REFRESH_TOKEN_SECRET"]
  ALGORITHM = 'HS256'.freeze
  BEARER_FORMAT = /^Bearer /i.freeze


  def authenticate 
    decode_data = decode_user_data(request.headers["Authorization"], ACCESS_TOKEN_SECRET)
    user_data   = decode_data[0]["user_id"] unless !decode_data
    @user       = User.find_by(id: user_data) 

    return response_error("You need to sign in to continue", 401) unless @user
  end

  def encode_user_data(payload, secret)
    JWT.encode payload, secret, ALGORITHM
  end

  def decode_user_data(token_params, secret)
    if token_params
      token = extract_token(token_params)
      
      begin 
        JWT.decode token, secret, true, { algorithm: ALGORITHM }
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

  private 

  def extract_token(token_param)
    if token_param.match?(BEARER_FORMAT)
      token_param.split(' ', 2).last
    else
      token_param
    end
  end


end
