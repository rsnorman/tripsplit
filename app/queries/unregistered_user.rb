class UnregisteredUser
  def self.find_by_email(email)
    new.find_by_email(email)
  end

  def initialize(users: User.all)
    @users = users
  end

  def find_by_email(email)
    @users.find_by(email: email, encrypted_password: '')
  end
end
