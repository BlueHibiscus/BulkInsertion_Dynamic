

			
	/* TO ACCESS WINDOW FILE SYSTEM FOLDER AND LOOP THROUGH FILES USING SQL QUERY BULK INSERT AND LOAD DATA INTO SQL SERVER TABLES BY BULK INSERT SCRIPT */ 
	/* TO USE SQL QUERY BULK INSERT TO LOOP THROUGH ALL THE FILES IN A FOLDER AND LOAD INTO SQL SERVER DATABASE TABLES */

	
	USE MASTER
	GO

	/* MICROSOFT HAS BUILT-IN EXTENDED STORED PROCEDURE CALLED 'xp_cmdshell'. THIS COMMAND HAD MADE THE JOB OF DEVELOPERS EASY WHERE YOU HAVE THE ABILITY TO RUN
	   ANY COMMAND LINE PROCESS AND ALSO CAN EMBED WITHIN STORED PROCEDURES, JOBS OR BATCH PROCESSING. THIS OPTION IS NOW ENABLES BY 1 */
	
	EXEC sp_configure 'show advanced options', 1    
	RECONFIGURE 
	GO
	

	EXEC SP_CONFIGURE 'xp_cmdshell', 1 
	RECONFIGURE 
	GO
	
	/* DROP DATABASE SQLSTUDIES 
	  GO */

	CREATE DATABASE SQLSTUDIES
	GO


	------- USING TEMPDB TO CREATE TEMPORATY TABLE----
	USE TEMPDB
	GO

	-------CHECKING FOR EXISTENCE OF THIS TABLE-----

	IF OBJECT_ID ('#TMP') IS NOT NULL 

	------IF THE TABLE ALREADY EXISTS, DROP IT--------
	DROP TABLE #TMP
	GO


	------CREATING A TEMPORARY TABLE ---------- 
	/* TO LOAD DATA FROM THE FOLDER AND FILES FILES TO THE TEMP TABLE QUICKLY   */
	
	CREATE TABLE #TMP (ID int identity, COL1 varchar(200))

	INSERT INTO #tmp

	EXEC xp_cmdshell 'dir /B "C:\Filetext\AllFiles"';


	--------USING SQLSTUDIES DATABASE ------

	USE SQLSTUDIES
	GO

	DECLARE @TIMES INT=1

	WHILE @TIMES<(SELECT COUNT(*) FROM #TMP)
	
	/* CREATING A TABLE 'PROJECT' WITH  TWO COLUMNS  ID AND ITEM  */

	BEGIN
           
		CREATE TABLE PROJECT (ID INT IDENTITY, ITEM VARCHAR (5000))

		DECLARE @FILENAME VARCHAR(100)=''
	
		SET @FILENAME = ( SELECT COL1 FROM #TMP WHERE ID=@TIMES ) 
	
		DECLARE @SQL NVARCHAR(MAX);
	
		SET @sql= N'INSERT PROJECT( ITEM )  SELECT VALUE FROM OPENROWSET
				                 ( BULK ''C:\Filetext\AllFiles\'+ @FILENAME+''', 
				                   FORMATFILE = ''C:\Filetext\pad_bulk_import.fmt'') MYFILE';

    		EXEC SYS.SP_EXECUTESQL @SQL;

	/* THE FILES FROM THE FOLDER ARE NOW RESIDING IN PROJECT TABLE */
	/* CREATING THE SCHEMA ALONG WITH THE TABLE DYNAMICALLY PRESENT IN THE FOLDER */
	
		DECLARE @COL VARCHAR(200)
				
		DECLARE @A INT =0, @B INT 

		DECLARE @SQLK NVARCHAR(MAX),@SQL1 NVARCHAR(MAX),@SQL2 NVARCHAR(MAX)=' ',@SQL3 NVARCHAR(MAX)

		DECLARE @N INT =0
		
	/* THE SECOND RECORD IN PROJECT TABLE WILL DYNAMICALLY BE CREATED AS THE THE COLUMN NAMES OF THE TABLE */ 	

		DECLARE @SCHEMA_NAME VARCHAR(400) = ( SELECT ITEM FROM PROJECT WHERE ID=1 )

		DECLARE @LISTOFCOLUMNS VARCHAR(400) = ( SELECT ITEM FROM PROJECT WHERE ID=2 )

		DECLARE @K INT = (SELECT (LEN(@ListofColumns) - LEN(REPLACE(@LISTOFCOLUMNS,',','')) ) AS MyCol2Count)

		DECLARE  @CHAR INT = CHARINDEX('.',@FILENAME)

		DECLARE  @SUB VARCHAR(200), @SQL_SCHEMA NVARCHAR(MAX)

		SET @SUB = SUBSTRING(@FILENAME, 0 , @CHAR)
		
		----- CREATING SCHEMA DYNAMICALLY-----
		
		SET @SQL_SCHEMA = 'CREATE SCHEMA '+ @SCHEMA_NAME


		------ CREATING TABLE DYNAMICALLY------	
			
		SET  @SQLK = 'CREATE TABLE '+@SCHEMA_NAME+'.'+@SUB+'  ('
		

			 WHILE(@n<= @k-1)
			 
	/* SELECTING ONLY THE DATA PRESENT WITHIN THE TWO COMMAS (',') AS FIELDS OF THE TABLE */

				 BEGIN
	
					----- USING SYSYEM FUNCTIONS TO SEGGREGATE THE COLUMNS WITHIN THE ROW WHOSE ID IS 2------
					
					SELECT  @B =   CHARINDEX(',',ITEM,@A)  FROM PROJECT WHERE ID = 2
			
					SELECT  @COL = SUBSTRING(ITEM,@A,@B-@A) FROM PROJECT WHERE ID = 2


					/* USING SYSTEM FUNCTIONS TO CHECK DATA INTEGRITY AND AVOIDING INVALID DATA ENTRY,
					   SPECIAL CHARACTERS, NUMBERS , SPACES ARE CHECKED AND PREVENTED FROM MAKING AN ENTRY */ 


					DECLARE  @P INT, @STRING VARCHAR(40) = @col


					SELECT @P = PATINDEX ('%[^a-zA-Z_]%',@STRING)
 
							WHILE @P > 0

								BEGIN

									SELECT @STRING = REPLACE(@STRING,SUBSTRING(@STRING,@P,1),'')

									SELECT @P = PATINDEX ('%[^a-zA-Z_]%',@STRING)

								END
							
							IF (@N < @K-1)
							
								BEGIN
		  
									SET @SQL1 = @STRING + ' VARCHAR(200), ' 
				
									SET @SQL2 = @SQL2 + @SQL1  
		
								END
	
			   						SET @A = @B +1

			   						SET @N = @N + 1
		
				END


		SET @SQL3 = @SQLK + @SQL2 + @STRING + ' VARCHAR(200))'

		EXEC SP_EXECUTESQL @SQL_SCHEMA
		 
		EXEC SP_EXECUTESQL @SQL3

		
	/* CODE TO INSERT ROWS DYNAMICALLY IN THE TABLES */


		DECLARE @sqlStr NVARCHAR(MAX) = 'INSERT INTO ' + @SCHEMA_NAME+'.'+@SUB+ ' VALUES ';

		DECLARE @valueList varchar(8000);

		DECLARE @value varchar(8000);

		DECLARE @valString VARCHAR(8000) = '';

		DECLARE @T INT = 3;


				WHILE (@T <= (SELECT COUNT(*) FROM PROJECT))

					BEGIN
	   
	   					--SELECT @pos, @len, @value /*  THESE VARIABLES ARE USED FOR DEBUGGING */
							
						DECLARE @POS INT = 0;

						DECLARE @LEN INT = 0;

						DECLARE @tempStr VARCHAR(8000) = '';

						SELECT @valueList = ITEM FROM PROJECT WHERE ID = @T;


							WHILE CHARINDEX(',', @valueList, @POS+1) > 0

							       BEGIN

									SET @len = CHARINDEX(',', @valueList, @POS+1) - @pos

									SET @value = SUBSTRING(@valueList, @POS, @LEN)

								/* USING SYSTEM FUNCTIONS TO CHECK DATA INTEGRITY AND AVOIDING INVALID DATA ENTRY,
					   			   SPECIAL CHARACTERS, NUMBERS , SPACES ARE CHECKED AND PREVENTED FROM MAKING AN ENTRY */ 
						
                    
									DECLARE @p1 INT, @string1 VARCHAR(4000) = @value

									SELECT @p1 = PATINDEX ('%[^a-zA-Z0-9-._ ]%',@string1)

										WHILE @p1 > 0

											BEGIN

												SELECT @STRING1 = REPLACE(@STRING1,SUBSTRING(@STRING1,@P1,1),'')

												SELECT @P1 = PATINDEX ('%[^a-zA-Z0-9-._ ]%',@STRING1)
		
											END


								SET @tempStr = @tempStr + ',''' + @string1 + '''';

								SET @POS = CHARINDEX(',', @valueList, @POS +@LEN) +1

						   		END

             
             				SET @valString = @valString + '(' + SUBSTRING(@tempStr, 2, LEN(@tempStr)) + '),';

			
                			SET @T = @T + 1;

           				END

 
		SET @sqlStr = @sqlStr + SUBSTRING(@valString, 0, LEN(@valString));

		EXEC SP_EXECUTESQL @sqlStr;

		SET @TIMES = @TIMES +1

	/* TABLE PROJECT IS DROP EACH TIME WHEN THE LOOP........................*/
		
		DROP TABLE PROJECT

	END
  
	
	-------- TESTING THE THE CODE ----------
	/* CHECK THE DYNAMICALLY CREATED TABLES WHICH WERE FILES IN THE FOLDER, THE TABLENAME ARE SAME AS THE FILE NAME  */

  	SELECT * FROM ADDRESSTYPE.ADDRESSTYPE
	
 	SELECT * FROM DEPARTMENT.DEPARTMENT_NAME
  	
	SELECT * FROM PERSONAL.PERSONAL_DETAILS
  	
	SELECT * FROM EMPLOYEE.EMP_DETAILS

  
	---------- CLEAN UP --------------------
   	/* DROP ALL THE TABLES */
	
	--DROP TABLE ADDRESSTYPE.ADDRESSTYPE
	
	--DROP TABLE DEPARTMENT.DEPARTMENT_NAME
	
	--DROP TABLE EMPLOYEE.EMP_DETAILS
	
	--DROP TABLE PERSONAL.PERSONAL_DETAILS









