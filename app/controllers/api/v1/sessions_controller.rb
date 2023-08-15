class Api::V1::SessionsController < ApplicationController
  def signup 
    @user = User.new(session_params)

    @user.save ? response_ok(@user, 200) :
                 response_error(@user.errors, 422)
  end

  def signin 
    @user = User.find_by(username: session_params[:username])

    if @user && @user.authenticate(session_params[:password])
      token = encode_user_data({ user_id: @user.id })

      render json: {
        message: "success",
        token: token, 
        data: @user
      }, status: 201
    else
      response_error("Invalid username or password", 422)
    end
  end

  def session_params
    params.require(:user).permit(:username, :password)
  end
end
