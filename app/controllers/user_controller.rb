get '/users/new' do
  erb :newUser
end

post '/users' do
  session.clear
  user = User.new(username: params[:username], email: params[:email], password: params[:password], phone: params[:phone_number])
  user.save
  portfolio = Portfolio.new(user_id: user.id, name: params[:portfolio])
  portfolio.save
  session[:current_user_id] = user.id
  session[:current_portfolio_id] = portfolio.id
  if user.persisted? && portfolio.persisted?
    redirect '/portfolio', notice: "Welcome, #{user.username} !"
  else
    redirect back, error: user.errors.full_messages.join(" | ") + (portfolio.persisted? ? "" : " | Portfolio name can't be blank")
  end
end

post '/users/login' do
  session.clear
  if user = User.find_by(username: params[:username])
    if user.password == params[:password]
      @user = user
      session[:current_user_id] = user.id
      session[:current_portfolio_id] = user.portfolios.last.id
      redirect '/portfolio', notice: "Welcome back, #{user.username} !"
    end
  end
  redirect back, error: "Invalid username or password"
end

get '/users/logout' do
  session.clear
  redirect '/'
end

