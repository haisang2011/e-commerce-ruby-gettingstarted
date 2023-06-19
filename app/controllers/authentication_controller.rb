class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  # POST /auth/login
  def login
    @user = User.find_by_email(login_params[:email])

    return render json: { status: 400, message: 'Incorrect email or password' }, status: :not_found unless @user

    parsedPassword = BCrypt::Password.new(@user.password)
    if parsedPassword == login_params[:password]
      token = jwt_encode(user_id: @user.id)
      return render json: {
        message: 'Success',
        status: 200,
        data: {
          accessToken: token,
          user: {
            email: @user.email,
            firstName: @user.first_name,
            lastName: @user.last_name,
            middleName: @user.middle_name,
            age: @user.age,
            gender: @user.gender,
            avatar: @user.avatar,
          }
        }
      }, status: :ok
    else
      return render json: { status: 400, message: 'Incorrect email or password' }, status: :not_found
    end
  end
  def sign_up
    user = User.new
    user.email = params[:email]
    user.password = BCrypt::Password.create(params[:password])
    user.first_name = params[:first_name]
    user.last_name = params[:last_name]

    if user.save
      token = jwt_encode(user_id: user.id)
      render json: {
        message: 'Success',
        status: 200,
        data: {
          accessToken: token,
          user: {
            user: user.email,
            first_name: user.first_name,
            last_name: user.last_name
          }
        }
      }, status: :ok
    else
      render json: { status: 400, message: 'Failed to sign up' }, status: :bad_request
    end
  end
  private
  def login_params
    params.permit(:email, :password)
  end
end