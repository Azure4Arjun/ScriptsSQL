/*
Script:			Size DBs.SQL
Description:	How to get informations about Databases
Reference:		Unknow
Author:			Unknow
*/

CREATE TABLE ##temp(DatabaseName sysname , 
                    Name sysname , 
                    physical_name nvarchar(500) , 
                    size decimal(18 , 2) , 
                    FreeSpace decimal(18 , 2) , 
                    PercFree decimal(18 , 2));   


EXEC sp_msforeachdb '
Use [?];
INSERT INTO ##temp(DatabaseName , 
                   Name , 
                   physical_name , 
                   Size , 
                   FreeSpace , 
                   PercFree)
SELECT DB_NAME()AS DatabaseName , 
       Name , 
       physical_name , 
       CAST(CAST(ROUND(CAST(size AS decimal) * 8.0 / 1024.0 , 2)AS decimal(18 , 2))AS nvarchar) as SizeMB , 
       CAST(CAST(ROUND(CAST(size AS decimal) * 8.0 / 1024.0 , 2)AS decimal(18 , 2)) - CAST(FILEPROPERTY(name , ''SpaceUsed'') * 8.0 / 1024.0 AS decimal(18 , 2))AS nvarchar) AS FreeSpaceMB , 
       (CAST(ROUND(CAST(size AS decimal) * 8.0 / 1024.0 , 2)AS decimal(18 , 2)) - CAST(FILEPROPERTY(name , ''SpaceUsed'') * 8.0 / 1024.0 AS decimal(18 , 2))) * 100 / CAST(ROUND(CAST(size AS decimal) * 8.0 / 1024.0 , 2)AS decimal(18 , 2)) AS PercFree
  FROM sys.database_files;'

SELECT *
  FROM ##temp

DROP TABLE ##temp;
