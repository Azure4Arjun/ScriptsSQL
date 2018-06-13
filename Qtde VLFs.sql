/*
Script:			Qtde VLFs.SQL
Description:	How to get informations about VLF's
Reference:		https://blogs.msdn.microsoft.com/saponsqlserver/2012/02/22/too-many-virtual-log-files-vlfs-can-cause-slow-database-recovery/
Author:			Unknow
*/

CREATE TABLE #TEMP (
 RECOVERYUNITID VARCHAR(255) --ESSA COLUNA S� EXISTE A PARTIR DO 2012, COMENTE ESTA LINHA SE FOR EXECUTAR DO 2008R2 PARA TRAS
 , FILEID VARCHAR(255)
 , FILESIZE VARCHAR(255)
 , STARTOFFSET VARCHAR(255)
 , FSEQNO VARCHAR(255)
 , [STATUS] VARCHAR(255)
 , PARITY VARCHAR(255)
 , CREATELSN VARCHAR(255)
 )
 
CREATE TABLE #DBCCRESULTS (
 SERVERNAME VARCHAR(255)
 , DBNAME VARCHAR(255)
 , VLF BIGINT
 )
 
EXEC MASTER.DBO.SP_MSFOREACHDB
 @COMMAND1 = 'USE [?] INSERT INTO #TEMP EXECUTE (''DBCC LOGINFO'')'
 , @COMMAND2 = 'INSERT INTO #DBCCRESULTS SELECT @@SERVERNAME, ''?'', COUNT(1) FROM #TEMP'
 , @COMMAND3 = 'TRUNCATE TABLE #TEMP'
 
 SELECT DISTINCT
 SERVERNAME
 , DBNAME
 , VLF
 INTO #TEMP2
 FROM #DBCCRESULTS
 ORDER BY 3 DESC
 

 SELECT TOP 5 * FROM #TEMP2 ORDER BY 3 DESC

 DROP TABLE #TEMP, #DBCCRESULTS;
  DROP TABLE #TEMP2
