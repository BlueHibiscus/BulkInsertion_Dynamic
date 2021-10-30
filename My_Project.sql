
			/* HOW TO USE SQL QUERY BULK INSERT TO LOOP THROUGH ALL THE FILES IN A FOLDER AND LOAD INTO SQL SERVER DATABASE TABLES */

	Use RidaProj
	Go


	EXEC sp_configure 'show advanced options', 1    
	RECONFIGURE 
	GO

	EXEC sp_configure 'xp_cmdshell', 1 
	RECONFIGURE 
	GO

		--TO USE TEMPDB
	USE TEMPDB
	GO

-------CHECKING FOR EXISTENCE OF THIS TABLE-----

	IF OBJECT_ID ('##TMP') IS NOT NULL 

	DROP TABLE ##TMP

	GO


------CREATING A TEMPORARY TABLE----------

CREATE TABLE ##TMP (ID int identity, COL1 varchar(200))

INSERT INTO ##tmp

EXEC xp_cmdshell 'dir /B "C:\Filetext\AllFiles"';


--USING RIDAPROJ DATABASE

USE RIDAPROJ
GO


DECLARE @TIMES INT=1

WHILE @TIMES<(SELECT COUNT(*) FROM ##TMP)

BEGIN
                
				/* CREATING WITH A TABLE PROJECT TWO COLUMNS  */

CREATE TABLE PROJECT (ID INT IDENTITY, ITEM VARCHAR (5000))

	DECLARE @FILENAME VARCHAR(100)=''
	
	SET @FILENAME = ( SELECT COL1 FROM ##TMP WHERE ID=@TIMES ) 
	

	DECLARE @SQL NVARCHAR(MAX);
	SET @sql= 'INSERT PROJECT( ITEM ) SELECT VALUE FROM OPENROWSET
				( BULK ''C:\Filetext\AllFiles\'+ @FILENAME+''', 
				FORMATFILE = ''C:\Filetext\pad_bulk_import.fmt'') a';

    EXEC sys.sp_executesql @SQL;


		DECLARE @COL VARCHAR(200)
				
		DECLARE @A INT =0, @B INT 

		DECLARE @SQLK NVARCHAR(MAX),@SQL1 NVARCHAR(MAX),@SQL2 NVARCHAR(MAX)=' ',@SQL3 NVARCHAR(MAX)

		DECLARE @N INT =0



		
		DECLARE @LISTOFCOLUMNS VARCHAR(400) = ( SELECT ITEM FROM PROJECT WHERE ID=2 )

		DECLARE @K INT = (SELECT (LEN(@ListofColumns) - LEN(REPLACE(@LISTOFCOLUMNS,',','')) ) AS MyCol2Count)


		DECLARE  @CHAR INT = CHARINDEX('.',@FILENAME)

		DECLARE  @SUB VARCHAR(200)

		SET @SUB = SUBSTRING(@FILENAME, 0 , @CHAR)

					/* CREATING EACH TABLE PRESENT IN FOLDER  */

		SET  @SQLK = 'CREATE TABLE '+@SUB+'  ('
		


			 WHILE(@n<= @k-1)

				 BEGIN
	
					SELECT @b = CHARINDEX(',',ITEM,@a)  FROM PROJECT WHERE ID = 2
			
					SELECT  @COL = SUBSTRING(ITEM,@a,@b-@a) FROM PROJECT WHERE ID = 2


									---  TO CHECK IF INVALID DATA IS NOT BEING ENTERED--- 


					DECLARE  @p INT, @string VARCHAR(40) = @col


					SELECT @p = PATINDEX ('%[^a-zA-Z_]%',@string)
 
						WHILE @p > 0

							BEGIN

							SELECT @string = REPLACE(@string,SUBSTRING(@string,@p,1),'')

							SELECT @p = PATINDEX ('%[^a-zA-Z_]%',@string)

		
						END

			
			
						IF (@n< @k-1)

							BEGIN
		  
								SET @sql1= @string+ ' VARCHAR(200), ' 
				
								SET @sql2 = @sql2+@sql1 
		
							END
	
			   SET @a=@b+1

			   SET @n=@n+1
		
			End


		SET @sql3 = @sqlk + @sql2 + @string + ' VARCHAR(200))'
		 
		EXEC sp_executesql @sql3



		/*TO INSERT VALUES IN TABLES*/


		DECLARE @sqlStr NVARCHAR(MAX) = 'INSERT INTO ' + @SUB+ ' VALUES ';

		DECLARE @valueList varchar(8000);

		DECLARE @value varchar(8000);

		DECLARE @valString VARCHAR(8000) = '';

		DECLARE @t INT = 3;


				WHILE (@t <= (SELECT COUNT(*) FROM Project))

						BEGIN
	   
							DECLARE @pos INT = 0;

							DECLARE @len INT = 0;

							DECLARE @tempStr VARCHAR(8000) = '';

							SELECT @valueList = Item FROM Project WHERE Id = @t;



								WHILE CHARINDEX(',', @valueList, @pos+1) > 0

									 BEGIN

										SET @len = CHARINDEX(',', @valueList, @pos+1) - @pos

										SET @value = SUBSTRING(@valueList, @pos, @len)

												 --SELECT @pos, @len, @value /* this is here for debugging */

                    


												/* TO CHECK IN INVALID DATA IS NOT BEING ENTERED  */


										DECLARE @p1 INT, @string1 VARCHAR(4000) = @value

										SELECT @p1 = PATINDEX ('%[^a-zA-Z0-9-._ ]%',@string1)

											WHILE @p1 > 0

													BEGIN

													Select @string1 = REPLACE(@string1,SUBSTRING(@string1,@p1,1),'')

													SELECT @p1 = PATINDEX ('%[^a-zA-Z0-9-._ ]%',@string1)
		
													END






									 SET @tempStr = @tempStr + ',''' + @string1 + '''';

									SET @pos = CHARINDEX(',', @valueList, @pos+@len) +1

						   END

             

                SET @valString = @valString + '(' + SUBSTRING(@tempStr, 2, LEN(@tempStr)) + '),';

			

                SET @t = @t + 1;

           END

 
SET @sqlStr = @sqlStr + SUBSTRING(@valString, 0, LEN(@valString));


EXEC sp_executesql @sqlStr;

SET @TIMES = @TIMES +1

DROP TABLE PROJECT

END
  
					/* CHECK THE TABLES  */

  SELECT * FROM ADDRESSTYPE
  SELECT * FROM DEPARTMENT_NAME
  SELECT * FROM PERSONAL_DETAILS
  SELECT * FROM EMP_DETAILS

  

   /* DROP ALL THE TABLES */

--DROP TABLE ADDRESSTYPE
--DROP TABLE DEPARTMENT_NAME
--DROP TABLE EMP_DETAILS
--DROP TABLE PERSONAL_DETAILS









