create database Medical_Cost_Prediction;
use Medical_Cost_Prediction;

SELECT NOW();

CREATE TABLE hospital_visit (
    Visit_id VARCHAR(10) PRIMARY KEY,
    Patient_id VARCHAR(10),
    Hospital_id VARCHAR(10),
    Visit_date DATE,
    Visit_reason VARCHAR(50)
); 
#Relationship create
ALTER TABLE hospital_visit ADD CONSTRAINT fk_patient_visit
FOREIGN KEY (Patient_id) REFERENCES Patients(Patient_id);

select * from hospital_visit;
describe hospital_visit;

CREATE TABLE Hospitals (
    Hospital_id VARCHAR(10) PRIMARY KEY,
    Hospital_name VARCHAR(100) NOT NULL,
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50) NOT NULL,
    Hospital_type VARCHAR(20) NOT NULL
);
select * from hospitals;
describe hospitals;
#ALTER TABLE hospital_visit
#ADD CONSTRAINT fk_hospital
#FOREIGN KEY (Hospital_id)
#REFERENCES Hospitals(Hospital_id);

CREATE TABLE Patients (
    Patient_id VARCHAR(20) PRIMARY KEY,
    First_name VARCHAR(50),
    Last_name VARCHAR(50),
    Gender VARCHAR(10),
    Date DATE,
    City VARCHAR(50),
    State VARCHAR(50)
);

select * from Patients;

CREATE TABLE Lifestyle (
    lifestyle_id  VARCHAR(30),                                
    patient_id VARCHAR(30),
    smoking_status VARCHAR(20),
    alcohol_consumption VARCHAR(20),
    Bmi DECIMAL(6,2),
    exercise_frequency VARCHAR(30)
);
select * from Lifestyle;
describe Lifestyle;
SHOW COLUMNS FROM Lifestyle;

ALTER TABLE Lifestyle
RENAME COLUMN patient_id TO Patient_id;

SET GLOBAL wait_timeout = 600;
SET GLOBAL interactive_timeout = 600;

SELECT COUNT(*) FROM Lifestyle;

SET SESSION lock_wait_timeout = 120;

CREATE TABLE Lifestyle_new AS
SELECT 
    lifestyle_id,
    patient_id AS Patient_id,
    smoking_status,
    alcohol_consumption,
    Bmi,
    exercise_frequency
FROM Lifestyle;

#Relationship create
ALTER TABLE Lifestyle
ADD PRIMARY KEY (lifestyle_id);

ALTER TABLE Lifestyle
ADD CONSTRAINT fk_patient_lifestyle
FOREIGN KEY (patient_id)
REFERENCES Patients(patient_id);

CREATE TABLE Lab_Test (
    Test_id VARCHAR(20) PRIMARY KEY,
    Visit_id VARCHAR(20),
    Test_name VARCHAR(50),
    Test_result VARCHAR(20),
    Test_cost INT
);
#Relationship create
ALTER TABLE Lab_Test ADD CONSTRAINT fk_visit_lab
FOREIGN KEY (Visit_id) REFERENCES hospital_visit(Visit_id);
select * from Lab_Test;

CREATE TABLE Medical_Billing (
    Bill_id VARCHAR(20) PRIMARY KEY,
    Visit_id VARCHAR(20),
    Total_amount INT,
    Insurance_covered INT,
    Out_of_pocket INT,
    Payment_status VARCHAR(20)
);
#Relation Create
ALTER TABLE Medical_Billing ADD CONSTRAINT fk_visit_bill
FOREIGN KEY (Visit_id) REFERENCES hospital_visit(Visit_id);
select * from Medical_Billing;
describe Medical_Billing ;

CREATE TABLE Medical_History (
    History_id VARCHAR(20) PRIMARY KEY,
    Patient_id VARCHAR(20),
    Chronic_disease VARCHAR(50),
    Diagnosis_date DATE,
    Allergies VARCHAR(50)
);
#Relationship Create
ALTER TABLE Medical_History ADD CONSTRAINT fk_patient_history
FOREIGN KEY (Patient_id) REFERENCES Patients(Patient_id);
select * from Medical_History;
describe Medical_History;

CREATE TABLE Insurance (
    Insurance_id VARCHAR(20) PRIMARY KEY,
    Patient_id VARCHAR(20),
    Insurance_provider VARCHAR(50),
    Policy_number VARCHAR(30),
    Coverage_amount INT,
    Policy_start_date DATE,
    Policy_end_date DATE
);
#Relationship create
ALTER TABLE Insurance ADD CONSTRAINT fk_patient_insurance
FOREIGN KEY (Patient_id) REFERENCES Patients(Patient_id);

select * from Insurance;
describe Insurance;

CREATE TABLE Prescription (
    Prescription_id VARCHAR(30) ,          
    Visit_id VARCHAR(30),
    Medicine_name VARCHAR(100),
    Dosage VARCHAR(30),
    Duration_days int
);
select * from Prescription;
describe Prescription;

#Relationship create
ALTER TABLE Prescription
ADD PRIMARY KEY (Prescription_id);

alter table  Prescription drop primary key;

#Add Foreign key
ALTER TABLE Prescription ADD CONSTRAINT fk_visit_prescription
FOREIGN KEY (Visit_id) REFERENCES hospital_visit(Visit_id);

SELECT Visit_id FROM Prescription;
SELECT Visit_id FROM hospital_visit;

#Miss Match check vlaue
SELECT Visit_id
FROM Prescription
WHERE Visit_id NOT IN (
    SELECT Visit_id FROM hospital_visit
);

DELETE FROM Prescription
WHERE Visit_id NOT IN (
    SELECT Visit_id FROM hospital_visit
);

SET SQL_SAFE_UPDATES = 0;
 
#40 QUESTION 
#Basic Queries (1–5)
#1. Display all patients.
select * from patients;
 
#2. Display all hospitals.
 select * from hospitals;
 
#3. Display all hospital visits.
 select * from hospital_visit;
 
#4. Display all lab tests.
 select * from Lab_test;
 
#5. Display all prescriptions.
 select * from prescription;
 
 #Filtering Queries (6–10)
#6. Show patients who are Male
select * from patients where gender = "male";
 
#7. Show hospitals located in a specific city (example: Inodre).
select * from hospitals where city ="Indore";
 
#8. Show patients with BMI greater than 25.
select * from Lifestyle where bmi >25;
 
#9. Show lab tests costing more than 1000.
select * from lab_test where test_cost > 1000;

#10. Show bills with payment status "Pending".
select * from medical_billing where Payment_status ="Pending";

#JOIN Queries(11-18)
#11. Show patient name with BMI.
select p.First_name , p.Last_name , l.bmi 
from lifestyle as l join patients as p 
on p.patient_id = l.patient_id;
 
#12. Show patient name with insurance provider.
 select p.First_name , p.Last_name , I.Insurance_provider  
 from Insurance as I join patients as p
 on p.patient_id = I.Patient_id;
 
#13. Show visit details with hospital name.
 select hv.visit_id , hv.patient_id , hv.hospital_id , hv.visit_date , hv.visit_reason , h.hospital_name
 from hospital_visit as hv join hospitals as h 
 on h.hospital_id= hv.hospital_id; 
 
#14. Show medicines prescribed in each visit.
 select * from hospital_visit;
 select * from prescription;
 select hv.visit_id , hv.patient_id , hv.hospital_id , hv.visit_date , hv.visit_reason ,
 p.medicine_name , p.dosage  
 from hospital_visit as hv join prescription as p
 on hv.visit_id = p.visit_id;
 
#15. Show patient with their chronic disease.
 select p.First_name , p.Last_name , p.Gender , p.City ,
 mh.chronic_disease from patients as p join medical_history as mh 
 using(Patient_id);
 
#16. Show visit with lab test results
select hv.visit_id , hv.patient_id , hv.hospital_id , hv.visit_date , hv.visit_reason ,
lb.Test_name , lb.Test_result , lb.test_cost 
from Lab_test as lb join Hospital_visit as hv 
using(visit_id);

#17. Show visit with total billing amount.
select v.visit_id , v.visit_date , v.visit_reason , mb.total_amount
from Medical_billing as mb join hospital_visit as v 
on v.visit_id = mb.visit_id;

#18. Show patient name and visit date.
select p.first_name , p.last_name , p.gender , p.city , hv.visit_date 
from patients as p join hospital_visit as hv 
on p.patient_id = hv.patient_id;
 
#Aggregate Functions (19–25)
#19. Count total patients
select count(*) as Total_Patient  from patients;

#20. Count total hospitals.
select count(*) as Total_hospital  from hospitals; 

#21. Find average BMI.
select avg(bmi) as BMI from Lifestyle;

#22. Find maximum test cost.
select max(test_cost) as Test_Cost_Maximum from lab_test;

#23. Find minimum test cost.
select min(test_cost)as Tect_cost_Minimum from Lab_test;

#24. Find total billing amount.
select sum(Total_amount) as Total_Amount from medical_billing;

#25. Count number of insured provider.
Select count(*) as Insurance_Provider from Insurance; 

#GROUP BY Queries (26–30)
#26. Count patients by gender.
select gender , count(*) as Total_patient 
from Patients 
group by gender;

#27. Count hospitals by city.
select city , count(*) as Total_hospital 
from hospitals 
group by city;

#28. Count patients by smoking status.
SELECT smoking_status, COUNT(*) AS patient_count
from Lifestyle 
GROUP BY smoking_status; 

#29. Count bills by payment status.
select payment_status , count(*) as Payment_Status 
from medical_billing 
group by Payment_status;

#30. Count lab tests by test name.
select Test_name , count(*) as Count_testName
 from lab_test
 group by Test_name;

#Advanced Queries (31–35)
#31. Find the most expensive lab test.
select Test_name , Test_cost from Lab_test order by Test_cost desc limit 1;

# Using Sub Query
select Test_name , Test_cost from Lab_test 
where Test_cost = (select max(Test_cost) from Lab_test);

#32. Find patient with highest BMI.
select p.First_name , p.Last_name , l.bmi 
from patients as p join Lifestyle as l 
on p.patient_id = l.patient_id 
order by bmi desc limit 1;


select max(Total_amount)  from medical_billing where Total_amount < (select max(Total_amount) from Medical_billing);
SELECT distinct Total_amount
FROM medical_billing
ORDER BY Total_amount DESC
LIMIT 1 OFFSET 1;

#33. Show patients with allergies.
select mh.Allergies , p.First_name , p.Last_name
from medical_history as mh join patients as p 
on p.patient_id = mh.patient_id
where mh.Allergies is not null;

#34. Find visits where lab tests were conducted.
select lb.Test_name ,
 hv.visit_id, hv.patient_id , hv.visit_reason , hv.visit_date
from hospital_visit as hv join lab_test as lb 
on hv.visit_id = lb.visit_id;

#35. Find patients who visited the hospital.
select h.Hospital_name , h.city , h.Hospital_Type ,
hv.hospital_id , hv.Visit_date , hv.Visit_reason ,
p.patient_id , p.First_name , p.Last_name , p.gender , p.city 
from patients as p join Hospital_Visit as hv
on p.patient_id = hv.patient_id 
join  hospitals as h
on h.hospital_id = hv.hospital_id;


#Additional SQL Questions (36–40)
#36. Show patient name and the hospital they visited.
select h.hospital_name , h.hospital_type ,
p.First_name , p.Last_name ,
hv.visit_id 
from Patients as p join hospital_visit as hv
on p.patient_id = hv.Patient_id
join hospitals as h
on h.hospital_id = hv.hospital_id;

#37. Show patient name with their prescribed medicines.
select p.First_name , p.Last_name ,
pr.Medicine_name 
from Patients as p join hospital_visit as hv
on p.patient_id = hv.patient_id 
join Prescription as pr
on pr.Visit_id = hv.Visit_id;

#38. Show total lab test cost for each visit.
select sum(lb.Test_cost) as Total_cost ,
hv.visit_id 
from Lab_test as lb join hospital_visit as hv
on hv.visit_id = lb.visit_id
group by hv.visit_id;

#39. Show patients who have insurance coverage more than 500000.
select p.First_name , p.Last_name ,
I.Coverage_amount , I.Insurance_provider 
from Insurance as I join Patients as p 
on p.patient_id = I.patient_id
where Coverage_amount > 500000;

#40. Show visits that have prescription.
select distinct p.First_name , p.Last_name ,
hv.visit_id , hv.patient_id
from hospital_visit as hv join Prescription as pr
on pr.visit_id = hv.visit_id
join patients as p 
on p.patient_id = hv.patient_id;

-- Here are only the questions (41–50) without SQL answers:
#41 Show patient name and their city.
select First_name , Last_name , City from Patients;

# 42.Show hospitals located in a specific state (example: Indore).
select * from hospitals where city ="Indore";

# 43.Show patients who do not smoke.
select * from Lifestyle where  smoking_status = "No";

# 44.Show visits along with the reason for visit.
select visit_id , Patient_id , hospital_id , visit_reason from Hospital_visit;

# 45.Show all patients who have chronic diseases.
select * from Patients;
select * from medical_history;
select P.Patient_id , P.First_name , P.Last_name , P.Gender , P.City ,
mh.Chronic_disease 
from Patients as p join Medical_history as mh
using(Patient_id);

# 46.Show patient name and their allergies.
select * from Patients;
select * from Medical_history;
select P.First_name , P.Last_name , P.Gender , p.city ,
mh.Allergies 
from Patients as P join Medical_History  as mh
on P.Patient_id = mh.Patient_id;

# 47.Show total number of visits for each patient.
select Patient_id ,count(*) as Total_Visit from Hospital_visit 
group by Patient_id;

# 48.Show hospital name and number of visits.
select * from hospital_visit;
select * from hospitals;
select h.hospital_name , count(*) as Visit_Number 
from Hospitals as h 
join hospital_visit as hv
on h.hospital_id = hv.hospital_id
group by h.Hospital_name;

# 49.Show patient name and their insurance coverage amount.
select * from Patients;
select * from Insurance;

# 50.Show medicines prescribed for more than 5 days.
select * from Prescription where Duration_days >5;


-- Window Function Queries (51–55)
# 51. Rank patients based on BMI (highest to lowest).
select * from Lifestyle ;
select patient_id , bmi ,
rank() over(order by bmi desc) as BMI_RANK
from Lifestyle;

# 52. Show row number for each hospital visit.
select * from hospital_visit;
select visit_id ,patient_id ,
row_number() over(order by visit_id desc) as RowNumber
from hospital_visit;

# 53. Show cumulative billing amount.
select * from medical_billing;
select Bill_id , Total_amount ,
sum(Total_amount) over(order by Bill_id desc) as Clumative_Amount
from Medical_billing;

#54. Find average test cost using window function.
select * from Lab_test;
select Test_id , Test_name , Test_result , Test_cost ,
avg(Test_cost) 
over() as Avg_Test_Cost
from Lab_test;

# 55. Rank hospitals based on number of visits.
select * from hospital_visit;
select * from hospitals;
select h.Hospital_name , 
count(hv.visit_id) as Totalt_Visit ,
rank() over(order by count(hv.visit_id) desc) as hospital_rankk
from hospital_visit as hv join hospitals as h
on h.hospital_id = hv.hospital_id
group by h.hospital_name; 

-- Subquery Questions (56–57)
# 56. Find patients whose BMI is higher than the average BMI.
select P.First_name , P.Last_name ,
l.bmi , l.smoking_status , l.exercise_frequency
from lifestyle as l join Patients as p 
on p.patient_id = l.patient_id
where bmi > (select avg(bmi) from Lifestyle);


select * from Lifestyle where bmi > (select avg(bmi) from Lifestyle);

# 57. Find lab tests that have cost higher than the average test cost.
select * from Lab_test where Test_cost > (select avg(Test_cost) from Lab_test);

--  Normal Queries (58–60)
# 58. Show patients who visited hospitals more than once.
select patient_id , count(*) as Total_visit
from Patients
group by Patient_id
having count(*) > 1;

# 59. Show hospitals that have more than 5 visits.
select hv.hospital_id ,
p.First_name , p.Last_name , count(*) as Visit
from hospital_visit as hv join patients as p
on p.patient_id = hv.patient_id
group by hv.hospital_id , p.First_name , p.Last_name
having count(*) >5 ;

SELECT hv.hospital_id,
COUNT(*) AS Visit_Count
FROM hospital_visit hv
GROUP BY hv.hospital_id
HAVING COUNT(*) > 5;

select * from hospital_visit;
select * from Patients;

# 60. Show patients who have both insurance and medical history.
select * from Patients;
select * from Medical_history;
select * from Insurance;
select P.First_name , P.Last_name , P.Gender , P.City , 
mh.History_id , mh.Patient_id , 
I.Patient_id 
from Patients as p join Insurance as I
on P.Patient_id = I.Patient_id
join Medical_history as mh
on mh.patient_id = p.patient_id;