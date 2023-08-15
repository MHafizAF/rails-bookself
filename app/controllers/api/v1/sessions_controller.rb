class Api::V1::SessionsController < ApplicationController
  ACCESS_TOKEN_SECRET  = ENV["ACCESS_TOKEN_SECRET"]
  REFRESH_TOKEN_SECRET = ENV["REFRESH_TOKEN_SECRET"]

  def signup 
    @user = User.new(session_params)

    @user.save ? response_ok(@user, 200) :
                 response_error(@user.errors, 422)
  end

  def signin 
    @user = User.find_by(username: session_params[:username])

    if @user && @user.authenticate(session_params[:password])
      access_token  = encode_user_data({ user_id: @user.id, exp: 1.hours.from_now.to_i }, ACCESS_TOKEN_SECRET)
      refresh_token = encode_user_data({ user_id: @user.id, exp: 7.hours.from_now.to_i }, REFRESH_TOKEN_SECRET)

      render json: {
        message: "success",
        access_token: access_token, 
        refresh_token: refresh_token,
        data: @user
      }, status: 201
    else
      response_error("Invalid username or password", 422)
    end
  end

  def refresh_token 
    user_id = decode_user_data(params[:refresh_token], REFRESH_TOKEN_SECRET)

    if user_id 
      access_token  = encode_user_data({ user_id: user_id[0]["user_id"], exp: 1.hours.from_now.to_i }, ACCESS_TOKEN_SECRET) 
      refresh_token = encode_user_data({ user_id: user_id[0]["user_id"], exp: 7.hours.from_now.to_i }, REFRESH_TOKEN_SECRET)

      render json: { access_token: access_token, refresh_token: refresh_token}
    else
      response_error("Invalid token", 400)
    end
  end

  def session_params
    params.require(:user).permit(:username, :password)
  end
end
