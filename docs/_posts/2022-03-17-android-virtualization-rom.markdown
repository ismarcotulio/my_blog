---
layout: post
title:  "Virtualización a nivel de plataforma en Dispositivo Android"
date:   2022-03-17 07:19:16 +0000
categories: virtualization android
---

**Palabras Claves:** KVM, AOSP, Linux Kernel, QEMU, CrosVM, Cuttlefish device, Cross-Compile, Virtualización anidada.

<p style="text-align:justify;"><b>Abstracto:</b> Durante las últimas décadas se ha vuelto popular el uso de tecnologías basadas en la virtualización, esto debido a las diversas ventajas que surgen al distribuir las funciones de una máquina física entre varios usuarios o entornos. Entre estas ventajas destacan el aprovechamiento de toda la capacidad de la máquina, la creación de entornos aislados, personalizados y seguros, la división independiente de tareas para mejorar la eficiencia, sin mencionar que se considera a la virtualización como la base de tecnologías basadas en la nube (Cloud Computing). Una de las tecnologías que posibilitan la virtualización son los hipervisores, los cuales son un tipo de software que separa los recursos físicos de los entornos virtuales que los necesitan, posteriormente dichos recursos los dividen de manera tal que los entornos virtuales puedan utilizarlos. La mayoría de empresas hacen uso de virtualización con hipervisores para controlar Sistemas Operativos o para instalarse directamente en el hardware. Uno de los hipervisores mayormente utilizados en la actualidad es KVM (Máquina Virtual basada en Kernel) el cual es Open Source y se encuentra integrado en el Kernel de Linux desde la versión 2.6 en adelante. Teniendo en cuenta que el Sistema Operativo Android para dispositivos móviles utiliza como base el kernel de linux, se puede pensar que este mismo hipervisor KVM puede ser utilizado para implementar servicios basados en virtualización utilizando como host plataformas móviles. Por tanto, en la presente investigación se pretende exponer conceptos, teoría y experimentos que permitan una virtualización a nivel de plataforma en un dispositivo móvil, con enfoque al uso del hipervisor KVM en Sistemas Operativos Android. Posteriormente se utilizan las máquinas virtuales para exponer aplicaciones reales que son de beneficio para uso cotidiano y empresarial.</p>
<br><br>

<h2 style="text-align:center;">INTRODUCCIÓN</h2>
<p style="text-align:justify;">El crecimiento de las plataformas y dispositivos móviles durante la última década es exponencial. Para nosotros es fácil percibirlo teniendo en cuenta que forman parte de nuestro día a día, siendo estos de utilidad ya sea para aplicaciones cotidianas en materia de comunicación, planificación y entretenimiento; así como aplicaciones empresariales en materia de Marketing, Ventas, Organización, Análisis y resultados científicos entre otros. Los dispositivos móviles están en todas partes del mundo y en cada actividad que realizamos, por esa razón se dice que existe una aplicación móvil para todo. Es importante tener en cuenta que así como crecen los diversos campos de la ciencia de la misma forma cada día se desarrollan aplicaciones que requieren una mayor complejidad tanto lógica a nivel de software como física a nivel de hardware. Teniendo lo anterior en cuenta no es de extrañar que cada ciertos meses o años veamos surgir nuevas gamas de dispositivos con características nuevas y en algunos casos con mayor potencia técnica en comparación a sus antecesores.</p>

<p style="text-align:justify;">Todas estas ventajas ofrecidas por los dispositivos móviles son en parte gracias al constante desarrollo de diversos Sistemas Operativos. Un Sistema Operativo es el programa más importante que se ejecuta en una computadora. Este se encarga de administrar procesos, memoria así como a otros programas y al hardware en general. También permite comunicarnos con una computadora sin la necesidad de saber el lenguaje de máquina. Es importante entender que un dispositivo móvil es como tal considerado una computadora, de hecho, todo software destinado para computadoras de escritorio, portátiles o servidores, sin duda alguna, puede ser programado para dispositivos móviles, la única diferencia está en las capacidades a nivel de hardware. En la actualidad destacan dos grandes Sistemas Operativos para dispositivos móviles, nos referimos al Sistema Operativo Android propiedad del gigante Google inc company y al Sistema Operativo Iphone de Apple inc company. Es importante mencionar que los conceptos y prácticas en este artículo son realizadas con base al Sistema Operativo Android. Esto debido a que Android OS es un sistema de código abierto, por lo cual es de acceso libre para todos e incluso para uso comercial. Sin mencionar que Android OS por mucho es el Sistema Operativo más popular alrededor del mundo. Teniendo en cuenta que la base de Android OS es el kernel de linux esto permite que sea un sistema operativo multiplataforma ya que su implementación no se limita solamente a dispositivos móviles, por lo cual se abre una mayor variedad de posibilidades en comparación a otros Sistemas Operativos móviles.</p>

<br>
<h3>Android Open Source Project (AOSP)</h3>
<p style="text-align:justify;">Android es una pila de software de código abierto creada para una amplia gama de dispositivos con diferentes factores de forma. El objetivo principal de Android es crear una plataforma de software abierta disponible para operadores, fabricantes de equipos originales y desarrolladores para hacer realidad sus ideas innovadoras y presentar un producto exitoso del mundo real que mejore la experiencia móvil de los usuarios. Android está diseñado para que no haya un punto central de falla, donde un actor de la industria restringe o controla las innovaciones de otro. El resultado es un producto de consumo completo con calidad de producción con código fuente abierto para la personalización y la migración. En primer lugar, la filosofía de Android es pragmática. El objetivo es un producto compartido que cada colaborador pueda adaptar y personalizar. Por supuesto, la personalización descontrolada puede dar lugar a implementaciones incompatibles. Para evitar esto, el Proyecto de código abierto de Android (AOSP) mantiene el Programa de compatibilidad de Android, que explica en detalle lo que significa ser compatible con Android y lo que se requiere de los fabricantes de dispositivos para lograr ese estado. Cualquiera puede usar el código fuente de Android para cualquier propósito y todos los usos legítimos son bienvenidos. <a href="https://source.android.com/setup/intro">[1]</a></p>

<p style="text-align:justify;">El proyecto de código abierto AOSP permite a los desarrolladores estudiar y experimentar a fondo las distintas versiones de Android mediante un conjunto de repositorios que son identificados por etiquetas las cuales hacen referencia a la versión de Android a la que van destinados. Por ejemplo, suponiendo tal vez que por razones de capacidad o consumo, tu equipo de desarrollo está interesado en la implementación de sistemas utilizando Android 9 (pie), siendo esto cierto, es probable que tu equipo opte por utilizar la rama aosp-pie-gsi aunque existen diversas ramas relacionadas a una misma versión de Android pero con propósitos diferentes. Es importante mencionar que para trabajar con el código de estos repositorios, es requisito utilizar el sistema de control de versiones Git así como Repo, una herramienta administradora de repositorios desarrollada por Google y que trabaja sobre Git. Cada repositorio cuenta con un conjunto de herramientas que permiten la compilación y emulación de dispositivos Android. Por defecto AOSP nos proporciona el código fuente del kernel y las especificaciones binarias para poder compilar algunos dispositivos específicos tales como Nexus y Pixel. También podemos crear compilaciones para placas tales como DragonBoard 845c, HiKey 960, Khadas VIM3 y Qualcomm Robotics Board RB5. Otra opción que AOSP nos proporciona en cuanto a la compilación de dispositivos es el uso de Imágenes de Sistema Genérico (GSI) la cual se ajusta a las configuraciones de dispositivos Android. En caso de que contemos con el código fuente (kernel) de algún dispositivo Android que no se encuentra en la lista del repositorio, AOSP nos brinda las herramientas necesarias para poder agregar un nuevo dispositivo, por ejemplo un Xperia Z, dispositivo sobre el cual precisamente existe una documentación de cómo compilarlo utilizando AOSP mediante el código fuente de uso abierto proporcionado por Sony. Por último se hace mención a los dispositivos Cuttlefish, un tipo de dispositivo agregado desde la versión 9 de Android hasta la actualidad y que ofrece una gran variedad de ventajas en comparación a otros tipos de dispositivos, como por ejemplo el tipo de emulación que lo caracteriza. Cuttlefish es un dispositivo Android virtual configurable que puede ejecutarse tanto de forma remota (usando ofertas de nube de terceros como Google Cloud Engine) como localmente (en máquinas Linux x86). Cuttlefish garantiza la fidelidad total con el marco de trabajo de Android (ya sea AOSP puro o una implementación personalizada en nuestro propio árbol). En la aplicación del mundo real, esto significa que debemos esperar que Cuttlefish responda a interacciones en el nivel del sistema operativo tal cual como lo haría un teléfono físico creado con la misma fuente de sistema operativo Android pura o personalizada. Para las prácticas realizadas en este artículo se utiliza un dispositivo Cuttlefish de la rama gsi de Android 11, en específico, el dispositivo <code>aosp_cf_x86_phone</code> perteneciente a la rama <code>aosp-android11-gsi</code>.
</p><br>
<h4>Capas de compilación</h4>
<p style="text-align:justify;">La jerarquía de compilación incluye capas de abstracción que corresponden a la composición física de un dispositivo: <a href="https://source.android.com/setup/develop/new-device#build-layers">[2]</a></p>
- **La capa del producto** define la especificación de funciones de un producto de envío, como los módulos que se van a construir, las configuraciones regionales admitidas y la configuración para varias configuraciones regionales. En otras palabras, este es el nombre del producto en general. Las variables específicas del producto se definen en archivos MAKE de definición de producto. Entre algunos ejemplos tenemos a ```myProduct```, ```myProduct_eu```, ```myProduct_eu_fr```, ```j2```, ```sdk```.
- **La capa de placa/dispositivo** representa la capa física de plástico en el dispositivo (es decir, el diseño industrial del dispositivo). Esta capa también representa los esquemas básicos de un producto. Estos incluyen los periféricos en la placa y su configuración. Los nombres utilizados son simplemente códigos para diferentes configuraciones de placa/dispositivo. Entre algunos ejemplos tenemos a ```marlin```, ```blueline```, ```coral```.
- **La capa de arquitectura** Describe la configuración del procesador y la interfaz binaria de la aplicación (ABI) que se ejecutan en la placa. Entre algunos ejemplos tenemos a ```arm```, ```x86```, ```arm64```, ```x86_64```.

<br>
<h4>Sistema de compilación</h4>
<p style="text-align:justify;">Es importante mencionar que en los repositorios AOSP nos podemos encontrar con dos sistemas de compilación diferentes. El primero es GNU Make, una herramienta la cual controla la generación de ejecutables y otros programas que no pertenecen al código fuente pero que si son requeridos por otros archivos fuentes. GNU Make compila los programas a partir de un archivo llamado makefile, que enumera cada uno de los archivos que no son fuente y los procesa a partir de otros archivos. El sistema de compilación GNU Make lo encontramos en versiones anteriores a Android 7 dentro del proyecto AOSP. El segundo es Soong, introducido a partir de Android 7.0 (Nougat) para reemplazar a make. Aprovecha la herramienta de clonación Kati GNU Make y el componente del sistema de compilación Ninja para acelerar las compilaciones de Android. Soong es el reemplazo del antiguo sistema de compilación basado en make de Android. Reemplaza los archivos Android.mk con archivos Android.bp, que son descripciones declarativas simples similares a JSON de los módulos para compilar. Hacer distinción entre ambos tipos de sistemas es clave en caso de que se desee implementar un marco de trabajo personalizado, otra razón a tener en cuenta es la diferencia en el consumo de recursos que requiere cada sistema. De una forma empírica y basándonos en los experimentos realizados por el equipo de trabajo, se confirmó que las últimas versiones en AOSP (7 en adelante) tienden a consumir más del doble de recursos que sus antecesoras, esto en parte debido al sistema de compilado, por ejemplo, la rama master (ultima estable) publicada hasta el momento, hace referencia a Android 13 (tiramisu) sobre la cual se confirmó un consumo por encima de los 12GB de ram durante el proceso de compilado; Una notable diferencia en comparación al compilado de la versión 7.1.2 (Nougat) de la cual se registró un consumo por debajo de los 4GB de ram.</p>

<br>
<h4>Tipos de Emuladores</h4>
<p style="text-align:justify;">Actualmente en AOSP destacan dos formas de emular dispositivos android; La forma más común es por medio de un Emulador Android de Dispositivos Virtuales (AVD). Android Emulator nos permite ejecutar emulaciones de dispositivos Android en máquinas con Windows, macOS o Linux. El emulador de Android ejecuta el sistema operativo Android en una máquina virtual llamada dispositivo virtual de Android (AVD). El AVD contiene una pila completa de software de Android y se ejecuta como si estuviera en un dispositivo físico. <a href="https://source.android.com/setup/create/avd">[3]</a></p>
<p style="text-align:center;">Figura 1</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/emulator-design.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Arquitectura AVD, (s. f.). Android Open Source Project.</i></p>
<p style="text-align:justify;">La segunda forma es por medio de Dispositivos Virtuales Android Cuttlefish (CVD), como se mencionó anteriormente Cuttlefish es un dispositivo Android virtual configurable que puede ejecutarse tanto de forma remota (usando ofertas de nube de terceros como Google Cloud Engine) como localmente (en máquinas Linux x86). Hay muchas similitudes con el emulador de Android, pero Cuttlefish garantiza una fidelidad total con el marco de trabajo de Android (ya sea AOSP puro o una implementación personalizada en su propio árbol). En la aplicación del mundo real, esto significa que debemos esperar que Cuttlefish responda a sus interacciones en el nivel del sistema operativo como un objetivo de teléfono físico creado con la misma fuente de sistema operativo Android pura o personalizada. El emulador de Android se ha creado en torno al caso de uso para facilitar el desarrollo de aplicaciones y contiene muchos ganchos funcionales para atraer los casos de uso del desarrollador de aplicaciones de Android. Esto puede presentar desafíos si el objetivo es crear un emulador con marco de Android personalizado. Para los casos en que se  necesita un dispositivo virtual que sea representativo para una plataforma/código de marco personalizado o árbol de Android, entonces Cuttlefish es una opción virtual ideal. Es el dispositivo canónico para representar el estado actual del desarrollo de AOSP. Uno de los aspectos importantes a destacar sobre los dispositivos cuttlefish es que son dispositivos Android que pueden ser utilizados para depurar. Se pueden registrar a sí mismos como un dispositivo normal via ADB y se puede interactuar con ellos como si fuesen un dispositivo físico por medio de Escritorios remotos.<a href="https://source.android.com/setup/create/cuttlefish">[4]</a></p>
<p style="text-align:center;">Figura 2</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/cf.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Dispositivo Virtual Cuttlefish renderizado via Webrt.</i></p>
<br>
<h4>Integración Continua de Android</h4>
<p style="text-align:justify;">Teniendo en cuenta que el equipo de desarrollo se centró en realizar pruebas principalmente en el dispositivo virtual Cuttlefish <code>aosp_cf_x86_phone</code> perteneciente a la rama <code>aosp-android11-gsi</code> consideramos importante mencionar el procedimiento que se siguió para escoger este dispositivo en particular entre una gran variedad de opciones disponibles; Si bien, la idea principal era compilar un dispositivo perteneciente a la última versión de Android y emularlo. A pesar de que se logró compilar con éxito este no se logró emular correctamente. La razón del fallo era que se estaba intentado emular localmente un dispositivo cuttlefish de arquitectura x86_64; Tomando como referencia la documentación oficial de AOSP, localmente solamente son soportados los dispositivos de arquitectura x86. Este descubrimiento se logró luego de muchas compilaciones de diferentes dispositivos al azar en todas las ramas principales. Como consecuencia se consumió una gran cantidad de tiempo en lo que terminaba de compilarse cada dispositivo. Además de la arquitectura se encontraron otras razones por las cuales algunos dispositivos en específico no se emulaban con éxito, la mayoría de estos problemas estaban relacionados con requisitos e incompatibilidades de hardware en el sistema operativo host. Teniendo en cuenta lo anterior se podría decir que era una tarea tediosa encontrar dispositivos que funcionaran correctamente en la máquina host de cada integrante del equipo, principalmente debido a que el compilado tardaba horas en finalizar. Afortunadamente Google nos proporciona una solución de integración continua (Android CI) que nos permite tener acceso a distintos artefactos de dispositivos ya compilados. Entre  estos artefactos se encuentran archivos de imágenes y herramientas de host cuttlefish necesarios para una correcta emulación. Si bien estos artefactos se generaban al compilar los dispositivos, mediante Android CI se lograban obtener en cuestión de minutos dependiendo de la velocidad de descarga de nuestro internet. Por tanto mediante Android CI se obtuvieron los artefactos de diversos dispositivos cuttlefish y estos posteriormente se utilizaron para realizar pruebas hasta encontrar el dispositivo que mejor se ajustaba a nuestro entorno, resultando como mejor opción el dispositivo aosp_cf_x86_phone de la rama aosp-android11-gsi.
</p>
<br>

<h3>Virtualización</h3>
<p style="text-align:justify;">El proyecto final correspondiente a este artículo tiene como temática principal la Virtualización, en específico, explorar aplicaciones reales de virtualización en dispositivos android. Por esta razón introducimos algunos conceptos esenciales sobre la virtualización y puntos importantes a tomar en cuenta para enriquecer la práctica.</p>
<p style="text-align:justify;">La virtualización es una tecnología que nos permite crear múltiples entornos simulados o recursos dedicados desde un único sistema de hardware físico. Su base es un software llamado hipervisor el cual se conecta directamente al hardware y nos permite dividir un sistema en entornos separados, distintos y seguros conocidos como máquinas virtuales (VM). Estas máquinas virtuales dependen de la capacidad del hipervisor para separar los recursos de la máquina del hardware y distribuirlos adecuadamente. El hardware físico, equipado con un hipervisor, se denomina host, mientras que las numerosas máquinas virtuales que utilizan sus recursos son invitados (guests). Estos invitados tratan los recursos informáticos, como la CPU, la memoria y el almacenamiento, como un conjunto de recursos que se pueden reubicar fácilmente. Los operadores pueden controlar instancias virtuales de CPU, memoria, almacenamiento y otros recursos, para que los invitados reciban los recursos que necesitan cuando los necesitan. <a href="https://www.redhat.com/en/topics/virtualization">[5]</a>
</p>
<br>

<h4>Diferencias entre Emulacion y Virtualización</h4>
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

<h4>Máquinas Virtuales Basadas En Kernel</h4>
<p style="text-align:justify;">Las máquinas virtuales basadas en kernel (KVM) representan la última generación de tecnologías de virtualización de código abierto. El objetivo del proyecto era crear un hipervisor moderno que se basará en la experiencia de tecnologías pertenecientes a generaciones anteriores y que aprovechara el hardware moderno disponible en la actualidad (VT-x, AMD-V). KVM convierte el kernel de Linux en un hipervisor al instalar el módulo del núcleo KVM. Siendo el hipervisor el kernel estándar de Linux, este se beneficia de los cambios al núcleo estándar (soporte de memoria, planificador, etc.). Optimizaciones para estos componentes de Linux (como el nuevo planificador en el kernel 3.1) benefician tanto al hipervisor (el sistema operativo host) como a los sistemas operativos invitados de Linux. Para las emulaciones de E/S, KVM utiliza un software de usuario llamado QEMU; Qemu es un programa de usuario que hace emulación de hardware. Este se encarga de emular el procesador y una larga lista de dispositivos periféricos: disco, red, VGA, PCI, USB, puertos seriales/paralelos, etc. para construir un hardware virtual completo en el que se pueda instalar el sistema operativo invitado y asi ser emulado por KVM. Formalmente QEMU es un emulador y virtualizador de máquinas genérico y de código abierto. Cuando se usa como emulador de máquina, QEMU puede ejecutar sistemas operativos y programas creados para una máquina (por ejemplo: una placa ARM) en una máquina diferente (por ejemplo: su propia PC). Por medio de la traducción dinámica, logra un buen rendimiento. <a href="https://www.packtpub.com/product/mastering-kvm-virtualization-second-edition/9781838828714">[7]</a></p>
<br>

<h3>Kernel de Linux</h3>
<p style="text-align:justify;">A pesar de su enorme código base (más de siete millones de líneas de código), el kernel de Linux es el sistema operativo más flexible que jamás se haya creado. Se puede ajustar para una amplia gama de sistemas diferentes, que se ejecutan en todo, desde un control por radio para un modelo de helicóptero, a un teléfono celular y a la mayoría de supercomputadoras más grandes en el mundo. Al personalizar el núcleo para nuestro entorno específico, es posible crear algo que es más pequeño y rápido que el núcleo proporcionado por la mayoría de las distribuciones de Linux. Ninguna distribución de Linux proporciona el kernel exacto que la mayoría de sus usuarios desean. Las distribuciones modernas se han vuelto muy complacientes, recopilando soporte para cada dispositivo conocido, para el sonido, e incluso para la conservación de energía. Pero es probable que se tenga una necesidad diferente a la de la mayoría de los usuarios (ya que cada distribución tiende a tratar de satisfacer las necesidades de la mayoría) como por ejemplo tener un hardware diferente. Cuando sale un nuevo kernel, es probable también que deseemos comenzar a usarlo sin esperar a que se construya una distribución a su alrededor. También, existen muy buenas razones para eliminar funciones del núcleo, especialmente si se está ejecutando en un sistema integrado o en uno con factor de forma pequeño. <a href="http://www.kroah.com/lkn/">[8]</a></p>
<br><br>

<h2 style="text-align:center;">PROYECTO</h2>
<p style="text-align:justify;">Tal como se mencionó anteriormente la temática principal del proyecto correspondiente a este artículo consiste en exponer aplicaciones reales de virtualización utilizando dispositivos android. Dentro de las aplicaciones a poner a prueba, destacan:</p>
<ol style="text-align:justify;">
<li style="text-align:justify;"><b>Protección de datos mediante máquinas virtuales:</b> Hoy en día es muy común que se manejen datos e información de carácter sensible en dispositivos móviles. Los mensajes del correo personal, fotos y videos en galería, información bancaria para realizar transacciones, documentos de trabajo, chats y contactos son algunos de los ejemplos de información que motivan a implementar una solución que garantice la protección de datos en dispositivos móviles. Si bien existen aplicaciones que permiten bloquear el acceso a cierta información, estas no están exentas de hackeos o técnicas que violen dichos mecanismos de seguridad. Es importante mencionar que consideramos que no existe implementación o sistema que no pueda ser hackeado o violado, sin embargo, el utilizar máquinas virtuales para proteger el acceso a datos (protección a nivel de Sistema operativo) es una opción más viable y segura que la protección por medio de aplicaciones de terceros.</li><br>
<li style="text-align:justify;"><b>Sistema BYOB empresarial mediante máquinas virtuales:</b> Existen muchas empresas que ambientan sistemas operativos o distribuciones con aplicaciones y servicios personalizados para sus empleados con el fin de garantizar la conservación de datos y seguridad de los mismos. En estos entornos se suelen limitar las acciones del usuario. Por ejemplo, dependiendo de la empresa es probable que se requiera restringir la instalación de aplicaciones, hacer cambios de configuración al sistema, restringir el acceso a aplicaciones y navegación en páginas no autorizadas, entre otras. También es posible monitorear la actividad de los empleados para generar reportes, hacer análisis de datos y mejorar la productividad. Una máquina virtual en dispositivos móviles cuya imagen sea personalizada con orientación BYOB ofrece todas esas ventajas. También permite tener servicios controlados en dispositivos portátiles así como una reducción de costos en inversión de equipos, ya que dicha máquina virtual se instalaría en el dispositivo personal del empleado sin afectar al sistema operativo principal.</li><br>
<li style="text-align:justify;"><b>Sistemas Operativos de escritorio en dispositivos móviles:</b> De la misma forma en que se emula el hardware del dispositivo virtual cuttlefish y se virtualiza su software en una computadora personal, se pretende medir que tan factible es este mismo proceso pero en plataformas móviles. La capacidad de virtualizar un Sistema Operativo de escritorio en dispositivos móviles ofrece una amplia variedad de aplicaciones reales debido al conjunto de programas que existen en las diferentes plataformas. Entre algunas de las tantas aplicaciones que se podrían poner a prueba destacamos; La capacidad de manejar un entorno ambientado al pentesting de manera portable, por ejemplo kali linux; La capacidad de instalar software de virtualización basada en contenedores (Docker) que permita el levantamiento de servidores desde cualquier lugar.</li>
</ol><br>

<h4>Metodología</h4>
<p style="text-align:justify;">Durante las primeras reuniones del equipo de sistemas, se planificaron las fases por las cuales debía pasar el proyecto para que este pudiera concluir exitosamente. Estas fases son:
</p>
<ol style="text-align:justify;">
<li>Preparación de entorno del servidor en el cual se almacena el repositorio AOSP para posteriormente realizar compilaciones.</li>
<li>Preparación de entorno del Host principal (Computadora personal) para la emulación de hardware del dispositivo Virtual de Android y virtualización de su Sistema correspondiente.</li>
<li>Creación de dispositivo propio que permita realizar compilaciones de un Sistema Android Personalizado.</li>
<li>Compilación de un Kernel de linux personalizado para optimizar el rendimiento.</li>
<li>Crear distribuciones basadas en el Sistema Android (popularmente conocidas como ROMs) de tal forma que se cumpla con todas las metas establecidas en relación a las aplicaciones reales o casos de uso.</li>
</ol>
<p style="text-align:justify;">Al realizar un análisis se llegó a la conclusión de que para garantizar el éxito, en la mayoría de casos sería necesario terminar una fase actual en su completitud para poder pasar a la siguiente. Por ejemplo, para poder modificar el kernel, antes se debe preparar el servidor que lo compila y para probar dicho kernel se debe tener preparado el Host principal en el que se emulara el dispositivo que lo correrá. Por tal razón se decidió que para este proyecto en específico no sería factible trabajar las fases de forma paralela, por lo cual finalmente se estableció una metodología en cascada como marco de trabajo oficial en la cual se podría pasar a la siguiente fase únicamente si cada integrante del equipo terminaba la fase actual en su completitud.
</p><br>

<h3>Compilacion de Sistema Android y obtención de artefactos</h3>
<p style="text-align:justify;">En esta sección se encuentran los pasos a seguir para preparar el entorno en el cual posteriormente se compilaron los respectivos dispositivos AOSP. Tal como se ha mencionado en secciones anteriores se tendrá un enfoque en el dispositivo <code>aosp_cf_x86_phone</code> perteneciente a la rama <code>aosp-android11-gsi</code>. También se incluyen hallazgos y opiniones del equipo de sistemas así como conceptos que se consideran relevantes. Es importante mencionar que muchos de los pasos que se mostraran a continuación se pueden encontrar en la documentación oficial de AOSP.</p>
<br>
<h4>Entorno de trabajo</h4>
<p style="text-align:justify;">Con respecto al entorno de trabajo, después de muchas pruebas compilando diferentes dispositivos, se tomó la decisión de utilizar un solo servidor especializado para compilar Sistemas Android. A pesar de que cada integrante del equipo logró compilar dispositivos exitosamente desde su computadora personal, el proceso era muy tardado y se reportaba un alto consumo de CPU y RAM, lo cual limitaba la cantidad de procesos que se podían realizar simultáneamente en nuestras computadoras personales. Por tanto se creó una instancia en Amazon Web Services del tipo <code>m5zn.6x large</code>  con las siguientes características:</p>
<ul>
<li>Sistema Operativo Ubuntu 18.04.</li>
<li>1 Terabyte de almacenamiento.</li>
<li>Arquitectura x86.</li>
<li>24 VCPU.</li>
<li>96 GB de RAM.</li>
<li>Conexión de 50 Gigabytes.</li>
</ul>
<p style="text-align:justify;">Según la documentación oficial de AOSP el mínimo de RAM requerido es de 16GB, sin embargo se pudo comprobar que esto depende de la versión de Android que se quiera compilar, por ejemplo, para la versión 7.1.2 (Nougat) el consumo de RAM era menor a los 4GB, sin embargo, para la última versión en la rama master el consumo sobrepasaba los 12 GB de ram.</p>
<p style="text-align:center;">Figura 3</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/htopBuild.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Consumo de recursos durante la compilación.</i></p>
<br>
<h4>Instalación de dependencias</h4>
<p style="text-align:justify;">Una vez hayamos verificado que cumplimos con los requisitos mínimos del sistema, lo siguiente será instalar todas las librerías y dependencias que requiere AOSP. El comando que se muestra a continuación podría variar dependiendo de la distribución linux que se esté utilizando: <a href="https://source.android.com/setup/build/initializing">[9]</a></p>
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
<p style="text-align:justify;">Sincronizamos el código fuente del repositorio. Esta tarea una vez comenzada puede tardar algunos minutos dependiendo de la velocidad de descarga. (Con el parámetro -j puede especificar el número de nucleos que desea utilizar en el multiprocesamiento):
</p>
```shell
sudo python3 repo sync -j24
```
<p style="text-align:center;">Figura 4</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/repoSync.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Sincronización del repositorio android11-gsi completada.</i></p>
<br>
<h4>Compilando Dispositivo</h4>
<p style="text-align:justify;">Una vez tengamos el repositorio sincronizado, se nos agregara a la carpeta del proyecto un conjunto de archivos pertenecientes a AOSP. Lo siguiente es activar el entorno para poder compilar dispositivos Android:</p>
```shell
source build/envsetup.sh
```
<p style="text-align:justify;">Después, indicamos el dispositivo que queremos compilar:</p>
```shell
lunch aosp_cf_x86_phone
```
<p style="text-align:justify;">Por último, comenzamos la compilación de la siguiente forma:</p>
```shell
m -j24
```
<p style="text-align:center;">Figura 5</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/aospDevice.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Inicializando dispositivo aosp_cf_x86_phone.</i></p>
<p style="text-align:center;">Figura 6</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/buildAOSP.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Compilación de dispositivo aosp_cf_x86_phone terminada.</i></p>
<br><br>
<h3>Emulación de Dispositivo Virtual Cuttlefish</h3>
<p style="text-align:justify;">En esta sección se encuentran los pasos a seguir para preparar un entorno (Host) que permite emular un dispositivo cuttlefish (Guest). Es recomendable que el compilado y la emulación se realicen en entornos diferentes. En el caso del entorno de simulación, se comprobó después de algunas pruebas que es problemático utilizar máquinas virtuales por el tema de virtualización anidada. Teniendo en cuenta lo anterior, se recomienda que el host sea un Sistema instalado directamente en disco del ordenador físico. También se incluyen hallazgos y opiniones del equipo de sistemas así como conceptos que se consideran relevantes. Es importante mencionar que muchos de los pasos que se mostraran a continuacion se pueden encontrar en la documentacion oficial de Google Source <a href="https://android.googlesource.com/device/google/cuttlefish/">[10]</a> y en la documentación oficial de Github <a href="https://github.com/google/android-cuttlefish/blob/main/BUILDING.md">[11]</a>.</p><br>

<h4>Entorno de trabajo</h4>
<p style="text-align:justify;">En este caso a diferencia del entorno de compilación es viable utilizar computadoras personales. A continuación se mencionan las especificaciones de uno de los entornos cuya emulación resultó exitosa:</p>
<ul>
<li>Sistema Operativo Debian 11 Bullseye.</li>
<li>8 GB de RAM.</li>
<li>Arquitectura 64 bits x86.</li>
<li>Tarjeta Gráfica Nvidia de 2GB.</li>
<li>Procesador Intel Core i5 cuarta generacion.</li>
</ul>
<p style="text-align:justify;">Es recomendable utilizar como Host un ordenador con la última versión de la distribución Debian de Linux como Sistema Operativo. Esto debido a que las versiones de algunas dependencias de "Cuttlefish-Common" son con base al gestor de paquetes de Debian. Para estos paquetes en específico el gestor de paquetes de Debian cuenta con versiones más actualizadas en comparación a otras distribuciones de Linux, como por ejemplo, ubuntu.</p>
<br>
<h4>Permisos en Debian</h4>
<p style="text-align:justify;">Debido a la seguridad en Debian, es probable que de entrada no se le permite instalar paquetes a su usuario normal. También al intentar instalar los paquetes con usuario root, es decir, utilizando "sudo" antes de cualquier comando o directamente con el comando "su" es probable que se le pida ingresar la contraseña Unix, la cual, no es la misma que la contraseña de su usuario root. Teniendo en cuenta lo anterior, se recomienda cambiar su contraseña Unix y también agregar a su usuario normal al grupo sudoers.</p>

<p style="text-align:justify;">Para cambiar su contraseña Unix, lo primero es acceder como usuario root ya sea desde la terminal (utilizando el comando su) o desde el inicio de sesión de Debian. Estando como usuario root bastará con utilizar el comando "passwd" en la terminal y posteriormente se le pedirá que ingrese la nueva contraseña Unix.</p>

<p style="text-align:justify;">Para agregar su usuario normal al grupo sudoers puede utilizar el siguiente comando:</p>
```shell
sudo usermod -aG sudo $USER
```
<p style="text-align:justify;">Si por alguna razón el comando anterior no funciona, puede agregar a su usuario de forma manual utilizando un editor de texto como vim o nano y escribir al final del archivo <code>miUsuario  ALL=(ALL) NOPASSWD:ALL
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
<p style="text-align:justify;">Si la salida es un número mayor a cero entonces nuestro equipo es capaz de virtualizar con KVM.</p>

<p style="text-align:center;">Figura 8</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/kvmOk.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Equipo capaz de virtualizar con KVM.</i></p>

<p style="text-align:justify;">Luego instalamos en nuestro host el paquete git-all y algunos otros paquetes necesarios que nos permitirán compilar el paquete "cuttlefish-common". Para ello ejecutamos los siguientes comandos:</p>
```shell
sudo apt update
```
```shell
sudo apt install git-all
```
```shell
sudo apt install -y git devscripts config-package-dev debhelper-compat golang
```
<p style="text-align:justify;">Después, clonamos el repositorio Android-Cuttlefish, compilamos el paquete "cuttlefish-common" y lo instalamos:</p>
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
<h4>Contenedor Android Cuttlefish</h4>
<p style="text-align:justify;">El segundo uso que le daremos al repositorio Android-Cuttlefish será para crear un contenedor con algunas configuraciones e instalaciones de paquetes que garanticen la emulación del dispositivo cuttlefish. Entre estas herramientas destacan QEMU x86, Google Chrome, WebRTC, sockets en kernel Host, drivers de video, dependencia LibVirt, entre otras.</p>
<p style="text-align:justify;">Primero, instalamos docker y añadimos algunos módulos de kernel al host:</p>
```shell
curl https://get.docker.com | sh
```
```
sudo modprobe vhost_vsock vhost_net
```
<p style="text-align:justify;">Luego nos vamos a la raíz del repositorio Android-Cuttlefish y construimos la imagen docker del contenedor:</p>
```shell
./build.sh
```
<p style="text-align:justify;">Una vez que tengamos lista la imagen del contenedor en docker, lo siguiente será crear el contenedor como tal. Para ello haremos uso de algunos comandos o funciones que nos proporciona el repositorio de Android-Cuttlefish. Estos comandos activan una serie de instrucciones bash las cuales pueden ser encontradas en el archivo <code>setup.sh</code>. Por tanto debemos hacer reconocibles dichos comandos por nuestro sistema, para ello desde la carpeta raíz del repositorio Android-Cuttlefish ejecutamos en la terminal (Este paso se debe realizar en cada terminal nueva):</p>
```shell
source setup.sh
```
<p style="text-align:justify;">A continuación crearemos nuestro primer contenedor para emular dispositivos cuttlefish. Recordando en secciones anteriores, para realizar este paso es requisito tener listo los artefactos del dispositivo cuttlefish en una sola carpeta. Para efectos de demostración se asumirá que los artefactos se encuentran en la carpeta <code>/home/$USER/Documents/aosp/android11-gsi-x86/</code>. Para crear el contenedor utilizaremos el comando <code>cvd_docker_create</code>, el cual recibe 4 parámetros:</p>
<ol>
<li style="text-align:justify;">El parámetro -x. Permite redireccionar peticiones realizadas dentro del contenedor hacia el Host. (Útil para renderizar en el Host un navegador que se ejecute dentro del contenedor).</li>
<li style="text-align:justify;">El parámetro --android. Permite especificar manualmente la ruta en donde se encuentran las imágenes de nuestro dispositivo.</li>
<li style="text-align:justify;">El parámetro --cuttlefish. Permite especificar manualmente la ruta en donde se encuentra el archivo comprimido <code>cvd-host_package.tar.gz</code>.</li>
<li style="text-align:justify;">El nombre del contenedor (Importante recordar).</li>
</ol>
<p style="text-align:justify;">Por tanto, el comando se escribirá de la siguiente forma:</p>
```shell
cvd_docker_create -x --android=/home/$USER/Documents/aosp/android11-gsi-x86/ --cuttlefish=/home/$USER/Documents/aosp/android11-gsi-x86/cvd-host_package.tar.gz cf11x86
```
<p style="text-align:center;">Figura 9</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/createcf.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Contenedor cf11x86 creado.</i></p>
<p style="text-align:justify;">Después lo que haremos será entrar al contenedor y ejecutar manualmente el archivo <code>launch_cvd</code>. Este archivo inicia los procesos para correr las imágenes y activar el socket que mantendrá estable al dispositivo. Para entrar en el contenedor debemos utilizar su nombre en combinación a un comando:</p>
```shell
cvd_login_cf11x86
```
<p style="text-align:center;">Figura 10</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/dirContenedor.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Directorios dentro del contenedor cf11x86.</i></p>
<p style="text-align:justify;">Estando dentro del contenedor, desde la raíz escribimos el siguiente comando:</p>
```shell
./bin/launch_cvd --start_webrtc --cpus 4 --memory_mb 4096
```
<p style="text-align:center;">Figura 11</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/cvdBooted.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Dispositivo cuttlefish iniciado.</i></p>
<p style="text-align:justify;">El último paso en esta sección es conectarnos al emulador. Para ello abrimos una nueva terminal y escribimos el siguiente comando:</p>
```shell
source setup.sh
```
```shell
cvd_login_cf11x86 google-chrome-stable
```
<p style="text-align:justify;">Se nos abrirá un navegador Google Chrome el cual se ejecuta dentro de nuestro contenedor. Escribimos la dirección <code>https://127.0.0.1:8443</code> y nos conectamos a nuestro respectivo dispositivo.</p>
<p style="text-align:center;">Figura 12</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/cvdWebRTC.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Conexión con dispositivo Cuttlefish vía WebRTC.</i></p>
<p style="text-align:justify;">Finalmente, se recomienda detener el socket sin forzarlo (ctrl+c). Para ello desde una nueva terminal escribimos:
</p>
```shell
source setup.sh
```
```shell
cvd_stop_cf11x86
```
<br><br>
<h3>Creando dispositivo propio</h3>
<p style="text-align:justify;">En esta sección se muestran los pasos seguidos para crear un dispositivo propio en AOSP. Una de las ventajas de crear un dispositivo propio en AOSP es que este nos permite realizar compilaciones modificadas sin alterar el código de los dispositivos que nos brinda el repositorio por defecto. Esto se logra debido a que nuestro dispositivo se crea con base a un dispositivo ya existente, por tanto para realizar modificaciones bastará con alterar el código de nuestro nuevo dispositivo como tal en vez del dispositivo original. Tal como se ha mencionado anteriormente, las pruebas e implementaciones de este artículo son realizadas en dispositivos virtuales de tipo Cuttlefish. Por esa razón el dispositivo que crearemos a continuación estará basado en el objetivo <code>aosp_cf_x86_phone_userdebug</code> de la rama <code>pie-gsi</code>.</p>
<p style="text-align:justify;">Teniendo en cuenta que en prácticas anteriores se utilizó la rama <code>android11-gsi</code>. Para esta sección el equipo de Sistemas decidió utilizar la rama <code>pie-gsi</code> debido a dos razones:
</p>
<ol>
<li style="text-align:justify">El dispositivo virtual cuttlefish se comenzó a implementar desde la aparición de Android 9. En repositorios posteriores se fueron agregando nuevas funcionalidades y características que para efectos de este proyecto no se consideran indispensables. Por esa razón se optó en utilizar una de las primeras ramas que ofrecen soporte a dispositivos Cuttlefish, <code>pie-gsi</code>. Esta rama cuenta con las características y funcionalidades mínimas para completar con éxito el proyecto a un menor costo de procesamiento y requerimientos de hardware.</li>
<li style="text-align:justify">Demostrar que estos pasos son de utilidad para cualquier implementación con  Android 9 o versiones posteriores. Por tanto, se puede utilizar también la rama <code>android11-gsi</code> con algunos cambios mínimos los cuales no se detallaran en este artículo pero que serán intuitivos para el lector.
</li>
</ol>
<p style="text-align:justify;">Antes de comenzar es importante aclarar que a partir de esta sección se utilizan únicamente artefactos que se obtienen como resultado de compilaciones de dispositivos, por lo que es deseable haber completado las secciones anteriores.</p>
<br>
<h4>Entendiendo las capas de compilación</h4>
<p style="text-align:justify;">El sistema de compilado AOSP incluye unas capas de abstracción para compilar un dispositivo. Entender las ideas detrás de estas capas, será de utilidad para entender la relación de
los distintos Makefiles para un dispositivo. Hay tres capas en el sistema de construcción del dispositivo: Producto, Placa/Dispositivo y Arquitectura. Estas capas se pueden considerar como diferentes dimensiones para medir la característica de un producto. Cada capa se relaciona con la anterior en una relación de uno a muchos, que es similar a la relación de herencia o composición en los términos orientados a objetos. Por ejemplo, un tipo de arquitectura de hardware puede tener más de una placa y cada placa puede tener más de un producto. <a href="https://www.packtpub.com/product/android-system-programming/9781787125360">[12]</a></p>
<ul>
<li style="text-align:justify;"><b>Product:</b> La capa Producto define las especificaciones de características del producto de envío como los módulos a construir, las configuraciones regionales admitidas y la configuración para varios locales. En otras palabras, este es el nombre del producto en general. Las variables específicas del producto se definen en los Makefiles de definición de productos. UN
producto puede heredar de otras definiciones de productos, lo que simplifica mantenimiento. Un método común es crear un producto base que contenga características que se aplican a todos los productos, luego crear variantes de productos basadas en ese producto base.</li>
<li style="text-align:justify;"><b>Board/Device:</b> La capa Placa/Dispositivo representa la capa física de plástico en el dispositivo (es decir, el diseño industrial del dispositivo). Por ejemplo, los dispositivos estadounidenses probablemente incluyen teclados QWERTY, mientras que los dispositivos vendidos en Francia probablemente incluyan teclados AZERTY. Esta capa también representa los esquemas básicos de un producto. Éstos incluyen los periféricos de la placa y su configuración.</li>
<li style="text-align:justify;"><b>Arch:</b> La capa de Arquitectura describe la configuración del procesador y Interfaz binaria de aplicación (ABI) ejecutándose en la placa.</li>
</ul>
<br>
<h4>Variantes de compilación</h4>
<p style="text-align:justify;">Hay principalmente tres tipos de variantes de construcción AOSP. La compilación de ingeniería es la predeterminada y es adecuada para el desarrollo. En este tipo de compilación, la política de seguridad del producto no se aplica por completo y los mecanismos de depuración están activados. Es fácil para los ingenieros probar y solucionar problemas con una compilación de ingeniería. El segundo tipo es la compilación del usuario, que se usa para la versión final. Todos los mecanismos de depuración están desactivados y la política de seguridad del producto se aplica por completo. El tercer sabor es userdebug, que se encuentra entre la compilación de ingeniería y la compilación del usuario. Este tipo de compilación se puede utilizar en la prueba de campo, que también la pueden utilizar los usuarios finales. <a href="https://www.packtpub.com/product/android-system-programming/9781787125360">[12]</a>

</p>
<br>

<h4>Archivos Makefile</h4>
<p style="text-align:justify;">Las definiciones de cada dispositivo dentro del repositorio AOSP se encuentran en la carpeta <code>device</code>. Estas definiciones se realizan a partir de archivos makefile los cuales hacen referencia a las capas de compilación. Convencionalmente la ruta en donde se ubican los makefiles de cada dispositivo sigue un formato <code>device/device-vendor/device-name</code>; Por ejemplo, en el caso del dispositivo cuttlefish, sabemos que su creador o fabricante es Google, por tanto, la ruta donde se encuentran sus archivos makefile vendría siendo <code>device/google/cuttlefish/</code>. Teniendo lo anterior en cuenta, por fines prácticos estableceremos que el fabricante es marco_tulio y el nombre del dispositivo es MarcoTulioOS, por tanto, la ruta en la cual se crearán los archivos makefile es <code>device/marco_tulio/MarcoTulioOS/</code>. A continuación se muestran los archivos makefile necesarios para la creación de nuestro dispositivo:
</p>
<h4>AndroidProducts.mk</h4>
<p style="text-align:justify;">En este archivo incluimos todos los Makefiles de definición de productos. El sistema de compilación AOSP se iniciará para buscar todas las definiciones de productos utilizando este archivo. En nuestro caso el archivo AndroidProducts.mk se encuentra en la raíz con el siguiente contenido:</p>

```makefile
PRODUCT_MAKEFILES := \
    aosp_cf_marcotulio_os_x86_phone:$(LOCAL_DIR)/vsoc_x86/phone/device.mk
```
<h4>device.mk</h4>
<p style="text-align:justify;">Este archivo sobreescribe algunas propiedades y copia los archivos de configuración a la carpeta del sistema. También incluye las capas HAL. Con respecto a este archivo, convencionalmente se suele crear más de uno con el fin de heredar algunas propiedades en varios dispositivos. Por ejemplo, los dispositivos cuttlefish pueden ser de arquitectura x86 o x86_64, por tanto, existe un archivo device.mk con las definiciones que comparten ambas arquitecturas y tambien se crea otro archivo device.mk por cada arquitectura con sus propiedades especificas. En nuestro caso se crearon tres archivos device.mk en rutas diferentes. El primero, el cual se encuentra en la ruta <code>MarcoTulioOS/vsoc_x86/phone/</code> es al que se hace referencia en el archivo AndroidProducts.mk. Este contiene las definiciones específicas para un teléfono cuttlefish de arquitectura x86 (ya que también hay otras opciones como: auto, tablet, placa, etc). En este archivo también se hace el llamado a los otros dos archivos device.mk.</p>


```makefile

$(call inherit-product, device/marco_tulio/MarcoTulioOS/shared/phone/device.mk)
$(call inherit-product, device/marco_tulio/MarcoTulioOS/vsoc_x86/device.mk)

# Exclude features that are not available on AOSP devices.
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/aosp_excluded_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/aosp_excluded_hardware.xml

PRODUCT_NAME := aosp_cf_marcotulio_os_x86_phone
PRODUCT_DEVICE := vsoc_x86
PRODUCT_MODEL := Marco Tulio's Cuttlefish x86 phone
PRODUCT_PACKAGE_OVERLAYS := device/marco_tulio/MarcoTulioOS/vsoc_x86/phone/overlay

```
<p style="text-align:justify;">El segundo se encuentra en la ruta <code>MarcoTulioOS/shared/phone</code> y hace referencia a las definiciones comunes en todas las arquitecturas (x86 o x86_64) de un telefono cuttlefish.</p>

```makefile
PRODUCT_SHIPPING_API_LEVEL := 28
TARGET_USES_MKE2FS := true

DISABLE_RILD_OEM_HOOK := true

AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    product \
    system \
    vendor

PRODUCT_PACKAGES += \
    update_engine \
    update_verifier

# Properties that are not vendor-specific. These will go in the product
# partition, instead of the vendor partition, and do not need vendor
# sepolicy
PRODUCT_PRODUCT_PROPERTIES := \
    persist.adb.tcp.port=5555 \
    persist.traced.enable=1 \
    ro.com.google.locationfeatures=1 \
 
# Explanation of specific properties:
#   debug.hwui.swap_with_damage avoids boot failure on M http://b/25152138
#   ro.opengles.version OpenGLES 3.0
PRODUCT_PROPERTY_OVERRIDES += \
    tombstoned.max_tombstone_count=500 \
    bt.rootcanal_test_console=off \
    debug.hwui.swap_with_damage=0 \
    ro.carrier=unknown \
    ro.com.android.dataroaming=false \
    ro.hardware.virtual_device=1 \
    ro.logd.size=1M \
    ro.opengles.version=196608 \
    wifi.interface=wlan0 \

# Below is a list of properties we probably should get rid of.
PRODUCT_PROPERTY_OVERRIDES += \
    wlan.driver.status=ok

# aes-256-heh default is not supported in standard kernels.
PRODUCT_PROPERTY_OVERRIDES += ro.crypto.volume.filenames_mode=aes-256-cts

# P doesn't have APEX modules, but for Q/R compatibiltiy testing, claim
# to support updatable APEX, as the P kernel does support it
PRODUCT_PROPERTY_OVERRIDES += ro.apex.updatable=true

# Packages for various GCE-specific utilities
#
PRODUCT_PACKAGES += \
    socket_vsock_proxy \
    CuttlefishService \
    wpa_supplicant.vsoc.conf \
    vsoc_input_service \
    rename_netiface \
    ip_link_add \
    setup_wifi \

#
# Packages for AOSP-available stuff we use from the framework
#
PRODUCT_PACKAGES += \
    e2fsck \
    ip \
    sleep \
    tcpdump \
    wpa_supplicant \
    wificond \

#
# Packages for the OpenGL implementation
#

# SwiftShader provides a software-only implementation that is not thread-safe
PRODUCT_PACKAGES += \
    libEGL_swiftshader \
    libGLESv1_CM_swiftshader \
    libGLESv2_swiftshader

# GL implementation for virgl
PRODUCT_PACKAGES += \
    libGLES_mesa

DEVICE_PACKAGE_OVERLAYS := device/marco_tulio/MarcoTulioOS/shared/overlay
PRODUCT_AAPT_CONFIG := normal large xlarge hdpi xhdpi
# PRODUCT_AAPT_PREF_CONFIG is intentionally not set to pick up every density resources.

#
# General files
#
PRODUCT_COPY_FILES += \
    device/marco_tulio/MarcoTulioOS/shared/config/audio_policy.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy.conf \
    device/marco_tulio/MarcoTulioOS/shared/config/camera_v3.json:$(TARGET_COPY_OUT_VENDOR)/etc/config/camera.json \
    device/marco_tulio/MarcoTulioOS/shared/config/init.vendor.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.cutf_cvm.rc \
    device/marco_tulio/MarcoTulioOS/shared/config/init.product.rc:$(TARGET_COPY_OUT_PRODUCT)/etc/init/init.rc \
    device/marco_tulio/MarcoTulioOS/shared/config/ueventd.rc:$(TARGET_COPY_OUT_VENDOR)/ueventd.rc \
    device/marco_tulio/MarcoTulioOS/shared/config/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    device/marco_tulio/MarcoTulioOS/shared/config/media_codecs_google_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video.xml \
    device/marco_tulio/MarcoTulioOS/shared/config/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml \
    device/marco_tulio/MarcoTulioOS/shared/config/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml \
    device/marco_tulio/MarcoTulioOS/shared/permissions/cuttlefish_excluded_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/cuttlefish_excluded_hardware.xml \
    frameworks/av/media/libeffects/data/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_telephony.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_configuration_generic.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/primary_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/primary_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml \
    frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.sensor.ambient_temperature.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.ambient_temperature.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml \
    system/bt/vendor_libs/test_vendor_lib/data/controller_properties.json:vendor/etc/bluetooth/controller_properties.json \

#
# The fstab requires special handling. For system-as-root builds, we *must*
# retrieve the vendor partition mount options from DTB, as system must be
# "pristine" to support GSI.
#
PRODUCT_COPY_FILES += \
    device/marco_tulio/MarcoTulioOS/shared/config/fstab:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.cutf_cvm \

# Packages for HAL implementations

#
# Hardware Composer HAL
#
PRODUCT_PACKAGES += \
    hwcomposer.drm_minigbm \
    hwcomposer.cutf_cvm_ashmem \
    hwcomposer-stats \
    android.hardware.graphics.composer@2.2-impl \
    android.hardware.graphics.composer@2.2-service

#
# Gralloc HAL
#
PRODUCT_PACKAGES += \
    gralloc.minigbm \
    gralloc.cutf_ashmem \
    android.hardware.graphics.mapper@2.0-impl-2.1 \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service

#
# Bluetooth HAL and Compatibility Bluetooth library (for older revs).
#
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.0-service.sim \
    android.hardware.bluetooth.a2dp@1.0-impl


#
# Audio HAL
#
PRODUCT_PACKAGES += \
    audio.primary.cutf \
    audio.r_submix.default \
    android.hardware.audio@4.0-impl:32 \
    android.hardware.audio.effect@4.0-impl:32 \
    android.hardware.audio@2.0-service \
    android.hardware.soundtrigger@2.0-impl \

#
# Drm HAL
#
PRODUCT_PACKAGES += \
    android.hardware.drm@1.0-impl \
    android.hardware.drm@1.0-service \
    android.hardware.drm@1.1-service.clearkey

#
# Dumpstate HAL
#
PRODUCT_PACKAGES += \
    android.hardware.dumpstate@1.0-service.cuttlefish

#
# Camera
#
PRODUCT_PACKAGES += \
    camera.cutf \
    camera.cutf.jpeg \
    camera.device@3.2-impl \
    android.hardware.camera.provider@2.4-impl \
    android.hardware.camera.provider@2.4-service

#
# Gatekeeper
#
PRODUCT_PACKAGES += \
    gatekeeper.cutf \
    android.hardware.gatekeeper@1.0-impl \
    android.hardware.gatekeeper@1.0-service

#
# GPS
#
PRODUCT_PACKAGES += \
    gps.cutf \
    android.hardware.gnss@1.0-impl \
    android.hardware.gnss@1.0-service

# Health
PRODUCT_PACKAGES += \
    android.hardware.health@2.0-service.cuttlefish

#
# Sensors
#
PRODUCT_PACKAGES += \
    sensors.cutf \
    android.hardware.sensors@1.0-impl \
    android.hardware.sensors@1.0-service

#
# Lights
#
PRODUCT_PACKAGES += \
    lights.cutf \
    android.hardware.light@2.0-impl \
    android.hardware.light@2.0-service

#
# Keymaster HAL
#
PRODUCT_PACKAGES += \
     android.hardware.keymaster@4.0-impl \
     android.hardware.keymaster@4.0-service

#
# Power HAL
#
PRODUCT_PACKAGES += \
    android.hardware.power@1.0-impl \
    android.hardware.power@1.0-service

#
# NeuralNetworks HAL
#
PRODUCT_PACKAGES += \
    android.hardware.neuralnetworks@1.1-service-sample-all \
    android.hardware.neuralnetworks@1.1-service-sample-float-fast \
    android.hardware.neuralnetworks@1.1-service-sample-float-slow \
    android.hardware.neuralnetworks@1.1-service-sample-minimal \
    android.hardware.neuralnetworks@1.1-service-sample-quant

#
# USB
PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-service

# TODO vibrator HAL
# TODO thermal

# BootControl HAL
PRODUCT_PACKAGES += \
    bootctrl.bcb \
    android.hardware.boot@1.0-impl \
    android.hardware.boot@1.0-impl.recovery \
    android.hardware.boot@1.0-service

PRODUCT_PACKAGES += \
    cuttlefish_dtb

# WLAN driver configuration files
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf

# Recovery mode
ifneq ($(TARGET_NO_RECOVERY),true)

PRODUCT_COPY_FILES += \
    device/marco_tulio/MarcoTulioOS/shared/config/init.recovery.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.cutf_cvm.rc \

endif

# Host packages to install
PRODUCT_HOST_PACKAGES += socket_vsock_proxy
```
<p style="text-align:justify;">El tercer y último device.mk se encuentra en la ruta <code>MarcoTulioOS/vsoc_x86</code> y hace referencia a las definiciones comunes para todos los tipos de dispositivo cuttlefish (teléfono, tablet, placa, auto, etc) independientemente de su arquitectura.</p>

```makefile
PRODUCT_COPY_FILES += device/google/cuttlefish_kernel/4.14-x86_64/kernel-4.14:kernel
```

<h4>BoardConfig.mk</h4>
<p style="text-align:justify;">BoardConfig.mk define las configuraciones específicas de la placa. Define el CPU/ABI, la arquitectura, configuraciones de OpenGLES, etc. También define el tamaño del archivo de imagen, formato, entre otros. En nuestro caso el archivo BoardConfig.mk se encuentra en la ruta <code>MarcoTulioOS/shared</code> con el siguiente contenido:</p>

```makefile
TARGET_BOOTLOADER_BOARD_NAME := cutf

# Boot partition size: 32M
# This is only used for OTA update packages. The image size on disk
# will not change (as is it not a filesystem.)
BOARD_BOOTIMAGE_PARTITION_SIZE := 33554432
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 33554432

# Build a separate vendor.img partition
BOARD_USES_VENDORIMAGE := true
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_PARTITION_SIZE := 536870912 # 512MB
TARGET_COPY_OUT_VENDOR := vendor

BOARD_USES_METADATA_PARTITION := true

TARGET_NO_RECOVERY := true

# Build a separate product.img partition
BOARD_USES_PRODUCTIMAGE := true
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_PRODUCTIMAGE_PARTITION_SIZE := 268435456 # 256MB
TARGET_COPY_OUT_PRODUCT := product

# Build a separate odm.img partition
BOARD_USES_ODMIMAGE := true
BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_ODM := odm

# Create a mount point for the system_ext.img partition
BOARD_ROOT_EXTRA_FOLDERS := system_ext

BOARD_BUILD_SYSTEM_ROOT_IMAGE := true
BOARD_USES_GENERIC_AUDIO := false
USE_CAMERA_STUB := true
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := true
TARGET_USES_64_BIT_BINDER := true

# 64 bit mediadrmserver
TARGET_ENABLE_MEDIADRM_64 := true

# Hardware composer configuration
TARGET_USES_HWC2 := true

# The compiler will occasionally generate movaps, etc.
BOARD_MALLOC_ALIGNMENT := 16

BOARD_SYSTEMIMAGE_PARTITION_SIZE := 5368709120 # 5 GB
# Make the userdata partition 4.25G to accommodate ASAN and CTS
BOARD_USERDATAIMAGE_PARTITION_SIZE := 4563402752

# Cache partition size: 64M
BOARD_CACHEIMAGE_PARTITION_SIZE := 67108864
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4

BOARD_DRM_HWCOMPOSER_BUFFER_IMPORTER := minigbm
BOARD_USES_DRM_HWCOMPOSER := true
BOARD_USES_MINIGBM := true
BOARD_GPU_DRIVERS := virgl
# This prevents mesa3d from unconditionally pulling in some modules
BOARD_USE_CUSTOMIZED_MESA := true

# Minimum size of the final bootable disk image: 10G
# GCE will pad disk images out to 10G. Our disk images should be at least as
# big to avoid warnings about partition table oddities.
BOARD_DISK_IMAGE_MINIMUM_SIZE := 10737418240

BOARD_BOOTIMAGE_MAX_SIZE := 8388608
BOARD_SYSLOADER_MAX_SIZE := 7340032
# TODO(san): See if we can get rid of this.
BOARD_FLASH_BLOCK_SIZE := 512

WITH_DEXPREOPT := true

USE_OPENGL_RENDERER := true

# Wifi.
BOARD_WLAN_DEVICE           := wlan0
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
WPA_SUPPLICANT_VERSION      := VER_0_8_X
WIFI_DRIVER_FW_PATH_PARAM   := "/dev/null"
WIFI_DRIVER_FW_PATH_STA     := "/dev/null"
WIFI_DRIVER_FW_PATH_AP      := "/dev/null"

BOARD_SEPOLICY_DIRS += device/google/cuttlefish/shared/sepolicy/private
BOARD_SEPOLICY_DIRS += device/google/cuttlefish/shared/sepolicy/vendor

# master has breaking changes in dlfcn.h, but the platform SDK hasn't been
# bumped. Restore the line below when it is.
VSOC_VERSION_CFLAGS := -DVSOC_PLATFORM_SDK_VERSION=28
# VSOC_VERSION_CFLAGS := -DVSOC_PLATFORM_SDK_VERSION=${PLATFORM_SDK_VERSION}
VSOC_STLPORT_INCLUDES :=
VSOC_STLPORT_LIBS :=
VSOC_STLPORT_STATIC_LIBS :=
VSOC_TEST_INCLUDES := external/googletest/googlemock/include external/googletest/googletest/include
VSOC_TEST_LIBRARIES := libgmock_main_host libgtest_host libgmock_host
VSOC_LIBCXX_STATIC := libc++_static
VSOC_PROTOBUF_SHARED_LIB := libprotobuf-cpp-full

CUTTLEFISH_LIBRIL_NAME := libril

# TODO(ender): Remove all these once we stop depending on GCE code.
GCE_VERSION_CFLAGS := -DGCE_PLATFORM_SDK_VERSION=${PLATFORM_SDK_VERSION}
GCE_STLPORT_INCLUDES := $(VSOC_STLPORT_INCLUDES)
GCE_STLPORT_LIBS := $(VSOC_STLPORT_LIBS)
GCE_STLPORT_STATIC_LIBS := $(VSOC_STLPORT_STATIC_LIBS)
GCE_TEST_INCLUDES := $(VSOC_TEST_INCLUDES)
GCE_TEST_LIBRARIES := $(VSOC_TEST_LIBRARIES)
GCE_LIBCXX_STATIC := $(VSOC_LIBCXX_STATIC)
GCE_PROTOBUF_SHARED_LIB := $(VSOC_PROTOBUF_SHARED_LIB)
# TODO(ender): up till here.

STAGEFRIGHT_AVCENC_CFLAGS := -DANDROID_GCE

INIT_BOOTCHART := true

# Need this so that the application's loop on reading input can be synchronized
# with HW VSYNC
TARGET_RUNNING_WITHOUT_SYNC_FRAMEWORK := true

# Settings for dhcpcd-6.8.2.
DHCPCD_USE_IPV6 := no
DHCPCD_USE_DBUS := no
DHCPCD_USE_SCRIPT := yes

USE_XML_AUDIO_POLICY_CONF := 1

BOARD_VNDK_VERSION := current

# TODO(b/73078796): remove
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true

TARGET_NO_RECOVERY ?= true
TARGET_RECOVERY_PIXEL_FORMAT := ABGR_8888
TARGET_RECOVERY_FSTAB ?= device/google/cuttlefish/shared/config/fstab.recovery

# To see full logs from init, disable ratelimiting.
# The default is 5 messages per second amortized, with a burst of up to 10.
BOARD_KERNEL_CMDLINE += printk.devkmsg=on
```
<p style="text-align:justify;">Además de las variables a nivel de producto, también hay variables para el dispositivo de destino y las variables a nivel de placa. Para simplificar el articulo no se brindara información detallada sobre estas variables, sin embargo motivamos a consultar la documentación oficial de AOSP para conocer la utilidad de cada variable.
</p><br>
<h4>Otros archivos importantes</h4>
<p style="text-align:justify;">Además de los archivos makefile también se recomienda copiar completamente en la raíz de nuestro dispositivo, la carpeta shared que se encuentra en la ruta <code>device/google/cuttlefish</code>. Esta carpeta contiene dependencias de algunas definiciones de variables en los archivos makefiles. También incluye carpetas y archivos que permitirán la personalización del sistema en futuras compilaciones, tales como, la carpeta <code>overlay</code> y <code>framework</code>. En caso de que se quiera tener una referencia más precisa sobre la estructura de archivos utilizada para crear el dispositivo, se puede consultar nuestro repositorio en Github. <a href="https://github.com/martulioruiz/MarcoTulioOS">Ir a repositorio</a>
</p>
<br>
<h4>Compilando dispositivo</h4>
<p style="text-align:justify;">Para compilar nuestro dispositivo seguimos los mismos pasos mencionados en secciones anteriores. Cuando utilicemos el comando <code>lunch</code> deberá aparecer nuestro dispositivo en la lista.
</p>
<p style="text-align:center;">Figura 13</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/newDeviceLunch.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Dispositivo aosp_cf_marcotulio_os_x86_phone-userdebug disponible para ser compilado.</i></p>
<p style="text-align:center;">Figura 14</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/newDeviceTarget.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Dispositivo aosp_cf_marcotulio_os_x86_phone-userdebug seleccionado para ser compilado.</i></p>
<br>
<h4>Probando dispositivo</h4>
<p style="text-align:justify;">Una vez que termine de compilar el dispositivo, utilizamos los artefactos resultantes para correr el dispositivo cuttlefish. Una forma de verificar que la creación de nuestro propio dispositivo se realizó correctamente es revisando los datos en <code>Ajustes->Acerca del teléfono</code>.
</p>
<p style="text-align:center;">Figura 15</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/newDeviceEmulator.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Verificando número de compilación y modelo del propio dispositivo.</i></p>

<br><br>
<h3>Creando distribución</h3>
<p style="text-align:justify;">Una vez que tengamos nuestro dispositivo propio podremos agregar servicios y aplicaciones así como modificar interfaz, permisos y configuraciones, entre otros. En esta sección se muestran los pasos y definiciones para la creación de una distribución linux basada en el código AOSP con orientación a aplicaciones para la virtualización en dispositivos Android. </p>
<br>
<h4>Distribución y Personalización</h4>
<p style="text-align:justify;">En la comunidad Android popularmente a las imágenes destinadas a ser flasheadas en dispositivos físicos se les suele llamar ROMs Personalizadas. El término ROM (Read-Only-Memory) en teoría de Sistemas Operativos hace referencia a una memoria que no puede ser modificada y cuyos datos o información es definida por el fabricante del dispositivo. En la mayoría de dispositivos Android (físicos), el sistema original como tal es compilado y copiado en una memoria ROM. Teniendo en cuenta que un Sistema Personalizado al ser flasheado en un dispositivo físico reemplaza al sistema original que se encuentra en la memoria ROM, por esa razón se le suele llamar popularmente como ROM personalizada. En nuestro caso, a pesar de que en efecto realizamos personalizaciones a una imagen genérica de android (GSI) y que esta podría ser flasheada en un dispositivo físico o virtual, consideramos más apropiado el término distribución para referirnos al conjunto de imágenes resultantes de la compilación de nuestro dispositivo AOSP.</p>
<p style="text-align:justify;">Una distribución de Linux es un sistema operativo compilado a partir de componentes desarrollados por varios proyectos y programadores de código abierto. Cada distribución incluye el kernel de Linux (la base del sistema operativo), las utilidades de shell de GNU (la interfaz de terminal y los comandos), el servidor X (para un escritorio gráfico), el entorno de escritorio, un sistema de administración de paquetes, un instalador y otros. servicios. Muchos componentes se desarrollan independientemente unos de otros y se distribuyen en forma de código fuente. Las distribuciones también incluyen un navegador de Internet, herramientas de administración y otro software como el hipervisor KVM. Una sola distribución de Linux puede contener miles de paquetes de software, utilidades y aplicaciones.

Las distribuciones de Linux compilan código de proyectos de código abierto y lo combinan en un solo sistema operativo que se puede instalar y arrancar. Las distribuciones de Linux están disponibles para computadoras de escritorio, para servidores sin interfaz gráfica, para supercomputadoras, para dispositivos móviles y para usos especiales, como PC de cine en casa y sistemas integrados. Debido a que es un software de código abierto, cualquiera puede crear su propia distribución de Linux ensamblando a partir del código fuente o modificando una distribución existente. Actualmente, se mantienen activamente más de 300 distribuciones de Linux. <a href="https://www.suse.com/suse-defines/definition/linux-distribution/">[13]</a></p>
<br>
<h4>Agregando aplicaciones</h4>
<p style="text-align:justify;">A continuación se mostrará como agregar aplicaciones al repositorio AOSP para que estas sean instaladas en el dispositivo durante el proceso de compilado. Debido a fines prácticos y demostrativos los pasos para la creación de servicios, modificación de permisos e interfaz serán objetivo de futuros artículos. Teniendo en cuenta que la temática de la distribución es orientada a la virtualización, con este propósito se agregan las siguientes aplicaciones:</p>
<ol>
<li style="text-align:justify;"><b>Brave Browser:</b> Brave es un navegador web de código abierto basado en Chromium, creado por la compañía Brave Software</li>
<li style="text-align:justify;"><b>Andronix:</b> Andronix permite instalar un sistema Linux en el dispositivo Android sin root</li>
<li style="text-align:justify;"><b>Termux:</b> Termux es un emulador de terminal de Android y una aplicación de entorno Linux que funciona directamente sin necesidad de enraizamiento o configuración.

</li>
<li style="text-align:justify;"><b>ES Explorer:</b> ES File Explorer es un administrador / explorador de archivos diseñado por ES Global, una subsidiaria de DO Global, para dispositivos Android.</li>
<li style="text-align:justify;"><b>Real VNC Viewer:</b> VNC Viewer convierte su teléfono en un escritorio remoto, brindándole acceso instantáneo a sus computadoras Mac, Windows y Linux</li>
<li style="text-align:justify;"><b>Net Hunter Store:</b> La tienda de aplicaciones Kali NetHunter es un catálogo instalable de aplicaciones de Android para pruebas de penetración y análisis forense.</li>
<li style="text-align:justify;"><b>VMOS:</b> VMOS es un software de aplicación basado en máquina virtual. VMOS se puede instalar en forma de una aplicación normal para el sistema Linux o Android a través de la tecnología VM.</li>
<li style="text-align:justify;"><b>XServer:</b> Servidor X Window System / X11 para Android, completo y totalmente funcional, con servidor PulseAudio incluido</li>
<li style="text-align:justify;"><b>Alpine Term:</b> Alpine Term es una aplicación de terminal y entorno Linux para Android.</li>
<li style="text-align:justify;"><b>Caffeine:</b> Caffeine es una curiosa aplicación gratuita para dispositivos Android que impide que nuestro móvil o tableta entre en estado de “sueño”.</li>
</ol>
<p style="text-align:justify;">Las aplicaciones que nos ofrece por defecto el repositorio AOSP se pueden encontrar en la ruta <code>aosp/packages/apps/</code>. Las aplicaciones pueden ser incluidas en dos formatos: App Bundle o directamente como un APK. Un Android App Bundle es el formato oficial (con la extensión .aab) en que se sube la aplicación a Google Play. Los paquetes de aplicaciones son objetos binarios firmados que organizan el código y los recursos de la app en módulos. El código y los recursos de cada módulo se organizan de manera similar al contenido de un APK, en donde cada uno de los módulos puede generarse como un APK independiente. En nuestro caso utilizaremos un único APK por aplicación.</p>
<p style="text-align:justify;">Para agregar nuestras propias aplicaciones debemos crear una carpeta por aplicación en el directorio <code>aosp/packages/apps/</code> y dentro de ella debemos copiar el archivo .apk junto con un archivo makefile llamado <code>Android.mk</code>; En este archivo se realizan las definiciones necesarias para que se instale la aplicación durante el proceso de compilado.</p>
<p style="text-align:justify;">Otra alternativa para agregar aplicaciones (la cual es la que se utiliza en este proyecto) y realizar otras modificaciones al sistema sin alterar las carpetas originales del repositorio AOSP es haciendo uso de <code>overlays</code>. Las superposiciones (overlays) funcionan asignando recursos definidos en el paquete de superposición a recursos definidos en el paquete de destino. Cuando una aplicación intenta resolver el valor de un recurso en el paquete de destino, en su lugar, se devuelve el valor del recurso superpuesto al que está asignado el recurso de destino. Es decir, si nosotros agregamos la aplicacion Google Chrome Browser a la ruta <code>aosp/packages/apps/</code> y también la agregamos con otras configuraciones a la ruta <code>device-name/overlay/packages/apps/</code>, se instalará la que se encuentra en la carpeta overlay. Para que nuestro dispositivo reconozca la carpeta overlay, esta se deberá definir en el archivo <code>device.mk</code> de la siguiente forma:
</p>

```makefile
PRODUCT_PACKAGE_OVERLAYS := device/marco_tulio/MarcoTulioOS/vsoc_x86/phone/overlay
```
<p style="text-align:justify;">Una vez definida la carpeta overlay, podemos agregar nuestras aplicaciones en una carpeta independiente al repositorio AOSP. Suponiendo que queremos agregar la aplicación Termux: Lo primero que debemos hacer es descargar el archivo apk y copiarlo a una carpeta en la ruta <code>overlay/packages/apps/</code> por ejemplo <code>device/marco_tulio/MarcoTulioOS/vsoc_x86/phone/overlay/packages/apps/Termux</code>; Luego deberemos crear el correspondiente archivo <code>Android.mk</code> el cual en este caso tendría la siguiente estructura:
</p>

```makefile
LOCAL_PATH := $(call my-dir)

my_archs := arm x86 arm64
my_src_arch := $(call get-prebuilt-src-arch, $(my_archs))

include $(CLEAR_VARS)
LOCAL_MODULE := Termux
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_TAGS := optional
LOCAL_BUILT_MODULE_STEM := package.apk
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_SRC_FILES := Termux.apk

LOCAL_PREBUILT_JNI_LIBS := \
  @lib/x86/libtermux-bootstrap.so \
  @lib/x86/libtermux.so

LOCAL_MODULE_TARGET_ARCH := $(my_src_arch)

include $(BUILD_PREBUILT)
```
<p style="text-align:justify;">Existen herramientas que nos permiten generar estos archivos <code>Android.mk</code> dependiendo del apk, como por ejemplo <a href="https://github.com/northbright/genandroidmk">genandroidmk</a>. Es importante mencionar que el archivo .apk debe tener soporte para la misma arquitectura del dispositivo físico o virtual (en nuestro caso x86).</p>
<p style="text-align:justify;">Finalmente, debemos definir la aplicación en el dispositivo. Para ello nos vamos al archivo <code>device.mk</code> donde definimos la carpeta overlay y agregamos lo siguiente:.</p>

```makefile
PRODUCT_PACKAGES += \
    Termux
```
<p style="text-align:center;">Figura 16</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/listApps.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Menú de aplicaciones de la distribución.</i></p>
<p style="text-align:center;">Figura 17</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/termuxAsSystem.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Termux instalada como aplicación de sistema.</i></p>
<br><br>

<h3>Caso de Uso con Virtualización Anidada</h3>
<p style="text-align:justify;">Para demostrar la potencia, capacidad y variedad de posibilidades que ofrece nuestra distribución y el dispositivo virtual de Android en general, se propuso como meta comprobar si es posible: Correr otros Sistemas Operativos en Android utilizando tecnologías de virtualización e iniciar servicios que usualmente se utilizan en entornos de escritorio. Para lograr la meta el equipo de desarrollo llegó a la conclusión de que el dispositivo virtual de Android Cuttlefish debía tener soporte para la virtualización anidada, esto debido a que como tal el dispositivo virtual es una Máquina Virtual cuyo hardware es emulado por QEMU o CrosVM. 
</p>
<p style="text-align:justify;">Según Google Cloud <a href="https://cloud.google.com/compute/docs/instances/nested-virtualization/overview">[14]</a> La virtualización anidada permite ejecutar instancias de máquinas virtuales (VM) dentro de otras VM para crear entornos de virtualización propios. Para admitir la virtualización anidada, Compute Engine por ejemplo agrega instrucciones Intel VT-x a las máquinas virtuales, de modo que cuando se crea una máquina virtual, el hipervisor que ya está en esa máquina virtual puede ejecutar máquinas virtuales adicionales. Las máquinas virtuales de Compute Engine se ejecutan en un host físico que tiene el hipervisor basado en KVM reforzado con seguridad de Google. Con la virtualización anidada, el host físico y su hipervisor son el entorno de nivel 0 (L0). El entorno L0 puede alojar varias máquinas virtuales de nivel 1 (L1). En cada máquina virtual L1 hay otro hipervisor, que se utiliza para instalar las máquinas virtuales de nivel 2 (L2). En nuestro caso el entorno L0 es el dispositivo virtual cuttlefish de Android. Teniendo en cuenta que el Sistema Android está basado en el Kernel de Linux, se puede concluir que este dispone del hipervisor KVM al igual que la mayoría de distribuciones Linux actuales. El entorno L1 podría ser una distribución linux y el entorno L2 un contenedor virtual que permita la implementación de algún servicio.</p>

<p style="text-align:justify;">KVM (Máquina Virtual basada en Kernel) es una solución de virtualización completa para Linux en hardware x86 que contiene extensiones de virtualización (Intel VT o AMD-V). Consiste en un módulo de kernel cargable, kvm.ko, que proporciona la infraestructura de virtualización central y un módulo específico del procesador, kvm-intel.ko o kvm-amd.ko. Con KVM, se pueden ejecutar varias máquinas virtuales que ejecutan imágenes de Linux o Windows sin modificar. Cada máquina virtual tiene un hardware virtualizado privado: una tarjeta de red, un disco, un adaptador de gráficos, etc. KVM es un software de código abierto. El componente kernel de KVM se incluye en la línea principal de Linux, a partir del 2.6.20. El componente de espacio de usuario de KVM se incluye en la línea principal QEMU, a partir de 1.3. <a href="https://www.linux-kvm.org/page/Main_Page">[15]</a>
 </p>
 <br>
 <h4>Enunciado y procedimiento</h4>
<p style="text-align:justify;">A continuación se muestran los pasos realizados para crear una Maquina Virtual con la distribución Alpine Linux en nuestro dispositivo virtual Cuttlefish utilizando QEMU. De la misma forma en la Máquina Virtual Alpine Linux se instalará docker el cual será utilizado para crear un contenedor con un servidor que permita la implementación de un servicio dentro del dispositivo Android (En nuestro caso un servidor de Jekyll para la implementación de un blog). Es importante mencionar que muchos de estos pasos son de conocimiento gracias al aporte del usuario en youtube Motoots. <a href="https://www.youtube.com/watch?v=RL96VSKzAQo">[16]</a></p>

<p style="text-align:justify;">Lo primero que debemos hacer es asegurarnos de tener instalado Termux. En nuestro caso Termux forma parte de las aplicaciones del sistema en la distribución. Una vez en termux actualizamos el gestor de paquetes:</p>

```bash
pkg update && pkg upgrade
```
<p style="text-align:justify;">Luego instalamos QEMU utilizando el siguiente comando:</p>
```bash
pkg install qemu-system-x86-64-headless qemu-utils
```
<p style="text-align:justify;">Instalamos wget y obtenemos Alpine Linux:</p>
```bash
pkg install wget
```
```bash
mkdir qemu
```
```bash
cd qemu
```
```bash
wget https://dl-cdn.alpinelinux.org/alpine/v3.13/releases/x86_64/alpine-virt-3.13.2-x86_64.iso
```
<p style="text-align:justify;">Después creamos una imagen qemu para la instalación:</p>
```bash
qemu-img create -f qcow2 alpine.qcow2 7G
```
<p style="text-align:justify;">Arrancamos la imagen de instalación con el siguiente comando:</p>
```bash
qemu-system-x86_64 -smp 2 -m 2048 \
  -drive file=alpine.qcow2,if=virtio \
  -netdev user,id=n1,hostfwd=tcp::6379-:6379,hostfwd=tcp::9000-:9000 \
  -device virtio-net,netdev=n1 \
  -cdrom alpine-virt-3.13.2-x86_64.iso -boot d \
  -nographic
```
<p style="text-align:justify;">Nos logueamos como usuario root y ejecutamos el comando <code>setup-alpine</code>. Realizamos la respectiva configuración por defecto para instalar alpine linux. Una vez que hayamos terminado el proceso de configuración, apagamos la máquina virtual"</p>
```bash
poweroff
```
<p style="text-align:justify;">Después, volvemos a correr linux pero sin la imagen de instalación:</p>
```bash
qemu-system-x86_64 -smp 2 -m 2048 \
  -drive file=alpine.qcow2,if=virtio \
  -netdev user,id=n1,hostfwd=tcp::6379-:6379,hostfwd=tcp::9000-:9000 \
  -device virtio-net,netdev=n1 \
  -nographic
```
<p style="text-align:justify;">Hasta este punto ya tendremos lista nuestra Máquina Virtual con Alpine Linux.</p>

<p style="text-align:center;">Figura 18</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/neofetch.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Máquina Virtual Alpine Linux creada con QEMU en Termux.</i></p>

<p style="text-align:justify;">Instalamos docker e iniciamos el servicio:</p>

```shell
apk add docker
```
```shell
service docker start
```
<p style="text-align:center;">Figura 19</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/dockerStarted.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Servicio de Docker activo en VM Alpine Linux.</i></p>

<p style="text-align:justify;">Creamos un contenedor en Docker con un servicio de prueba. En nuestro caso, utilizamos un archivo de procesamiento por lotes que contiene todos los comandos necesarios para crear un contenedor basado en Ubuntu el cual implementa automáticamente un servidor de blog Jekyll.</p>

<p style="text-align:center;">Figura 20</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/setupBlog.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Creando contenedor Ubuntu con servidor Jekyll.</i></p>

<p style="text-align:center;">Figura 21</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/setupBlog.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Servidor Jekyll corriendo en 0.0.0.0:9000.</i></p>

<p style="text-align:justify;">Para finalizar comprobamos que nuestro blog (o servicio de prueba) está corriendo sin problemas en la dirección <code>0.0.0.0:9000/my_blog</code> con el navegador Brave.</p>

<p style="text-align:center;">Figura 22</p>
<img src="https://raw.githubusercontent.com/martulioruiz/my_blog/main/docs/assets/showBlog.png" style="display: block; margin-left: auto; margin-right: auto; width: 50%;">
<p style="text-align:center; "><i>Nota. Servidor Jekyll corriendo en 0.0.0.0:9000.</i></p>

<br><br>
<h2 style="text-align:center;">BIBLIOGRAFIAS</h2>
1. Set up for Android Development. | (s. f.). Android Open Source Project. |<a href="https://source.android.com/setup/intro">Enlace a la pagina</a>
2. Adding a New Device.|(s. f.). Android Open Source Project.|<a href="https://source.android.com/setup/develop/new-device#build-layers">Enlace a la página</a> 
3. Using Android Emulator Virtual Devices.| (s. f.). Android Open Source Project.|<a href="https://source.android.com/setup/create/avd">Enlace a la pagina</a>
4. Cuttlefish Virtual Android Devices.| (s. f.). Android Open Source Project.|<a href="https://source.android.com/setup/create/cuttlefish">Enlace a la pagina</a>
5. Understanding virtualization.|(s. f.). Red Hat.|<a href="https://www.redhat.com/en/topics/virtualization">Enlace a la pagina</a> 
6. Dell Technologies Blog.|Emulation or virtualization: What’s the difference?.|13 de marzo de 2014.|<a href="https://www.dell.com/en-us/blog/emulation-or-virtualization-what-s-the-difference">Enlace a la pagina</a> 
7. Chirammal, H. D., Mukhedkar, P., & Vettathu, A. (2016). | Mastering KVM Virtualization.| Packt Publishing. |<a href="https://www.packtpub.com/product/mastering-kvm-virtualization-second-edition/9781838828714">Enlace al libro</a>
8. Kroah-Hartman, G. (2007).| Linux Kernel in a Nutshell.| Van Duuren Media.|<a href="http://www.kroah.com/lkn/">Enlace al libro</a>
9. Establishing a Build Environment.|(s. f.). Android Open Source Project.|<a href="https://source.android.com/setup/build/initializing">Enlace a la pagina</a> 
10. device/google/cuttlefish | Git at Google.|<a href="https://android.googlesource.com/device/google/cuttlefish/">Enlace a la pagina</a>  
11. android-cuttlefish/BUILDING.md at main | google/android-cuttlefish.| (s. f.). GitHub.|<a href="https://github.com/google/android-cuttlefish/blob/main/BUILDING.md">Enlace a la pagina</a>
12. Ye, R. (2017).| Android System Programming.| Packt Publishing.| <a href="https://www.packtpub.com/product/android-system-programming/9781787125360">Enlace a la pagina</a>
13. What is a Linux Distribution? | Answer from. (s. f.). SUSE Defines.| <a href="https://www.suse.com/suse-defines/definition/linux-distribution/">Enlace a la pagina</a>
14. About nested virtualization | Compute Engine Documentation |. (s. f.). Google Cloud.| <a href="https://cloud.google.com/compute/docs/instances/nested-virtualization/overview">Enlace a la pagina</a>
15. KVM. (s. f.).| KVM Official Page.|<a href="https://www.linux-kvm.org/page/Main_Page">Enlace a la página</a>
16. Running Docker using QEMU on an Android Device.| (2021, 16 marzo).| [Vídeo]. YouTube.|<a href="https://www.youtube.com/watch?v=RL96VSKzAQo">Enlace al video</a>  
