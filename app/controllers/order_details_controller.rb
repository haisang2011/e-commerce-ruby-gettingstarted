class OrderDetailsController < ApplicationController
  # skip_before_action :verify_authenticity_token
  def index
    order_details = OrderDetail.all
    render json: {success: true, data: order_details}, status: :ok
  end
end
