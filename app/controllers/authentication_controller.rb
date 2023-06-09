class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request, only: [:login, :register]

  # POST /auth/login
  def login
    @user = User.find_by_email(login_params[:email])

    return render json: { status: 400, message: 'Incorrect email or password' }, status: :not_found unless @user

    parsedPassword = BCrypt::Password.new(@user.password)
    if parsedPassword == login_params[:password]
      token = jwt_encode(user_id: @user.id)
      @user.update(login_token: token)

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
  def register
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

  def update_profile
    user = User.find_by(id: params[:id])

    if user.nil?
      render json: { status: 404, message: 'User not found' }, status: :not_found
      return
    end
    update_success = user.update(email: params[:email],
                                 first_name: params[:first_name],
                                 last_name: params[:last_name],
                                 middle_name: params[:middle_name],
                                 age: params[:age],
                                 gender: params[:gender],
                                 avatar: params[:avatar])
    if update_success
      render json: {
        message: 'Profile updated successfully',
        status: 200,
        data: {
          user: {
            email: user.email,
            first_name: user.first_name,
            last_name: user.last_name,
            middle_name: user.middle_name,
            age: user.age,
            gender: user.gender == 1 ? "Male" : "Female",
            avatar: user.avatar
          }
        }
      }, status: :ok
    else
      render json: { status: 400, message: 'Failed to update profile' }, status: :bad_request
    end
  end

  def logout
    @current_user.update(login_token: nil);
    render json: {message: "Logout successfully",success: true, data: nil}, status: 200
  end

  private
  def login_params
    params.permit(:email, :password)
  end
end