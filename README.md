# Rails-Avanzado

## Vistas parciales
Para evitar el uso de código repetitivo, Rails nos permite usar vistas parciales: fragmentos de vista que una o más vistas pueden implementar. A continuación se muestra la vista `index.html.haml` que implementa la vista parcial `layouts/_movies_form.html.haml` para mostrar cada fila de la tabla de películas.

```ruby
# index.html.haml
%h1 All Movies

%table#movies
  %thead
    %tr
      %th Movie Title
      %th Rating
      %th Release Date
      %th More Info
  %tbody
    # Renderiza la vista parcial por cada fila de la tabla Movies
    - @movies.each do |movie|
      .content
        = render partial: 'layouts/movies_form', locals: {movie: movie}
```

```ruby
# _movies_form.html.haml
# Representa una fila de la tabla Movies
%tr
    %td= movie.title
    %td= movie.rating
    %td= movie.release_date
    %td= link_to "More about #{movie.title}", movie_path(movie)
```

## Validaciones
Empleamos validaciones cuando queremos forzar que los modelos a ser guardados en nuestra base de datos tengan ciertas características deseadas, como por ejemplo, la obligatoriedad de un correo electrónico o nombre de usuario. Rails nos proporciona validaciones predefinidas, así como la posibilidad de crear nuestras propias validaciones personalizadas.
Las validaciones mostradas a continuación verifican la presencia de un título y fecha de estreno no nulos, que la fecha de estreno sea posterior a 1930, y que el rating sea uno de los definidos anteriormente (Estas dos últimas validaciones siendo realizadas por métodos personalizados).

```ruby
# movie.rb
class Movie < ActiveRecord::Base
    begin
        # Define que valores puede tomar ratings
        def self.all_ratings ; %w[G PG PG-13 R NC-17] ; end
        
        # Valida que el titulo y el release_date sean no nulo
        validates :title, :presence => true
        validates :release_date, :presence => true

        # Usa validador personalizado para que release_date sea despues de 1930
        validate :released_1930_or_later

        # Valida que rating este incluido en el array anteriormente definido
        validates :rating, :inclusion => {:in => Movie.all_ratings},
            :unless => :grandfathered?

        # Se define el validadores personalizado
        def released_1930_or_later
            errors.add(:release_date, 'must be 1930 or later') if
            release_date && release_date < Date.parse('1 Jan 1930')
        end
        @@grandfathered_date = Date.parse('1 Nov 1968')
        def grandfathered?
            release_date && release_date < @@grandfathered_date
        end
    end
end
```

## Filtros
Los filtor son métodos que se ejecutan antes o después de una acción de controlador, normalmente para verificar ciertas condiciones que consideremos necesarias para la correcta ejecución del controlador. En caso estas condiciones no sean cumplidas, el método filtro puede decidir renderizar una vista, redirigir a otra acción de controlador, etc. Un uso frecuente de estos filtros es condicionar ciertas acciones a que el usuario haya iniciado sesión.

```ruby
# application_controller.rb
class ApplicationController < ActionController::Base
    # Especifica un método a ejecutarse antes de ejecutar la accion del controlador
    before_action :set_current_user 
    protected
    # Define el método filtro
    def set_current_user
        @current_user ||= Moviegoer.where(:id => session[:user_id])
        redirect_to login_path and return unless @current_user
    end
end
```

## SSO y Autenticación a través de terceros
Una manera sencilla de ahorrar esfuerzo es, en lugar de crear desde cero un sistema propio de autenticación, utilizar uno de estos servicios de un tercero, como puede ser Google, Facebook, Twitter, etc. Para este ejemplo se utilizó como proveedor a Google, instalando las gemas:

```ruby
gem 'omniauth'
gem "omniauth-rails_csrf_protection"
gem "omniauth-google-oauth2"
```

Se creó un archivo `config/initializers/omniauth.rb` que contiene las claves `GOOGLE_CLIENT_ID` y `GOOGLE_CLIENT_SECRET`, proporcionadas por la plataforma Google Cloud. Se agregaron rutas para el inicio de sesión en `routes.rb`:

```ruby
Myrottenpotatoes::Application.routes.draw do
  # [...]
  get  'auth/:provider/callback' => 'sessions#create'
  get '/sessions/logout' => 'sessions#destroy'
  # [...]
end
```

Además, se crea un controlador Sessions que se encargará de iniciar y terminar la sesión, localizando al Moviegoer que corresponde a las credenciales de inicio de sesión, o en caso no exista creándolo mediante un método de la clase Moviegoer.

```ruby
class SessionsController < ApplicationController
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
```

```ruby
class Moviegoer < ActiveRecord::Base
    class << self
        def from_omniauth(auth_hash)
          user = find_or_create_by(uid: auth_hash['uid'], provider: auth_hash['provider'])
          user.name = auth_hash['info']['name']
          user.save!
          user
        end
      end
end
```

Luego, agregamos a las vistas necesarias (en este caso Index) un link para iniciar sesion con Google:

![](/imgs/Login_Show.png)

Al presionar el link, nos redigirirá al servicio de autenticación de Google.

![](/imgs/Login_Google_Screen.png)

Despues de iniciar sesión, el controlador de sesión se encargará de leer los datos del Log In y se los pasará al método `from_omniauth` de `Moviegoers`, que localizará al usuario loggeado en la base de datos o en caso no encontrarlo lo creará. Ahora, con estos datos ya leídos y almacenados, podemos mostrar un saludo al usuario loggeado:

![](/imgs/Login_Succesful.png)

Además, agregamos el link a hacer Log Out si detectamos que existe una sesión activa, como es el caso actual:

![](/imgs/LogOut.png)

## Asociaciones
Rails nos permite definir las asociaciones entre nuestros modelos (uno a muchos, muchos a muchos, uno a uno) y además nos proporciona una sintaxis muy legible para trabajar con estas. En el caso de una relacion uno-a-muchos basta con colocar las palabras clave `has_many` y `belongs_to` seguido del nombre del modelo para establecer una asociacion de este tipo entre dos modelos. Además se pueden agregar parámetros como `:dependent => :destroy` que nos ayudará al momento de eliminar un modelo a eliminar el resto de modelos relacionados. 

Una vez creadas las reviews `Alice_review` (potatoes = 5) y `Bob_review` (potatoes = 2), las podemos asociar mediante la consola de Rails a la pelicula `Aladdin` (Movie) y a sus respectivos criticos `Alice` y `Bob` (Moviegoers) mediante:

```
Aladdin.reviews = [Alice_review, Bob_review]
Alice.reviews << Alice_review
Bob.reviews << Bob_review
```

Podemos verificar que se asociaron correctamente mediante la consola de Rails:

![](/imgs/association_done.png)

Si al modelo `movie.rb` agregamos el parámetro `:dependent => :destroy` a su asociación con reviews, entonces al momento de eliminar una película de la BD se eliminarán tambien todas sus reviews asociadas. Podemos confirmar este comportamiento mediante la consola de Rails:

![](/imgs/dependent_destroy.png)

Podemos observar que se eliminaron ambas reviews asociadas a la película.
