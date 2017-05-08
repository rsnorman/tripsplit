class DownloadsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    if params[:id] == 'ios'
      redirect_to 'https://itunes.apple.com/us/app/tripsplit-make-traveling-with-friends-great/id1231790399?mt=8'
    else
      redirect_to 'https://play.google.com/store/apps/details?id=io.katetdev.tripsplit'
    end
  end
end
