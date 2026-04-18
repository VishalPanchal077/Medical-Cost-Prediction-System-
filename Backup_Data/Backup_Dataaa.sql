use Copy_Medical;

CREATE TABLE hospital_visitss (
    Visit_id VARCHAR(10) PRIMARY KEY,
    Patient_id VARCHAR(10),
    Hospital_id VARCHAR(10),
    Visit_date DATE,
    Visit_reason VARCHAR(50)
);

select * from hospital_visitss;

CREATE TABLE Hospitalss (
    Hospital_id VARCHAR(10) PRIMARY KEY,
    Hospital_name VARCHAR(100) NOT NULL,
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50) NOT NULL,
    Hospital_type VARCHAR(20) NOT NULL
);

CREATE TABLE Patientss (
    Patient_id VARCHAR(20) PRIMARY KEY,
    First_name VARCHAR(50),
    Last_name VARCHAR(50),
    Gender VARCHAR(10),
    Date DATE,
    City VARCHAR(50),
    State VARCHAR(50)
);

CREATE TABLE Lifestyless (
    lifestyle_id  VARCHAR(30),                                
    patient_id VARCHAR(30),
    smoking_status VARCHAR(20),
    alcohol_consumption VARCHAR(20),
    Bmi DECIMAL(6,2),
    exercise_frequency VARCHAR(30)
);

CREATE TABLE Lab_Testss (
    Test_id VARCHAR(20) PRIMARY KEY,
    Visit_id VARCHAR(20),
    Test_name VARCHAR(50),
    Test_result VARCHAR(20),
    Test_cost INT
);

CREATE TABLE Medical_Billingss (
    Bill_id VARCHAR(20) PRIMARY KEY,
    Visit_id VARCHAR(20),
    Total_amount INT,
    Insurance_covered INT,
    Out_of_pocket INT,
    Payment_status VARCHAR(20)
);

CREATE TABLE Medical_Historyss (
    History_id VARCHAR(20) PRIMARY KEY,
    Patient_id VARCHAR(20),
    Chronic_disease VARCHAR(50),
    Diagnosis_date DATE,
    Allergies VARCHAR(50)
);

CREATE TABLE Insurancess (
    Insurance_id VARCHAR(20) PRIMARY KEY,
    Patient_id VARCHAR(20),
    Insurance_provider VARCHAR(50),
    Policy_number VARCHAR(30),
    Coverage_amount INT,
    Policy_start_date DATE,
    Policy_end_date DATE
);

CREATE TABLE Prescriptionss (
    Prescription_id VARCHAR(30) ,          
    Visit_id VARCHAR(30),
    Medicine_name VARCHAR(100),
    Dosage VARCHAR(30),
    Duration_days int
);

select * from hospital_visitss;
select * from hospitalss;
select * from Prescription;
select * from Insurancess;
select * from Medical_Historyss;
select * from Medical_Billingss;
select * from Lab_Testss;
select * from Lifestyless;
select * from Patientss;

DROP TABLE hospital_visit;
DROP TABLE Prescription;
DROP TABLE Insurance;
DROP TABLE Medical_History;
DROP TABLE Lifestyle;
DROP TABLE Lab_Test;
DROP TABLE Medical_Billing;
drop table patients;
