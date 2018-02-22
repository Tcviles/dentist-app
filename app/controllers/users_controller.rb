class UsersController < ApplicationController
  get '/user/:id' do
    if !logged_in?
      redirect to '/'
    else
      @user = User.find_by_id(session[:user_id])
      binding.pry
      erb :'users/show'
    end
  end

  get '/signup' do
    if !logged_in?
      @dentists = Dentist.all
      @insurances = Insurance.all
      erb :'users/create_user'
    else
      redirect to '/user/:id'
    end
  end

  post '/signup' do
    if params[:name] == "" || params[:email] == "" || params[:password] == ""
      redirect to '/signup'
    else
      @user = User.new(:name => params[:name], :email => params[:email], :password => params[:password])
      if params[:insurance][:name] == ""
        @user.insurance = Insurance.create(company: params[:insurance][:name], coverage:1000)
      else
        @user.insurance = Insurance.find_by_id(params[:user][:insurance_id])
      end

      if params[:insurance][:name] == ""
        @user.dentist = Dentist.create(name: params[:dentist][:name], fee:2000)
      else
        @user.dentist = Dentist.find_by_id(params[:user][:dentist_id])
      end
      @user.save
      session[:user_id] = @user.id
      session[:developer?] = true if @user.name=="Thomas"
      redirect to "/user/#{session[:user_id]}"
    end
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
      session[:developer?] = true if @user.name == "Thomas"
      redirect "/user/#{session[:user_id]}"
    else
      redirect to '/signup'
    end
  end

  get '/logout' do
    if logged_in?
      session.destroy
      redirect to '/login'
    else
      redirect to '/'
    end
  end
end
