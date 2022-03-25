---
layout: post
title:  "Virtualizacion a nivel de plataforma en Dispositivo Android"
date:   2022-03-17 07:19:16 +0000
categories: virtualization android
---

**Palabras Claves:** KVM, AOSP, Linux Kernel, QEMU, CrosVM, Cuttlefish device, Cross-Compile, Virtualizacion anidada.

<p style="text-align:justify;"><b>Abstracto:</b> Durante las últimas décadas se ha vuelto popular el uso de tecnologías basadas en la virtualización, esto debido a las diversas ventajas que surgen al distribuir las funciones de una máquina física entre varios usuarios o entornos. Entre estas ventajas destacan el aprovechamiento de toda la capacidad de la máquina, la creación de entornos aislados, personalizados y seguros, la división independiente de tareas para mejorar la eficiencia, sin mencionar que se considera a la virtualización como la base de tecnologías basadas en la nube (Cloud Computing). Una de las tecnologías que posibilitan la virtualización son los hipervisores, los cuales son un tipo de software que separa los recursos físicos de los entornos virtuales que los necesitan, posteriormente dichos recursos los dividen de manera tal que los entornos virtuales puedan utilizarlos. La mayoría de empresas hacen uso de virtualización con hipervisores para controlar Sistemas Operativos o para instalarse directamente en el hardware. Uno de los hipervisores mayormente utilizados en la actualidad es KVM (Máquina Virtual basada en Kernel) el cual es Open Source y se encuentra integrado en el Kernel de Linux desde la versión 2.6 en adelante. Teniendo en cuenta que el Sistema Operativo Android para dispositivos móviles utiliza como base el kernel de linux, se puede pensar que este mismo hipervisor KVM puede ser utilizado para implementar servicios basados en virtualización utilizando como host plataformas móviles. Por tanto, en la presente investigación se pretende exponer conceptos, teoría y experimentos que permitan una virtualización a nivel de plataforma en un dispositivo móvil, con enfoque al uso del hipervisor KVM en Sistemas Operativos Android. Posteriormente se utilizan las máquinas virtuales para exponer aplicaciones reales que son de beneficio para uso cotidiano y empresarial.</p>
<br><br>

<h2 style="text-align:center;">INTRODUCCION</h2>
<p style="text-align:justify;">El crecimiento de las plataformas y dispositivos móviles durante la última década es exponencial. Para nosotros es fácil percibirlo teniendo en cuenta que forman parte de nuestro dia a dia, siendo estos de utilidad ya sea para aplicaciones cotidianas en materia de comunicación, planificación y entretenimiento; así como aplicaciones empresariales en materia de Marketing, Ventas, Organización, Análisis y resultados científicos entre otros. Los dispositivos móviles están en todas partes del mundo y en cada actividad que realizamos, por esa razón se dice que existe una aplicación móvil para todo. Es importante tener en cuenta que así como crecen los diversos campos de la ciencia de la misma forma cada día se desarrollan aplicaciones que requieren una mayor complejidad tanto lógica a nivel de software como física a nivel de hardware. Teniendo lo anterior en cuenta no es de extrañar que cada ciertos meses o años veamos surgir nuevas gamas de dispositivos con caracteristicas nuevas y en algunos casos con mayor potencia tecnica en comparacion a sus antecesores.</p>

<p style="text-align:justify;">Todas estas ventajas ofrecidas por los dispositivos móviles son en parte gracias al constante desarrollo de diversos Sistemas Operativos. Un Sistema Operativo es el programa más importante que se ejecuta en una computadora. Este se encarga de administrar procesos, memoria así como a otros programas y al hardware en general. También permite comunicarnos con una computadora sin la necesidad de saber el lenguaje de máquina. Es importante entender que un dispositivo móvil es como tal considerado una computadora, de hecho, todo software destinado para computadoras de escritorio, portátiles o servidores, sin duda alguna, puede ser programado para dispositivos móviles, la única diferencia está en las capacidades a nivel de hardware. En la actualidad destacan dos grandes Sistemas Operativos para dispositivos móviles, nos referimos al Sistema Operativo Android propiedad del gigante Google inc company y al Sistema Operativo Iphone de Apple inc company. Es improtante mencionar que los conceptos y prácticas en este artículo son realizadas con base al Sistema Operativo Android. Esto debido a que Android OS es un sistema de código abierto, por lo cual es de acceso libre para todos e incluso para uso comercial. Sin mencionar que Android OS por mucho es el Sistema Operativo más popular alrededor del mundo. Teniendo en cuenta que la base de Android OS es el kernel de linux esto permite que sea un sistema operativo multiplataforma ya que su implementación no se limita solamente a dispositivos móviles, por lo cual se abre una mayor variedad de posibilidades en comparación a otros Sistemas Operativos moviles.</p>

<br>
<h3>Android Open Source Project (AOSP)</h3>
<p style="text-align:justify;">Android es una pila de software de código abierto creada para una amplia gama de dispositivos con diferentes factores de forma. El objetivo principal de Android es crear una plataforma de software abierta disponible para operadores, fabricantes de equipos originales y desarrolladores para hacer realidad sus ideas innovadoras y presentar un producto exitoso del mundo real que mejore la experiencia móvil de los usuarios. Android está diseñado para que no haya un punto central de falla, donde un actor de la industria restringe o controla las innovaciones de otro. El resultado es un producto de consumo completo con calidad de producción con código fuente abierto para la personalización y la migración. En primer lugar, la filosofía de Android es pragmática. El objetivo es un producto compartido que cada colaborador pueda adaptar y personalizar. Por supuesto, la personalización descontrolada puede dar lugar a implementaciones incompatibles. Para evitar esto, el Proyecto de código abierto de Android (AOSP) mantiene el Programa de compatibilidad de Android, que explica en detalle lo que significa ser compatible con Android y lo que se requiere de los fabricantes de dispositivos para lograr ese estado. Cualquiera puede usar el código fuente de Android para cualquier propósito y todos los usos legítimos son bienvenidos. <a href="https://source.android.com/setup/intro">[1]</a></p>

<p style="text-align:justify;">El proyecto de código abierto AOSP permite a los desarrolladores estudiar y experimentar a fondo las distintas versiones de Android mediante un conjunto de repositorios que son identificados por etiquetas las cuales hacen referencia a la versión de Android a la que van destinados. Por ejemplo, suponiendo tal vez que por razones de capacidad o consumo, tu equipo de desarrollo está interesado en la implementación de sistemas utilizando Android 9 (pie), siendo esto cierto, es probable que tu equipo opte por utilizar la rama aosp-pie-gsi aunque existen diversas ramas relacionadas a una misma versión de Android pero con propósitos diferentes. Es importante mencionar que para trabajar con el código de estos repositorios, es requisito utilizar el sistema de control de versiones Git así como Repo, una herramienta administradora de repositorios desarrollada por Google y que trabaja sobre Git. Cada repositorio cuenta con un conjunto de herramientas que permiten la compilación y emulación de dispositivos Android. Por defecto AOSP nos proporciona el código fuente del kernel y las especificaciones binarias para poder compilar algunos dispositivos específicos tales como Nexus y Pixel. También podemos crear compilaciones para placas tales como DragonBoard 845c, HiKey 960, Khadas VIM3 y Qualcomm Robotics Board RB5. Otra opción que AOSP nos proporciona en cuanto a la compilación de dispositivos es el uso de Imágenes de Sistema Genérico (GSI) la cual se ajusta a las configuraciones de dispositivos Android. En caso de que contemos con el código fuente (kernel) de algún dispositivo Android que no se encuentra en la lista del repositorio, AOSP nos brinda las herramientas necesarias para poder agregar un nuevo dispositivo, por ejemplo un Xperia Z, dispositivo sobre el cual precisamente existe una documentación de cómo compilarlo utilizando AOSP mediante el código fuente de uso abierto proporcionado por Sony. Por último se hace mención a los dispositivos Cuttlefish, un tipo de dispositivo agregado desde la versión 9 de Android hasta la actualidad y que ofrece una gran variedad de ventajas en comparación a otros tipos de dispositivos, como por ejemplo el tipo de emulación que lo caracteriza. Cuttlefish es un dispositivo Android virtual configurable que puede ejecutarse tanto de forma remota (usando ofertas de nube de terceros como Google Cloud Engine) como localmente (en máquinas Linux x86). Cuttlefish garantiza la fidelidad total con el marco de trabajo de Android (ya sea AOSP puro o una implementación personalizada en nuestro propio árbol). En la aplicación del mundo real, esto significa que debemos esperar que Cuttlefish responda a interacciones en el nivel del sistema operativo tal cual como lo haría un teléfono físico creado con la misma fuente de sistema operativo Android pura o personalizada. Para las prácticas realizadas en este artículo se utiliza un dispositivo Cuttlefish de la rama gsi de Android 11, en específico, el dispositivo <code>aosp_cf_x86_phone</code> perteneciente a la rama <code>aosp-android11-gsi</code>.
</p><br>
<h4>Capas de compilacion</h4>
<p style="text-align:justify;">La jerarquía de compilación incluye capas de abstracción que corresponden a la composición física de un dispositivo: <a href="https://source.android.com/setup/develop/new-device#build-layers">[2]</a></p>
- **La capa del producto** define la especificación de funciones de un producto de envío, como los módulos que se van a construir, las configuraciones regionales admitidas y la configuración para varias configuraciones regionales. En otras palabras, este es el nombre del producto en general. Las variables específicas del producto se definen en archivos MAKE de definición de producto. Entre algunos ejemplos tenemos a ```myProduct```, ```myProduct_eu```, ```myProduct_eu_fr```, ```j2```, ```sdk```.
- **La capa de placa/dispositivo** representa la capa física de plástico en el dispositivo (es decir, el diseño industrial del dispositivo). Esta capa también representa los esquemas básicos de un producto. Estos incluyen los periféricos en la placa y su configuración. Los nombres utilizados son simplemente códigos para diferentes configuraciones de placa/dispositivo. Entre algunos ejemplos tenemos a ```marlin```, ```blueline```, ```coral```.
- **La capa de arquitectura** describe la configuración del procesador y la interfaz binaria de la aplicación (ABI) que se ejecutan en la placa. Entre algunos ejemplos tenemos a ```arm```, ```x86```, ```arm64```, ```x86_64```.

<br>
<h4>Sistema de compilacion</h4>
<p style="text-align:justify;">Es importante mencionar que en los repositorios AOSP nos podemos encontrar con dos sistemas de compilación diferentes. El primero es GNU Make, una herramienta la cual controla la generación de ejecutables y otros programas que no pertenecen al código fuente pero que si son requeridos por otros archivos fuentes. GNU Make compila los programas a partir de un archivo llamado makefile, que enumera cada uno de los archivos que no son fuente y los procesa a partir de otros archivos. El sistema de compilación GNU Make lo encontramos en versiones anteriores a Android 7 dentro del proyecto AOSP. El segundo es Soong, introducido a partir de Android 7.0 (Nougat) para reemplazar a make. Aprovecha la herramienta de clonación Kati GNU Make y el componente del sistema de compilación Ninja para acelerar las compilaciones de Android. Soong es el reemplazo del antiguo sistema de compilación basado en make de Android. Reemplaza los archivos Android.mk con archivos Android.bp, que son descripciones declarativas simples similares a JSON de los módulos para compilar. Hacer distinción entre ambos tipos de sistemas es clave en caso de que se desee implementar un marco de trabajo personalizado, otra razón a tener en cuenta es la diferencia en el consumo de recursos que requiere cada sistema. De una forma empírica y basándonos en los experimentos realizados por el equipo de trabajo, se confirmó que las últimas versiones en AOSP (7 en adelante) tienden a consumir mas del doble de recursos que sus antecesoras, esto en parte debido al sistema de compilado, por ejemplo, la rama master (ultima estable) publicada hasta el momento, hace referencia a Android 13 (tiramisu) sobre la cual se confirmó un consumo por encima de los 12GB de ram durante el proceso de compilado; Una notable diferencia en comparación al compilado de la versión 7.1.2 (Nougat) de la cual se registró un consumo por debajo de los 4GB de ram.</p>

<br>
<h4>Tipos de Emuladores</h4>
<p>Actualmente en AOSP destacan dos formas de emular dispositivos android; La forma mas comun es por medio de un Emulador Android de Dispositivos Virtuales (AVD). Android Emulator nos permite ejecutar emulaciones de dispositivos Android en máquinas con Windows, macOS o Linux. El emulador de Android ejecuta el sistema operativo Android en una máquina virtual llamada dispositivo virtual de Android (AVD). El AVD contiene una pila completa de software de Android y se ejecuta como si estuviera en un dispositivo físico. <a href="https://source.android.com/setup/create/avd">[3]</a></p>
<p style="text-align:center;">Figura 1</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/emulator-design.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Arquitectura AVD, (s. f.). Android Open Source Project.</i></p>
<p style="text-align:justify;">La segunda forma es por medio de Dispositivos Virtuales Android Cuttlefish (CVD), como se menciono anteriormente Cuttlefish es un dispositivo Android virtual configurable que puede ejecutarse tanto de forma remota (usando ofertas de nube de terceros como Google Cloud Engine) como localmente (en máquinas Linux x86). Hay muchas similitudes con el emulador de Android, pero Cuttlefish garantiza una fidelidad total con el marco de trabajo de Android (ya sea AOSP puro o una implementación personalizada en su propio árbol). En la aplicación del mundo real, esto significa que debemos esperar que Cuttlefish responda a sus interacciones en el nivel del sistema operativo como un objetivo de teléfono físico creado con la misma fuente de sistema operativo Android pura o personalizada. El emulador de Android se ha creado en torno al caso de uso de facilitar el desarrollo de aplicaciones y contiene muchos ganchos funcionales para atraer los casos de uso del desarrollador de aplicaciones de Android. Esto puede presentar desafíos si el objetivo es crear un emulador con marco de Android personalizado. Para los casos en que se  necesita un dispositivo virtual que sea representativo para una plataforma/código de marco personalizado o arbol de Android, entonces Cuttlefish es una opción virtual ideal. Es el dispositivo canónico para representar el estado actual del desarrollo de AOSP. Uno de los aspectos importantes a destacar sobre los dispositivos cuttlefish es que son dispositivos Android que pueden ser utilizados para depurar. Se pueden registrar a si mismos como un dispositvo normal via ADB y se puede interactuar con ellos como si fuesen un dispositivo fisico por medio de Escritorios remotos.<a href="https://source.android.com/setup/create/cuttlefish">[4]</a></p>
<p style="text-align:center;">Figura 2</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/cf.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Dispositivo Virtual Cuttlefish renderizado via Webrt.</i></p>
<br>
<h4>Integracion Continua de Android</h4>
<p style="text-align:justify;">Teniendo en cuenta que el equipo de desarrollo se centró en realizar pruebas principalmente en el dispositivo virtual Cuttlefish <code>aosp_cf_x86_phone</code> perteneciente a la rama <code>aosp-android11-gsi</code> consideramos importante mencionar el procedimiento que se siguió para escoger este dispositivo en particular entre una gran variedad de opciones disponibles; Si bien, la idea principal era compilar un dispositivo perteneciente a la última versión de Android y emularlo. A pesar de que se logró compilar con éxito este no se logró emular correctamente. La razón del fallo era que se estaba intentado emular localmente un dispositivo cuttlefish de arquitectura x86_64; Tomando como referencia la documentación oficial de AOSP, localmente solamente son soportados los dispositivos de arquitectura x86. Este descubrimiento se logró luego de muchas compilaciones de diferentes dispositivos al azar en todas las ramas principales. Como consecuencia se consumió una gran cantidad de tiempo en lo que terminaba de compilarse cada dispositivo. Además de la arquitectura se encontraron otras razones por las cuales algunos dispositivos en específico no se emulaban con éxito, la mayoría de estos problemas estaban relacionados con requisitos e incompatibilidades de hardware en el sistema operativo host. Teniendo en cuenta lo anterior se podría decir que era una tarea tediosa encontrar dispositivos que funcionaran correctamente en la máquina host de cada integrante del equipo, principalmente debido a que el compilado tardaba horas en finalizar. Afortunadamente Google nos proporciona una solución de integración continua (Android CI) que nos permite tener acceso a distintos artefactos de dispositivos ya compilados. Entre  estos artefactos se encuentran archivos de imágenes y herramientas de host cuttlefish necesarios para una correcta emulación. Si bien estos artefactos se generaban al compilar los dispositivos, mediante Android CI se lograban obtener en cuestión de minutos dependiendo de la velocidad de descarga de nuestro internet. Por tanto mediante Android CI se obtuvieron los artefactos de diversos dispositivos cuttlefish y estos posteriormente se utilizaron para realizar pruebas hasta encontrar el dispositivo que mejor se ajustaba a nuestro entorno, resultando como mejor opción el dispositivo aosp_cf_x86_phone de la rama aosp-android11-gsi.
</p>
<br>

<h3>Virtualizacion</h3>
<p style="text-align:justify;">El proyecto final correspondiente a este articulo tiene como tematica principal la Virtualizacion, en especifico, explorar aplicaciones reales de virtualizacion en dispositivos android. Por esta razon introducimos algunos conceptos escenciales sobre la virtualizacion y puntos importantes a tomar en cuenta para enriquecer la practica.</p>
<p style="text-align:justify;">La virtualización es una tecnología que nos permite crear múltiples entornos simulados o recursos dedicados desde un único sistema de hardware físico. Su base es un software llamado hipervisor el cual se conecta directamente al hardware y nos permite dividir un sistema en entornos separados, distintos y seguros conocidos como máquinas virtuales (VM). Estas máquinas virtuales dependen de la capacidad del hipervisor para separar los recursos de la máquina del hardware y distribuirlos adecuadamente. El hardware físico, equipado con un hipervisor, se denomina host, mientras que las numerosas máquinas virtuales que utilizan sus recursos son invitados (guests). Estos invitados tratan los recursos informáticos, como la CPU, la memoria y el almacenamiento, como un conjunto de recursos que se pueden reubicar fácilmente. Los operadores pueden controlar instancias virtuales de CPU, memoria, almacenamiento y otros recursos, para que los invitados reciban los recursos que necesitan cuando los necesitan. <a href="https://www.redhat.com/en/topics/virtualization">[5]</a>
</p>
<br>

<h4>Diferencias entre Emulacion y Virtualizacion</h4>
<p style="text-align:justify;">La emulación, en definitiva, consiste en hacer que un sistema imite a otro. Por ejemplo, si una pieza de software se ejecuta en el sistema A y no en el sistema B, hacemos que el sistema B "emule" el funcionamiento del sistema A. El software luego se ejecuta en una emulación del sistema A. En este mismo ejemplo, la virtualización implicaría tomar el sistema A y dividirlo en dos servidores, B y C. Ambos servidores "virtuales" son contenedores de software independientes, que tienen su propio acceso a recursos basados ​​en software: CPU, RAM, almacenamiento y redes. – y se puede reiniciar de forma independiente. Se comportan exactamente como el hardware real, y una aplicación u otra computadora no podrían notar la diferencia. La emulación se puede utilizar de manera efectiva en los siguientes escenarios: <a href="https://www.dell.com/en-us/blog/emulation-or-virtualization-what-s-the-difference">[6]</a>
</p>
- Ejecutar un sistema operativo diseñado para otro hardware (por ejemplo, software de Mac en una PC; juegos basados ​​en consola en una computadora).
- Ejecutar software destinado a otro sistema operativo (ejecutar software específico de Mac en una PC y viceversa).
- Ejecución de software heredado después de que el hardware comparable se vuelva obsoleto.

<p style="text-align:justify;">Mientras que los entornos que son emulados requieren un puente de software para interactuar con el hardware, la virtualización accede directamente al hardware. Sin embargo, a pesar de ser la opción más rápida en general, la virtualización se limita a ejecutar software que ya podía ejecutarse en el hardware subyacente. Los beneficios más claros de la virtualización incluyen: <a href="https://www.dell.com/en-us/blog/emulation-or-virtualization-what-s-the-difference">[6]</a></p>
- Amplia compatibilidad con la arquitectura de CPU x86 existente.
- Capacidad de aparecer como dispositivos físicos para todo el hardware y software.
- Autónomo en cada caso.

<br>

<h4>Maquinas Virtuales Basadas En Kernel</h4>
<p style="text-align:justify;">Las máquinas virtuales basadas en kernel (KVM) representan la última generación de tecnologias de virtualización de codigo abierto. El objetivo del proyecto era crear un hipervisor moderno que se basara en la experiencia de tecnologías pertenecientes a generaciones anteriores y que aprovechara el hardware moderno disponible en la actualidad (VT-x, AMD-V). KVM convierte el kernel de Linux en un hipervisor al instalar el modulo del nucleo KVM. Siendo el hipervisor el kernel estándar de Linux, este se beneficia de los cambios al núcleo estándar (soporte de memoria, planificador, etc.). Optimizaciones para estos componentes de Linux (como el nuevo planificador en el kernel 3.1) benefician tanto al hipervisor (el sistema operativo host) como a los sistemas operativos invitados de Linux. Para las emulaciones de E/S, KVM utiliza un software de usuario llamado QEMU; Qemu es un programa de usuario que hace emulación de hardware. Este se encarga de emular el procesador y una larga lista de dispositivos periféricos: disco, red, VGA, PCI, USB, puertos seriales/paralelos, etc. para construir un hardware virtual completo en el que se pueda instalar el sistema operativo invitado y asi ser emulado por KVM. Formalmente QEMU es un emulador y virtualizador de máquinas genérico y de código abierto. Cuando se usa como emulador de máquina, QEMU puede ejecutar sistemas operativos y programas creados para una máquina (por ejemplo: una placa ARM) en una máquina diferente (por ejemplo: su propia PC). Por medio de la traducción dinámica, logra un buen rendimiento. <a href="https://www.packtpub.com/product/mastering-kvm-virtualization-second-edition/9781838828714">[7]</a></p>
<br>

<h3>Kernel de Linux</h3>
<p style="text-align:justify;">A pesar de su enorme codigo base (más de siete millones de líneas de código), el kernel de Linux es el sistema operativo más flexible que jamás se haya creado. Se puede ajustar para una amplia gama de sistemas diferentes, que se ejecutan en todo, desde un control por radio para un modelo de helicóptero, a un teléfono celular y a la mayoría de supercomputadoras más grandes en el mundo. Al personalizar el núcleo para nuestro entorno específico, es posible crear algo que es más pequeño y rápido que el núcleo proporcionado por la mayoría de las distribuciones de Linux. Ninguna distribución de Linux proporciona el kernel exacto que la mayoría de sus usuarios desean. Las distribuciones modernas se han vuelto muy complacientes, recopilando soporte para cada dispositivo conocido, para el sonido, e incluso para la conservación de energía. Pero es probable que se tenga una necesidad diferente a la de la mayoría de los usuarios (ya que cada distribución tiende a tratar de satisfacer las necesidades de la mayoría) como por ejemplo tener un hardware diferente. Cuando sale un nuevo kernel, es probable tambien que deseemos comenzar a usarlo sin esperar a que se construya una distribución a su alrededor. Tambien, existen muy buenas razones para eliminar funciones del núcleo, especialmente si se está ejecutando en un sistema integrado o en uno con factor de forma pequeño. <a href="http://www.kroah.com/lkn/">[8]</a></p>
<br><br>

<h2 style="text-align:center;">PROYECTO</h2>
<p>Tal como se mencionó anteriormente la temática principal del proyecto correspondiente a este artículo consiste en exponer aplicaciones reales de virtualización utilizando dispositivos android. Dentro de las aplicaciones a poner a prueba, destacan:</p>
<ol style="text-align:justify;">
<li><b>Protección de datos mediante máquinas virtuales:</b> Hoy en día es muy común que se manejen datos e información de carácter sensible en dispositivos móviles. Los mensajes del correo personal, fotos y videos en galería, información bancaria para realizar transacciones, documentos de trabajo, chats y contactos son algunos de los ejemplos de información que motivan a implementar una solución que garantice la protección de datos en dispositivos móviles. Si bien existen aplicaciones que permiten bloquear el acceso a cierta información, estas no están exentas de hackeos o técnicas que violen dichos mecanismos de seguridad. Es importante mencionar que consideramos que no existe implementación o sistema que no pueda ser hackeado o violado, sin embargo, el utilizar máquinas virtuales para proteger el acceso a datos (protección a nivel de Sistema operativo) es una opción más viable y segura que la protección por medio de aplicaciones de terceros.</li><br>
<li><b>Sistema BYOB empresarial mediante máquinas virtuales:</b> Existen muchas empresas que ambientan sistemas operativos o distribuciones con aplicaciones y servicios personalizados para sus empleados con el fin de garantizar la conservación de datos y seguridad de los mismos. En estos entornos se suele limitar las acciones del usuario. Por ejemplo, dependiendo de la empresa es probable que se requiera restringir la instalación de aplicaciones, hacer cambios de configuración al sistema, restringir el acceso a aplicaciones y navegación en páginas no autorizadas, entre otras. También es posible monitorear la actividad de los empleados para generar reportes, hacer análisis de datos y mejorar la productividad. Una máquina virtual en dispositivos móviles cuya imagen sea personalizada con orientación BYOB ofrece todas esas ventajas. También permite tener servicios controlados en dispositivos portátiles así como una reducción de costos en inversión de equipos, ya que dicha máquina virtual se instalaría en el dispositivo personal del empleado sin afectar al sistema operativo principal.</li><br>
<li><b>Sistemas Operativos de escritorio en dispositivos móviles:</b> De la misma forma en que se emula el hardware del dispositivo virtual cuttlefish y se virtualiza su software en una computadora personal, se pretende medir que tan factible es este mismo proceso pero en plataformas móviles. La capacidad de virtualizar un Sistema Operativo de escritorio en dispositivos móviles ofrece una amplia variedad de aplicaciones reales debido al conjunto de programas que existen en las diferentes plataformas. Entre algunas de las tantas aplicaciones que se podrían poner a prueba destacamos; La capacidad de manejar un entorno ambientado al pentesting de manera portable, por ejemplo kali linux; La capacidad de instalar software de virtualización basada en contenedores (Docker) que permita el levantamiento de servidores desde cualquier lugar.</li>
</ol><br>

<h4>Metodologia</h4>
<p style="text-align:justify;">Durante las primeras reuniones del equipo de sistemas, se planificaron las fases por las cuales debia pasar el proyecto para que este pudiera concluir exitosamente. Estas fases son:
</p>
<ol style="text-align:justify;">
<li>Preparación de entorno del servidor en el cual se almacena el repositorio AOSP para posteriormente realizar compilaciones.</li>
<li>Preparación de entorno del Host principal (Computadora personal) para la emulación de hardware del dispositivo Android Virtual y virtualización de su correspondiente software o sistema.</li>
<li>Implementación de software dual-boot que permita seleccionar la distribución o imagen Android a correr al iniciar nuestro dispositivo virtual.</li>
<li>Modificación del Kernel de linux para optimizar imagen del sistema Android.</li>
<li>Crear Versiones personalizadas de imágenes Android (ROMs).</li>
<li>Implementar VMs (Con ROMs o distribuciones linux) en Host Secundario (Dispositivo Virtual Cuttlefish, el cual, es también un Guest del Host principal) de tal forma que se cumpla con todas las metas establecidas en relación a las aplicaciones reales o casos de uso.</li>
</ol>
<p style="text-align:justify;">Al realizar un análisis se llegó a la conclusión de que para garantizar el éxito, en la mayoría de casos sería necesario terminar una fase actual en su completitud para poder pasar a la siguiente. Por ejemplo, para poder modificar el kernel, antes se debe preparar el servidor que lo compila y para probar dicho kernel se debe tener preparado el Host principal en el que se emulara el dispositivo que lo correrá. Por tal razón se decidió que para este proyecto en específico no sería factible trabajar las fases de forma paralela, por lo cual finalmente se estableció una metodología en cascada como marco de trabajo oficial en la cual se podría pasar a la siguiente fase únicamente si cada integrante del equipo terminaba la fase actual en su completitud.
</p><br>

<h3>Compilacion de Sistema Android y obtencion de artefactos</h3>
<p style="text-align:justify;">En esta seccion se encuentran los pasos a seguir para preparar el entorno en el cual posteriormente se compilaran los respectivos dispositivos AOSP. Tal como se ah mencionado en secciones anteriores se tendra un enfoque en el dispositivo <code>aosp_cf_x86_phone</code> perteneciente a la rama <code>aosp-android11-gsi</code>. Tambien se incluyen hallazgos y opiniones del equipo de sistemas asi como conceptos que se consideran relevantes. Es importante mencionar que muchos de los pasos que se mostraran a continuacion se pueden encontrar en la documentacion oficial de AOSP.</p>
<br>
<h4>Entorno de trabajo</h4>
<p style="text-align:justify;">Con respecto al entorno de trabajo, después de muchas pruebas compilando diferentes dispositivos, se tomó la decisión de utilizar un solo servidor especializado para compilar Sistemas Android. A pesar de que cada integrante del equipo logró compilar dispositivos exitosamente desde su computadora personal, el proceso era muy tardado y se reportaba un alto consumo de CPU y RAM, lo cual limitaba la cantidad de procesos que se podían realizar simultáneamente en nuestras computadoras personales. Por tanto se creó una instancia en Amazon Web Services del tipo <code>m5zn.6xlarge</code>  con las siguientes características:</p>
<ul>
<li>Sistema Operativo Ubuntu 18.04.</li>
<li>1 Tera-Byte de almacenamiento.</li>
<li>Arquitectura x86.</li>
<li>24 VCPU.</li>
<li>96 GB de RAM.</li>
<li>Conexion de 50 Gigabits.</li>
</ul>
<p style="text-align:justify;">Segun la documentación oficial de AOSP el mínimo de RAM requerido es de 16GB, sin embargo se pudo comprobar que esto depende de la versión de Android que se quiera compilar, por ejemplo, para la versión 7.1.2 (Nougat) el consumo de RAM era menor a los 4GB, sin embargo, para la última versión en la rama master el consumo sobrepasaba los 12 GB de ram.</p>
<p style="text-align:center;">Figura 3</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/htopBuild.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Consumo de recursos durante la compilacion.</i></p>
<br>
<h4>Instalación de dependencias</h4>
<p>Una vez hayamos verificado que cumplimos con los requisitos mínimos del sistema, lo siguiente será instalar todas las librerías y dependencias que requiere AOSP. El comando que se muestra a continuación podría variar dependiendo de la distribución linux que se esté utilizando: <a href="https://source.android.com/setup/build/initializing">[9]</a></p>
```shell
sudo apt-get install git-core gnupg flex bison build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 libncurses5 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig
```
<br>
<h4>Obteniendo repositorio AOSP</h4>
<p style="text-align:justify;">Primero creamos en nuestro área personal de linux una carpeta con el nombre de nuestro proyecto, para ello abrimos la terminal y escribimos los siguientes comandos:</p>
```shell
cd /home/$USER
```
```shell
mkdir aosp
```
```shell
cd aosp
```
<p style="text-align:justify;">Una vez dentro de nuestra carpeta del proyecto, lo siguiente es obtener y configurar “repo”, el cual es un script de python mantenido por Google que nos ayuda a sincronizar repositorios AOSP, para ello en la terminal escribimos los siguientes comandos:</p>
```shell
sudo apt update
```
```shell
sudo apt install git-all curl
```
```shell
sudo curl https://storage.googleapis.com/git-repo-downloads/repo > repo
```
```shell
sudo chmod a+x repo
```
<p style="text-align:justify;">Luego utilizando python3 para ejecutar nuestro archivo repo, inicializamos el repositorio AOSP en la rama <code>android11-gsi</code>:
</p>
```shell
sudo python3 repo init -u https://android.googlesource.com/platform/manifest -b android11-gsi
```
<p style="text-align:justify;">Sincronizamos el código fuente del repositorio. Esta tarea una vez comenzada puede tardar algunos minutos dependiendo de la velocidad de descarga. (Con el parámetro -j puede especificar el numero de nucleos que desea utilizar en el multiprocesamiento):
</p>
```shell
sudo python3 repo sync -j24
```
<p style="text-align:center;">Figura 4</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/repoSync.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Sincronizacion del repositorio android11-gsi completada.</i></p>
<br>
<h4>Compilando Dispositivo</h4>
<p style="text-align:justify;">Una vez tengamos el repositorio sincronizado, se nos agregara a la carpeta del proyecto un conjunto de archivos pertenecientes a AOSP. Lo siguiente es activar el entorno para poder compilar dispositivos Android:</p>
```shell
source build/envsetup.sh
```
<p>Despues, indicamos el dispositivo que queremos compilar:</p>
```shell
lunch aosp_cf_x86_phone
```
<p>Por último, comenzamos la compilación de la siguiente forma:</p>
```shell
m -j24
```
<p style="text-align:center;">Figura 5</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/aospDevice.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Inicializando dispositivo aosp_cf_x86_phone.</i></p>
<p style="text-align:center;">Figura 6</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/buildAOSP.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Compilacion de dispositivo aosp_cf_x86_phone terminada.</i></p>
<br><br>
<h3>Emulación de Dispositivo Virtual Cuttlefish</h3>
<p style="text-align:justify;">En esta sección se encuentran los pasos a seguir para preparar un entorno (Host) que permita emular un dispositivo cuttlefish (Guest). Es recomendable que el compilado y la emulación se realicen en entornos diferentes. En el caso del entorno de simulación, se comprobó después de algunas pruebas que es problemático utilizar máquinas virtuales por el tema de virtualización anidada. Teniendo en cuenta lo anterior, se recomienda que el host sea un Sistema instalado directamente en disco del ordenador físico. Tambien se incluyen hallazgos y opiniones del equipo de sistemas asi como conceptos que se consideran relevantes. Es importante mencionar que muchos de los pasos que se mostraran a continuacion se pueden encontrar en la documentacion oficial de Google Source <a href="https://android.googlesource.com/device/google/cuttlefish/">[10]</a> y en la documentacion oficial de Github <a href="https://github.com/google/android-cuttlefish/blob/main/BUILDING.md">[11]</a>.</p><br>

<h4>Entorno de trabajo</h4>
<p style="text-align:justify;">En este caso a diferencia del entorno de compilacion es viable utilizar computadoras personales. A continuacion se mencionan las especificaciones de uno de los entornos cuya emulacion resulto exitosa:</p>
<ul>
<li>Sistema Operativo Debian 11 Bullseye.</li>
<li>8 GB de RAM.</li>
<li>Arquitectura 64 bits x86.</li>
<li>Tarjeta Grafica Nvidia de 2GB.</li>
<li>Procesador Intel Core i5 cuarta generacion.</li>
</ul>
<p style="text-align:justify;">Es recomendable utilizar como Host un ordenador con la ultima version de la distribución Debian de Linux como Sistema Operativo. Esto debido a que las versiones de algunas dependencias de "Cuttlefish-Common" son con base al gestor de paquetes de Debian. Para estos paquetes en específico el gestor de paquetes de Debian cuenta con versiones mas actualizadas en comparación a otras distribuciones de Linux, como por ejemplo, ubuntu.</p>
<br>
<h4>Permisos en Debian</h4>
<p style="text-align:justify;">Debido a la seguridad en Debian, es probable que de entrada no se le permita instalar paquetes a su usuario normal. También al intentar instalar los paquetes con usuario root, es decir, utilizando "sudo" antes de cualquier comando o directamente con el comando "su" es probable que se le pida ingresar la contraseña Unix, la cual, no es la misma que la contraseña de su usuario root. Teniendo en cuenta lo anterior, se recomienda cambiar su contraseña Unix y también agregar a su usuario normal al grupo sudoers.</p>

<p style="text-align:justify;">Para cambiar su contraseña Unix, lo primero es acceder como usuario root ya sea desde la terminal (utilizando el comando su) o desde el inicio de sesión de Debian. Estando como usuario root bastará con utilizar el comando "passwd" en la terminal y posteriormente se le pedirá que ingrese la nueva contraseña Unix.</p>

<p style="text-align:justify;">Para agregar su usuario normal al grupo sudoers puede utilizar el siguiente comando:</p>
```shell
sudo usermod -aG sudo $USER
```
<p>Si por alguna razón el comando anterior no funciona, puede agregar a su usuario de forma manual utilizando un editor de texto como vim o nano y escribir al final del archivo <code>miUsuario  ALL=(ALL) NOPASSWD:ALL
</code>:</p>
```shell
sudo nano /etc/sudoers.d
```
<br>
<h4>Artefactos del dispositivo</h4>
<p style="text-align:justify;">La palabra "Artefactos" es utilizada para referirse a los archivos resultantes de la compilación de un Sistema Android. Estos pueden ser imágenes, makefiles o herramientas necesarias para correr emuladores. Estos artefactos se pueden obtener de 2 formas. La primera es al compilar un Sistema o dispositivo Android por medio de algún repositorio AOSP; La segunda es por medio de "Android CI".</p>
<p style="text-align:justify;">Como se mencionó anteriormente, en nuestro caso se utilizó Android CI únicamente para encontrar la rama y dispositivo más estable para nuestro entorno de emulación. La ventaja de Android CI es que podemos obtener los artefactos por medio de descarga directa lo cual toma minutos, a diferencia de compilar el sistema desde nuestro entorno de compilación (servidor) lo cual puede tomar horas.</p>
<p style="text-align:justify;">Si su objetivo es directamente emular el Sistema Android (sin modificar el kernel o realizar cambios al sistema) o probar dispositivos y ramas de una manera rápida, su mejor opción es descargar los artefactos desde Android CI. También puede utilizar los artefactos de Android CI como referencia para saber cuales son los necesarios para la emulación y así buscarlos en la carpeta <code>/out</code> de su repositorio AOSP. Son dos artefactos los que necesita buscar en Android CI para la emulación de dispositivos Cuttlefish, estos son:</p>
<ul>
<li style="text-align:justify;">El archivo comprimido con las imágenes del sistema el cual tiene un nombre parecido a <code>aosp_cf_x86_phone-img-xxxxxx.zip</code>. (Recuerde seleccionar una dispositivo cuttlefish con arquitectura x86)</li>
<li style="text-align:justify;">El archivo comprimido con las herramientas para que el Host pueda crear la emulación. En este caso el nombre exacto es<code>cvd-host_package.tar.gz</code></li>
</ul>
<p style="text-align:justify;">Si su objetivo es emular un dispositivo Android con kernel y configuraciones del sistema modificados, entonces deberá realizar las respectivas modificaciones utilizando el repositorio AOSP para posteriormente compilar el sistema desde su entorno de compilación. Lo siguiente será buscar los artefactos anteriormente mencionados en la carpeta <code>/out</code> de su repositorio AOSP. Tenga en cuenta que dentro del repositorio AOSP las imágenes las encontrará en la ruta <code>/out/target/product/vsoc_x86/</code> separadas y no como un archivo comprimido. El archivo comprimido con las herramientas del Host para emular el dispositivo lo puede encontrar en la ruta <code>/out/host/linux-x86/</code>.</p>
<p style="text-align:justify;">En el caso de que esté utilizando Android CI, deberá de extraer el archivo de imágenes y copiar el archivo comprimido en una sola carpeta. En el caso de que esté utilizando los artefactos generados por una compilación, deberá copiar todas las imágenes en una carpeta y en la misma copiar el archivo comprimido con las herramientas del Host para la emulación del dispositivo.
</p>
<p style="text-align:center;">Figura 7</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/deviceFolder.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Artefactos de dispositivo aosp_cf_x86_phone.</i></p>
<br>

<h4>Paquetes de Debian</h4>
<p style="text-align:justify;">Una vez que tengamos listos los artefactos del dispositivo, lo siguiente que haremos es utilizar el repositorio de Github Android-Cuttlefish, el cual contiene un conjunto de herramientas que nos permitirán emular nuestro dispositivo cuttlefish. El primer uso que le daremos al repositorio será el de construir un paquete Debian llamado "cuttlefish-common". Este paquete es una recopilación de dependencias que son necesarias para que algunas herramientas del repositorio Android-Cuttlefish funcionen correctamente. Habiendo dicho lo anterior, antes de comenzar debemos verificar que nuestro equipo sea capaz de virtualizar con KVM, para ello utilizamos el siguiente comando:</p>
```shell
grep -c -w "vmx\|svm" /proc/cpuinfo
```
<p>Si la salida es un número mayor a cero entonces nuestro equipo es capaz de virtualizar con KVM.</p>

<p style="text-align:center;">Figura 8</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/kvmOk.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Equipo capaz de virtualizar con KVM.</i></p>

<p>Luego instalamos en nuestro host el paquete git-all y algunos otros paquetes necesarios que nos permitirán compilar el paquete "cuttlefish-common". Para ello ejecutamos los siguientes comandos:</p>
```shell
sudo apt update
```
```shell
sudo apt install git-all
```
```shell
sudo apt install -y git devscripts config-package-dev debhelper-compat golang
```
<p>Después, clonamos el repositorio Android-Cuttlefish, compilamos el paquete "cuttlefish-common" y lo instalamos:</p>
```shell
cd /home/$USER
```
```shell
git clone https://github.com/google/android-cuttlefish
```
```shell
cd android-cuttlefish
```
```shell
debuild -i -us -uc -b -d
```
```shell
sudo dpkg -i ../cuttlefish-common_*_*64.deb || sudo apt-get install -f
```
```shell
sudo usermod -aG kvm,cvdnetwork,render $USER
```
<p>Por último reiniciamos nuestro equipo:</p>
```shell
sudo reboot
```
<br>
<h4></h4>
<br><br>
<h2 style="text-align:center;">BIBLIOGRAFIAS</h2>
1. Set up for Android Development. | (s. f.). Android Open Source Project. |<a href="https://source.android.com/setup/intro">Enlace a la pagina</a>
2. Adding a New Device.|(s. f.). Android Open Source Project.|<a href="https://source.android.com/setup/develop/new-device#build-layers">Enlace a la pagina</a> 
3. Using Android Emulator Virtual Devices.| (s. f.). Android Open Source Project.|<a href="https://source.android.com/setup/create/avd">Enlace a la pagina</a>
4. Cuttlefish Virtual Android Devices.| (s. f.). Android Open Source Project.|<a href="https://source.android.com/setup/create/cuttlefish">Enlace a la pagina</a>
5. Understanding virtualization.|(s. f.). Red Hat.|<a href="https://www.redhat.com/en/topics/virtualization">Enlace a la pagina</a> 
6. Dell Technologies Blog.|Emulation or virtualization: What’s the difference?.|13 de marzo de 2014.|<a href="https://www.dell.com/en-us/blog/emulation-or-virtualization-what-s-the-difference">Enlace a la pagina</a> 
7. Chirammal, H. D., Mukhedkar, P., & Vettathu, A. (2016). | Mastering KVM Virtualization.| Packt Publishing. |<a href="https://www.packtpub.com/product/mastering-kvm-virtualization-second-edition/9781838828714">Enlace al libro</a>
8. Kroah-Hartman, G. (2007).| Linux Kernel in a Nutshell.| Van Duuren Media.|<a href="http://www.kroah.com/lkn/">Enlace al libro</a>
9. Establishing a Build Environment.|(s. f.). Android Open Source Project.|<a href="https://source.android.com/setup/build/initializing">Enlace a la pagina</a> 
10. device/google/cuttlefish | Git at Google.|<a href="https://android.googlesource.com/device/google/cuttlefish/">Enlace a la pagina</a>  
11. android-cuttlefish/BUILDING.md at main | google/android-cuttlefish.| (s. f.). GitHub.|<a href="https://github.com/google/android-cuttlefish/blob/main/BUILDING.md">Enlace a la pagina</a>  

