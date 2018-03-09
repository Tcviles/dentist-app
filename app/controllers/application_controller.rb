require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "super_secret"
  end

  get '/' do
    erb :index
  end

  helpers do
    def logged_in?
      !!current_user
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end

    def any_params_blank?(params)
      params[:name] == "" || params[:email] == "" || params[:password] == "" || params[:name].nil? || params[:email].nil? || params[:password].nil?
    end

    def make_new_user(params)
      @user = User.new(:name => params[:name], :email => params[:email], :password => params[:password])

      if !params[:insurance][:name].empty?
        @user.insurance = Insurance.create(company: params[:insurance][:name], coverage:1000)
      else
        @user.insurance = Insurance.find_by_id(params[:user][:insurance_id])
      end

      if !params[:dentist][:name].empty?
        @user.dentist = Dentist.create(name: params[:dentist][:name], fee:2000)
      else
        @user.dentist = Dentist.find_by_id(params[:user][:dentist_id])
      end

      @user.save
      @user
    end
  end
end
