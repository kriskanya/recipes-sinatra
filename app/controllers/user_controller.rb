class UserController < ApplicationController

  get '/signup' do
    if !session[:id]
      erb :'/users/create_user'
    else
      redirect '/recipes'
    end
  end

  post '/signup' do
    if params[:username].empty? || params[:email].empty? || params[:password].empty?
      erb :'/users/create_user', locals: {message: 'All fields required.'}
    else
      @user = User.new(username: params[:username], email: params[:email], password: params[:password])
      @user.save
      session[:id] = @user.id

      redirect '/recipes'
    end
  end

  get '/login' do
    if !session[:id]
      erb :'/users/login'
    else
      redirect '/recipes'
    end
  end

  post '/login' do 
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:id] = user[:id]
      redirect '/tweets'
    else
      erb :'/users/login', locals: {message: "Incorrect Username/Password"} 
    end
  end

  get '/logout' do 
    if session[:id] != nil
      session.destroy
      redirect '/login'
    else
      redirect '/'
    end
  end

end