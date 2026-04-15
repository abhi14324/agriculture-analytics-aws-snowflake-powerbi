 CREATE OR REPLACE STORAGE INTEGRATION PBI_Integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::642528006770:role/powerbi-role'
  STORAGE_ALLOWED_LOCATIONS = ('s3://	
powerbi-aws-project/')
  COMMENT = 'Optional Comment'


  //description Integration Object
  desc integration PBI_Integration;

//drop integration PBI_Integration



--------------------------------------------
//drop database PowerBI

CREATE database PowerBI;

create schema PBI_Data;

create table PBI_Dataset (
Year int,	Location string,	Area	int,
Rainfall	float, Temperature	float, Soil_type string,
Irrigation	string, yeilds	int,Humidity	float,
Crops	string,price	int,Season string);

select * from PBI_Dataset;

//drop database test;

create stage PowerBI.PBI_Data.pbi_stage
url = 's3://powerbi-aws-project'
storage_integration = PBI_Integration;

//desc stage s1 ;

//drop stage s1;


copy into PBI_Dataset 
from @pbi_stage
file_format = (type=csv field_delimiter=',' skip_header=1 )
on_error = 'continue' ;

list @pbi_stage ;

select year , count(*) as Count from PBI_DATASET group by YEAR order by year;


--- Transformation of data Using Snowflake  
create table agriculture as 
select * from pbi_dataset;

select * from agriculture;

update agriculture
set rainfall = 1.1 * rainfall;

update agriculture 
set area = 0.9 * area;

select * from agriculture;


ALTER table agriculture
add year_group String ;

update agriculture 
set year_group = 'Y1'
where year >= 2004 and year <= 2009;

update agriculture 
set year_group = 'Y2'
where year >= 2010 and year <= 2015;

update agriculture 
set year_group = 'Y3'
where year >= 2016 and year <= 2019;



-- Adding rainfall Groups 
-- min 255 max 4103

--rainfall 255 & 1200 - Low
--rainfall 1200 2800 - Medium
--Rainfall 2800 & 4103 - High

alter table agriculture 
add rainfall_group String;

select * from agriculture

--rainfall 255 & 1200 - Low
update agriculture
set rainfall_group = 'Low'
where rainfall >= 255 and rainfall <1200;

--rainfall 1200 2800 - Medium
update agriculture
set rainfall_group = 'Medium'
where rainfall >= 1201 and rainfall <2800;

--Rainfall 2800 & 4103 - High
update agriculture
set rainfall_group = 'High'
where rainfall >= 2800 and rainfall <4103;


TABLEAUselect * from agriculture
