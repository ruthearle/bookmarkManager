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
    user.password_token = (1..64).map{('A'..'Z').to_a.sample}.join
    user.password_token_timestamp = Time.now
    user.save
    flash[:notice] = "Please check your email"
    redirect('/')
  else
    flash[:notice] = "Incorrect email address!"
    redirect('/users/forgot_password')
  end
end