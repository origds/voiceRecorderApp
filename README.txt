  Para el desarrollo de VoiceRecorderApp se utilizó como librería externa IQAudioRecorderController que permitió personalizar la interfaz de grabación, así como herramientas de edición para cada una de estas. Su instalación se realizó a través de Pods. 

  El almacenaje de datos se implementó usando CoreData el diseño de una clase Voicenote que permite asociar cada audio con el nombre que el usuario quiera darle. Por defecto se guardan con un nombre genérico y es el usuario quien decide si renombrarlas o no.

  La estructura del proyecto es bastante sencilla, se utilizó un único view controller (el inicial) donde se muestra tanto la lista de grabaciones como el botón que permite grabar nuevos audios. Cuenta con los archivos que definen el funcionamiento de la tabla: datasource y diseño de las celdas y finalmente con los archivos de definición del modelo de CoreData.

  La interfaz se trabajó haciendo uso del Storyboard.
