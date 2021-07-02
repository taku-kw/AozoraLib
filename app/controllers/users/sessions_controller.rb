class Users::SessionsController < Devise::SessionsController
  def guest_sign_in
    user = User.guest
    sign_in user
    user.books = Book.order("RANDOM()").limit(20)
    redirect_to root_path
  end
end
