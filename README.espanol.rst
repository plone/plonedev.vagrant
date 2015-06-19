PloneDev.Vagrant
================

PloneDev.Vagrant es un conjunto de herramientas para instalar fácilmente un entorno de desarrollo para Plone, dentro de una máquina virtual.

Estas herramientas usan VirtualBox como plataforma de virtualización y el sistema Vagrant para adecuar toda la configuración de la máquina virtualizada. Debería correr en cualquier máquina para la cual esté disponible Vagrant; incluyendo Windows Vista o superior, OS X y Linux.

Ambos, VirtualBox y Vagrant son software de código abierto.

Las herramientas de PloneDev.Vagrant están diseñadas para ser fácil de instalar y utilizar.

Los archivos principales para el desarrollo de Plone se instalan para ser fácilmente accesibles y modificables con editores que corren dentro en la máquina principal.
También se proveen comandos para correr Plone y *buildout* desde la máquina principal.
De esta manera no se requiere practicamente nada de conocimiento de la plataforma de desarrollo de la máquina virtual (que es Ubuntu Linux).

Instalación
------------

1. Instale VirtualBox: https://www.virtualbox.org

2. Instale Vagrant: http://www.vagrantup.com

3. Si usted usa Windows, instale el conjunto de herramientas *Putty ssh*: http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html. Instale todos los binarios, o al menos putty.exe y plink.exe.

4. Descargue y descomprima PloneDev-Vagrant https://github.com/plone/plonedev.vagrant/archive/master.zip.

5. Abra una cónsola de comandos; cambie el directorio al directorio *plonedev.vagrant-master*. Ejecute el comando "vagrant up".

6. Ahora vaya por su almuerzo o tómese un descanso tomando un café. El comando "vagrant up" descargará de la red el conjunto de herramientas (a menos que ya las haya instalado antes), descargará Plone, instalará Plone y configurará algunos *scripts* convenientes para hacer más sencillas ciertas tareas. En Windows, también generará un par de llaves ssh que serán usadas por Putty.

7. Verifique si la instalación se ejecutó adecuadamente. Lo último que debería verse en la ventana de comandos debería ser un mensaje de éxito, proveniente del *Plone Unified Installer*. En este punto la máquina virtual debería estar ejecutándose.

Mientras se ejecuta "vagrant up", puede ignorar mensajes como "stdin: is not a tty" and "warning: Could not retrieve fact fqdn". En este contexto, no tienen ningún significado relevante.


Problemas frecuentes
~~~~~~~~~~~~~~~

  "Vagrant ha detectado que usted tiene una versión de VirtualBox que
  no esta soportada. Por favor instale una de las versiones soportadas
  listadas aquí que son compatibles con Vagrant: 4.0, 4.1, 4.2"

Usted podría obtener un mensaje como este en versiones viejas de Vagrant, actualice Vagrant a la versión 1.2.2 para evitar este problema. https://github.com/mitchellh/vagrant/issues/1856

Usando la máquina virtual instalada por Vagrant
--------------------------------------

Usted puede 'iniciar' (start) o 'parar' (stop) usando los siguientes comandos en el mismo directorio *plonedev.vagrant-master*::

    c:\...> vagrant suspend

este comando para la ejecución de la máquina virtual, salvando una imagen de su estado actual para qu luego pueda ser reiniciada con el comando::

    c:\...> vagrant resume

Ejecute "vagrant" sin argumentos en la línea de comando para ver los argumentos y funciones disponibles.

Finalmente, si lo desea puede remover la máquina virtual (perdiendo todo su contenido) con el comando::

    c:\...> vagrant destroy

Ejecutando Plone y buildout
--------------------------

Para ejecutar *buildout*, solo escriba el comando "buildout" (buildout.sh si es un entorno tipo-Unix). Esta sentencia ejecutará la utilidad *buildout*; añada los argumentos deseados en la línea de comandos, según sea necesario, por ejemplo::

    c:\...> buildout -c develop.cfg

Para iniciar *Plone* como un proceso en el *foreground* (de modo que los mensajes se ven en la línea de comandos), use el comando::

    c:\...> plonectl fg

Plone estará disponible en el puerto 8080 de la máquina principal, de esta manera será posible que usted use un navegador y al apuntarlo a la dirección: http://localhost:8080 debería ser posible ver la interfaz de Zope/Plone invitándolo a crear un website

Plone está instalado con un usuario administrador con el login: "admin" y password "admin".

Usted puede interrumpir la ejecución de *Plone* usando el botón de *stop* en la sección de mantenimiento de sitios, o con presionar Ctrl-C en la ventana de comandos.

Si usted usa Ctrl-C, tendrá que limpiar algunas cosas. Plone aún estará corriendo en la máquina virtual. Tendrá que matar el proceso ejecutando el comando::

    c:\...> kill_plone

Usted también puede usar los parámetros start|stop|status|run con el comando *plonectl*.


Editando la configuración de Plone y los archivos de código fuente
--------------------------------------------

Después de ejecutar "vagrant up", usted debería tener un sub-directorio *Plone*. En el, deberá conseguir los archivos de configuración del *buildout* y un directorio *src*. Estos son los elementos esenciales para una instalación normal de *Plone*. Usted puede agregar paquetes de desarrollo al directorio *src* y editar todos los archivos necesarios.

Todo esto sucede en un directorio que está compartido con el sistema de operativo de la máquina virtual, y los archivos .cfg y el directorio *src* está enlazado a la copia funcional de archivos de *Plone* en la máquina virtual.


Usando la máquina virtual directamente
-----------------------------

El método para obtener una interfaz de comandos en su máquina virtual dependerá del sistema operativo de su máquina principal. En sistemas Unix o semejantes (como Linux), use el comando::

    $ vagrant ssh

Si su sistema operativo principal es Windows, use::

    c:\...> putty_ssh

El comando "putty_ssh" ejecuta el programa Putty SSH usando parámetros que lo conectan a la máquina virtual a través del puerto 2222 y usa una llave ssh especial creada para *putty*. Esa llave, por cierto, es creada y almacenada en un modo que no está protegido por contraseña, por lo tanto no puede considerarse como "adecuadamente seguro" para ningún propósito crítico.

Para los usuarios Windows, también hay un 'wrapper' conveniente alrededor de la utilidad *pscp* la versión de *putty* para hacer copias seguras de archivos a través de la red. Para copiar de la máquina principal a la máquina virtual puede usar::


    c:\...> putty_scp myfile.cfg vagrant@localhost:.

O, de la máquina virtual a la máquina principal::

    c:\...> putty_scp -r vagrant@localhost:Plone/zinstance/var .

La cadena "vagrant@localhost:" especifica el usuario 'vagrant' en la máquina virtual.

Ejecutando mr.bob
----------------

El truco de plonedev.vagrant para hacer los archivos fuentes modificables desde la máquina principal plantea un problema cuando se trata de ejecutar *mr.bob*. Normalmente, para ejecutar *mr.bob* y crear un nuevo paquete, se haría lo siguiente::

    c:\...> putty_ssh (o "vagrant ssh" en una máquina Linux/BSD/OSX)
    vagrant@...: cd Plone/zinstance/src
    vagrant@...: ../bin/mrbob -O my.newpackage bobtemplates:plone_addon

Sin embargo, "../bin/mrbob" no va a funcionar en este contexto porque el archivo *src* se encuentra en otra ubicación (enlazado simbólicamente hacia el *buildout*).

Así que, plonedev.vagrant establece un *alias* de *shell* para *mrbob*, que lo ejecuta desde ~/Plone/zinstance/bin/mrbob. Así, en vez de "../bin/mrbob", sólo use "mrbob"::

    vagrant@...: mrbob -O my.newpackage bobtemplates:plone_addon

Lo que no funciona
-----------------

Usar "plonectl debug" desde la máquina principal tampoco va a funcionar. Sin embargo, usted puede usar una línea de comando a través de ssh para obtener un *shell* dentro de la máquina virtual y ejecutarlo desde allí. Solo necesitará saber un poco sobre como usar la línea de comandos de *bash* en *Linux*.

Lo mismo es válido para ejecutar *mr.bob* para generar el esqueleto de paquete, o para hacer cualquier otra cosa que requiera interacción en la línea de comandos.

¿Una versión diferente de Plone o de Linux?
--------------------------------------

¿Desea instalar una versión diferente de Plone? Solo edite el archivo Vagrantfile para especificar una URL distinta en el *Unified Installer*. haga este cambio antes de ejecutar "vagrant up" por primera vez. Podría hacer lo mismo para especificar una máquina virtual distinta.

¿Qué hay debajo de todo esto?
---------------------

VirtualBox provee la infraestructura de máquina virtual. Vagrant se encarga convenientemente de la configuración, incluyendo el *port forwarding* y carpetas compartidas. Vagrant también hace de *wrapper* alrededor de Puppet y el sistema de aprovisionamiento del *shell*.

El sistema operativo de la máquina virtual es el Ubuntu LTS más reciente (12.0.4, Precise Pangolin), 32-bit (de manera que funcionará en una máquina de arquitectura 32-bit o 64-bit).

Después de configurar el sistema operativo, el sistema de aprovisionamiento de Vagrant se usa para cargar los paquetes requeridos, descargar el *Plone Unified Installer*, ejecutar la instalación y configurar los scripts de utilerías y la carpeta compartida.

¿Problemas o sugerencias?
------------------------

Abra un ticket en http://dev.plone.org . Asegúrese de mencionar el componente *plonedev.vagrant* y por favor escriba en Inglés, esta documentación en español ha sido publicada para mejor difusión, pero el idioma oficial del proyecto es Inglés.

Steve McMahon, steve@dcn.org
Traducido por: Carlos Maldonado cmaldonado@covetel.com.ve

Licencia
-------

El código incluído con estas herramientas está bajo la licencia MIT http://opensource.org/licenses/MIT . La documentación es CC Attribution Unported, http://creativecommons.org/licenses/by/3.0/ .
