---
layout: post
title:  "Algoritmos de administracion en Codigo Fuente De Android"
date:   2022-03-30 07:19:16 +0000
categories: algoritmos android
---

**Palabras Claves:** Sistema Android, administración de memoria, paginación, planificadores, Android Runtime, Dalvik, Hardware Abstraction Layer, Rounn Robin,  Kernel Linux, Google.

<p style="text-align:justify;"><b>Abstracto:</b> En la actualidad por mucho Android es el Sistema Operativo más utilizado alrededor del mundo. Esto en parte debido a que el código fuente para compilar el Sistema Android es Open Source, por tanto cada día surgen nuevas mejoras, versiones y aplicaciones implementadas por ingenieros expertos en sistemas informáticos y embebidos. En promedio cada año el equipo de Google lanza una nueva versión de Android más potente y con nuevas características que sus antecesores. A donde sea que vayamos encontramos dispositivos Android, esto no es casualidad, su agradable interfaz de usuario, variabilidad de dispositivos con precios y especificaciones para todas la clases junto a la diversidad  de aplicaciones juegan un papel importante en el éxito de aceptación por los consumidores. Sin mencionar que el sistema al estar basado en el kernel de linux permite su arranque en todo tipo de dispositivos y no solamente en dispositivos móviles en comparación a sus competidores. Sin embargo más allá de lo estético existen implementaciones lógicas  que hoy en día han transformado al Sistema Android como tal en un sistema potente y complejo que muchas veces como usuarios tendemos a ignorar. Estas implementaciones distribuidas por toda la arquitectura Android juega también un papel importante en el éxito de aceptación del sistema por los consumidores. Teniendo en cuenta que alrededor de las cuatro capas principales de la arquitectura del Sistema Android existen un número increíble de programas, algoritmos, subsistemas, librerías, hardware, drivers, servicios de sistema y servicios Android que contribuyen al óptimo rendimiento de las nuevas versiones. En el presente artículo se realiza un estudio de implementaciones alrededor del sistema Android con un enfoque en la administración de memoria, planificación y ejecución de procesos.
</p>
<p style="text-align:justify;"><b>Abstract:</b> At present, Android is by far the most used Operating System around the world. This is partly due to the fact that the source code to compile the Android System is Open Source, so every day there are new improvements, versions and applications implemented by expert engineers in computer and embedded systems. On average, every year the Google team launches a new version of Android that is more powerful and has new features than its predecessors. Wherever we go we find Android devices, this is no coincidence, its pleasant user interface, will buy devices with prices and specifications for all classes along with the diversity of applications play an important role in the success of acceptance by consumers. Not to mention that the system, being based on the linux kernel, allows it to boot on all types of devices and not only on mobile devices compared to its competitors. However, beyond the aesthetic, there are logical implementations that today have transformed the Android System as such into a powerful and complex system that many times as users we tend to ignore. These successful implementations distributed throughout the Android architecture also play an important role in the acceptance of the system by consumers. Taking into account that around the four main layers of the Android System architecture there are an incredible number of programs, algorithms, subsystems, libraries, hardware, drivers, system services and Android services that contribute to the optimal performance of the new versions. In this article, a study of implementations around the Android system is carried out with a focus on memory management, planning and execution of processes.
</p>
<br><br>

<h2 style="text-align:center;">INTRODUCCION</h2>
<p style="text-align:justify;">Se podría decir que el Sistema Operativo Android está dividido en cuatro capas cada una basada en la capa de abajo de su posición. La primera capa es el Hardware, este es el dispositivo físico como tal, es decir, una pieza de metal que se puede sostener en la mano. En la siguiente capa se encuentra el Kernel de Linux el cual es un programa que se encarga de crear entorno de memoria y procesos en los cuales son ejecutadas todas las aplicaciones. Luego siguen las Librerías del Sistema, las cuales son librerías de programas, frecuentemente suministradas como binarios por proveedores de terceros que implementan servicios utilizados por múltiples aplicaciones. Por último se encuentra la capa de Aplicaciones y servicios de sistema. Las aplicaciones utilizan los entornos proveídos por las capas inferiores para realizar trabajo útil para el usuario. En donde un conjunto de aplicaciones de larga ejecución llamados Daemons, realizan tareas periódicas y administran el estado del sistema. El kernel de Android es una variable del kernel de Linux. El kernel es la capa de portabilidad principal del Sistema Android. Mucha de la programación en Android está hecha en el lenguaje de programación de Java. Sin embargo el código fuente de Java es compilado en instrucciones para Dalvik y ART, no para instrucciones de la máquina virtual de Java (JVM). El propósito de la máquina virtual de Android es la de hacer aplicaciones portables a través de dispositivos Android. Muchas aplicaciones, bibliotecas y utilidades existentes se pueden usar en Android siempre que sean recopiladas sobre la plataforma Android. Una de las librerías de Sistema que son parte del sistema Android Estándar es Bionic. Bionic es un equivalente en Android a las librerías estándar de C. Los servicios del sistema son aplicaciones especiales, que mantienen varios subsistemas indexados para la búsqueda, ubicación y conexión de por ejemplo, redes wifi, montado y desmontado de discos extraíbles, etc. Un servicio de Sistema especial llamado init, es la primera aplicación en correr cuando se inicia el sistema. Aunque los servicios de sistema de algunas distribuciones linux se superponen con las que se ejecutan en Android en una cantidad pequeña. El sistema Android tiene servicios desconocidos como installd, rild, surfaceflinger y vold en lugar de servicios más comunes como udevd y syslog. <a href="https://www.oreilly.com/library/view/inside-the-android/9780134096377/">[1]</a></p>

<p style="text-align:justify;">El Sistema Android tiene componentes que operan dentro de cada capa del modelo. Desde abajo hacia arriba, los componentes son:  Binder que es un servicio de comunicación entre procesos (IPC) y quizás, el corazón de Android; La capa de Abstracción De Hardware la cual es una librería de sistema que soporta compatibilidades binarias para el sistema Android a través de múltiples plataformas hardware/drivers. El HAL sirve como una interfaz entre Android y cierto tipo genérico de dispositivos Hardware; Dalvik y ART son librerías del sistema especiales que comprenden la máquina virtual y el entorno de ejecución en el cual se ejecutan las aplicaciones Android. ART y Dalvik son análogos de Android a la máquina virtual de java y las librerías que este provee. Ambos tanto el runtime y muchas de las librerías que soportan son escritas en c/c++ y compiladas en el código nativo del dispositivo; Las librerías APIs de Android son librerías de Sistema escritas en Java, compiladas en código de máquina virtual DEX e interpretado en código de máquina (oat); Los servicios de Android son los análogos a los servicios de Sistema, son aplicaciones privilegiadas de Android escritas en Java que proveen funcionalidades esenciales del sistema android. El servicio Zygote, en especial, juega un rol clave en el sistema Android; Las aplicaciones son desarrolladas para Android, compiladas sobre APIs Android y ejecutadas dentro del entorno de ejecución.  <a href="https://www.oreilly.com/library/view/inside-the-android/9780134096377/">[1]</a></p>

<p style="text-align:justify;">La administración de memoria es la segunda mayor tarea del kernel. El hardware de memoria puede ser dividido en dos categorías: acceso aleatorio y estructura bloqueada. La información puede ser almacenada dentro o ser recuperada desde una memoria de acceso aleatorio (RAM). En un dispositivo ideal, toda la memoria es de acceso aleatorio, sin embargo debido al coste de las memorias de acceso aleatorio se integran en menor tamaño y se agregan memorias de bloque estructurado las cuales usualmente son más baratas, más grandes y de acceso más lento.  <a href="https://www.oreilly.com/library/view/inside-the-android/9780134096377/">[1]</a></p>

<p style="text-align:justify;">La mayoría de hardware de un dispositivo tiene en su centro, un pequeño número de unidades de procesamiento (también llamados núcleos o procesadores). Estos son componentes que ejecutan instrucciones de máquina. En un dispositivo teóricamente ideal, cada núcleo tiene capacidades idénticas y accesos idénticos para toda la memoria. En la práctica existen excepciones, registros y quizás, algún tipo de caché disponible para un núcleo en específico. El primer trabajo de un kernel es el de crear un entorno de ejecución virtual encima del hardware.  <a href="https://www.oreilly.com/library/view/inside-the-android/9780134096377/">[1]</a></p>

<br><br>

<h2 style="text-align:center;">ADMINISTRACIÓN DE MEMORIA</h2>
<p style="text-align:justify;">El kernel de Linux provee un “contenedor”, es decir, un entorno que abstrae el hardware dentro de recursos estándares lo cual facilita la ejecución de programas. De forma similar, Android como tal es un contenedor. Este provee de servicios abstractos para aplicaciones que corren dentro de él. Pensar en el kernel de Linux como un contenedor es un ejercicio útil ya que Android es un contenedor en sentidos usualmente reservados, por ejemplo, servidores web.  <a href="https://www.oreilly.com/library/view/inside-the-android/9780134096377/">[1]</a></p>

<p style="text-align:justify;">Los lenguajes intermedios, popularizados por el lenguaje Java, son lenguajes de máquina para computadoras virtuales. La idea es que el código escrito en un lenguaje informático como Java, diseñado para ser leído y escrito por seres humanos, se compile en el lenguaje intermedio. El lenguaje intermedio es un lenguaje de máquina para una computadora virtual: hardware que probablemente en realidad no existe. Ejecutar aplicaciones escritas en el lenguaje intermedio en una computadora real dada requiere de una aplicación binaria compilada que usa las instrucciones nativas de la computadora objetivo que interpreta instrucciones sucesivas en el lenguaje de máquina virtual, traduce cada una a una o más instrucciones nativas y ejecuta estas instrucciones nativas. Este programa se denomina intérprete o máquina virtual (VM). Claramente, una máquina virtual tiene un costo en eficiencia. Si se necesitan tres instrucciones nativas para ejecutar una sola instrucción del idioma intermedio, y si esa instrucción del idioma intermedio no es significativamente más poderosa que una sola instrucción nativa, entonces se necesitarán tres veces más tiempo para ejecutar un programa compilado en el lenguaje intermedio (y luego ejecutarlo en la máquina virtual) como lo haría para ejecutar exactamente el mismo programa compilado con instrucciones nativas y ejecutarse directamente. Sin embargo, el beneficio de una máquina virtual es la portabilidad. En lugar de tener múltiples versiones binarias de una aplicación, una para cada arquitectura de computadora de destino: hay una sola interfaz de lenguaje mediador “binario”. Es solo la máquina virtual la que interpreta el lenguaje intermedio que debe construirse por separado para cada arquitectura. Un binario de lenguaje intermedio se puede ejecutar en cualquier arquitectura que tenga una implementación de la máquina virtual. La portabilidad es esencial para el modelo de Android y, por lo tanto, la mayor parte del código de Android se compila en un lenguaje intermedio, DEX, el IL utilizado por la máquina virtual Android original, Dalvik.  <a href="https://www.oreilly.com/library/view/inside-the-android/9780134096377/">[1]</a></p>

<p style="text-align:justify;">Android runtime (ART) es el administrador de tiempo de ejecución el cual es usado por aplicaciones y algunos servicios de sistema en Android. ART y su predecesor Dalvik fueron originalmente creados específicamente para el proyecto Android. ART al ser el administrador de tiempo de ejecución, ejecuta archivos de formato Dalvik y con especificación Dex. ART utiliza la compilación AOT (Ahead-Of-Time), el cual mejora el rendimiento en aplicaciones. En el tiempo de instalación, ART compila aplicaciones utilizando la herramienta dex2oat. Esta herramienta recibe archivos DEX como entrada y genera el ejecutable de una aplicación compilada para el dispositivo.  <a href="https://source.android.com/devices/tech/dalvik">[3]</a></p>

<p style="text-align:justify;">Android Runtime (ART) y la máquina virtual Dalvik usan paginación y asignación de memoria (mmapping) para administrar la memoria. Esto significa que cualquier memoria que modifique una aplicación, ya sea asignando nuevos objetos o tocando páginas asignadas, permanece residente en la RAM y no se puede eliminar. La única forma de liberar memoria de una aplicación es liberar las referencias de objetos que contiene la aplicación, lo que hace que la memoria esté disponible para el recolector de elementos no utilizados. Eso es con una excepción: cualquier archivo asignado sin modificación, como el código, se puede paginar fuera de la RAM si el sistema quiere usar esa memoria en otro lugar. <a href="https://developer.android.com/topic/performance/memory-overview.">[2]</a></p>

<p style="text-align:justify;">Desde el punto de vista del kernel la memoria se divide en bloques de partes iguales llamados páginas. Generalmente definidos en kb. Estas páginas están organizadas en rangos continuos llamados VMA (Área de Memoria Virtual). Las VMA son creadas cuando el proceso realiza una petición a una nueva piscina de páginas de memoria a través del sistema llamado mmap(). Las aplicaciones rara vez hacen llamado directo a mmap(). Estos llamados son típicamente mediados por el asignador, malloc()/ operator new() para procesos nativos o por el Android Runtime para aplicaciones Java. Las VMAs pueden ser de dos tipos: respaldadas por archivos (file-backed) y anónimas. Las VMAs respaldadas por archivos son como tal una vista de un archivo en memoria. Ellas son obtenidas al pasar un archivo descriptor a mmap(). El kernel entrega fallas de página (page-fault) en el VMA a través del archivo pasado, por lo que leer un puntero al VMA se convierte en el equivalente de read() en el archivo. Los VMA respaldados por archivos se utilizan, por ejemplo, por el vinculador dinámico (id) al ejercer nuevos procesos o cargar bibliotecas dinámicamente, o por el marco de trabajo de Android, al cargar una nueva biblioteca .dex o acceder a recursos en el APK. Las VMAs anónimas son áreas de solamente memoria que no está respaldada por ningún archivo. Esta es la forma en que los asignadores solicitan memoria dinámica del kernel. Los VMAs anónimos se obtienen llamando a mmap(...MAP_ANONYMOUS…). <a href="https://perfetto.dev/docs/case-studies/memory">[4]</a></p>


<p style="text-align:justify;">La memoria física es solamente asignada en granularidad de páginas, una vez que la aplicación intente leer/escribir desde un VMA. Si asignamos 32mb de páginas pero solo tocamos un byte, el uso de memoria del proceso solo aumentará en 4kb. Por tanto, habrá aumentado la memoria virtual del proceso en 32mb pero la memoria física residente se mantiene en 4kb. A la cantidad de memoria de un proceso que reside en la memoria física la llamamos RSS (Conjunto de tamaño residente). Sin embargo es importante tener en cuenta que no toda la memoria residente es igual. Desde el punto de vista del consumo de memoria, las páginas individuales dentro de un VMA pueden tener los siguientes estados: <a href="https://perfetto.dev/docs/case-studies/memory">[4]</a></p>
<ul style="text-align:justify;">
<li>Residente: Las páginas son mapeadas hacia una página de memoria física. En un residente limpio el contenido de la página es el mismo que el contenido en disco. El kernel puede desalojar páginas limpias más fácilmente en caso de una presión de memoria. Esto se debe a que, si se necesitaran nuevamente, el kernel sabría que puede volver a crear su contenido leyéndolo del archivo adyacente; En un residente sucio el contenido de la página no difiere del deseo o la página no tiene respaldo de disco. Las páginas sucias no se pueden desalojar porque el hacerlo provocaría la pérdida de datos. Sin embargo se pueden intercambiar en disco o ZRAM.
</li>
<li>Swapped: Una página se puede escribir en el archivo de intercambio en el disco o comprimirse. La página permanecerá intercambiada hasta que ocurra una nueva falla de página en su dirección virtual, momento en el cual el kernel la traerá de vuelta a la memoria principal.
</li>
<li>No presente: Nunca ocurrió una falla de página en la página o la página estaba limpia y luego fue desalojada.
</li>
</ul>

<p style="text-align:justify;">La memoria compartida se puede asignar a más de un proceso. Esto significa que las VMAs en diferentes procesos se refieren a la misma memoria física. Esto suele suceder con la memoria respaldada por archivos de las bibliotecas de uso común (Por ejemplo, libc, framework.dex). Esto introduce el concepto de PSS (Tamano de conjunto proporcional). En PSS, la memoria residente en múltiples procesos se atribuye proporcionalmente a cada uno de ellos. Si mapeamos una página de 4kb en cuatro procesos, cada uno de sus PSS aumentará en 1kb.<a href="https://perfetto.dev/docs/case-studies/memory">[4]</a></p>

<p style="text-align:justify;"></p>

<br>
<h3>Memoria Compartida</h3>
<p style="text-align:justify;">Binder trabaja por medio del mapeo de un solo bloque de memoria física dentro de un espacio de memoria virtual de una o más aplicaciones. Cualquier escrito por cualquiera de las aplicaciones que comparten el bloque de memoria será visible en todas las demás aplicaciones. En estos casos la comunicación entre procesos es bastante eficiente sobre todo si no se necesita hacer copias.
</p>
<p style="text-align:justify;">Para que quepa todo lo necesario en RAM, Android intenta  compartir páginas RAM a través de procesos. Esto lo puede hacer de las siguientes formas: <a href="https://developer.android.com/topic/performance/memory-overview.">[2]</a></p>
<ol style="text-align:justify;">
<li>Cada proceso de la aplicación es bifurcado a través de procesos existentes llamados Zygote. El proceso Zygote inicia cuando el sistema arranca y carga los recursos y el marco de trabajo del código. Para iniciar un nuevo proceso de aplicación, el sistema bifurca al proceso Zygote, luego carga y corre el código de la aplicación en el nuevo proceso. Este enfoque permite que la mayoría de páginas RAM ubicadas para recursos y el  marco de trabajo del código sean compartidas a través de procesos de aplicaciones.
</li>
<li>La mayoría de datos estáticos son “mmapped” en un proceso. Esta técnica permite que los datos sean compartidos a través de procesos,  y también permite que se despagine cuando lo requiera. Entre los ejemplos de datos estáticos se mencionan: Código Dalvik, recursos de aplicación, elementos tradicionales del proyecto como el código nativo en archivos de extensión .so.
</li>
<li>En muchos casos, Android comparte la misma RAM dinámica a través de procesos utilizando explícitamente regiones ubicadas de memoria compartida (tanto con ashmen o gralloc). Por ejemplo, las superficies de ventana utilizan memoria compartida entre la aplicación y el compositor de pantalla, así como el bus del cursor utiliza memoria compartida entre el proveedor de contenido y el cliente.
</li>
</ol>

<br>
<h4>Memoria Compartida: Clase Ashmen</h4>
<p style="text-align:justify;">El equipo de Android encontró la existencia del sistema de memoria compartido “shmen” insuficiente para sus necesidades e introdujo una variante llamada “ashmen”. Ashmen de acuerdo a su documentación es un nuevo asignador de memoria compartida, similar a POSIX SHM pero con un entorno diferente y con exportación de archivos simples basados en APIs. <a href="https://www.oreilly.com/library/view/inside-the-android/9780134096377/">[1]</a>
</p>

<br>
<h4>Memoria Compartida: Clase PMEM e ION</h4>
<p style="text-align:justify;">Existen muchas razones por las cuales un dispositivo Android puede necesitar compartir memoria entre procesos, quizás, una de las más esenciales es la de dibujar la pantalla. Una de las cosas más destacables del Sistema Android desde su primer lanzamiento es su compromiso con OpenGL. Desde los inicios, el sistema Android incluye como componente estándar ambos la librería de gráficos 2D (skia) y 3D. La última implementación fue una librería de la API OpenGL, la cual permitió compatibilidad con OpenGL ES 2. Para operar eficientemente, ambos la librería para dibujar 2D y 3D requieren que el cliente sea capaz de escribir en la memoria que representa los píxeles de la pantalla. El módulo del kernel que permite este mapeo de región específica de la memoria Android en sus inicios fue llamado pmem. Pmem es muy similar a ashmen, con la excepción de que ashmen permite la compartición de bloque de memoria virtual, pmem asigna y comparte bloques de memoria física contigua. <a href="https://www.oreilly.com/library/view/inside-the-android/9780134096377/">[1]</a>
</p>

<br>
<h3>Zigote</h3>
<p style="text-align:justify;">El sistema Android, como parte del inicio, debe crear máquinas virtuales y entornos de tiempo de ejecución para todos los servicios del sistema que se compilan en DEX IL. También debe proporcionar una forma de iniciar e inicializar nuevos entornos de tiempo de ejecución para nuevas aplicaciones a medida que se inician. La solución de Android para esta necesidad es un programa inteligente llamado Zygote. Zygote es para Android lo que init es para Linux: el padre de todas las aplicaciones. init inicia Zygote como parte del inicio del sistema. Zygote se inicia precargando todo el marco de trabajo de Android. A diferencia de Java Desktop, no carga las bibliotecas de forma perezosa o por demanda sino que carga todo como parte del inicio del sistema. Cuando está completamente inicializado, entra en un ciclo cerrado, esperando para conexiones a un enchufe. <a href="https://www.oreilly.com/library/view/inside-the-android/9780134096377/">[1]</a></p>

<p style="text-align:justify;">Zygote hace uso de una función importante del sistema operativo Linux, la paginación de copia en escritura, para eliminar casi todos los elementos de la lista de inicialización de Java. El sistema operativo dispone de memoria virtual para aplicaciones; en este caso, Zygote. La memoria se organiza en páginas de tamaño uniforme. Cuando la aplicación hace referencia a la memoria en una determinada dirección, el hardware del dispositivo reinterpreta la dirección como un índice en una tabla de páginas y un desplazamiento en la página asociada a la que apunta el índice. Es totalmente posible que una dirección que apunta en la parte superior del espacio de memoria virtual de una aplicación haga referencia a una ubicación que en realidad está cerca del fondo de la memoria física. Cuando el sistema necesita crear una nueva aplicación, se conecta al socket Zygote y envía un pequeño paquete que describe la aplicación que se iniciará. Zygote se clona a sí mismo, creando un nuevo proceso a nivel de kernel. La nueva aplicación tiene su propia tabla de páginas. La mayor parte de la nueva tabla de páginas es simplemente una copia de la tabla de páginas de Zygote. Apunta exactamente a las mismas páginas de la memoria física. Solo las páginas que la nueva aplicación utiliza para sus propios fines no se comparten. El nuevo proceso es interesante porque comparte memoria con Zygote, su padre, en un modo llamado copia en escritura. Debido a que los dos procesos utilizan exactamente la misma memoria, iniciar el proceso secundario es casi instantáneo. El kernel no necesita asignar mucha memoria para el nuevo proceso, ni necesita cargar las bibliotecas del marco de trabajo de Android. Zygote se encarga de cargar todo. <a href="https://www.oreilly.com/library/view/inside-the-android/9780134096377/">[1]</a></p>

<p style="text-align:center;">Figura 1</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/zygote.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Android Deep Dive (2021), Capítulo 6 - Inicio de Android: Dalvik y Zygote, pág 124
</i></p>

<p style="text-align:justify;">Debido a que ambos procesos han mapeado exactamente la misma memoria física en sus espacios de direcciones virtuales, si alguno cambiará el contenido de la memoria al escribir en ella, el otro se vería afectado. Eso sería muy malo. Para evitar el problema, el sistema copia las páginas al escribir. El hardware notifica al núcleo cuando cualquiera de los procesos intenta escribir en una página compartida. En lugar de permitir la escritura, el núcleo asigna una nueva página de memoria y copia el contenido de la página original; La página en la que está escribiendo un proceso. Después de que los dos procesos tengan copias separadas de la página, cada uno puede modificar libremente su propia copia. Copiar sobre escribir es un gran ahorro. Además del inicio rápido, solo hay una copia para todos los procesos de cualquier página que no haya sido alterada por ningún proceso (todo el código de la biblioteca, por ejemplo). Incluso si algún proceso secundario escribiera en cada página de memoria (algo que, literalmente, nunca sucede), el costo de asignar la nueva memoria se amortiza a lo largo de la vida del proceso. No se incurre en la inicialización.
</p>

<p style="text-align:center;">Figura 2</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/zygote2.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Android Deep Dive (2021), Capítulo 6 - Inicio de Android: Dalvik y Zygote, pág 126
</i></p>

<br>
<h3>Recolector de Desperdicios</h3>
<p style="text-align:justify;">Un entorno de administración de memoria, como la máquina virtual ART y Dalvik, mantienen un rastreo de cada ubicación de memoria. Una vez que se determina que una pieza de memoria no seguirá siendo utilizada por el programa, se libera devuelta hacia la pila, sin ninguna intervención del programador. El mecanismo para reclamar memoria no utilizada dentro de un entorno de administración de memoria es conocido como Recolector de desperdicios. El recolector de desperdicios tiene dos objetivos principales: Encontrar objetos de datos en programas que no podrán ser accedidos en el futuro; Reclamar los recursos utilizados por dichos objetos. 
</p>

<p style="text-align:justify;">La pila de memoria del sistema Android es generacional, esto significa que hay diferentes espacios de ubicación que son rastreados, basados en el tiempo de vida esperado y en el tamaño del objeto que será ubicado. Cada generación de pila tiene su propio límite superior dedicado a la cantidad de memoria que pueden ocupar los objetos en ella. Cada vez que una generación comienza a llenarse, el sistema ejecuta un evento de recolección de desperdicios en un intento de liberar memoria. La duración de la recolección de desperdicios depende de qué generación de objetos esté recolectando y de cuantos objetos activos hay en cada generación. Generalmente no se puede controlar que el evento de recolección de desperdicios ocurra dentro del código. El sistema tiene un conjunto activo de criterios para determinar cuándo realizar una recolección de desperdicios. Cuando los criterios se satisfacen, el sistema termina de ejecutar el proceso y comienza la recolección de desperdicios. Si la recolección de desperdicios ocurre en medio de un ciclo de procesamiento intenso como una animación o durante la reproducción de música, este puede incrementar el tiempo de procesamiento. <a href="https://developer.android.com/topic/performance/memory-overview.">[2]</a> 
</p>

<br>
<h3>Ubicación y demanda de Memoria</h3>
<p style="text-align:justify;">La pila Dalvik está restringida por un solo rango de memoria virtual por cada proceso de aplicación. Esto define el tamaño lógico de la pila, el cual puede crecer tanto como se necesite pero solamente hasta un límite que el sistema define por cada aplicación. El tamaño lógico de la pila no es lo mismo que la cantidad de memoria física utilizada por la pila. Cuando inspeccionamos la pila de nuestra aplicación, Android procesa un valor llamado Tamaño de Conjunto Proporcional (PSS), el cual contabiliza para tanto para páginas sucias como limpias que son compartidas con otros procesos pero solamente en una cantidad que es proporcional a cuantas aplicaciones comparten la RAM. Este total (PSS) es lo que el sistema considera su huella de memoria física. La pila Dalvik no compacta el tamaño lógico de la pila, esto significa que Android no desfragmenta la pila para cerrar espacio. Android solamente puede encoger el tamaño lógico de la pila cuando hay espacio no utilizado al final de la pila. Después de la recolección de desperdicios, Dalvik camina la pila y encuentra páginas sin utilizar, luego retorna estas páginas hacia el kernel utilizando “madvise”. Por lo tanto, la ubicación y desubicación emparejada de grandes fragmentos deberían resultar en la demanda de toda la memoria física utilizada. Sin embargo, recuperar memoria de asignaciones pequeñas puede ser mucho menos eficiente porque la página utilizada para una asignación pequeña aún puede compartirse con otra cosa que aún no se ha liberado. <a href="https://developer.android.com/topic/performance/memory-overview.">[2]</a>
</p>

<br>
<h3>Restricciones de Memoria en Aplicaciones</h3>
<p style="text-align:justify;">Para mantener un entorno multitarea funcional, Android establece un límite en la pila para cada aplicación. El tamaño exacto de la pila varía dependiendo del dispositivo y de cuanta RAM este tiene disponible en general. Si la aplicación alcanza la capacidad máxima de la pila e intenta asignar más memoria, esta puede que reciba un mensaje de tipo OutOfMemoryError. <a href="https://www.oreilly.com/library/view/inside-the-android/9780134096377/">[1]</a>
</p>

<br>
<h4>Clase Logger</h4>
<p style="text-align:justify;">Como consecuencia de tener que tener cuidado con el uso de la memoria persistente, Android no puede escribir sus registros del sistema, como normalmente lo hace, en archivos. Arrojando kilobytes por minuto a un sistema de archivos basado en memoria flash, incluso si los archivos se administraron cuidadosamente para evitar llenar el espacio limitado en un dispositivo móvil ya que agotará la memoria flash muy rápidamente. Android abordó este problema escribiendo sus registros en un búfer circular en el núcleo: Los registros hacen no ir a archivos. Si los inconvenientes de esta idea no son inmediatamente obvios, se volverán obvios durante los intentos de diagnosticar un bloqueo del sistema no supervisado. Cuando un sistema Android se reinicia, su memoria se reinicia y todos los registros se pierden. <a href="https://www.oreilly.com/library/view/inside-the-android/9780134096377/">[1]</a> 
</p>

<br><br>

<h2 style="text-align:center;">DEPURACIÓN DEL USO DE MEMORIA EN ANDROID</h2>

<br>
<h4>dumpsys meminfo</h4>
<p style="text-align:justify;">Un buen lugar para empezar a investigar el uso de memoria de un proceso es dumpsys meminfo el cual proporciona un punto de vista de alto nivel sobre qué tanto de los varios tipos de memoria está siendo utilizado por un proceso. <a href="https://perfetto.dev/docs/case-studies/memory">[4]</a>
</p>

<p style="text-align:center;">Figura 3</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/dumpsys.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Información de consumo en memorias del sistema UI
</i></p>

<br><br>
<h2 style="text-align:center;">PLANIFICADORES DE PROCESOS EN ANDROID</h2>

<p style="text-align:justify;">Con frecuencia la documentación de Android se refiere a la gestión de procesos como  ciclo de vida de Android. Android implementa la multitarea mediante la ejecución de múltiples hilos para cada proceso; el proceso más simple consta de un sólo hilo principal que sólo es lanzado en el caso de que no exista ninguna instancia del proceso en ejecución. De igual forma un proceso puede utilizar múltiples hilos, uno por cada subproceso.</p>

<br>
<h3>Estado de los procesos</h3>
<p style="text-align:justify;">Cada aplicación de Android corre en su propio proceso, el cual es creado por la aplicación cuando se ejecuta y permanece hasta que la aplicación deja de trabajar o el sistema necesita memoria para otras aplicaciones. Android sitúa cada proceso en una jerarquía de "importancia" basada en estados, como se puede ver a continuación: <a href="http://www.jtech.ua.es/dadm/2011-2012/restringido/android-av/wholesite.pdf">[5]</a></p>
<ul style="text-align:justify;">
<li><b>Procesos en primer plano (Active process):</b> Es un proceso que aloja una Activity en la pantalla y con la que el usuario está interactuando (su método onResume() ha sido llamado) o que un IntentReceiver está ejecutándose. Este tipo de procesos serán eliminados como último recurso si el sistema necesitase memoria.
</li>
<li><b>Procesos visibles (Visible process):</b> Es un proceso que aloja una Activity pero no está en primer plano (su método onPause() ha sido llamado). Esto ocurre en situaciones dónde la aplicación muestra un cuadro de diálogo para interactuar con el usuario. Este tipo de procesos no será eliminado en caso que sea necesaria la memoria para mantener a todos los procesos del primer plano corriendo.
</li>
<li><b>Procesos de servicio (Started service process): </b> Es un proceso que aloja un Service que ha sido iniciado con el método startService(). Este tipo de procesos no son visibles y suelen ser importantes para el usuario (conexión con servidores, reproducción de música).
</li>
<li><b>Procesos en segundo plano (Background process):</b> Es un proceso que aloja una Actividad que no es actualmente visible para el usuario (su método onStop() ha sido llamado). Normalmente la eliminación de estos procesos no suponen un gran impacto para la actividad del usuario. Es muy usual que existan numerosos procesos de este tipo en el sistema, por lo que el sistema mantiene una lista para asegurar que el último proceso visto por el usuario sea el último en eliminarse en caso de necesitar memoria.</li>
<li><b>Procesos vacíos (Empty process):</b> Es un proceso que no aloja ningún componente. La razón de existir de este proceso es tener una caché disponible de la aplicación para su próxima activación. Es común que el sistema elimine este tipo de procesos con frecuencia para obtener memoria disponible.</li>
</ul>

<p style="text-align:justify;">Según esta jerarquía, Android prioriza los procesos existentes en el sistema y decide cuáles han de ser eliminados, con el fin de liberar recursos y poder lanzar la aplicación requerida. <a href="http://www.jtech.ua.es/dadm/2011-2012/restringido/android-av/wholesite.pdf">[5]</a></p>

<p style="text-align:center;">Figura 4</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/processState1.jpeg" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Estados de los procesos.
</i></p>

<br>
<h3>Ciclo de vida de una actividad</h3>
<p style="text-align:justify;">El hecho de que cada aplicación se ejecuta en su propio proceso aporta beneficios en cuestiones básicas como seguridad, gestión de memoria, o la ocupación de la CPU del dispositivo móvil. Android se ocupa de lanzar y parar todos estos procesos, gestionar su ejecución y decidir qué hacer en función de los recursos disponibles y de las órdenes dadas por el usuario. El usuario desconoce este comportamiento de Android. Simplemente es consciente de que mediante un simple clic pasa de una a otra aplicación y puede volver a cualquiera de ellas en el momento que lo desee. <a href="http://www.jtech.ua.es/dadm/2011-2012/restringido/android-av/wholesite.pdf">[5]</a></p>

<p style="text-align:justify;">Android lanza tantos procesos como permitan los recursos del dispositivo. Cada proceso, correspondiente a una aplicación, estará formado por una o varias actividades independientes (componentes Activity) de esa aplicación. Cuando el usuario navega de una actividad a otra, o abre una nueva aplicación, el sistema detiene dicho proceso y realiza una copia de su estado para poder recuperarlo más tarde. El proceso y la actividad siguen existiendo en el sistema, pero están dormidos y su estado ha sido guardado. Es entonces cuando crea, o despierta si ya existe, el proceso para la aplicación que debe ser lanzada, asumiendo que existan recursos para ello. <a href="http://www.jtech.ua.es/dadm/2011-2012/restringido/android-av/wholesite.pdf">[5]</a></p>

<p style="text-align:justify;">Cada uno de los componentes básicos de Android tiene un ciclo de vida bien definido; esto implica que el desarrollador puede controlar en cada momento en qué estado se encuentra dicho componente, pudiendo así programar las acciones que mejor convengan. El componente Activity, probablemente el más importante, tiene un ciclo de vida como el mostrado en la siguiente figura. <a href="http://www.jtech.ua.es/dadm/2011-2012/restringido/android-av/wholesite.pdf">[5]</a></p>

<p style="text-align:center;">Figura 5</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/processActivity.jpeg" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Ciclo de vida de un proceso.
</i></p>

<p style="text-align:justify;">De la figura anterior, pueden sacarse las siguientes conclusiones: <a href="http://www.jtech.ua.es/dadm/2011-2012/restringido/android-av/wholesite.pdf">[5]</a></p>
<ul style="text-align:justify;">
<li><b>onCreate(), onDestroy(): </b>Abarcan todo el ciclo de vida. Cada uno de estos métodos representan el principio y el fin de la actividad.
</li>
<li><b>onStart(), onStop():</b>  Representan la parte visible del ciclo de vida. Desde onStart() hasta onStop(), la actividad será visible para el usuario, aunque es posible que no tenga el foco de acción por existir otras actividades superpuestas con las que el usuario está interactuando. Pueden ser llamados múltiples veces.
</li>
<li><b>onResume(), onPause():</b> Delimitan la parte útil del ciclo de vida. Desde onResume() hasta onPause(), la actividad no sólo es visible, sino que además tiene el foco de la acción y el usuario puede interactuar con ella. </li>
</ul>

<p style="text-align:justify;">Tal y como se ve en el diagrama de la figura anterior, el proceso que mantiene a esta Activity puede ser eliminado cuando se encuentra en onPause() o en onStop(), es decir, cuando no tiene el foco de la aplicación. Android nunca elimina procesos con los que el usuario está interactuando en ese momento. Una vez se elimina el proceso, el usuario desconoce dicha situación y puede incluso volver atrás y querer usarlo de nuevo. Entonces el proceso se restaura gracias a una copia y vuelve a estar activo como si no hubiera sido eliminado. Además, la Activity puede haber estado en segundo plano, invisible, y entonces es despertada pasando por el estado onRestart().Pero, ¿qué ocurre en realidad cuando no existen recursos suficientes? Obviamente, los recursos son siempre limitados, más aún cuando se está hablando de dispositivos móviles. En el momento en el que Android detecta que no hay los recursos necesarios para poder lanzar una nueva aplicación, analiza los procesos existentes en ese momento y elimina los procesos que sean menos prioritarios para poder liberar sus recursos. <a href="http://www.jtech.ua.es/dadm/2011-2012/restringido/android-av/wholesite.pdf">[5]</a></p>

<p style="text-align:justify;">Cuando el usuario regresa a una actividad que está dormida, el sistema simplemente la despierta. En este caso, no es necesario recuperar el estado guardado porque el proceso todavía existe y mantiene el mismo estado. Sin embargo, cuando el usuario quiere regresar a una aplicación cuyo proceso ya no existe porque se necesitaba liberar sus recursos, Android lo crea de nuevo y utiliza el estado previamente guardado para poder restaurar una copia fresca del mismo. Como se ya ha explicado, el usuario no percibe esta situación ni conoce si el proceso ha sido eliminado o está dormido.<a href="http://www.jtech.ua.es/dadm/2011-2012/restringido/android-av/wholesite.pdf">[5]</a></p>

<br>
<h3>Planificación de procesos</h3>
<p style="text-align:justify;">Android es un sistema operativo basado en el kernel de Linux para la determinación de la planificación de sus procesos debido a esto algunos procesos en Android 8 son nativos, pero la mayoría de procesos se ejecutan en una máquina virtual de java; en la mayoría de los casos Android 8 al ejecutar una aplicación lo hace en su propio proceso Linux, se crea un proceso para la aplicación cuando se ejecuta esta aplicación y los seguirá ejecutando hasta que el sistema reclame recursos de otros procesos hasta que sea necesario y pueda asignarle a esta aplicaciones. Android tiene políticas de planificación de procesos las cuales son las siguientes:<a href="http://www.jtech.ua.es/dadm/2011-2012/restringido/android-av/wholesite.pdf">[5]</a></p>
<ul style="text-align:justify;">
<li><b>SCHED_OTHER:</b> El estándar de operación por turnos de tiempo compartido de las políticas.
</li>
<li><b>SCHED_BATCH:</b> Lo utiliza para realizar una ejecución “lote” es decir requiere que el programa, datos y órdenes al sistema operativo sean remitidos todos juntos al estilo de los procesos.
</li>
<li>
<b>SCHED_IDLE:</b> La utiliza para ejecutar trabajos o aplicaciones de muy baja prioridad en un segundo plano.
</li>
</ul>

<p style="text-align:justify;">Estados de un proceso en Android. El sistema operativo Android 8.0 utiliza estados de procesos para saber qué procesos eliminar primero ante un escenario para ello Android asigna prioridades a cada uno de los procesos utilizando el siguiente orden.<a href="http://www.jtech.ua.es/dadm/2011-2012/restringido/android-av/wholesite.pdf">[5]</a></p>

<p style="text-align:justify;">Foreground Process: En este estado va la aplicación que contiene una actividad ejecutada en primer plano en la pantalla del usuario y con la que está interactuando en el momento.<a href="http://www.jtech.ua.es/dadm/2011-2012/restringido/android-av/wholesite.pdf">[5]</a></p>

<ul style="text-align:justify;">
<li><b>Visible Process:</b> Este proceso ocupa una actividad que no está ejecutándose en primer plano es decir el método pausa ha sido llamado por esta actividad.</li>
<li><b>Service Process:</b> Estos procesos se inician cuando un service ha sido llamado.</li>
<li><b>Background process:</b> Es un proceso que contiene una actividad que el usuario no puede verla y que ya no tiene demasiada importancia es de baja prioridad.</li>
<li><b>Empty process:</b> Este es un estado de proceso que no está alojando ningún tipo de componente. La razón por lo que existe este estado es el de tener una caché disponible para la próxima aplicación que ejecute el usuario.</li>
</ul>

<p style="text-align:center;">Figura 6</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/processState2.jpeg" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Planificacion de procesos.
</i></p>

<br>
<h3>Algoritmos de planificación</h3>
<p style="text-align:justify;">En Android 9 básicamente se utilizan dos algoritmos de planificación que son el denominado SJF y el round robin:
<a href="http://www.jtech.ua.es/dadm/2011-2012/restringido/android-av/wholesite.pdf">[5]</a></p>
<ul style="text-align:justify;">
<li><b>SJF:</b> Android 9 utiliza algoritmos de planificación SJF debido a que este algoritmo da Da prioridad a los procesos más cortos a la hora de ejecución y los va colocando en una cola, selecciona al proceso con el próximo tiempo de ejecución más corto y lo ejecuta hasta que este proceso termine.
</li>
<li>
<b>Round Robin:</b> Este algoritmo también lo utiliza el Android 8 debido a que este proceso consiste en asignar un intervalo de tiempo de ejecución, a este intervalo se lo denomina cuanto, por lo cual, si el proceso agota su cuanto, este va a elegir otro proceso para que ocupe la CPU.
</li>
</ul>

<br><br>
<h2 style="text-align:center;">BIBLIOGRAFIAS</h2>
1. Meike, G., & Schiefer, L. (2021).| Inside the Android OS.| Addison Wesley Professional.|<a href="https://www.oreilly.com/library/view/inside-the-android/9780134096377/">Enlace al libro</a>
2. Overview of memory management. |(s. f.). Android Developers.|<a href="https://developer.android.com/topic/performance/memory-overview.">Enlace a la pagina</a> 
3. Android Runtime (ART) and Dalvik.| (s. f.). Android Open Source Project.|<a href="https://source.android.com/devices/tech/dalvik">Enlace a la pagina</a>
4. Debugging memory usage on Android.| Perfetto Tracing Docs.| (s. f.). Perfetto.|<a href="https://perfetto.dev/docs/case-studies/memory">Enlace a la pagina</a>
5. Jtech.ua.es. (2019).|<a href="http://www.jtech.ua.es/dadm/2011-2012/restringido/android-av/wholesite.pdf">Enlace a la pagina</a>
6. Android Developers. (2019).| Procesos y subprocesos  |  Android Developers.| <a href="https://developer.android.com/guide/components/processes-and-threads?hl=es-419">Enlace a la pagina</a>
7. Tanenbaum A.| Sistemas Operativos Modernos 2009 3ra Ed.| Ámsterdam: Pearson Educación.| <a href="https://developer.android.com/guide/components/processes-and-threads?hl=es-419">Enlace a la pagina</a>
8. Guías para desarrolladores | Desarrolladores de Android |. (2021). Android Developers. Geraadpleegd op 31 maart 2022.|<a href="https://developer.android.com/guide?hl=es">Enlace a la pagina</a>
9. Carlos Escobar.| (2016, 12 april).| Sistema operativo Android: Caracteristicas y funcionalidades para dispositivos moviles.|<a href="https://core.ac.uk/download/pdf/71396792.pdf">Enlace a la pagina</a>  
 

 


