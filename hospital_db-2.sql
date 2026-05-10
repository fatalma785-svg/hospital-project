-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: 25 أبريل 2026 الساعة 14:03
-- إصدار الخادم: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hospital_db`
--

-- --------------------------------------------------------

--
-- بنية الجدول `departments`
--

CREATE TABLE `departments` (
  `id` int(11) NOT NULL,
  `department_name` varchar(50) DEFAULT NULL,
  `total_beds` int(11) DEFAULT NULL,
  `current_occupancy` int(11) DEFAULT 0,
  `threshold_percent` int(11) DEFAULT 80
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- إرجاع أو استيراد بيانات الجدول `departments`
--

INSERT INTO `departments` (`id`, `department_name`, `total_beds`, `current_occupancy`, `threshold_percent`) VALUES
(1, 'ER', 20, 4, 75),
(2, 'ICU', 15, 3, 80),
(3, 'D1', 15, 0, 75),
(4, 'D2', 15, 4, 75),
(5, 'D3', 15, 15, 75);

-- --------------------------------------------------------

--
-- بنية الجدول `login`
--

CREATE TABLE `login` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `role` varchar(20) DEFAULT 'staff'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- إرجاع أو استيراد بيانات الجدول `login`
--

INSERT INTO `login` (`id`, `username`, `password`, `full_name`, `role`) VALUES
(1, 'raghad', 'NGH.123', 'رغد', 'admin'),
(2, 'norah', 'NGH.123', 'نوره', 'admin'),
(3, 'fatima', 'NGH.123', 'فاطمه', 'admin'),
(4, 'sara', 'NGH.123', 'سارة', 'admin'),
(5, 'walaa', 'NGH.123', 'ولاء', 'staff'),
(6, 'lama', 'NGH.123', 'لمى', 'staff'),
(7, 'ahmad', 'NGH.123', 'أحمد', 'staff'),
(8, 'saad', 'NGH.123', 'سعد', 'staff'),
(9, 'omar', 'NGH.123', 'عمر', 'staff'),
(10, 'abdullah', 'NGH.123', 'عبدالله', 'staff');

-- --------------------------------------------------------

--
-- بنية الجدول `patients`
--

CREATE TABLE `patients` (
  `mrn` int(11) NOT NULL,
  `patient_name` varchar(120) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `diagnosis` varchar(150) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `department` varchar(10) DEFAULT 'ER',
  `adm_datetime` datetime DEFAULT NULL,
  `facility_code` varchar(50) DEFAULT NULL,
  `ward` varchar(50) DEFAULT NULL,
  `room` varchar(20) DEFAULT NULL,
  `sex` varchar(10) DEFAULT NULL,
  `pt_id_type` varchar(50) DEFAULT NULL,
  `vip_type` varchar(50) DEFAULT NULL,
  `eligibility` varchar(50) DEFAULT NULL,
  `dept_new` varchar(50) DEFAULT NULL,
  `md` varchar(100) DEFAULT NULL,
  `adm_route` varchar(50) DEFAULT NULL,
  `num_of_adm` int(11) DEFAULT NULL,
  `dx_full` text DEFAULT NULL,
  `los` int(11) DEFAULT NULL,
  `expected_sched_adm` date DEFAULT NULL,
  `dsc_time` datetime DEFAULT NULL,
  `dsc_result` varchar(50) DEFAULT NULL,
  `patient_status` varchar(50) DEFAULT NULL,
  `expected_date_assigned` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- إرجاع أو استيراد بيانات الجدول `patients`
--

INSERT INTO `patients` (`mrn`, `patient_name`, `age`, `diagnosis`, `status`, `department`, `adm_datetime`, `facility_code`, `ward`, `room`, `sex`, `pt_id_type`, `vip_type`, `eligibility`, `dept_new`, `md`, `adm_route`, `num_of_adm`, `dx_full`, `los`, `expected_sched_adm`, `dsc_time`, `dsc_result`, `patient_status`, `expected_date_assigned`) VALUES
(1001, 'محمد القحطاني', 27, 'Pneumonia', 'Discharged', NULL, '2026-04-22 22:35:52', 'FC1', 'W1', '134', 'Male', 'National ID', 'Normal', 'Covered', 'D1', 'Dr. Nora', 'Referral', 1, 'Pneumonia', 8, '2026-04-22', '2026-04-30 22:35:52', 'Discharged', NULL, '2026-04-24'),
(1002, 'أحمد الغامدي', 21, 'Diabetes', 'Admitted', 'ER', '2026-04-22 22:35:52', 'FC1', 'W2', '128', 'Male', 'National ID', 'Normal', 'Covered', 'ER', 'Dr. Nora', 'Referral', 1, 'Diabetes', 5, '2026-04-22', '2026-04-27 22:35:52', 'Discharged', NULL, '2026-04-23'),
(1003, 'عبدالله الحربي', 44, 'Hypertension', 'Admitted', 'D2', '2026-04-22 22:35:52', 'FC1', 'W2', '117', 'Male', 'National ID', 'VIP', 'Covered', 'D2', 'Dr. Khalid', 'Referral', 2, 'Hypertension', 7, '2026-04-22', '2026-04-29 22:35:52', 'Transferred', 'Critical', '2026-04-23'),
(1004, 'خالد العتيبي', 59, 'Asthma', 'Discharged', NULL, '2026-04-22 22:35:52', 'FC1', 'W1', '125', 'Male', 'National ID', 'Normal', 'Covered', 'D1', 'Dr. Nora', 'ER', 2, 'Asthma', 10, '2026-04-22', '2026-05-02 22:35:52', 'Discharged', NULL, '2026-04-25'),
(1005, 'سعد الدوسري', 21, 'COVID-19', 'Discharged', NULL, '2026-04-22 22:35:52', 'FC3', 'W1', '141', 'Female', 'National ID', 'Normal', 'Covered', 'D1', 'Dr. Khalid', 'Clinic', 2, 'COVID-19', 8, '2026-04-22', '2026-04-30 22:35:52', 'Discharged', NULL, '2026-04-24'),
(1006, 'ناصر الزهراني', 30, 'Kidney Stones', 'Admitted', 'ER', '2026-04-22 22:35:52', 'FC3', 'ICU', '135', 'Male', 'National ID', 'Normal', 'Covered', 'ER', 'Dr. Faisal', 'Clinic', 1, 'Kidney Stones', 8, '2026-04-22', '2026-04-30 22:35:52', 'Discharged', 'Critical', '2026-04-25'),
(1007, 'فهد الشمري', 28, 'Heart Disease', 'Discharged', NULL, '2026-04-22 22:35:52', 'FC2', 'W2', '135', 'Female', 'National ID', 'Normal', 'Covered', 'D2', 'Dr. Ahmed', 'Clinic', 3, 'Heart Disease', 6, '2026-04-22', '2026-04-28 22:35:52', 'Transferred', NULL, '2026-04-27'),
(1008, 'يوسف العنزي', 31, 'Fracture', 'Admitted', 'ER', '2026-04-22 22:35:52', 'FC2', 'W2', '125', 'Female', 'National ID', 'Normal', 'Covered', 'ER', 'Dr. Ahmed', 'Clinic', 3, 'Fracture', 1, '2026-04-22', '2026-04-23 22:35:52', 'Discharged', 'Stable', '2026-04-24'),
(1009, 'عبدالرحمن المطيري', 51, 'Anemia', 'Admitted', 'D3', '2026-04-22 22:35:52', 'FC1', 'W3', '147', 'Male', 'National ID', 'Normal', 'Covered', 'D3', 'Dr. Nora', 'ER', 3, 'Anemia', 8, '2026-04-22', '2026-04-30 22:35:52', 'Transferred', NULL, '2026-04-24'),
(1010, 'تركي القحطاني', 22, 'Migraine', 'Admitted', 'D2', '2026-04-22 22:35:52', 'FC2', 'W2', '139', 'Male', 'National ID', 'Normal', 'Covered', 'D2', 'Dr. Nora', 'ER', 1, 'Migraine', 10, '2026-04-22', '2026-05-02 22:35:52', 'Discharged', NULL, '2026-04-25'),
(2001, 'سلمان الشهري', 59, 'General Case', 'Discharged', NULL, '2026-04-22 22:35:52', 'FC2', 'W3', '108', 'Male', 'National ID', 'Normal', 'Covered', 'D3', 'Dr. Ahmed', 'Clinic', 1, 'General Case', 1, '2026-04-22', '2026-04-23 22:35:52', 'Discharged', 'Stable', '2026-04-24'),
(2002, 'نورة العتيبي', 47, 'General Case', 'Admitted', 'D3', '2026-04-22 22:35:52', 'FC2', 'W3', '132', 'Male', 'National ID', 'Normal', 'Covered', 'D3', 'Dr. Sara', 'Clinic', 1, 'General Case', 3, '2026-04-22', '2026-04-25 22:35:52', 'Discharged', NULL, '2026-04-24'),
(2003, 'عبدالعزيز القحطاني', 39, 'General Case', 'Discharged', NULL, '2026-04-22 22:35:52', 'FC3', 'W3', '116', 'Female', 'National ID', 'Normal', 'Covered', 'D3', 'Dr. Ahmed', 'ER', 1, 'General Case', 3, '2026-04-22', '2026-04-25 22:35:52', 'Discharged', 'Critical', '2026-04-24'),
(2004, 'رهف الغامدي', 34, 'General Case', 'Admitted', 'ICU', '2026-04-22 22:35:52', 'FC3', 'ICU', '116', 'Female', 'National ID', 'Normal', 'Covered', 'ICU', 'Dr. Faisal', 'ER', 1, 'General Case', 9, '2026-04-22', '2026-05-01 22:35:52', 'Discharged', NULL, '2026-04-25'),
(2005, 'محمد الدوسري', 34, 'General Case', 'Admitted', 'ER', '2026-04-22 22:35:52', 'FC3', 'W3', '123', 'Male', 'National ID', 'Normal', 'Covered', 'ER', 'Dr. Khalid', 'Clinic', 1, 'General Case', 8, '2026-04-22', '2026-04-30 22:35:52', 'Discharged', NULL, '2026-04-26'),
(2006, 'سارة الحربي', 50, 'General Case', 'Admitted', 'ICU', '2026-04-22 22:35:52', 'FC3', 'ICU', '130', 'Male', 'National ID', 'Normal', 'Covered', 'ICU', 'Dr. Nora', 'Referral', 2, 'General Case', 5, '2026-04-22', '2026-04-27 22:35:52', 'Discharged', NULL, '2026-04-24'),
(2007, 'خالد المطيري', 49, 'General Case', 'Discharged', NULL, '2026-04-22 22:35:52', 'FC2', 'W2', '124', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Faisal', 'ER', 2, 'General Case', 9, '2026-04-22', '2026-05-01 22:35:52', 'Transferred', NULL, '2026-04-27'),
(2008, 'دانة الشمري', 34, 'General Case', 'Admitted', 'D3', '2026-04-22 22:35:52', 'FC3', 'W3', '119', 'Male', 'National ID', 'VIP', 'Covered', 'D3', 'Dr. Faisal', 'Clinic', 2, 'General Case', 1, '2026-04-22', '2026-04-23 22:35:52', 'Discharged', NULL, '2026-04-25'),
(2009, 'تركي العنزي', 45, 'General Case', 'Admitted', 'D3', '2026-04-22 22:35:52', 'FC1', 'W3', '138', 'Male', 'National ID', 'Normal', 'Covered', 'D3', 'Dr. Faisal', 'ER', 2, 'General Case', 1, '2026-04-22', '2026-04-23 22:35:52', 'Transferred', NULL, '2026-04-25'),
(2010, 'جود الزهراني', 22, 'General Case', 'Admitted', 'D3', '2026-04-22 22:35:52', 'FC2', 'W3', '138', 'Male', 'National ID', 'Normal', 'Covered', 'D3', 'Dr. Faisal', 'ER', 2, 'General Case', 3, '2026-04-22', '2026-04-25 22:35:52', 'Discharged', NULL, '2026-04-25'),
(2011, 'عبدالله القحطاني', 38, 'General Case', 'Admitted', 'D3', '2026-04-22 22:35:52', 'FC3', 'W3', '126', 'Male', 'National ID', 'Normal', 'Covered', 'D3', 'Dr. Nora', 'Referral', 2, 'General Case', 5, '2026-04-22', '2026-04-27 22:35:52', 'Transferred', NULL, '2026-04-24'),
(2012, 'لمياء الحربي', 22, 'General Case', 'Admitted', 'D3', '2026-04-22 22:35:52', 'FC2', 'W3', '148', 'Female', 'National ID', 'Normal', 'Covered', 'D3', 'Dr. Faisal', 'Clinic', 2, 'General Case', 4, '2026-04-22', '2026-04-26 22:35:52', 'Discharged', NULL, '2026-04-27'),
(2013, 'فهد العتيبي', 58, 'General Case', 'Admitted', 'D3', '2026-04-22 22:35:52', 'FC3', 'W3', '133', 'Male', 'National ID', 'Normal', 'Covered', 'D3', 'Dr. Faisal', 'ER', 3, 'General Case', 5, '2026-04-22', '2026-04-27 22:35:52', 'Transferred', NULL, '2026-04-24'),
(2014, 'غلا الدوسري', 44, 'General Case', 'Admitted', 'D3', '2026-04-22 22:35:52', 'FC2', 'W3', '144', 'Female', 'National ID', 'Normal', 'Covered', 'D3', 'Dr. Faisal', 'ER', 1, 'General Case', 5, '2026-04-22', '2026-04-27 22:35:52', 'Discharged', NULL, '2026-04-27'),
(2015, 'سعد الغامدي', 28, 'General Case', 'Admitted', 'D3', '2026-04-22 22:35:52', 'FC3', 'W3', '128', 'Male', 'National ID', 'Normal', 'Covered', 'D3', 'Dr. Faisal', 'Clinic', 2, 'General Case', 9, '2026-04-22', '2026-05-01 22:35:52', 'Discharged', NULL, '2026-04-24'),
(2016, 'ريم الشمري', 28, 'General Case', 'Admitted', 'D3', '2026-04-22 22:35:52', 'FC3', 'W3', '108', 'Female', 'National ID', 'VIP', 'Covered', 'D3', 'Dr. Nora', 'Clinic', 1, 'General Case', 1, '2026-04-22', '2026-04-23 22:35:52', 'Discharged', NULL, '2026-04-25'),
(2017, 'نايف العنزي', 35, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC2', 'W2', '134', 'Female', 'National ID', 'Normal', 'Covered', 'D2', 'Dr. Khalid', 'Clinic', 2, 'General Case', 10, '2026-04-22', '2026-05-02 22:35:52', 'Discharged', NULL, '2026-04-23'),
(2018, 'أريج المطيري', 34, 'General Case', 'Admitted', 'ICU', '2026-04-22 22:35:52', 'FC3', 'ICU', '110', 'Female', 'National ID', 'Normal', 'Covered', 'ICU', 'Dr. Nora', 'Clinic', 2, 'General Case', 2, '2026-04-22', '2026-04-24 22:35:52', 'Discharged', NULL, '2026-04-25'),
(2019, 'عبدالرحمن الحربي', 44, 'General Case', 'Discharged', NULL, '2026-04-22 22:35:52', 'FC3', 'W1', '115', 'Male', 'National ID', 'Normal', 'Covered', 'D1', 'Dr. Faisal', 'Clinic', 2, 'General Case', 8, '2026-04-22', '2026-04-30 22:35:52', 'Discharged', NULL, '2026-04-25'),
(2020, 'لين الزهراني', 58, 'General Case', 'Admitted', 'D3', '2026-04-22 22:35:52', 'FC2', 'W3', '107', 'Male', 'National ID', 'Normal', 'Covered', 'D3', 'Dr. Nora', 'ER', 1, 'General Case', 6, '2026-04-22', '2026-04-28 22:35:52', 'Transferred', NULL, '2026-04-24'),
(2021, 'سلطان القحطاني', 59, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC3', 'W2', '115', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Sara', 'Clinic', 1, 'General Case', 3, '2026-04-22', '2026-04-25 22:35:52', 'Discharged', NULL, '2026-04-27'),
(2022, 'نوف العتيبي', 21, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC2', 'W2', '134', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Khalid', 'Clinic', 3, 'General Case', 7, '2026-04-22', '2026-04-29 22:35:52', 'Discharged', 'Critical', '2026-04-26'),
(2023, 'ياسر الدوسري', 29, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC2', 'ICU', '117', 'Male', 'National ID', 'VIP', 'Covered', 'ICU', 'Dr. Faisal', 'ER', 3, 'General Case', 1, '2026-04-22', '2026-04-23 22:35:52', 'Discharged', NULL, '2026-04-23'),
(2024, 'شهد الغامدي', 24, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC1', 'W2', '148', 'Male', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Ahmed', 'Referral', 1, 'General Case', 10, '2026-04-22', '2026-05-02 22:35:52', 'Discharged', 'Critical', '2026-04-27'),
(2025, 'فيصل الشمري', 54, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC2', 'ICU', '108', 'Male', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Nora', 'Clinic', 3, 'General Case', 6, '2026-04-22', '2026-04-28 22:35:52', 'Discharged', NULL, '2026-04-23'),
(2026, 'أميرة العنزي', 59, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC1', 'ICU', '140', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Khalid', 'Clinic', 3, 'General Case', 9, '2026-04-22', '2026-05-01 22:35:52', 'Transferred', NULL, '2026-04-23'),
(2027, 'بندر المطيري', 32, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC3', 'W1', '146', 'Male', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Sara', 'ER', 2, 'General Case', 6, '2026-04-22', '2026-04-28 22:35:52', 'Discharged', NULL, '2026-04-24'),
(2028, 'مشاعل الحربي', 43, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC1', 'W3', '144', 'Male', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Nora', 'Clinic', 1, 'General Case', 9, '2026-04-22', '2026-05-01 22:35:52', 'Discharged', NULL, '2026-04-27'),
(2029, 'تركي القحطاني', 22, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC3', 'W3', '128', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Khalid', 'Referral', 3, 'General Case', 3, '2026-04-22', '2026-04-25 22:35:52', 'Discharged', NULL, '2026-04-25'),
(2030, 'جواهر الزهراني', 40, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC1', 'W2', '147', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Ahmed', 'Clinic', 3, 'General Case', 4, '2026-04-22', '2026-04-26 22:35:52', 'Discharged', NULL, '2026-04-26'),
(2031, 'سلمان الدوسري', 36, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC2', 'W1', '118', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Faisal', 'Referral', 2, 'General Case', 10, '2026-04-22', '2026-05-02 22:35:52', 'Transferred', NULL, '2026-04-27'),
(2032, 'رغد العتيبي', 38, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC3', 'W1', '149', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Faisal', 'ER', 2, 'General Case', 9, '2026-04-22', '2026-05-01 22:35:52', 'Discharged', 'Stable', '2026-04-26'),
(2033, 'حسين الغامدي', 22, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC1', 'ICU', '110', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Sara', 'Clinic', 2, 'General Case', 10, '2026-04-22', '2026-05-02 22:35:52', 'Discharged', 'Critical', '2026-04-24'),
(2034, 'العنود الشمري', 56, 'General Case', 'Admitted', 'D3', '2026-04-22 22:35:52', 'FC2', 'W2', '108', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Sara', 'ER', 1, 'General Case', 1, '2026-04-22', '2026-04-23 22:35:52', 'Discharged', NULL, '2026-04-23'),
(2035, 'فارس العنزي', 35, 'General Case', 'Admitted', 'D3', '2026-04-22 22:35:52', 'FC2', 'ICU', '120', 'Female', 'National ID', 'VIP', 'Covered', NULL, 'Dr. Nora', 'Clinic', 1, 'General Case', 7, '2026-04-22', '2026-04-29 22:35:52', 'Transferred', NULL, '2026-04-26'),
(2036, 'سحر المطيري', 30, 'General Case', 'Admitted', 'D3', '2026-04-22 22:35:52', 'FC2', 'ICU', '114', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Ahmed', 'Referral', 3, 'General Case', 5, '2026-04-22', '2026-04-27 22:35:52', 'Discharged', NULL, '2026-04-27'),
(2037, 'عبدالمجيد الحربي', 22, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC1', 'W2', '112', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Nora', 'ER', 2, 'General Case', 3, '2026-04-22', '2026-04-25 22:35:52', 'Transferred', NULL, '2026-04-24'),
(2038, 'جوري القحطاني', 43, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC3', 'W2', '118', 'Male', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Nora', 'Clinic', 2, 'General Case', 9, '2026-04-22', '2026-05-01 22:35:52', 'Transferred', NULL, '2026-04-23'),
(2039, 'راكان الزهراني', 48, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC3', 'W2', '118', 'Male', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Ahmed', 'Referral', 1, 'General Case', 2, '2026-04-22', '2026-04-24 22:35:52', 'Discharged', NULL, '2026-04-24'),
(2040, 'دلال الدوسري', 51, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC1', 'W3', '107', 'Male', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Khalid', 'Clinic', 2, 'General Case', 1, '2026-04-22', '2026-04-23 22:35:52', 'Transferred', 'Stable', '2026-04-26'),
(2041, 'عبدالله الغامدي', 52, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC1', 'W3', '100', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Ahmed', 'Referral', 3, 'General Case', 4, '2026-04-22', '2026-04-26 22:35:52', 'Discharged', NULL, '2026-04-23'),
(2042, 'هديل العتيبي', 48, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC3', 'W1', '145', 'Male', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Ahmed', 'ER', 1, 'General Case', 9, '2026-04-22', '2026-05-01 22:35:52', 'Discharged', 'Critical', '2026-04-25'),
(2043, 'مشعل الشمري', 25, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC1', 'ICU', '110', 'Male', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Faisal', 'ER', 2, 'General Case', 6, '2026-04-22', '2026-04-28 22:35:52', 'Discharged', NULL, '2026-04-24'),
(2044, 'ألين العنزي', 41, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC1', 'W1', '124', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Nora', 'Clinic', 3, 'General Case', 7, '2026-04-22', '2026-04-29 22:35:52', 'Transferred', 'Stable', '2026-04-23'),
(2045, 'محمد المطيري', 30, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC2', 'W1', '118', 'Male', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Khalid', 'ER', 1, 'General Case', 6, '2026-04-22', '2026-04-28 22:35:52', 'Discharged', NULL, '2026-04-23'),
(2046, 'لينا الحربي', 46, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC3', 'ICU', '117', 'Male', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Khalid', 'ER', 2, 'General Case', 4, '2026-04-22', '2026-04-26 22:35:52', 'Discharged', 'Critical', '2026-04-26'),
(2047, 'خالد القحطاني', 41, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC1', 'W2', '138', 'Male', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Sara', 'Clinic', 2, 'General Case', 10, '2026-04-22', '2026-05-02 22:35:52', 'Discharged', NULL, '2026-04-23'),
(2048, 'ريم الزهراني', 47, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC1', 'W1', '126', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Khalid', 'ER', 3, 'General Case', 5, '2026-04-22', '2026-04-27 22:35:52', 'Discharged', NULL, '2026-04-26'),
(2049, 'سعد الدوسري', 53, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC1', 'ICU', '128', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Sara', 'Referral', 2, 'General Case', 3, '2026-04-22', '2026-04-25 22:35:52', 'Transferred', 'Stable', '2026-04-25'),
(2050, 'نور الغامدي', 26, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC1', 'W1', '139', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Sara', 'ER', 2, 'General Case', 10, '2026-04-22', '2026-05-02 22:35:52', 'Discharged', NULL, '2026-04-27'),
(2051, 'عبدالرحمن العتيبي', 32, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC2', 'ICU', '136', 'Male', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Sara', 'Referral', 2, 'General Case', 3, '2026-04-22', '2026-04-25 22:35:52', 'Transferred', 'Critical', '2026-04-23'),
(2052, 'شهد الشمري', 23, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC2', 'W2', '100', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Faisal', 'ER', 2, 'General Case', 5, '2026-04-22', '2026-04-27 22:35:52', 'Discharged', NULL, '2026-04-25'),
(2053, 'تركي العنزي', 40, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC2', 'ICU', '136', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Khalid', 'Referral', 2, 'General Case', 2, '2026-04-22', '2026-04-24 22:35:52', 'Transferred', NULL, '2026-04-26'),
(2054, 'دانة المطيري', 31, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC2', 'ICU', '107', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Faisal', 'ER', 1, 'General Case', 3, '2026-04-22', '2026-04-25 22:35:52', 'Discharged', NULL, '2026-04-25'),
(2055, 'فهد الحربي', 55, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC2', 'W3', '110', 'Male', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Sara', 'Clinic', 3, 'General Case', 1, '2026-04-22', '2026-04-23 22:35:52', 'Discharged', 'Stable', '2026-04-23'),
(2056, 'مها القحطاني', 44, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC2', 'ICU', '135', 'Male', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Nora', 'ER', 3, 'General Case', 4, '2026-04-22', '2026-04-26 22:35:52', 'Discharged', NULL, '2026-04-24'),
(2057, 'بدر الزهراني', 35, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC3', 'W2', '126', 'Male', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Ahmed', 'Clinic', 3, 'General Case', 9, '2026-04-22', '2026-05-01 22:35:52', 'Discharged', NULL, '2026-04-27'),
(2058, 'نورة الدوسري', 23, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC2', 'W1', '138', 'Male', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Nora', 'ER', 2, 'General Case', 9, '2026-04-22', '2026-05-01 22:35:52', 'Discharged', NULL, '2026-04-23'),
(2059, 'نايف الغامدي', 29, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC2', 'W3', '128', 'Male', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Ahmed', 'ER', 1, 'General Case', 10, '2026-04-22', '2026-05-02 22:35:52', 'Discharged', NULL, '2026-04-26'),
(2060, 'غلا العتيبي', 58, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC3', 'W1', '141', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Ahmed', 'ER', 3, 'General Case', 4, '2026-04-22', '2026-04-26 22:35:52', 'Discharged', NULL, '2026-04-25'),
(2061, 'عبدالله الشمري', 23, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC1', 'W2', '113', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Nora', 'ER', 1, 'General Case', 10, '2026-04-22', '2026-05-02 22:35:52', 'Discharged', NULL, '2026-04-24'),
(2062, 'لين العنزي', 40, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC2', 'W3', '105', 'Male', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Nora', 'ER', 2, 'General Case', 6, '2026-04-22', '2026-04-28 22:35:52', 'Discharged', NULL, '2026-04-25'),
(2063, 'سلمان المطيري', 31, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC2', 'ICU', '134', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Nora', 'Referral', 1, 'General Case', 3, '2026-04-22', '2026-04-25 22:35:52', 'Discharged', NULL, '2026-04-26'),
(2064, 'رهف الحربي', 58, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC2', 'W3', '106', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Nora', 'Referral', 3, 'General Case', 5, '2026-04-22', '2026-04-27 22:35:52', 'Discharged', NULL, '2026-04-23'),
(2065, 'محمد القحطاني', 58, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC1', 'ICU', '108', 'Male', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Nora', 'Clinic', 3, 'General Case', 9, '2026-04-22', '2026-05-01 22:35:52', 'Transferred', NULL, '2026-04-24'),
(2066, 'أريج الزهراني', 54, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC3', 'ICU', '109', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Faisal', 'Clinic', 2, 'General Case', 7, '2026-04-22', '2026-04-29 22:35:52', 'Transferred', NULL, '2026-04-27'),
(2067, 'فيصل الدوسري', 37, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC1', 'W2', '148', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Sara', 'ER', 1, 'General Case', 2, '2026-04-22', '2026-04-24 22:35:52', 'Discharged', NULL, '2026-04-25'),
(2068, 'جود الغامدي', 45, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC3', 'W2', '127', 'Male', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Khalid', 'Clinic', 1, 'General Case', 10, '2026-04-22', '2026-05-02 22:35:52', 'Transferred', NULL, '2026-04-26'),
(2069, 'سعد العتيبي', 53, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC1', 'ICU', '137', 'Male', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Faisal', 'Referral', 3, 'General Case', 4, '2026-04-22', '2026-04-26 22:35:52', 'Discharged', NULL, '2026-04-26'),
(2070, 'دانة الشمري', 31, 'General Case', 'Admitted', 'D2', '2026-04-22 22:35:52', 'FC2', 'W2', '130', 'Female', 'National ID', 'Normal', 'Covered', 'D2', 'Dr. Ahmed', 'Clinic', 2, 'General Case', 9, '2026-04-22', '2026-05-01 22:35:52', 'Discharged', NULL, '2026-04-26'),
(2071, 'خالد العنزي', 57, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC2', 'W2', '126', 'Male', 'National ID', 'Normal', 'Covered', 'D2', 'Dr. Sara', 'ER', 1, 'General Case', 8, '2026-04-22', '2026-04-30 22:35:52', 'Transferred', NULL, '2026-04-26'),
(2072, 'مها المطيري', 51, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC1', 'W3', '123', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Khalid', 'ER', 3, 'General Case', 9, '2026-04-22', '2026-05-01 22:35:52', 'Discharged', NULL, '2026-04-23'),
(2073, 'تركي الحربي', 27, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC2', 'W3', '113', 'Male', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Faisal', 'Clinic', 2, 'General Case', 2, '2026-04-22', '2026-04-24 22:35:52', 'Deceased', NULL, '2026-04-24'),
(2074, 'نوف القحطاني', 40, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC1', 'ICU', '136', 'Male', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Faisal', 'ER', 3, 'General Case', 7, '2026-04-22', '2026-04-29 22:35:52', 'Discharged', NULL, '2026-04-24'),
(2075, 'عبدالعزيز الزهراني', 20, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC1', 'W1', '129', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Khalid', 'ER', 1, 'General Case', 7, '2026-04-22', '2026-04-29 22:35:52', 'Discharged', NULL, '2026-04-24'),
(2076, 'ريم الدوسري', 39, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC3', 'ICU', '143', 'Male', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Nora', 'Clinic', 2, 'General Case', 5, '2026-04-22', '2026-04-27 22:35:52', 'Transferred', 'Critical', '2026-04-23'),
(2077, 'فهد الغامدي', 36, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC2', 'W1', '144', 'Male', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Khalid', 'ER', 3, 'General Case', 8, '2026-04-22', '2026-04-30 22:35:52', 'Discharged', NULL, '2026-04-24'),
(2078, 'شهد العتيبي', 42, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC1', 'ICU', '134', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Nora', 'Clinic', 1, 'General Case', 7, '2026-04-22', '2026-04-29 22:35:52', 'Discharged', NULL, '2026-04-23'),
(2079, 'بندر الشمري', 46, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC1', 'W2', '132', 'Male', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Ahmed', 'Referral', 2, 'General Case', 8, '2026-04-22', '2026-04-30 22:35:52', 'Discharged', NULL, '2026-04-26'),
(2080, 'جواهر العنزي', 41, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC3', 'ICU', '109', 'Male', 'National ID', 'Normal', 'Covered', 'ICU', 'Dr. Khalid', 'Referral', 3, 'General Case', 7, '2026-04-22', '2026-04-29 22:35:52', 'Transferred', NULL, '2026-04-25'),
(2081, 'سلمان المطيري', 50, 'General Case', 'Discharged', NULL, '2026-04-22 22:35:52', 'FC3', 'W1', '149', 'Female', 'National ID', 'Normal', 'Covered', 'D1', 'Dr. Khalid', 'ER', 1, 'General Case', 2, '2026-04-22', '2026-04-24 22:35:52', 'Discharged', 'Stable', '2026-04-24'),
(2082, 'غلا الحربي', 27, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC2', 'W3', '130', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Nora', 'Referral', 3, 'General Case', 10, '2026-04-22', '2026-05-02 22:35:52', 'Discharged', NULL, '2026-04-26'),
(2083, 'عبدالله القحطاني', 46, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC2', 'ICU', '142', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Faisal', 'Referral', 1, 'General Case', 7, '2026-04-22', '2026-04-29 22:35:52', 'Discharged', 'Critical', '2026-04-25'),
(2084, 'ألين الزهراني', 47, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC1', 'ICU', '100', 'Male', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Khalid', 'Referral', 1, 'General Case', 7, '2026-04-22', '2026-04-29 22:35:52', 'Discharged', NULL, '2026-04-25'),
(2085, 'محمد الدوسري', 40, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC3', 'W3', '126', 'Male', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Faisal', 'ER', 3, 'General Case', 7, '2026-04-22', '2026-04-29 22:35:52', 'Transferred', NULL, '2026-04-27'),
(2086, 'رهف الغامدي', 41, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC3', 'W2', '103', 'Female', 'National ID', 'Normal', 'Covered', 'D2', 'Dr. Nora', 'Referral', 2, 'General Case', 5, '2026-04-22', '2026-04-27 22:35:52', 'Transferred', NULL, '2026-04-23'),
(2087, 'خالد العتيبي', 23, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC3', 'ICU', '107', 'Male', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Khalid', 'ER', 1, 'General Case', 4, '2026-04-22', '2026-04-26 22:35:52', 'Discharged', 'Critical', '2026-04-25'),
(2088, 'نور الشمري', 55, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC2', 'W1', '105', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Nora', 'Referral', 2, 'General Case', 5, '2026-04-22', '2026-04-27 22:35:52', 'Discharged', NULL, '2026-04-23'),
(2089, 'تركي العنزي', 23, 'General Case', 'Pending', NULL, '2026-04-22 22:35:52', 'FC3', 'W1', '123', 'Female', 'National ID', 'Normal', 'Covered', NULL, 'Dr. Ahmed', 'ER', 1, 'General Case', 1, '2026-04-22', '2026-04-23 22:35:52', 'Discharged', NULL, '2026-04-24'),
(2090, 'مها المطيري', 53, 'General Case', 'Admitted', 'D2', '2026-04-22 22:35:52', 'FC1', 'W2', '132', 'Female', 'National ID', 'Normal', 'Covered', 'D2', 'Dr. Faisal', 'ER', 2, 'General Case', 1, '2026-04-22', '2026-04-23 22:35:52', 'Transferred', NULL, '2026-04-26');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `patients`
--
ALTER TABLE `patients`
  ADD PRIMARY KEY (`mrn`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
