-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 10, 2023 at 11:27 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.0.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `kelbd`
--



-- --------------------------------------------------------

--
-- Table structure for table `job_entry`
--

CREATE TABLE `job_entry` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_number` varchar(255) NOT NULL,
  `importer_name` varchar(50) NOT NULL,
  `mother_vessel_name` varchar(255) NOT NULL,
  `eta` varchar(255) NOT NULL,
  `commodity` varchar(255) NOT NULL,
  `mv_location` varchar(255) NOT NULL,
  `bl_quantity` int(11) NOT NULL,
  `stevedore_name` varchar(255) NOT NULL,
  `stevedore_contact_number` varchar(20) NOT NULL,
  `time_stamp` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order_job_table`
--

CREATE TABLE `order_job_table` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
--   `order_number` varchar(50) NOT NULL,
  `job_entry_id` int(11) NOT NULL,
  `job_number` int(50) NOT NULL DEFAULT 0,
  `order_number_done` tinyint(1) NOT NULL DEFAULT 0,
  `sixty_percent_done` tinyint(1) NOT NULL DEFAULT 0,
  `job_completed` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  FOREIGN KEY (job_entry_id) REFERENCES job_entry(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `chq_approval`
--

CREATE TABLE `chq_approval` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
--   `order_job_number` varchar(255) NOT NULL,
  `order_job_id` int(11) NOT NULL,
  `sixty_percent_payment_amount` varchar(100) DEFAULT NULL,
  `forty_percent_payment_amount` varchar(100) DEFAULT NULL,
  `damarage` varchar(100) DEFAULT NULL,
  `second_trip` varchar(100) DEFAULT NULL,
  `third_trip` varchar(100) DEFAULT NULL,
  `direct_trip` varchar(100) DEFAULT NULL,
  `sixty_percent_payment_chq_number` varchar(255) DEFAULT NULL,
  `sixty_percent_payment_chq_date` date DEFAULT NULL,
  `forty_percent_payment_chq_number` varchar(255) DEFAULT NULL,
  `forty_percent_payment_chq_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (order_job_id) REFERENCES order_job_table(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `chq_due_list`
--

CREATE TABLE `chq_due_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
--   `order_job_number` varchar(255) NOT NULL,
  `order_job_id` int(11) NOT NULL,
  `part_pay` double DEFAULT NULL,
  `payment` varchar(255) DEFAULT NULL,
  `mode` varchar(255) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (order_job_id) REFERENCES order_job_table(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `current_status`
--

CREATE TABLE `current_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
--   `order_job_number` varchar(255) NOT NULL,
    `order_job_id` int(11) NOT NULL,
  `current_location` varchar(50) DEFAULT NULL,
  `remark` varchar(100) DEFAULT NULL,
  `time_updated` datetime NOT NULL,
  `trip_completed` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
    FOREIGN KEY (order_job_id) REFERENCES order_job_table(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `damarage_dispatch`
--

CREATE TABLE `damarage_dispatch` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
--   `order_job_number` varchar(255) NOT NULL,
    `order_job_id` int(11) NOT NULL,
  `date` datetime NOT NULL,
  `loading_location` varchar(50) DEFAULT NULL,
  `unloading_location` varchar(50) DEFAULT NULL,
  `loading_start_time_stamp` datetime DEFAULT NULL,
  `loading_completion_time_stamp` datetime DEFAULT NULL,
  `sailing_time_stamp` datetime DEFAULT NULL,
  `duration_of_travel_time` varchar(255) DEFAULT NULL,
  `unloading_start_time_stamp` datetime DEFAULT NULL,
  `unloading_completion_time_stamp` datetime DEFAULT NULL,
  `others` varchar(100) DEFAULT NULL,
  `total_elapsed_time` time DEFAULT NULL,
  `voyage_time` time DEFAULT NULL,
  `free_time` time DEFAULT NULL,
  `total_despatch` int(11) DEFAULT NULL,
  `daily_despatch` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
    FOREIGN KEY (order_job_id) REFERENCES order_job_table(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

CREATE TABLE `payment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
--   `order_job_number` varchar(50) NOT NULL,
    `order_job_id` int(11) NOT NULL,
  `payment_chq_no` int(11) DEFAULT NULL,
  `payment_chq_amount` int(11) DEFAULT NULL,
  `payment_chq_date` datetime DEFAULT NULL,
  `LV_name` varchar(255) NOT NULL,
  `LA_name` varchar(255) NOT NULL,
  `commodity` varchar(255) NOT NULL,
  `chq_issue_date` varchar(255) NOT NULL,
  `amount` varchar(255) NOT NULL,
  `part_pay` varchar(255) NOT NULL,
  `payment` varchar(255) NOT NULL,
  `balance` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (order_job_id) REFERENCES order_job_table(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pre_defined_ship`
--

CREATE TABLE `pre_defined_ship` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `LV_name` varchar(50) DEFAULT NULL,
  `capacity` varchar(255) DEFAULT NULL,
  `master_reg_number` varchar(255) DEFAULT NULL,
  `masters_name` varchar(255) DEFAULT NULL,
  `masters_contact_number` varchar(255) DEFAULT NULL,
  `masters_nid_image_attachment` varchar(255) DEFAULT NULL,
  `leased` tinyint(1) DEFAULT NULL,
  `company_name` varchar(255) DEFAULT NULL,
  `proprietors_name` varchar(255) DEFAULT NULL,
  `office_address` varchar(255) DEFAULT NULL,
  `ac_number` varchar(255) DEFAULT NULL,
  `contact_details` varchar(255) DEFAULT NULL,
  `lv_documents_attachement` varchar(255) DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `staffs_info` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `record_entry`
--

CREATE TABLE `record_entry` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
--   `order_number` varchar(50) NOT NULL,
--   `job_number` int(50) NOT NULL,
  `order_job_id` int(11) NOT NULL,
  `date_from_charpotro` date NOT NULL,
  `cp_number_from_charpotro` int(11) NOT NULL,
  `LA_name` varchar(50) NOT NULL,
  `LV_name` varchar(50) NOT NULL,
  `dest_from` varchar(50) NOT NULL,
  `dest_to` varchar(50) NOT NULL,
  `capacity` int(11) NOT NULL,
  `rate` int(11) NOT NULL,
  `LV_master_name` varchar(50) NOT NULL,
  `LV_master_contact_number` varchar(15) NOT NULL,
  `date_created` date NOT NULL,
  `date_updated` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (order_job_id) REFERENCES order_job_table(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `position` varchar(50) NOT NULL,
  `department` varchar(50) NOT NULL,
  `user_created_time` datetime NOT NULL,
  `enabled` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


--
-- Indexes for table `chq_due_list`
--
ALTER TABLE `chq_due_list`
  ADD UNIQUE KEY `unique_order_job_id_AND_mode` (`order_job_id`,`mode`);

--
-- Indexes for table `job_entry`
--
ALTER TABLE `job_entry`
  ADD UNIQUE KEY `unique_order_number` (`order_number`);

--
-- Indexes for table `order_job_table`
--
ALTER TABLE `order_job_table`
  ADD UNIQUE KEY `unique_job_entry_id_AND_job_number` (`job_entry_id`,`job_number`);

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
