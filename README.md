# BulkInsertion_Dynamic
HOW TO CREATE THE TABLES , COLUMNS AND INSERT RECORDS INTO THEM DYNAMICALLY. THE DATA IN .TXT FILE IS COLLECTED BY USING SQL QUERY BULK INSERT TO LOOP THROUGH ALL THE FILES IN A FOLDER AND LOADED INTO SQL SERVER DATABASE TABLES. 

### Instructions:
1.For this project, you need SQL SERVER software in your system. Create notepad files and save them with the names of the table you want to create in SQL Server. Save them in ‘AllFiles’ folder inside the ‘Filetext’ Folder, inside C drive.  
Save ‘Pad_bulk_import’ file inside’ Filetext’ folder in c drive.

Instructions:
1.The name of your file will be the name of your table. For example the name of the file in the folder is 

'MyEmployeeTable' then the name of the table will also be 'MyEmployeeTable'.
2.The first line in notepad will be your Schema name.
3. The second line in notepad will be your column names of the table. The column nmes are separated by 

comma (‘,’) separator. Don’t forget to put a comma after the last column name too.
4. Start filling the rows of your table from the third line. Separate the data using comma (‘,’). Put comma after 

the last row entry too.
5.Press enter only to create rows, Otherwise don’t.

### Explanation:

1) Data is dumped from various resources and platforms in .txt format.  
2) xp_xmdshell makes the job easy to run any command line process and can also embed within stored 
procedures, jobs or batch processing. This option is now enabled by 1 using Master Database
3) My job is to collect the data from files present in the folder and import into SQL Server. OPENROWSET is 
a T-SQL function that allows for reading data from many sources including using the SQL Server's BULK 
import capability. One of the useful features of the BULK provider is its ability to read individual files from the 
file system into SQL Server, such as loading a data from a text file  into a SQL Server table.
4) All the files are imported from the folder by creating a temporary table in Temp database with two columns. 
First column is  an identity function for generating the numbers sequntially, the second column consists all the 
remaining data of the '.txt' files.  
5) In User defined database 'SQL Studies' we create a table 'Project'  with two columns and insert data from 
temporary table into Project table using Formatfile.
6) The files from the folder are now residing in Project table as rows and columns.
7) Now tables are created dynamically with each record in Project table.
8) 8)  The second record in Project table will dynamically be created as the column names of the table. 
9) System functions like Charindex(), Substring() etc are used to seggregate the columns within the rows .
10) To maintain Data integraity and avoid invalid data insertion, the system functions patindex() and 
substring() are used.

