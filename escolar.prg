SET DELE ON
SET CENTURY ON
SET CONFIRM OFF
SET SYSMENU TO 
SET DATE TO DMY
SET STATUS OFF
SET SAFE OFF
SET NOTIFY OFF
SET DECIMALS TO 2
SET TALK OFF

PUBLIC lnhandle
PUBLIC esPlantel AS Boolean
PUBLIC esOficinas AS Boolean
PUBLIC esEmsad AS Boolean
STORE SQLCONNECT('CEscolar', 'sa','') TO lnhandle
CLOSE DATABASES 
CLOSE ALL
SET DEFAULT TO \

* Cursor para saber si se trata de un plantel EMSAD.
SQLEXEC(lnhandle,"SELECT pla_emsad AS res FROM planteles","TEMP")
IIF(TEMP.res,esEmsad=.T.,esEmsad=.F.)
* Cursor para saber si se trata de la base de datos de oficinas generales.
SQLScript = "IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='ResOficinas') SELECT 1 AS res ELSE SELECT 0 AS res"
SQLEXEC(lnhandle, SQLScript, "TEMP")
IIF(TEMP.res==1,esOficinas=.T.,esOficinas=.F.)
* Cursor para saber si se trata de la base de datos de un plantel.
SQLEXEC(lnhandle,"SELECT COUNT(*) AS res FROM planteles","TEMP")
IIF(TEMP.res>5,esPlantel=.F.,esPlantel=.T.)


IF (FILE("\Sistemas\sistemas.exe") AND FILE("\Escolar\escolar.exe") AND !esOficinas)
  * No se correr� el controlador de versiones si la base de datos de oficinas generales est� us�ndose.
  * S�lo correra el controlador de versiones si se est� en el cpu donde est� instalado el servidor. 
  * No se ejecutar� si se est� en un cpu corriendo el sistema de manera remota ( LAN ).
  
  IF (!FILE("\Tools\Winrar\winrar.exe")) AND !esOficinas
    * copia la carpeta Tools en C:\
    RUN /N xcopy \escolar\Tools \Tools /S /I
  ENDIF

* --------------------------------------
  * Ejecutar el controlador de versiones.
  DO versioncontroller
* --------------------------------------
  IF esPlantel
    * Ejecutar procedimientos de mantenimiento base de datos.
    * El proceso de mantenimiento s�lo se ejecutar� en la base de datos del plantel, siguiendo
    * la pol�tica de que tanto en coordinaci�n como en oficinas se tenga exactamente lo mismo que
    * en plantel... por lo tanto coordinaci�n y oficinas no deben alterar nada.
    * �S�lo en plantel se pueden hacer cambios a la base de datos! el sistema en coordinaciones y
    * en oficinas generales debe reflejar exactamente lo que est� en el plantel, ya sea que en plantel
    * est� bien o est� mal la informaci�n.
    DO procesomantenimiento
  ENDIF
* --------------------------------------

ENDIF

_SCREEN.BorderStyle= 2
_SCREEN.Closable= .F.
_SCREEN.ControlBox= .F.
_SCREEN.Movable= .T.
_SCREEN.WindowState= 2

DO FORM "\Escolar\formas\frmmenuprincipal.scx"
READ EVENTS
*------------------------------------------------------------
