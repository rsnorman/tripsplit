# Controller for registering, updating, and deleting users
class Api::V1::UsersController < Api::ApiController
	def update
    @user = current_user
		@user.update_attributes(user_params)
	end

	private

	def user_params
		params.require(:user).permit(:email, :name, :password, :picture)
	end
end
