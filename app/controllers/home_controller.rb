class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    render layout: 'marketing'
  end
end
