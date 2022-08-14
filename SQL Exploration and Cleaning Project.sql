/* SQL Exploration And Cleaning Project on Brain strokes*/
---This data is downloaded from kaggle --

/* Table of contents 
1) gender: "Male", "Female" or "Other"
2) age: age of the patient
3) hypertension: 0 if the patient doesn't have hypertension, 1 if the patient has hypertension
4) heart disease: 0 if the patient doesn't have any heart diseases, 1 if the patient has a heart disease 
5) ever-married: "No" or "Yes"
6) worktype: "children", "Govtjov", "Neverworked", "Private" or "Self-employed" 7) Residencetype: "Rural" or "Urban"
8) avgglucoselevel: average glucose level in blood
9) bmi: body mass index
10) smoking_status: "formerly smoked", "never smoked", "smokes" or "Unknown"*
11) stroke: 1 if the patient had a stroke or 0 if not
*/

USE [DATA DB]

--Let's Explore the data first--
SELECT* FROM [dbo].[brain_stroke$]

/* Let's ook for any NULL Values*/


SELECT gender,age,hypertension,heart_disease,ever_married,Residence_type,avg_glucose_level,smoking_status,stroke
FROM  [dbo].[brain_stroke$]
WHERE stroke IS NULL
 --- it seems there is one row containing null value where stroke column and smoking_status have null values--
 
 DELETE FROM [dbo].[brain_stroke$]
 WHERE smoking_status IS NULL

/* the above query deletd the null value row */

/* There seems to be in the smoking status column certain field values are marked as unknown */

 SELECT  smoking_status, age  FROM [dbo].[brain_stroke$]
 WHERE smoking_status ='Unknown'

 --Let's count the unknown value in smoking_status column*/

 SELECT COUNT(smoking_status) FROM  [dbo].[brain_stroke$]
 WHERE smoking_status ='Unknown'
 /*THE ANSWER SHOWS 10551*/

 /* Lets assume that certain age group won't smoke*/
 
 SELECT age,smoking_status FROM  [dbo].[brain_stroke$] 
 WHERE age< 10 AND smoking_status!='Unknown'

  --well it looks only those under age 10 is the only ones those don't smoke :o--
  --Now lets fill the smoking_status column with never smoked with those are under the age of 10--

  SELECT age,smoking_status,
 CASE
     WHEN age < 10 THEN REPLACE(smoking_status,'Unknown','never smoked')
	 ELSE smoking_status
	 END
 FROM [dbo].[brain_stroke$] 

 UPDATE [dbo].[brain_stroke$] 
 SET smoking_status=CASE
     WHEN age < 10 THEN REPLACE(smoking_status,'Unknown','never smoked')
	 ELSE smoking_status
	 END
--Let's see if the above query worked---

SELECT COUNT(smoking_status) FROM  [dbo].[brain_stroke$]
 WHERE smoking_status ='Unknown'

 --Yes the count now reduced to 7334--

--Lets add an additional Table to categorize their age----

SELECT age ,
CASE 
    WHEN age <=18 THEN 'Child'
	WHEN age <=40 THEN 'Youth'
	WHEN age <=55 THEN 'Middle_Age'
	ELSE 'Old_Age'
	END
FROM  [dbo].[brain_stroke$]


ALTER TABLE  [dbo].[brain_stroke$]
ADD  Age_interval NVARCHAR(255)

UPDATE  [dbo].[brain_stroke$]
SET Age_interval=CASE 
    WHEN age <=18 THEN 'Child'
	WHEN age <=40 THEN 'Youth'
	WHEN age <=55 THEN 'Middle_Age'
	ELSE 'Old_Age'
	END

	SELECT* FROM [dbo].[brain_stroke$]
	WHERE smoking_status !='Unknown' AND smoking_status='smokes'
	

  SELECT DISTINCT(ever_married),COUNT(ever_married)
  FROM  [dbo].[brain_stroke$]
  WHERE   hypertension=1 AND stroke=1  
  GROUP BY ever_married
  ORDER BY 2

  ---FROM the above query it seems that Married people have more stroke occured--

SELECT DISTINCT(work_type),COUNT(work_type)
  FROM  [dbo].[brain_stroke$]
  WHERE hypertension=1 AND stroke=1  
  GROUP BY work_type
  ORDER BY 2
  
  ---This uery shows Private employees have more strokes occured---
	
 SELECT* FROM [dbo].[brain_stroke$]

 SELECT DISTINCT(smoking_status),COUNT(smoking_status) 
 FROM [dbo].[brain_stroke$]
 WHERE stroke>0 AND smoking_status!='Unknown'
 GROUP BY smoking_status
 ORDER BY 2

 --It seems smoking realy much of a factor for the stroke occurs ---

 --NOW lets see how does it affect Different Ages--

SELECT DISTINCT(Age_interval),COUNT(Age_interval)
FROM [dbo].[brain_stroke$]
WHERE hypertension=1 AND stroke=1  
GROUP BY Age_interval
ORDER BY 2

---It seems there is no strokes found in children but shows old age people is affected the most---

SELECT* FROM [dbo].[brain_stroke$]


SELECT gender,AVG(CAST(age AS INT)) AS Avg_age FROM [dbo].[brain_stroke$]
WHERE  stroke=1 
GROUP  BY gender

-- The AVG age for men and women to have stroke is at the age of 68 & 67--

 --Min and MAX age of men and women who has stroke--

 SELECT gender, MIN(CAST(age AS INT)) AS Min_age FROM [dbo].[brain_stroke$]
 WHERE stroke=1
 GROUP BY gender 


 SELECT gender, MAX(CAST(age AS INT)) AS Min_age FROM [dbo].[brain_stroke$]
 WHERE stroke=1
 GROUP BY gender 

 
 /** I hope there is nothing much left to further explore int the given date with this let me conclude my first SQL Project**/