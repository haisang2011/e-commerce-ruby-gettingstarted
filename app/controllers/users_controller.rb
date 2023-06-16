require 'bcrypt'

class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]
  before_action :set_user, only: [:show, :destroy]

  # GET /users
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  # GET /users/{username}
  def show
    render json: @user, status: :ok
  end

  # CREATE /users
  def create
    @user = User.new
    @user.first_name = user_params[:firstName]
    @user.last_name = user_params[:lastName]
    @user.email = user_params[:email]
    @user.password = BCrypt::Password.create(params[:password])

    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # PUT /users/{email}
  def update
    render json: { errors: "ashfdsfg" }, status: :ok
    # unless @user.update(user_params)
    #   render json: { errors: @user.errors.full_messages },
    #          status: :unprocessable_entity
    # end
  end

  # DELETE /users/{username}
  def destroy
    @user.destroy
  end

  private
    def user_params
      params.permit(:firstName, :lastName, :email, :password)
    end

    def set_user
      @user = User.find(params[:id])
    end

end