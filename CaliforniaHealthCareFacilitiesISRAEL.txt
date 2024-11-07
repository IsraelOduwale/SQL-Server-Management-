-- =============================================
-- Author:		Israel Oduwale
-- Create date: 11-07-2024
-- Description:	This code is to create the CaliforniaHospitals Table 
--				To run further analysis on the records in the TABLES
-- PROJECT SCOPE:  1: LOAD HOSPITAL FACILITIES DATA TO DATABASE 
--				   2: CREATE SQL QUERIES TO GENERATE METRICS LIKE TOTAL COUNTS, NUMBER OF BEDS, 
--					  NUMBER OF FACILITY TYPE, SHOW COUNTY MAPS FOR TOTAL NUMBER OF FACILITIES IN EACH COUNTY IN CALIFORNIA .
--				   3: PRODUCE A BUSINESS INTELLIGENCE REPORT SHOWING DIFFERENT KPIS
-- Version:		v1.0
-- =============================================


use Dev 
--creating table for sql command query in SSIS package
CREATE TABLE CaliforniaHospitalsData (
    [LICENSED_CERTIFIED] varchar(250) null,
    [FLAG] varchar(150) null,
    [T18_19] varchar(150) null,
    [FACID] varchar(150) null,
    [FAC_STATUS_TYPE_CODE] varchar(250) null,
    [ASPEN_FACID] varchar(150) null,
    [CCN] varchar(150) null,
    [TERMINAT_SW] varchar(150) null,
    [PARTICIPATION_DATE] varchar(150) null,
    [APPROVAL_DATE] varchar(150) null,
    [NPI] varchar(150) null,
    [CAN_BE_DEEMED_FAC_TYPE] varchar(150) null,
    [CAN_BE_CERTIFIED_FAC_TYPE] varchar(150) null,
    [DEEMED] varchar(150) null,
    [AO_CD] varchar(150) null,
    [DMG_EFCTV_DT] varchar(250) null,
    [AO_TRMNTN_DT] varchar(250) null,
    [AO_NAME] varchar(250) null,
    [FACNAME] varchar(250) null,
    [FAC_TYPE_CODE] varchar(250) null,
    [FAC_FDR] varchar(150) null,
    [LTC] varchar(150) null,
    [CAPACITY] varchar(150) null,
    [ADDRESS] varchar(150) null,
    [CITY] varchar(150) null,
    [ZIP] varchar(150) null,
    [ZIP9] varchar(150) null,
    [FACADMIN] varchar(150) null,
    [CONTACT_EMAIL] varchar(150) null,
    [CONTACT_FAX] varchar(150) null,
    [CONTACT_PHONE_NUMBER] varchar(150) null,
    [COUNTY_CODE] varchar(150) null,
    [COUNTY_NAME] varchar(150) null,
    [DISTRICT_NUMBER] varchar(150) null,
    [DISTRICT_NAME] varchar(150) null,
    [ISFACMAIN] varchar(150) null,
    [PARENT_FACID] varchar(150) null,
    [FAC_FAC_RELATIONSHIP_TYPE_CODE] varchar(150) null,
    [START_DATE] varchar(150) null,
    [LICENSE_NUMBER] varchar(150) null,
    [BUSINESS_NAME] varchar(150) null,
    [LICENSE_STATUS_DESCRIPTION] varchar(150) null,
    [INITIAL_LICENSE_DATE] varchar(150) null,
    [LICENSE_EFFECTIVE_DATE] varchar(150) null,
    [LICENSE_EXPIRATION_DATE] varchar(150) null,
    [ENTITY_TYPE_DESCRIPTION] varchar(150) null,
    [LATITUDE] varchar(150) null,
    [LONGITUDE] varchar(150) null,
    [LOCATION] varchar(150) null,
    [HCAI_ID] varchar(150) null,
    [CCLHO_CODE] varchar(150) null,
    [CCLHO_NAME] varchar(150) null,
    [FIPS_COUNTY_CODE] varchar(150) null,
    [BIRTHING_FACILITY_FLAG] varchar(150) null,
    [TRAUMA_PED_CTR] varchar(150) null,
    [TRAUMA_CTR] varchar(150) null,
    [TYPE_OF_CARE] varchar(150) null,
    [CRITICAL_ACCESS_HOSPITAL] varchar(150) null,
    [DATA_DATE] varchar(150) null,
    [DMG_EFCTV_DATE] varchar(150) null
);

--Confirming successful data load 
select * from [dbo].[CaliforniaHospitalsData];



--Record count
SELECT COUNT(*) as Total_Record_Count
FROM CaliforniaHospitalsData;



--Total Number of Beds available across all facilities
SELECT 
SUM(CAST(capacity AS INT)) AS NUMBER_OF_BEDS
FROM CaliforniaHospitalsData;


--TOTAL COUNTS OF FACILITIES BY FACILITY TYPE
SELECT
FAC_TYPE_CODE,
COUNT (FACID) AS 'Total Facilities by Type'
FROM CaliforniaHospitalsData
GROUP BY FAC_TYPE_CODE;


--Number of facility type
select  
count(distinct FAC_TYPE_CODE) as Number_Of_FacilityType
from CaliforniaHospitalsData;


--to show hospitals status based on their type of license (state licensing or federal certification) 
--and if they still open
Select 
LICENSED_CERTIFIED,
FAC_STATUS_TYPE_CODE,
count(*)
from CaliforniaHospitalsData
group by 
LICENSED_CERTIFIED,
FAC_STATUS_TYPE_CODE


--to show hospitals by T18-Medicare, T18/19-Medicare/Medi-Cal, T-19=Medi-Cal
SELECT 
COALESCE(T18_19, 'Other') AS T18_19_Type,
COUNT(*) AS TotalCount
FROM CaliforniaHospitalsData
GROUP BY 
COALESCE(T18_19, 'Other');




--to show number of terminated (Y is terminated and blank is not terminated)
SELECT 
case 
when TERMINAT_SW= 'Y' then 'Terminated'
else 'NotTerminated'
end as Certification_Status,
COUNT(*) AS TotalCount
FROM CaliforniaHospitalsData
group by 
TERMINAT_SW



--top 20 facilities details by total beds
SELECT top 20
FACNAME,
FAC_TYPE_CODE,
CITY,
SUM(CAST(capacity AS INT)) AS total_capacity
FROM CaliforniaHospitalsData
group by
FACNAME,
FAC_TYPE_CODE,
CITY
order by total_capacity desc










/**
DAX EXPRESSIONS USED IN POWERBI AND OTHERS

1. TO FIND TOTAL FACILITIES
TotalFacilities = COUNTROWS(DISTINCT(CaliforniaHospitalsData[FACID]))

2. CONDITIONAL COLUMN CREATED FOR TERMINAT SW TO SHOW TERMINATED (Y) AND NOT TERMINATED (IF BLANK)

3. CONDITIONAL COLUMN CREATED FOR T18_T19 COLUMN, T19- MEDIC-CAL, T18 OR T18/T19 = MEDICARE/MEDIC-CAL, ELSE 'OTHER'

4. to find terminated number 
Terminated = CALCULATE(COUNTROWS(CaliforniaHospitalsData), (CaliforniaHospitalsData[Terminat_status ]="Terminated"))

5. to find not terminated number 
Not_Terminated = CALCULATE(COUNTROWS(CaliforniaHospitalsData), (CaliforniaHospitalsData[Terminat_status ]="Not Terminated"))

6. TO FIND INACTIVE FACILITIES LICENSE STATUS
Inactive = 
CALCULATE(
    COUNTROWS('CaliforniaHospitalsData'),
    FILTER(
        'CaliforniaHospitalsData',
        CONTAINSSTRING('CaliforniaHospitalsData'[LICENSE_STATUS_DESCRIPTION], "Inactive")
    )
)

7. TO FIND ACTIVE FACILITIES LICENSE STATUS
Active = CALCULATE(COUNTROWS(CaliforniaHospitalsData), (CaliforniaHospitalsData[LICENSE_STATUS_DESCRIPTION]="Active"))

8. TO FIND THE NUMBER OF CERTIFIED FACILITIES
Certified Only = CALCULATE(COUNTROWS(CaliforniaHospitalsData), (CaliforniaHospitalsData[LICENSED_CERTIFIED]="Certified Only"))

9. TO FIND THE NUMBER OF LICENSED AND CERTIFIED FACILITIES
Licensed and Certified = CALCULATE(COUNTROWS(CaliforniaHospitalsData),
	(CaliforniaHospitalsData[LICENSED_CERTIFIED]="Licensed and Certified"))

10.  TO FIND THE NUMBER OF LICENSED ONLY FACILITIES
Licensed Only = CALCULATE(COUNTROWS(CaliforniaHospitalsData), (CaliforniaHospitalsData[LICENSED_CERTIFIED]="Licensed Only"))

11. TO FIND THE NUMBER OF NOT LICENSED/NOT CERTIFIED FACILITIES
Not_Licensed/Not Certified = CALCULATE(COUNTROWS(CaliforniaHospitalsData), 
	(CaliforniaHospitalsData[LICENSED_CERTIFIED]="Not Licensed/Not Certified"))
**/

select 
count(license_status_description)
from [dbo].[CaliforniaHospitalsData]
where LICENSE_STATUS_DESCRIPTION='Active'

select 
count(license_status_description)
from [dbo].[CaliforniaHospitalsData]
where LICENSE_STATUS_DESCRIPTION like 'Inactive%'