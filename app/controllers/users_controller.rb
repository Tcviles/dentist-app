class UsersController < ApplicationController

  DEVELOPERS = ["Thomas"]

  get '/user/:id' do
    if !logged_in?
      redirect to '/'
    else
      @user = User.find_by_id(session[:user_id])
      if !@user.insurance || !@user.dentist
        redirect to '/user/:id/edit'
      else
        erb :'users/show'
      end
    end
  end

  get '/user/:id/edit' do
    if !logged_in?
      redirect to '/'
    else
      @user = User.find_by_id(session[:user_id])
      erb :'users/update'
    end
  end

  patch '/user/:id' do
    @user = User.find_by_id(params[:id])
    @user.dentist = Dentist.find_by(:name => params[:dentist])
    @user.insurance = Insurance.find_by(:company => params[:insurance])
    @user.save
    redirect to "/user/:id"
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
    if params[:name] == "" || params[:email] == "" || params[:password] == ""
      redirect to '/signup'
    else
      @user = User.new(:name => params[:name], :email => params[:email], :password => params[:password])
      if !params[:insurance][:name].empty?
        binding.pry
        @user.insurance = Insurance.create(company: params[:insurance][:name], coverage:1000)
      else
        @user.insurance = Insurance.find_by_id(params[:user][:insurance_id])
      end

      if !params[:insurance][:name].empty?
        @user.dentist = Dentist.create(name: params[:dentist][:name], fee:2000)
      else
        @user.dentist = Dentist.find_by_id(params[:user][:dentist_id])
        binding.pry
      end
      @user.save
      session[:user_id] = @user.id
      session[:developer?] = true if DEVELOPERS.include?(@user.name)
      redirect to "/user/#{session[:user_id]}"
    end
  end

  get '/congrats' do
    erb :congrats
  end

  get '/real-suprise' do
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
      session[:developer?] = true if DEVELOPERS.include?(@user.name)
      redirect "/user/#{session[:user_id]}"
    else
      redirect to '/signup'
    end
  end

  get '/logout' do
    if logged_in?
      session.destroy
      redirect to '/'
    else
      redirect to '/'
    end
  end

  get '/user/:id/delete' do
    if session[:user_id] == params[:id]
      @user = Uer.find_by_id(params[:id])
      @user.delete
      redirect to '/'
    else
      redirect to '/'
    end
  end
end
