# Rails-Avanzado

## Vistas parciales
Para evitar el uso de código repetitivo, Rails nos permite usar vistas parciales: fragmentos de vista que una o más vistas pueden implementar. A continuación se muestra la vista `index.html.haml` que implementa la vista parcial `layouts/_movies_form.html.haml` para mostrar cada fila de la tabla de películas.

## Validaciones
Empleamos validaciones cuando queremos forzar que los modelos a ser guardados en nuestra base de datos tengan ciertas características deseadas, como por ejemplo, la obligatoriedad de un correo electrónico o nombre de usuario. Rails nos proporciona validaciones predefinidas, así como la posibilidad de crear nuestras propias validaciones personalizadas.

## Filtros
Los filtor son métodos que se ejecutan antes o después de una acción de controlador, normalmente para verificar ciertas condiciones que consideremos necesarias para la correcta ejecución del controlador. En caso estas condiciones no sean cumplidas, el método filtro puede decidir renderizar una vista, redirigir a otra acción de controlador, etc.

## SSO y Autenticación a través de terceros

## Asociaciones y claves foráneas

## Asociaciones indirectas
