class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    if (unregistered_user = UnregisteredUser.find_by_email(sign_up_params[:email]))
      User.transaction do
        unregistered_user.update(email: "TEMP-#{unregistered_user.email}")

        super do |user|
          TransferUserOwnership.new(unregistered_user).transfer_to(user)
          unregistered_user.destroy
        end
      end
    else
      super
    end
  end

  def render_create_success
    @user = @resource
  end

  protected

  def sign_up_params
    params.require(:user).permit(:email, :password, :name)
  end
end
