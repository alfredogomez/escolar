
PROCEDURE catalogoactualizarfilia

*-------------------------------------------------------
* ACTUALIZAR CAT�LOGO DE MAESTROS:
*-------------------------------------------------------
*   Este m�dulo revisa todas las matr�culas temporales que existan en la base de
* datos local y las compara con la tabla filia.dbf en la carpeta de instalaci�n.
*   Para los profesores que ten�an matr�cula temporal pero ya se encuentren en la 
* tabla filia.dbf con matr�cula, se corregir� su matr�cula con este m�dulo.
*-----------------------------------------------------
WWM1=CHR(13)+"Porfavor espere un momento a que se "+CHR(13)
WWM2="actualice el cat�logo de maestros."
WAIT WINDOW WWM1+WWM2 AT 20,50 NOWAIT NOCLEAR

SET DEFAULT TO \

*----- Crear una tabla de filia temporal con la informaci�n real de los maestros.
Q=FILETOSTR("\Escolar\Scripts\1404020\CteTblFilia2.sql")
SQLEXEC(lnhandle,Q)
dbFilia="\Escolar\Datos\filia.dbf"
SELECT * FROM &dbFilia INTO CURSOR TEMP
SELECT TEMP
SCAN
Q="INSERT FILIA2 VALUES('"+ALLTRIM(STR(TEMP.MATRICULA,8,0))+"','"+ALLTRIM(TEMP.A_PATERNO)+" "+ALLTRIM(TEMP.A_MATERNO)+" "+ALLTRIM(TEMP.NOMBRE)+"')"
SQLEXEC(lnhandle,Q)
SELECT TEMP
ENDSCAN

*----- Comparar Matr�culas y hacer un cursor con la lista de las matr�culas que no coinciden.
Q=FILETOSTR("\Escolar\Scripts\1404020\ChkMatriculas.sql")
SQLEXEC(lnhandle,Q,"LISTA")

*----- Cambiar todas las matr�culas incorrectas en la lista para las siguientes 6 tablas:
*      ordinar, extraord, horarios, portafolio, segacad y plazas.
DIMENSION ArrTablas[6,2]
ArrTablas[1,1]="ordinar"
ArrTablas[1,2]="or_maest"
ArrTablas[2,1]="extraord"
ArrTablas[2,2]="ex_cvemae"
ArrTablas[3,1]="horarios"
ArrTablas[3,2]="ho_maest"
ArrTablas[4,1]="portafolio"
ArrTablas[4,2]="po_maest"
ArrTablas[5,1]="segacad"
ArrTablas[5,2]="sa_cvemae"
ArrTablas[6,1]="plazas"
ArrTablas[6,2]="matri_pla"
SELECT LISTA
SCAN
  i=1
  DO WHILE i < 7
    Q="UPDATE "+ArrTablas[i,1]+" SET "+ArrTablas[i,2]+" = '"+LISTA.M_Correcta+"' WHERE "+ArrTablas[i,2]+" = '"+STR(LISTA.M_Incorrecta)+"'"
    SQLEXEC(lnhandle,Q)
    i=i+1
  ENDDO
ENDSCAN

*----- Borrar tabla FILIA2, limpiar la tabla FILIA y vaciar en FILIA la informaci�n de filia.dbf
SQLEXEC(lnhandle,"DROP TABLE FILIA2")
SQLQuery="DELETE FROM filia WHERE NOT (matricula<50 OR LEN(matricula)=6)"
SQLEXEC(lnhandle,SQLQuery)
SELECT * FROM &dbFilia INTO CURSOR TEMP
SELECT TEMP
SCAN
  Q="INSERT FILIA VALUES('"+ALLTRIM(STR(TEMP.MATRICULA,8,0))+"','"+ALLTRIM(TEMP.R_F_C)+"','"+ALLTRIM(TEMP.A_PATERNO)+"', '"+ALLTRIM(TEMP.A_MATERNO)+"', '"+ALLTRIM(TEMP.NOMBRE)+"', "+ALLTRIM(STR(TEMP.SEXO))+", '"+ALLTRIM(TEMP.curp)+"')"
  SQLEXEC(lnhandle,Q)
  SELECT TEMP
ENDSCAN

WAIT CLEAR

ENDPROC

PROCEDURE procesoEstatusEgresado

*-------------------------------------------------------
* PROCESO DE MARCAR ALUMNOS EGRESADOS:
*-------------------------------------------------------
* Este m�dulo marca con estatus = 2 a los alumnos que han egresado. El prop�sito
* de este m�dulo es el de ejecutar este proceso de manera autom�tica al inicio de
* ciclos B una vez que se han impreso los certificados y al terminar cada uno de 
* los periodos extraordinarios. As� el plantel no tendr� que hacer este proceso de
* manera manual evit�ndose los problemas de omisi�n por parte del plantel y los problemas
* que ocasiona el no ejecutarlo.
*-------------------------------------------------------

WWM1=CHR(13)+"Porfavor espere un momento a que se realice"+CHR(13)
WWM2="el proceso de marcar alumnos egresados."
WAIT WINDOW WWM1+WWM2 AT 20,50 NOWAIT NOCLEAR

SQLQuery="SELECT al_matric AS matric FROM alumnos WHERE al_semes=6 AND al_estatus=1 ORDER BY al_matric"
SQLEXEC(lnhandle,SQLQuery,"ALUMNOSENSEXTO")

fecha=CTOD('01/01/1900')

SELECT ALUMNOSENSEXTO
SCAN
  SQLQuery="SELECT or_asigna AS asigna, or_calord AS calord, or_fecacta AS fecacta FROM ordinar WHERE or_matric='"+ALUMNOSENSEXTO.matric+"' AND or_marrep<>99"
  SQLEXEC(lnhandle,SQLQuery,"ASIGNATURAS")
  SELECT ASIGNATURAS
  GO TOP
  IF !EOF()
    rep=.F.
    SCAN WHILE !rep
      IF !((VAL(ASIGNATURAS.calord)>5) OR INLIST(ALLTRIM(ASIGNATURAS.calord),'AE','A'))
        * CHECAR EXTRAORDINARIOS
        SQLQuery="SELECT ex_califi AS califi FROM extraord WHERE ex_matric='"+ALUMNOSENSEXTO.matric+"' AND ex_asigna='"+STR(ASIGNATURAS.asigna,4,0)+"'"
        SQLEXEC(lnhandle,SQLQuery,"CALEXTRAORD")
        SELECT CALEXTRAORD
        GO TOP
        IF EOF()
          rep=.T.
        ELSE
          repext=.T.
          SCAN
            IF ALLTRIM(CALEXTRAORD.califi)='A'
              repext=.F.
            ENDIF
            IF VAL(CALEXTRAORD.califi)>5
              repext=.F.
            ENDIF
          ENDSCAN
          IF repext
            rep=.T.
          ENDIF
        ENDIF
      ENDIF
    ENDSCAN
    IF !rep
      SQLQuery="UPDATE alumnos SET al_estatus='2' WHERE al_matric='"+ALUMNOSENSEXTO.matric+"'"
      SQLEXEC(lnhandle,SQLQuery)
      SQL1="SELECT MAX(fecha) AS fecha FROM "
      SQL2="( SELECT MAX(or_fecacta) AS fecha FROM ordinar  WHERE or_matric='"+ALUMNOSENSEXTO.matric+"' "
      SQL3="  UNION "
      SQL4="  SELECT MAX(ex_fecacta) AS fecha FROM extraord WHERE ex_matric='"+ALUMNOSENSEXTO.matric+"' "
      SQL5=") AS tbl"
      SQLEXEC(lnhandle,SQL1+SQL2+SQL3+SQL4+SQL5,"FECHA")
      _fecela=STR(DAY(DATE()),2,0)+'/'+RIGHT('00'+ALLTRIM(STR(MONTH(DATE()),2,0)),2)+'/'+STR(YEAR(DATE()),4,0)
      _feccon=STR(DAY(FECHA.fecha),2,0)+'/'+RIGHT('00'+ALLTRIM(STR(MONTH(FECHA.fecha),2,0)),2)+'/'+STR(YEAR(FECHA.fecha),4,0)
      SQLQuery="UPDATE alumnos SET al_fecimp='"+_fecela+"' WHERE al_matric='"+ALUMNOSENSEXTO.matric+"'"
      SQLEXEC(lnhandle,SQLQuery)
      SQLQuery="UPDATE alumnos SET al_fecbaj='"+_feccon+"' WHERE al_matric='"+ALUMNOSENSEXTO.matric+"'"
      SQLEXEC(lnhandle,SQLQuery)
      SQLEXEC(lnhandle,"UPDATE alumnos SET al_entcer=1 WHERE al_matric='"+ALUMNOSENSEXTO.matric+"'")
    ENDIF
  ENDIF
ENDSCAN

WAIT CLEAR
ENDPROC 

PROCEDURE procesomantenimiento
*-------------------------------------------------------
* PROCESO DE MANTENIMIENTO DE BASE DE DATOS:
*-------------------------------------------------------
* Este m�dulo hace una serie de procesos de limpieza y mantenimiento a la base
* de datos del plantel (no afecta a las bases de datos de las coordinaciones ni
* la base de datos de oficinas generales, siguiendo la pol�tica de que en dichas
* bases de datos debe reflejarse exactamente lo que hay en el plantel ya sea que 
* all� est� mal o bien no importa, lo que importa es que est� exactamente igual.)
* Esto funciona como la integridad de la informaci�n, pero la diferencia es que este
* proceso se corre autom�tico cada vez que se inicia el sistema, tambi�n justo antes
* de enviar un respaldo y tambi�n antes de imrpimir actas ordinarias o extraordinarias.
*-----------------------------------------------------
WWM1=CHR(13)+"Porfavor espere un momento a que se realicen"+CHR(13)
WWM2="los procesos de mantenimiento a la base de datos."
WAIT WINDOW WWM1+WWM2 AT 20,50 NOWAIT NOCLEAR

SET DEFAULT TO \Escolar\Scripts\maintenance_2014A\

* ------------------------------------------------------------
* CORREGIR ESTATUS DE ALUMNOS.
* ------------------------------------------------------------
* CORREGIR EL SEMESTRE DE LOS ALUMNOS EN TABLA alumnos.
  SQLEXEC(lnhandle, FILETOSTR("fixTbl_alumnos_semestres.sql"))
* CORREGIR ESTATUS EN LA TABLA alumnos.
  SQLEXEC(lnhandle, FILETOSTR("fixTbl_alumnos_estatus.sql"))
* CORREGIR CICLO-GENERACI�N EN LA TABLA alumnos.
  SQLEXEC(lnhandle, FILETOSTR("fixTbl_alumnos_cicloGene.sql"))
* CORREGIR FECHAS DE BAJAS EN LA TABLA alumnos.
  SQLEXEC(lnhandle, FILETOSTR("fixTbl_alumnos_fecbaj.sql"))
* CORREGIR CAPACITACIONES EN TABLA alumnos.
  SQLEXEC(lnhandle, FILETOSTR("fixTbl_alumnos_capac.sql"))
* CORREGIR TIPO DE MODALIDAD EN TABLA alumnos.
  SQLEXEC(lnhandle, FILETOSTR("fixTbl_alumnos_tipModal.sql"))
* CORREGIR FECHAS DE INICIO Y FIN DE CICLO.
  

WAIT CLEAR
ENDPROC