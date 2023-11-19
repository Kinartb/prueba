 
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
    redirect = false

    if params[:sort]
      @sorting = params[:sort]
    elsif session[:sort]
      @sorting = session[:sort]
      redirect = true
    end

    if params[:ratings]
      @ratings = params[:ratings]
    elsif session[:ratings]
      @ratings = session[:ratings]
      redirect = true
    else
      @ratings = Hash[@all_ratings.map { |rat| [rat, 1] }]
      redirect = true
    end

    redirect_to movies_path(sort: @sorting, ratings: @ratings) and return if redirect

    @movies = Movie.where(rating: @ratings.keys).order(@sorting ? @sorting : :id).all

    session[:sort] = @sorting
    session[:ratings] = @ratings
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
    params.require(:movie).permit(:title, :rating, :release_date, :otros_parametros, ratings: [])
  end
end
