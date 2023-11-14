# Rails-Avanzado

## Vistas parciales
Para evitar el uso de código repetitivo, Rails nos permite usar vistas parciales: fragmentos de vista que una o más vistas pueden implementar. A continuación se muestra la vista `index.html.haml` que implementa la vista parcial `layouts/_movies_form.html.haml` para mostrar cada fila de la tabla de películas.

## Validaciones
Empleamos validaciones cuando queremos forzar que los modelos a ser guardados en nuestra base de datos tengan ciertas características deseadas, como por ejemplo, la obligatoriedad de un correo electrónico o nombre de usuario. Rails nos proporciona validaciones predefinidas, así como la posibilidad de crear nuestras propias validaciones personalizadas.
Las validaciones mostradas a continuación verifican la presencia de un título y fecha de estreno no nulos, que la fecha de estreno sea posterior a 1930, y que el rating sea uno de los definidos anteriormente (Estas dos últimas validaciones siendo realizadas por métodos personalizados).

## Filtros
Los filtor son métodos que se ejecutan antes o después de una acción de controlador, normalmente para verificar ciertas condiciones que consideremos necesarias para la correcta ejecución del controlador. En caso estas condiciones no sean cumplidas, el método filtro puede decidir renderizar una vista, redirigir a otra acción de controlador, etc. Un uso frecuente de estos filtros es condicionar ciertas acciones a que el usuario haya iniciado sesión.

## SSO y Autenticación a través de terceros
Una manera sencilla de ahorrar esfuerzo es, en lugar de crear desde cero un sistema propio de autenticación, utilizar uno de estos servicios de un tercero, como puede ser Google, Facebook, Twitter, etc.

## Asociaciones y claves foráneas


## Asociaciones indirectas
