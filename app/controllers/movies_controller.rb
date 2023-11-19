class MoviesController < ApplicationController
  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    if params[:remembered_ratings]
      pr = Hash[params[:remembered_ratings].map {|x| [x,1]}]
    else
      pr = params[:ratings]
    end
    @ratings_to_show = pr&.keys || @all_ratings
    if @ratings_to_show.present?
      @movies = Movie.with_ratings(@ratings_to_show).order(params[:sort_var])
    end
  end
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render render app/views/movies/show.html.haml by default
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
      redirect_to movies_path, :notice => "#{@movie.title} creada!"
    end
  end
  def edit
    @movie = Movie.find params[:id]
  end
  def update
    @movie = Movie.find params[:id]
    if @movie.update(movie_params)
      redirect_to movie_path(@movie), :notice => "#{@movie.title} updated."
    else
      flash[:alert] = "#{@movie.title} could not be updated: " +
        @movie.errors.full_messages.join(",")
      render 'edit'
    end
  end
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to movies_path, :notice => "#{@movie.title} deleted."
  end
  private
  def movie_params
    params.require(:movie)
    params[:movie].permit(:title,:rating,:release_date)
  end
  
end

