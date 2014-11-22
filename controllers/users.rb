get '/users/new' do
  @user = User.new
  erb :"users/new"
end

post '/users' do
  @user = User.create(:email                => params[:email],
                     :password              => params[:password],
                     :password_confirmation => params[:password_confirmation])
  if @user.save
    session[:user_id] = @user.id
    redirect to('/')
  else
    flash.now[:errors] = @user.errors.full_messages
    erb :"users/new"
  end
end

get '/users/forgot_password' do
  erb :'users/forgot_password'
end

post '/users/forgot_password' do
  user = User.first(email: params[:email])
  if user.class == User
    user.password_token           = (1..64).map{('A'..'Z').to_a.sample}.join
    user.password_token_timestamp = Time.now
    user.save
    send_password_token(user.email, user.password_token)
    flash[:notice] = "Please check your email"
    redirect('/')
  else
    flash[:errors] = ["Incorrect email address!"]
    redirect('/users/forgot_password')
  end
end

get '/users/reset_password/:token' do
  @user = User.first(password_token: params[:token])
  if (Time.now  - @user.password_token_timestamp) > 3600
    flash[:errors] = ["This link has expired."]
    redirect '/users/forgot_password'
  else
    erb :'/users/new_password'
  end
end

post '/users/new_password' do
  user = User.first(password_token: params[:token])
  if (Time.now  - user.password_token_timestamp) > 3600
    flash[:errors] = ["This link has expired."]
    redirect '/users/forgot_password'
  else
    user.update(password: params[:password],
                password_confirmation: params[:password_confirmation],
                password_token: nil,
                password_token_timestamp: nil)
    if user.save
      flash[:notice] = 'Your password has been reset.'
      redirect('/sessions/new')
    else
      flash.now[:errors] = user.errors.full_messages
    end
  end
end

