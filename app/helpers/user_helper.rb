helpers do

  def logged_in?
    !session[:current_user_id].blank?
  end

  def current_user
    User.find(session[:current_user_id])
  end


end