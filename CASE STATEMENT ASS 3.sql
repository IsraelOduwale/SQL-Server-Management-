-- =============================================
-- Author:		Israel Oduwale
-- Create date: 05-10-2024
-- Description:	This code is to run several Case Statements
--				Do more analysis on Table Students
-- Revise Date: 08-19-2024 
-- Version:		v1.0
-- =============================================

use SQLTrainingCase

create table Students
(
ID int not null,
[NAME] varchar (50) not null,
SCORE smallint not null
);

insert into Students
values
(1, 'Simisola', 60),
(2, 'Ivan', 80),
(3, 'Metodija', 52),
(4, 'Callum', 98),
(5, 'Leia', 84),
(6, 'Aparecida', 82),
(7, 'Ursula', 69),
(8, 'Ramazan', 78),
(9, 'Corona', 87),
(10, 'Alise', 57),
(11, 'Galadriel', 89),
(12, 'Merel', 99),
(13, 'Cherice', 55),
(14, 'Nithya', 81),
(15, 'Elsad', 71),
(16, 'Liisi', 90),
(17, 'Johanna', 90),
(18, 'Anfisa', 90),
(19, 'Ryosuke', 97),
(20, 'Sakchai', 61),
(21, 'Elbert', 63),
(22, 'Katelyn', 51);

select * from Students

/**
We have a table with a list of students and their scores on an exam. We need to give each student a grade, and we need to do it automatically.Write a logic in which we will write the breakdown for each grade. When score is 94 or higher, the row will have the value of A. If  score is  94 gets an  A, If  score is  90 gets an  A- ,If  score is  87 gets an  B+  ,
If  score is  83 gets an  B  ,If  score is  80 gets an  B- ,If  score is  77 gets an  C+ ,
If  score is  73 gets an  C , If  score is  70 gets an  C- ,If  score is  67 gets an  D+ ,
If  score is  60 gets an  D,if students get none of these scores, you should assign an FGive each student a grade, which we will add in a new column named grade.
You can show the grades from highest to lowest
**/

Select 
ID,
[NAME],
SCORE,
case
when Score between 60 and 66 then 'D'
when Score between 67 and 69 then 'D+'
when Score between 70 and 72 then 'C-'
when Score between 73 and 76 then 'C'
when Score between 77 and 79 then 'C+'
when Score between 80 and 82 then 'B-'
when Score between 83 and 86 then 'B'
when Score between 87 and 89 then 'B+'
when score between 90 and 93 then 'A-'
when Score>=94 then 'A'
else 'F'
end as 'GRADE'
from Students
order by SCORE desc
/**
Do analysis on the above data to show how many students passed or failed. If a student scores 60 or higher, that student passed but if they scored lower than 60, they have failed**/select 
case 
when score>=60 then 'Passed'
when score<60 then 'Failed'
else 'Unknown'
End as 'RESULT',
Count(*) as 'NUMBER_OF_STUDENTS'
from Students
Group by
case 
when score>=60 then 'Passed'
when score<60 then 'Failed'
else 'Unknown'
end;



--another way is subquery
select
Result, Count (*) as 'Number_of_student'
from
(
select 
id,
case 
when score>=60 then 'Passed'
when score<60 then 'Failed'
else 'Unknown'
End as 'RESULT'
from Students
Group by SCORE, ID
)x 
group by Result


