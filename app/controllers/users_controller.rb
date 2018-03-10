class UsersController < ApplicationController

  DEVELOPERS = [1]

  get '/user/:id' do
    if !logged_in?
      redirect to '/'
    else
      @user = User.find_by_id(session[:user_id])
      if !@user.insurance || !@user.dentist
        redirect to "/user/#{session[:user_id]}/edit"
      else
        erb :'users/show'
      end
    end
  end

  get '/user/:id/edit' do
    if !logged_in?
      redirect to '/'
    else
      @dentists = Dentist.all
      @insurances = Insurance.all
      @user = User.find_by_id(session[:user_id])
      erb :'users/update'
    end
  end

  patch '/user/:id' do
    @user = User.find_by_id(params[:id])
    @user.dentist = Dentist.find_by(:name => params[:dentist])
    @user.insurance = Insurance.find_by(:company => params[:insurance])
    @user.save
    redirect to "/user/#{session[:user_id]}"
  end

  get '/signup' do
    if !logged_in?
      @dentists = Dentist.all
      @insurances = Insurance.all
      erb :'users/create_user'
    else
      redirect to "/user/#{session[:user_id]}"
    end
  end

  post '/signup' do
    @user = make_new_user(params)
    if @user.id.nil?
      @errors = @user.errors
      redirect to '/signup'
    else
      session[:user_id] = @user.id
      session[:developer?] = true if DEVELOPERS.include?(@user.id)
      redirect to "/user/#{session[:user_id]}"
    end
  end

  get '/congrats' do
    erb :suprise
  end

  get '/login' do
    if !logged_in?
      erb :'users/login'
    else
      redirect "/user/#{session[:user_id]}"
    end
  end

  post '/login' do
    @user = User.find_by(:email => params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      session[:developer?] = true if DEVELOPERS.include?(@user.id)
      redirect "/user/#{session[:user_id]}"
    else
      redirect to '/login'
    end
  end

  get '/logout' do
    if logged_in?
      session.destroy
    end
    redirect to '/'
  end

  get '/user/:id/delete' do
    if session[:user_id] == params[:id].to_i
      @user = User.find_by_id(params[:id])
      @user.delete
    end
    redirect to '/'
  end
end
