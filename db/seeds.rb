# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# Seed the RottenPotatoes DB with some movies.

more_movies = [
  {:title => 'Aladdin', :rating => 'G', :release_date => '25-Nov-1992'},
  {:title => 'When Harry Met Sally', :rating => 'R', :release_date => '21-Jul-1989'},
  {:title => 'The Help', :rating => 'PG-13', :release_date => '10-Aug-2011'},
  {:title => 'Raiders of the Lost Ark', :rating => 'PG', :release_date => '12-Jun-1981'},
  {:title => 'The Dark Knight', :rating => 'PG-13', :release_date => '18-Jul-2008'},
  {:title => 'Inception', :rating => 'PG-13', :release_date => '16-Jul-2010'},
  {:title => 'Forrest Gump', :rating => 'PG-13', :release_date => '6-Jul-1994'},
  {:title => 'The Shawshank Redemption', :rating => 'R', :release_date => '23-Sep-1994'},
  {:title => 'The Matrix', :rating => 'R', :release_date => '31-Mar-1999'},
  {:title => 'Jurassic Park', :rating => 'PG-13', :release_date => '11-Jun-1993'},
  {:title => 'Pulp Fiction', :rating => 'R', :release_date => '14-Oct-1994'},
  {:title => 'The Godfather', :rating => 'R', :release_date => '24-Mar-1972'},
  {:title => 'The Shawshank Redemption', :rating => 'R', :release_date => '23-Sep-1994'},
  {:title => 'Fight Club', :rating => 'R', :release_date => '15-Oct-1999'},
  {:title => 'The Silence of the Lambs', :rating => 'R', :release_date => '14-Feb-1991'},
  {:title => 'Schindler\'s List', :rating => 'R', :release_date => '4-Feb-1994'},
  {:title => 'The Lion King', :rating => 'G', :release_date => '24-Jun-1994'},
  {:title => 'Gladiator', :rating => 'R', :release_date => '5-May-2000'},
  {:title => 'The Great Gatsby', :rating => 'PG-13', :release_date => '10-May-2013'}
]

more_movies.each do |movie|
  Movie.create(movie)
end
