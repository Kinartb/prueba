class SessionsController < ApplicationController
  # login & logout actions should not require user to be logged in
  skip_before_action :set_current_user  # check you version
  def create
    begin
      @user = Moviegoer.from_omniauth(request.env['omniauth.auth'])
      session[:user_id] = @user.id
      flash[:success] = "Bienvenido, #{@user.name}!"
    rescue => error
      flash[:warning] = error.message
    end
    redirect_to root_path
  end

  def destroy
    reset_session
    flash[:notice] = 'Se cerró la sesión correctamente!'
    redirect_to movies_path
  end
end
