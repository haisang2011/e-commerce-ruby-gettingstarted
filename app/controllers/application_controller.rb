class ApplicationController < ActionController::API
  include JsonWebToken

  before_action :authenticate_request

  private
    def authenticate_request
      begin
        authorization = request.headers["Authorization"]
        token = authorization.split(" ").last if authorization
        decoded = jwt_decode(token)
        @current_user = User.find(decoded[:user_id])

        if (@current_user.nil? || @current_user.login_token != token)
          render json: { message: "Unauthorized", status: 401, data: nil }, status: :unauthorized
        end

      rescue ActiveRecord::RecordNotFound => e
        render json: { message: e.message, status: 401, data: nil }, status: :unauthorized
      rescue JWT::DecodeError => e
        render json: { message: e.message, status: 401, data: nil }, status: :unauthorized
      end
    end
end
