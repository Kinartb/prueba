 
class MoviesController < ApplicationController
  def initialize
    @all_ratings = Movie.all_ratings
    super
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render render app/views/movies/show.html.haml by default
  end

  def index

    # Si se accedio por los links para ordenar la tabla
    if params[:sort]
      @sorting = params[:sort]
    
    # Si se accedio desde otro lado
    elsif session[:sort]
      @sorting = session[:sort]
    end

    # Si se accedio por los links para ordenar tabla
    if params[:key_ratings]
      @ratings_to_show = params[:key_ratings]
    
    # Si se accedio por el boton "Refresh" para clasificar ratings
    elsif params[:commit]
      @ratings_to_show = params[:ratings]&.keys || @all_ratings

    # Si se accedio por otro lado
    elsif session[:key_ratings]
      @ratings_to_show = session[:key_ratings]
    
    else
      @ratings_to_show = @all_ratings
    end



    @movies = Movie.with_ratings(@ratings_to_show).order(@sorting ? @sorting : :id)

    # Se guardan las configuraciones en la sesion
    session[:sort] = @sorting
    session[:key_ratings] = @ratings_to_show
  end

  def new
    @movie = Movie.new
  end

  def create
    begin
      @movie = Movie.create!(movie_params)
    rescue ActiveRecord::ActiveRecordError => e
      flash[:alert] = "La pelicula no pudo ser creada :(\n" + e.message
      render 'new'
    else
      redirect_to movies_path, notice: "#{@movie.title} creada!"
    end
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def update
    @movie = Movie.find(params[:id])
    if @movie.update(movie_params)
      redirect_to movie_path(@movie), notice: "#{@movie.title} updated."
    else
      flash[:alert] = "#{@movie.title} could not be updated: " + @movie.errors.full_messages.join(",")
      render 'edit'
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to movies_path, notice: "#{@movie.title} deleted."
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :rating, :release_date, :otros_parametros, :rem_ratings, :sort)
  end
end
