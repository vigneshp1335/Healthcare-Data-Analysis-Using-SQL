create database healthcare;

use healthcare;

# patient table

SELECT COUNT(*) AS total_patients FROM patient_detials;
SELECT gender, COUNT(*) AS total FROM patient_detials GROUP BY gender;
SELECT city, COUNT(*) AS total FROM patient_detials GROUP BY city;
SELECT MONTH(registration_date) AS month,COUNT(*) AS total FROM patient_detials
GROUP BY MONTH(registration_date) ORDER BY month;
SELECT * FROM patient_detials WHERE registration_date > '2023-01-01';
SELECT 
CASE
    WHEN age BETWEEN 20 AND 30 THEN '20-30'
    WHEN age BETWEEN 31 AND 40 THEN '31-40'
    WHEN age BETWEEN 41 AND 50 THEN '41-50'
    WHEN age BETWEEN 51 AND 60 THEN '51-60'
    ELSE '60+'
END AS age_group,
COUNT(*) AS total_patients FROM patient_detials GROUP BY age_group ORDER BY age_group;
SELECT AVG(age) AS average_age FROM patient_detials;
SELECT COUNT(*) AS senior_citizens FROM patient_detials WHERE age > 60;
SELECT * FROM patient_detials WHERE city = 'Chennai'AND registration_date > '2023-01-01';
SELECT city, COUNT(*) AS total FROM patient_detials GROUP BY city ORDER BY total DESC LIMIT 5;

# doctors table

SELECT COUNT(*) AS total_doctors FROM doctors;
SELECT specialization, COUNT(*) AS total FROM doctors GROUP BY specialization;
SELECT specialization, AVG(experience_years) AS avg_experience FROM doctors GROUP BY specialization;
SELECT * FROM doctors WHERE experience_years > 10;
SELECT doctor_name, specialization FROM doctors;
SELECT * FROM doctors ORDER BY experience_years DESC
LIMIT 1;
SELECT * FROM doctors ORDER BY experience_years ASC
LIMIT 1;
SELECT d.doctor_id,d.doctor_name,d.specialization FROM doctors d
LEFT JOIN appointments a ON d.doctor_id = a.doctor_id WHERE a.appointment_id is null;
SELECT 
CASE
    WHEN experience_years BETWEEN 0 AND 5 THEN '0-5'
    WHEN experience_years BETWEEN 6 AND 10 THEN '6-10'
    WHEN experience_years BETWEEN 11 AND 20 THEN '11-20'
    ELSE '20+'
END AS experience_range,
COUNT(*) AS total FROM doctors GROUP BY experience_range;
SELECT * FROM doctors ORDER BY experience_years DESC LIMIT 3;

#appointment table

SELECT COUNT(*) AS total_appointments FROM appointments;
SELECT doctor_id, COUNT(*) AS total FROM appointments GROUP BY doctor_id;
SELECT patient_id, COUNT(*) AS total_visits FROM appointments GROUP BY patient_id;
SELECT MONTH(visit_date) AS month,COUNT(*) AS total FROM appointments GROUP BY MONTH(visit_date) ORDER BY month;
SELECT disease, COUNT(*) AS total FROM appointments GROUP BY disease ORDER BY total DESC;
SELECT disease, COUNT(*) AS total FROM appointments GROUP BY disease ORDER BY total DESC
LIMIT 1;
SELECT patient_id, COUNT(*) AS total_visits FROM appointments GROUP BY patient_id HAVING COUNT(*) > 3;
SELECT doctor_id, COUNT( DISTINCT patient_id) AS total_patients FROM appointments GROUP BY doctor_id
HAVING COUNT( DISTINCT patient_id) > 50;
SELECT DISTINCT patient_id FROM appointments WHERE visit_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);
SELECT patient_id,
       MIN(visit_date) AS first_visit,
       MAX(visit_date) AS last_visit FROM appointments GROUP BY patient_id;

#bill table

SELECT SUM(bill_amount) AS total_revenue FROM billing_details;
SELECT AVG(bill_amount) AS average_bill FROM billing_details;
SELECT payment_mode, SUM(bill_amount) AS total_revenue FROM billing_details GROUP BY payment_mode;
SELECT payment_mode, COUNT(*) AS total_transactions FROM billing_details GROUP BY payment_mode;
SELECT MAX(bill_amount) AS highest_bill,
       MIN(bill_amount) AS lowest_bill FROM billing_details;
SELECT MONTH(payment_date) AS month, SUM(bill_amount) AS total_revenue FROM billing_details 
GROUP BY MONTH(payment_date) ORDER BY month;
SELECT * FROM billing_details WHERE bill_amount > (SELECT AVG(bill_amount) FROM billing_details);
SELECT * FROM billing_details ORDER BY bill_amount DESC
LIMIT 10;

#combined(joins)

 SELECT p.city,SUM(b.bill_amount) AS total_revenue FROM patient_detials p 
 INNER JOIN appointments a ON p.patient_id = a.patient_id
 INNER JOIN billing_details b ON a.appointment_id = b.appointment_id 
GROUP BY p.city ORDER BY total_revenue DESC;

SELECT d.doctor_name,SUM(b.bill_amount) AS total_revenue FROM doctors d
INNER JOIN appointments a ON d.doctor_id = a.doctor_id
INNER JOIN billing_details b ON a.appointment_id = b.appointment_id 
GROUP BY d.doctor_name ORDER BY total_revenue DESC;

SELECT d.specialization,SUM(b.bill_amount) AS total_revenue FROM doctors d
INNER JOIN appointments a ON d.doctor_id = a.doctor_id
INNER JOIN billing_details b ON a.appointment_id = b.appointment_id
GROUP BY d.specialization ORDER BY total_revenue DESC;

SELECT p.patient_name,SUM(b.bill_amount) AS total_spent FROM patient_detials p
INNER JOIN appointments a ON p.patient_id = a.patient_id
INNER JOIN billing_details b ON a.appointment_id = b.appointment_id
GROUP BY p.patient_name ORDER BY total_spent DESC;

SELECT d.doctor_name,SUM(b.bill_amount) AS total_revenue FROM doctors d
INNER JOIN appointments a ON d.doctor_id = a.doctor_id
INNER JOIN billing_details b ON a.appointment_id = b.appointment_id
GROUP BY d.doctor_name ORDER BY total_revenue DESC
LIMIT 3;

SELECT 
CASE 
    WHEN COUNT(a.appointment_id) = 1 THEN 'New Patient'
    ELSE 'Repeat Patient'
END AS patient_type,
COUNT(*) AS total_patients FROM appointments a GROUP BY a.patient_id;

SELECT p.patient_name,COUNT(DISTINCT a.doctor_id) AS doctor_count FROM patient_detials p
INNER JOIN appointments a ON p.patient_id = a.patient_id
GROUP BY p.patient_name HAVING COUNT(DISTINCT a.doctor_id) > 1;

SELECT a.disease,SUM(b.bill_amount) AS total_revenue FROM appointments a
INNER JOIN billing_details b ON a.appointment_id = b.appointment_id
GROUP BY a.disease ORDER BY total_revenue DESC;

SELECT d.doctor_name,d.specialization,COUNT(a.appointment_id) AS total_appointments,SUM(b.bill_amount) AS total_revenue FROM doctors d
INNER JOIN appointments a ON d.doctor_id = a.doctor_id
INNER JOIN billing_details b ON a.appointment_id = b.appointment_id
GROUP BY d.doctor_name, d.specialization ORDER BY total_revenue DESC;

SELECT p.patient_name,SUM(b.bill_amount) AS total_spent FROM patient_detials p
INNER JOIN appointments a ON p.patient_id = a.patient_id
INNER JOIN billing_details b ON a.appointment_id = b.appointment_id
GROUP BY p.patient_name HAVING SUM(b.bill_amount) > 1000 ORDER BY total_spent DESC;