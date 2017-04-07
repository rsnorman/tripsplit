module ApplicationHelper
  def api_link(path)
    "#{request.base_url}#{path}"
  end
end
