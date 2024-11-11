class Api::V1::SessionsController < ApplicationController
  ACCESS_TOKEN_SECRET  = ENV["ACCESS_TOKEN_SECRET"]
  REFRESH_TOKEN_SECRET = ENV["REFRESH_TOKEN_SECRET"]
  TOKEN_EXPIRATION = {
    access: 1.hours.from_now,
    refresh: 7.hours.from_now
  }.freeze

  def signup 
    @user = User.new(session_params)

    @user.save ? response_ok(@user, 201) 
      : response_error(@user.errors, 422)
  end

  def signin 
    @user = User.find_by(username: session_params[:username])

    if @user && @user.authenticate(session_params[:password])
      render_token({
        access: generate_token(@user.id, TOKEN_EXPIRATION[:access], ACCESS_TOKEN_SECRET),
        refresh: generate_token(@user.id, TOKEN_EXPIRATION[:refresh] ,REFRESH_TOKEN_SECRET)
      })
    else
      response_error("Invalid username or password", 422)
    end
  end

  def refresh_token 
    user_id = decode_user_data(params[:refresh_token], REFRESH_TOKEN_SECRET)

    if user_id
      render_token({
        access: generate_token(user_id[0]["user_id"], TOKEN_EXPIRATION[:access], ACCESS_TOKEN_SECRET),
        refresh: generate_token(user_id[0]["user_id"], TOKEN_EXPIRATION[:refresh] ,REFRESH_TOKEN_SECRET)
      })
    else
      response_error("Invalid token", 400)
    end
  end

  def render_token tokens
    render json: {
        message: "success",
        data: {
          access_token: tokens[:access], 
          refresh_token: tokens[:refresh]
        }
      }, status: 201
  end

  def generate_token user_id, expiration, secret
    {
      token: encode_user_data({ user_id: user_id, exp: expiration.to_i }, secret),
      exp_at: expiration
    }
  end

  def session_params
    params.require(:user).permit(:username, :name, :password)
  end
end
