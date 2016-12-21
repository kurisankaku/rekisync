# Admin constraint for sidekiq module of ruotes.rb.
class AdminConstraint
  def matches?(request)
    return false unless request.session[:user_id]
    user = User.find request.session[:user_id]
    !!user
  end
end
