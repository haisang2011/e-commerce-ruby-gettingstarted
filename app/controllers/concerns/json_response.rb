module JsonResponse
  def json(success, data, status)
    render json: { success: success, data: data }, status: status
  end
end