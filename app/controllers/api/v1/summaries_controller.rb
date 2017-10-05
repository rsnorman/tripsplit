# Controller for retrieving trip summary
class Api::V1::SummariesController < Api::ApiController
  load_and_authorize_resource :trip, through: :current_user
end
