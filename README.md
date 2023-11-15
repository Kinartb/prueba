# Rails-Avanzado

## Vistas parciales
Para evitar el uso de código repetitivo, Rails nos permite usar vistas parciales: fragmentos de vista que una o más vistas pueden implementar. A continuación se muestra la vista `index.html.haml` que implementa la vista parcial `layouts/_movies_form.html.haml` para mostrar cada fila de la tabla de películas.

## Validaciones
Empleamos validaciones cuando queremos forzar que los modelos a ser guardados en nuestra base de datos tengan ciertas características deseadas, como por ejemplo, la obligatoriedad de un correo electrónico o nombre de usuario. Rails nos proporciona validaciones predefinidas, así como la posibilidad de crear nuestras propias validaciones personalizadas.
Las validaciones mostradas a continuación verifican la presencia de un título y fecha de estreno no nulos, que la fecha de estreno sea posterior a 1930, y que el rating sea uno de los definidos anteriormente (Estas dos últimas validaciones siendo realizadas por métodos personalizados).

## Filtros
Los filtor son métodos que se ejecutan antes o después de una acción de controlador, normalmente para verificar ciertas condiciones que consideremos necesarias para la correcta ejecución del controlador. En caso estas condiciones no sean cumplidas, el método filtro puede decidir renderizar una vista, redirigir a otra acción de controlador, etc. Un uso frecuente de estos filtros es condicionar ciertas acciones a que el usuario haya iniciado sesión.

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

## Asociaciones y claves foráneas


## Asociaciones indirectas
