class ApplicationController < ActionController::API
  include JsonWebToken

  before_action :authenticate_request

  private
    def authenticate_request
      begin
        header = request.headers["Authorization"]
        header = header.split(" ").last if header
        decoded = jwt_decode(header)
        @current_user = User.find(decoded[:user_id])
      rescue ActiveRecord::RecordNotFound => e
        render json: { message: e.message, status: 401, data: nil }, status: :unauthorized
      rescue JWT::DecodeError => e
        render json: { message: e.message, status: 401, data: nil }, status: :unauthorized
      end
    end
end
