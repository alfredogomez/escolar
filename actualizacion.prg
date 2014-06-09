PROCEDURE versioncontroller

*-----------------
* --> _verNue
*=================
_verNue= "1406050"
*=================

*-------------------------------------------------------
* CONTROL DE VERSIONES:
*-------------------------------------------------------
* Este módulo lleva un control de las versiones instaladas en los planteles, revisa si
* es necesario hacer actualizaciones en el sistema local y/o en las bases de datos
* y también revisa si existe una versión superior a la instalada en el sitio cobaesenlinea
* en cuyo caso realiza la actualización automática.
*-----------------------------------------------------

oWsh = CREATEOBJECT("wscript.shell")
*-------------
* --> _verFtp
*-------------
SET DEFAULT TO \Escolar\cmdFiles
Arch="ftpVersionCheck.ftp"
Retorno = CHR(13)+CHR(10)
STRTOFILE("open ftp.cobaesenlinea.com"+Retorno,Arch,.F.)
STRTOFILE("victormanriquez@cobaesenlinea.com"+Retorno,Arch,.T.)
STRTOFILE("FTPApplet.jar"+Retorno,Arch,.T.)
STRTOFILE("lcd C:\"+Retorno,Arch,.T.)
STRTOFILE("cd EscolarSistema"+Retorno,Arch,.T.)
STRTOFILE("quote pasv"+Retorno,Arch,.T.)
STRTOFILE("ls * C:\Escolar\cmdFiles\ftpVersion.txt"+Retorno,Arch,.T.)
STRTOFILE("quit"+Retorno,Arch,.T.)
oWsh.Run("ftp -v -s:ftpVersionCheck.ftp", 1, .T.)
IF FILE("ftpVersion.txt")
  _verFtp=SUBSTR(FILETOSTR("ftpVersion.txt"),9,7)
  DELETE FILE "ftpVersion.txt"
ELSE
  * Si el archivo de texto no existe entonces no se descargó de ftp la información y suponemos que no hay internet en
  * el plantel y que el plantel hizo la descarga de la carpeta Escolar de manera manual (no automática)
  * SE IGNORARÁ LA VERSIÓN DEL SITIO Y SE EVITARÁ LA DESCARGA VÍA FTP
  _verFtp=_verNue
ENDIF
IF (_verFtp<_verNue)
  * caso: (_verFtp<_verNue)
  * Si de da el caso de que la versión en el sitio sea menor que la de la carpeta de instalación, 
  * entonces muy probablemente se trate de un error al subir el archivo de instalación en el sitio cobaesenlinea.
  * SE IGNORARÁ LA VERSIÓN DEL SITIO Y SE EVITARÁ LA DESCARGA VÍA FTP  
  _verFtp=_verNue
ENDIF
*-------------
* --> _verIns
*-------------
SQLEXEC(lnhandle,"SELECT TOP 1 ve_version FROM version","VERINST")
_verIns=ALLTRIM(VERINST.ve_version)
FOR i=1 TO LEN(_verIns)
  IF ISALPHA(SUBSTR(_verIns,i,1))
    EXIT
  ENDIF
ENDFOR
IF ((SUBSTR(_verIns,3,1)=="/") OR ((LEN(_verIns)+i)!=15))
  * Si la versión tiene el formato como las versiones de Victor (??/??/????) entonces dejarla en ceros para
  * forzar la descarga de la versión del sitio cobaesenlinea y ejecutar todas las actualizaciones.
  _verIns="0000000"
ELSE
  IF _verFtp<_verIns
  * Si se da el caso de que la versión en el sitio sea menor que la de la versión instalada
  * en el cpu, entonces se ignorará la actualización de la versión.
  _verIns=_verNue
  ENDIF
ENDIF

_SCREEN.CAPTION="Sistema Académico y Escolar 1.0"+SPACE(5)+_Usuario+" Version: "+_verNue
*-------------------------------------------------------------
*   PROCESO DE CONTROL DE VERSIONES:
*-------------------------------------------------------------
IF !((_verFtp==_verNue) AND (_verNue==_verIns))									&& IF#1
  IF !((_verNue==_verFtp) AND (_verNue>_verIns))								&& IF#2
    *--------------------------------------------------------------------------------
    * DESCARGAR E INSTALAR ARCHIVO COMPRIMIDO CON LA CARPETA Escolar A TRAVÉS DE FTP
    *--------------------------------------------------------------------------------
    MSG1="¡Es necesario descargar la nueva versión del sistema!"+CHR(13)
    IF _US_CONTROL>1															&& IF#3
      * Sólo los usuarios en coordinación u oficinas pueden decidir no descargar.
      Abortar=MESSAGEBOX(MSG1+"¿Desea hacer la descarga de la nueva versión ahora?",36,"Descarga...")
    ELSE
      Abortar=0
      IF (_verIns>_verNue)
        MESSAGEBOX("Retroceso de Versión No Permitida !! Se procederá a Descargar la nueva versión.",0+16,"Retroceso de Versión")
      ELSE
        MESSAGEBOX(MSG1+"Se procederá a hacer la descarga de manera automática",0+64,"Actualización")
      ENDIF
    ENDIF 	 																	&& ENDIF#3
    IF Abortar != 7																&& IF#4
      * Descarga la versión nueva de ftp.cobaesenlinea.com
	  Arch="ftpVersionDownload.ftp"
	  STRTOFILE("open ftp.cobaesenlinea.com"+Retorno,Arch,.F.)
	  STRTOFILE("victormanriquez@cobaesenlinea.com"+Retorno,Arch,.T.)
	  STRTOFILE("FTPApplet.jar"+Retorno,Arch,.T.)
	  STRTOFILE("lcd \"+Retorno,Arch,.T.)
	  STRTOFILE("cd EscolarSistema"+Retorno,Arch,.T.)
	  STRTOFILE("binary"+Retorno,Arch,.T.)
	  STRTOFILE("prompt"+Retorno,Arch,.T.)
	  STRTOFILE("quote pasv"+Retorno,Arch,.T.)
	  STRTOFILE("get Escolar_"+_verFtp+".rar"+Retorno,Arch,.T.)
	  STRTOFILE("quit"+Retorno,Arch,.T.)
      * Instalar la nueva versión con un BatchFile en C:\ generado aquí mismo 
      Arch="\Tools\Batch\versionInstall.bat"
      STRTOFILE("@echo off"+Retorno,Arch,.F.)
      STRTOFILE("echo ----------------------------------------------"+Retorno,Arch,.T.)
      STRTOFILE("echo   Porfavor, espere un momento"+Retorno,Arch,.T.)
      STRTOFILE("echo   se esta descargando de internet"+Retorno,Arch,.T.)
      STRTOFILE("echo   el archivo con la nueva version del sistema"+Retorno,Arch,.T.)
      STRTOFILE("echo -----------------------------------------------"+Retorno,Arch,.T.)
      STRTOFILE("ftp -v -s:\Escolar\cmdFiles\ftpVersionDownload.ftp"+Retorno,Arch,.T.)
      STRTOFILE("echo   La version del sistema se ha descargado."+Retorno,Arch,.T.)
      STRTOFILE("taskkill /f /im sistemas.exe"+Retorno,Arch,.T.)
      STRTOFILE("rmdir /S /Q \Escolar"+Retorno,Arch,.T.)
      STRTOFILE("start \Tools\Winrar\winrar.exe x \Escolar_"+_verFtp+".rar \"+Retorno,Arch,.T.)
      STRTOFILE("echo ----------------------------------------------"+Retorno,Arch,.T.)
      STRTOFILE("echo   La version del sistema se ha instalado."+Retorno,Arch,.T.)
      STRTOFILE("set /p DUMMY=Presione la tecla ENTER para continuar..."+Retorno,Arch,.T.)
      STRTOFILE("\Sistemas\sistemas.exe"+Retorno,Arch,.T.)
      STRTOFILE("Exit",Arch,.T.)
      * Cerrar todo antes de salir del sistema para poder instalar en limpio.
      CLOSE DATABASES ALL
      CLOSE TABLES ALL
      CLOSE INDEXES
      CLOSE ALL
      * Ejecutar el batch file para instalar la nueva versión.
      oWsh.Run("\Tools\Batch\versionInstall.bat", 1, .T.)
      * Una vez ejecutado el batch, se sale del sistema y se devuelve al inicio.
    ENDIF																		&& ENDIF#4
  ELSE
    *--------------------------------------------------------------------------------
    * EJECUTAR LAS ACTUALIZACIONES NECESARIAS (UPDATES)
    *--------------------------------------------------------------------------------
    SQLEXEC(lnhandle,"SELECT * FROM DatosGen","GRAL")
    SQLEXEC(lnhandle,"TRUNCATE TABLE version")
    Q="INSERT VERSION VALUES ("+STR(GRAL.gen_zona,1,0)+", "+STR(GRAL.gen_p,3,0)+", '"+DTOC(DATE())+"', '"+_verNue+"')"
    SQLEXEC(lnhandle,Q)
    MESSAGEBOX("Sistema Actualizado con la Version :"+_verNue,0+64,"Aviso...")
    _SCREEN.CAPTION="Sistema Académico y Escolar 1.0"+SPACE(5)+_Usuario+" Version: "+_verNue
    
*-------------------------------------------------------------
*   PROCESO DE EJECUCION DE UPDATES:
*-------------------------------------------------------------
    IF _verIns<"1404020"
	  DO versionupdate1404020
    ENDIF
    IF _verIns<"1404070"
      DO versionupdate1404070
    ENDIF
    IF _verIns<"1405060"
      DO versionupdate1405060
    ENDIF
    IF _verIns<"1405090"
      DO versionupdate1405090
    ENDIF
    IF _verIns<"1406020"
      DO versionupdate1406020
    ENDIF

  ENDIF																			&& ENDIF#2
ENDIF																			&& ENDIF#1
ENDPROC


PROCEDURE versionupdate1404020
*-----------------------------------------------------------------------------------
*         Instalación y Actualización correspondiente a la versión 1404020
*-----------------------------------------------------------------------------------
*	Nuevo formulario para generar reporte de seguimientos académicos por maestro.
*	Corrección de la tabla FILIA para todos los planteles (Cada plantel tenía una diferente)
*   Formulario para poder agregar maestros en el catálogo que no tengan matrícula
*   Actualizaciones automáticas del sistema local
*-----------------------------------------------------------------------------------

*----- Crea una función en la base de datos del servidor local para poder generar el seguimiento por maestros.
SQLScript = FILETOSTR("\Escolar\Scripts\1404020\CteFnctn_v_samaestro.sql")
SQLEXEC(lnhandle,SQLScript)

DO catalogoActualizarFilia

ENDPROC



PROCEDURE versionupdate1404070
*-----------------------------------------------------------------------------------
*         Instalación y Actualización correspondiente a la versión 1404070
*-----------------------------------------------------------------------------------
*	Corrección para generar reporte de seguimientos académicos por área académica.
*	Corrección de la tabla AREA para todos los planteles (Cada plantel tenía una diferente)
*	Corrección de la tabla ASIGNATURA para todos los planteles para que corresponda con el área
*-----------------------------------------------------------------------------------
WWM1=CHR(13)+"Porfavor espere un momento a que se "+CHR(13)
WWM2="corrijan las asignaturas con sus áreas académicas."
WAIT WINDOW WWM1+WWM2 AT 20,50 NOWAIT NOCLEAR

*------ Corregir la tabla AREAS en la base de datos.
Q1="IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='areas') "
Q2="SELECT 'SI' AS areas ELSE SELECT 'NO' AS areas"
SQLEXEC(lnhandle,Q1+Q2,"EXISTE")

IF EXISTE.areas == "NO"
  Q="CREATE TABLE areas (ar_clave INT PRIMARY KEY, ar_nombre NVARCHAR(30), ar_marca INT)"
  SQLEXEC(lnhandle,Q)
ELSE
  SQLEXEC(lnhandle,"TRUNCATE TABLE areas")
ENDIF
Q1="BULK INSERT areas FROM '\Escolar\Scripts\1404070\DataAreas.txt' "
Q2="WITH (DATAFILETYPE= 'widechar', FIELDTERMINATOR= ',')"
SQLEXEC(lnhandle,Q1+Q2)

*------ Corregir las áreas de las asignaturas en la tabla ASIGNATURA
Q=FILETOSTR("\Escolar\Scripts\1404070\fixAreas.sql")
SQLEXEC(lnhandle,Q)

WAIT CLEAR
MESSAGEBOX("Listo! Se ha terminado de actualizar el sistema.",0+64,"Aviso...")
ENDPROC


PROCEDURE versionupdate1405060
*-----------------------------------------------------------------------------------
*         Instalación y Actualización correspondiente a la versión 1405060
*-----------------------------------------------------------------------------------
*	Nuevo formulario para generar reporte de LISTA NEGRA DE MAESTROS.
*	Corrección de la tabla ASIGNATURA para todos los planteles.
*-----------------------------------------------------------------------------------

*----- Crea las funciones en la base de datos del servidor local para poder generar la lista negra de maestros.
SQLScript = FILETOSTR("\Escolar\Scripts\1405060\CteFnctn_v_lnmaestro_1.sql")
SQLEXEC(lnhandle,SQLScript)
SQLScript = FILETOSTR("\Escolar\Scripts\1405060\CteFnctn_v_lnmaestro_2.sql")
SQLEXEC(lnhandle,SQLScript)
SQLScript = FILETOSTR("\Escolar\Scripts\1405060\CteFnctn_v_lnmaestro_3.sql")
SQLEXEC(lnhandle,SQLScript)
SQLScript = FILETOSTR("\Escolar\Scripts\1405060\CteFnctn_v_lnmaestro_6.sql")
SQLEXEC(lnhandle,SQLScript)

*-----Limpiar tabla Asignatura y vaciar en Asignatura la información de asigna.dbf
WWM1=CHR(13)+"Porfavor espere un momento a que se "+CHR(13)
WWM2="actualice la tabla de asignaturas."
WAIT WINDOW WWM1+WWM2 AT 20,50 NOWAIT NOCLEAR

SQLEXEC(lnhandle,"TRUNCATE TABLE ASIGNATURA")
dbAsigna="\Escolar\Datos\asigna.dbf"
SELECT * FROM &dbAsigna INTO CURSOR TEMP
SELECT TEMP
SCAN
  IF TEMP.as_estatus
    estatus="1"
  ELSE
    estatus="0"
  ENDIF
  Q1="INSERT ASIGNATURA VALUES("+ALLTRIM(STR(TEMP.as_clave,8,0))+", '"+ALLTRIM(TEMP.as_nombre)+"', '"+ALLTRIM(TEMP.as_abrev)+"', "+ALLTRIM(STR(TEMP.as_capac))+", "+ALLTRIM(STR(TEMP.as_semes))
  Q2=", "+ALLTRIM(STR(TEMP.as_horsem))+", "+ALLTRIM(STR(TEMP.as_area))+", '"+ALLTRIM(TEMP.as_catrhum)+"', "+ALLTRIM(STR(TEMP.as_matsant))+", "+ALLTRIM(STR(TEMP.as_matssig))+", "+estatus+")"
  SQLEXEC(lnhandle,Q1+Q2)
  SELECT TEMP
ENDSCAN

WAIT CLEAR
MESSAGEBOX("Listo! Se ha terminado de actualizar el sistema.",0+64,"Aviso...")
ENDPROC


PROCEDURE versionupdate1405090
*-----------------------------------------------------------------------------------
*         Instalación y Actualización correspondiente a la versión 1404090
*-----------------------------------------------------------------------------------
*	En una actualización posterior a la 1404020 se borró la función v_samaestro.sql
*   por lo tanto en esta versión se vuelve a grabar en la base de datos.
*-----------------------------------------------------------------------------------

*----- Crea una función en la base de datos del servidor local para poder generar el seguimiento por maestros.
SQLScript = FILETOSTR("\Escolar\Scripts\1404020\CteFnctn_v_samaestro.sql")
SQLEXEC(lnhandle,SQLScript)

FUNCTION versionupdate1406020
*-----------------------------------------------------------------------------------
*         Instalación y Actualización correspondiente a la versión 1406020
*-----------------------------------------------------------------------------------
*	- En esta versión se ha incluido el calendario oficial a la base de datos. Se crearon
*     dos tablas nuevas (calendar y calendarAsueto) para marcar en calendar las fechas 
*     importantes del calendario y en calendarAsueto las fechas de asueto oficiales.
*-----------------------------------------------------------------------------------

SET DEFAULT TO \Escolar\Scripts\1406020\

*      CALENDARIO OFICIAL EN TABLAS
* ------------------------------------------------------------
* Crear las tablas del calendario 
SQLEXEC(lnhandle, FILETOSTR("cteTbl_calendar.sql"))
SQLEXEC(lnhandle, FILETOSTR("cteTbl_calendarAsueto.sql"))
* Llenar las tablas con información del calendario
* ---- Insertar la información para ciclos por default A y B
SQLEXEC(lnhandle, FILETOSTR("datTbl_calendar_0000A.sql"))
SQLEXEC(lnhandle, FILETOSTR("datTbl_calendar_0000B.sql"))
SQLEXEC(lnhandle, FILETOSTR("datTbl_calendarAsueto_0000A.sql"))
SQLEXEC(lnhandle, FILETOSTR("datTbl_calendarAsueto_0000B.sql"))
* ---- Insertar la información para el ciclo 2013B y 2014A
SQLEXEC(lnhandle, FILETOSTR("datTbl_calendar_2013B.sql"))
SQLEXEC(lnhandle, FILETOSTR("datTbl_calendar_2014A.sql"))
SQLEXEC(lnhandle, FILETOSTR("datTbl_calendarAsueto_2013B.sql"))
SQLEXEC(lnhandle, FILETOSTR("datTbl_calendarAsueto_2014A.sql"))

*      PADRON INICIAL OFICIAL EN TABLA
* ------------------------------------------------------------
* Crear las tabla del padrón inicial.
  SQLEXEC(lnhandle, FILETOSTR("cteTbl_padronini.sql"))
* Llenar la tabla del padrón con la información del padrón.
  SQLEXEC(lnhandle, FILETOSTR("datTbl_padronini_2014A.sql"))
  
* CORRER EL PROCESO DE MARCAR ALUMNOS COMO EGRESADOS.
  DO \Escolar\processestatusegresado
  
* CORRER EL PROCESO DE MANTENIMIENTO DE BASE DE DATOS
  DO \Escolar\processmaintenance
  
* CORRECIÓN TABLA SEGACAD
* Un problema que sucedío en la zona 4 para la impresión de los seguimientos académicos.
  SQLEXEC(lnhandle,"ALTER TABLE segacad ALTER COLUMN fua DATETIME NULL")
  
* ACTUALIZAR EL CATÁLOGO
  DO \Escolar\catalogoactualizarfilia
  
ENDPROC

