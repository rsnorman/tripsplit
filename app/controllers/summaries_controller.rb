class SummariesController < ApplicationController
  load_and_authorize_resource :trip, through: :current_user, only: :show

  def show
  end
end
