
*-------------------------------------------------------
* ACTUALIZAR CATÁLOGO DE MAESTROS:
*-------------------------------------------------------
*   Este módulo revisa todas las matrículas temporales que existan en la base de
* datos local y las compara con la tabla filia.dbf en la carpeta de instalación.
*   Para los profesores que tenían matrícula temporal pero ya se encuentren en la 
* tabla filia.dbf con matrícula, se corregirá su matrícula con este módulo.
*-----------------------------------------------------
WWM1=CHR(13)+"Porfavor espere un momento a que se "+CHR(13)
WWM2="actualice el catálogo de maestros."
WAIT WINDOW WWM1+WWM2 AT 20,50 NOWAIT NOCLEAR

SET DEFAULT TO \

*----- Crear una tabla de filia temporal con la información real de los maestros.
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

*----- Comparar Matrículas y hacer un cursor con la lista de las matrículas que no coinciden.
Q=FILETOSTR("\Escolar\Scripts\1404020\ChkMatriculas.sql")
SQLEXEC(lnhandle,Q,"LISTA")

*----- Cambiar todas las matrículas incorrectas en la lista para las siguientes 6 tablas:
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

*----- Borrar tabla FILIA2, limpiar la tabla FILIA y vaciar en FILIA la información de filia.dbf
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