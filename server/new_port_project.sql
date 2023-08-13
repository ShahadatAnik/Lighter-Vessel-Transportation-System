-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 11, 2023 at 03:56 PM
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
-- Table structure for table `chq_approval`
--

CREATE TABLE `chq_approval` (
  `id` int(11) NOT NULL,
  `record_entry_id` int(11) NOT NULL,
  `sixty_percent_payment_amount` int(20) DEFAULT NULL,
  `sixty_percent_payment_chq_number` varchar(255) DEFAULT NULL,
  `sixty_percent_payment_chq_date` date DEFAULT NULL,
  `forty_percent_payment_amount` int(20) DEFAULT NULL,
  `forty_percent_payment_chq_number` varchar(255) DEFAULT NULL,
  `forty_percent_payment_chq_date` date DEFAULT NULL,
  `demurrage` varchar(100) DEFAULT NULL,
  `second_trip` varchar(100) DEFAULT NULL,
  `third_trip` varchar(100) DEFAULT NULL,
  `direct_trip` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `chq_approval`
--

DELIMITER $$
CREATE TRIGGER `insert_chq_due_list_40_or_60_percent` AFTER UPDATE ON `chq_approval` FOR EACH ROW BEGIN 
    DECLARE order_count_40 INT;
    DECLARE order_count_60 INT;
    
    SELECT COUNT(record_entry_id) INTO order_count_40 
    FROM chq_due_list 
    WHERE record_entry_id = NEW.record_entry_id 
    AND mode = '40';

    SELECT COUNT(record_entry_id) INTO order_count_60 
    FROM chq_due_list 
    WHERE record_entry_id = NEW.record_entry_id 
    AND mode = '60';

    IF NEW.forty_percent_payment_amount > 0 AND order_count_40 < 1 THEN 
        INSERT INTO chq_due_list (record_entry_id, mode) VALUES (NEW.record_entry_id, '40');
    END IF;
    
    IF NEW.sixty_percent_payment_amount > 0 AND order_count_60 < 1 THEN 
        INSERT INTO chq_due_list (record_entry_id, mode) VALUES (NEW.record_entry_id, '60');
    END IF;
END
$$
DELIMITER ;



-- --------------------------------------------------------

--
-- Table structure for table `chq_due_list`
--

CREATE TABLE `chq_due_list` (
  `id` int(11) NOT NULL,
  `record_entry_id` int(11) NOT NULL,
  `part_pay` double DEFAULT NULL,
  `payment` varchar(255) DEFAULT NULL,
  `mode` varchar(255) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `current_status`
--

CREATE TABLE `current_status` (
  `id` int(11) NOT NULL,
  `record_entry_id` int(11) NOT NULL,
  `current_location` varchar(50) DEFAULT NULL,
  `remark` varchar(100) DEFAULT NULL,
  `time_updated` datetime NOT NULL,
  `trip_completed` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `demurrage_dispatch`
--

CREATE TABLE `demurrage_dispatch` (
  `id` int(11) NOT NULL,
  `record_entry_id` int(11) NOT NULL,
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
  `daily_despatch` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_entry`
--

CREATE TABLE `job_entry` (
  `id` int(11) NOT NULL,
  `importer_name` varchar(50) NOT NULL,
  `mother_vessel_name` varchar(255) NOT NULL,
  `eta` varchar(255) NOT NULL,
  `commodity` varchar(255) NOT NULL,
  `mv_location` varchar(255) NOT NULL,
  `bl_quantity` int(11) NOT NULL,
  `stevedore_name` varchar(255) NOT NULL,
  `stevedore_contact_number` varchar(20) NOT NULL,
  `time_stamp` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 5 Dumping data for table `job_entry`
--

INSERT INTO `job_entry` (`id`, `importer_name`, `mother_vessel_name`, `eta`, `commodity`, `mv_location`, `bl_quantity`, `stevedore_name`, `stevedore_contact_number`, `time_stamp`) VALUES
(1, 'importer1', 'mv1', '2021-08-11', 'commodity1', 'mv_location1', 100, 'stevedore1', '01700000000', '2023-07-05 13:48:24'),
(2, 'importer2', 'mv2', '2021-08-11', 'commodity2', 'mv_location2', 200, 'stevedore2', '01700000000', '2023-07-05 13:48:24'),
(3, 'importer3', 'mv3', '2021-08-11', 'commodity3', 'mv_location3', 300, 'stevedore3', '01700000000', '2023-07-05 13:48:24'),
(4, 'importer4', 'mv4', '2021-08-11', 'commodity4', 'mv_location4', 400, 'stevedore4', '01700000000', '2023-07-05 13:48:24'),
(5, 'importer5', 'mv5', '2021-08-11', 'commodity5', 'mv_location5', 500, 'stevedore5', '01700000000', '2023-07-05 13:48:24');


-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

CREATE TABLE `payment` (
  `id` int(11) NOT NULL,
  `record_entry_id` int(11) NOT NULL,
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
  `balance` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pre_defined_ship`
--

CREATE TABLE `pre_defined_ship` (
  `id` int(11) NOT NULL,
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
  `lv_documents_attachment` varchar(255) DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `staffs_info` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `record_entry`
--

CREATE TABLE `record_entry` (
  `id` int(11) NOT NULL,
  `job_entry_id` int(11) NOT NULL,
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
  `date_updated` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 5 Dumping data for table `record_entry`
--

INSERT INTO `record_entry` (`id`, `job_entry_id`, `date_from_charpotro`, `cp_number_from_charpotro`, `LA_name`, `LV_name`, `dest_from`, `dest_to`, `capacity`, `rate`, `LV_master_name`, `LV_master_contact_number`, `date_created`, `date_updated`) VALUES
(1, 1, '2021-08-11', 1, 'LA_name1', 'LV_name1', 'dest_from1', 'dest_to1', 1, 1, 'LV_master_name1', '01700000000', '2023-07-05 13:48:24', '2023-07-05 13:48:24'),
(2, 1, '2021-08-11', 2, 'LA_name2', 'LV_name2', 'dest_from2', 'dest_to2', 2, 2, 'LV_master_name2', '01700000000', '2023-07-05 13:48:24', '2023-07-05 13:48:24'),
(3, 2, '2021-08-11', 3, 'LA_name3', 'LV_name3', 'dest_from3', 'dest_to3', 3, 3, 'LV_master_name3', '01700000000', '2023-07-05 13:48:24', '2023-07-05 13:48:24'),
(4, 3, '2021-08-11', 4, 'LA_name4', 'LV_name4', 'dest_from4', 'dest_to4', 4, 4, 'LV_master_name4', '01700000000', '2023-07-05 13:48:24', '2023-07-05 13:48:24'),
(5, 3, '2021-08-11', 5, 'LA_name5', 'LV_name5', 'dest_from5', 'dest_to5', 5, 5, 'LV_master_name5', '01700000000', '2023-07-05 13:48:24', '2023-07-05 13:48:24');

--
-- Triggers `record_entry`
--
DELIMITER $$
CREATE TRIGGER `insert_triggers_after_record_entry` AFTER INSERT ON `record_entry` FOR EACH ROW BEGIN
  INSERT INTO chq_approval (record_entry_id) VALUES (NEW.id);
  INSERT INTO current_status (record_entry_id) VALUES (NEW.id);
  INSERT INTO demurrage_dispatch (record_entry_id) VALUES (NEW.id);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `position` varchar(50) NOT NULL,
  `department` varchar(50) NOT NULL,
  `user_created_time` datetime NOT NULL,
  `enabled` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `chq_approval`
--
ALTER TABLE `chq_approval`
  ADD PRIMARY KEY (`id`),
  ADD KEY `record_entry_id` (`record_entry_id`);

--
-- Indexes for table `chq_due_list`
--
ALTER TABLE `chq_due_list`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_record_entry_id_AND_mode` (`record_entry_id`,`mode`);

--
-- Indexes for table `current_status`
--
ALTER TABLE `current_status`
  ADD PRIMARY KEY (`id`),
  ADD KEY `record_entry_id` (`record_entry_id`);

--
-- Indexes for table `demurrage_dispatch`
--
ALTER TABLE `demurrage_dispatch`
  ADD PRIMARY KEY (`id`),
  ADD KEY `record_entry_id` (`record_entry_id`);

--
-- Indexes for table `job_entry`
--
ALTER TABLE `job_entry`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `record_entry_id` (`record_entry_id`);

--
-- Indexes for table `pre_defined_ship`
--
ALTER TABLE `pre_defined_ship`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `record_entry`
--
ALTER TABLE `record_entry`
  ADD PRIMARY KEY (`id`),
  ADD KEY `job_entry_id` (`job_entry_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `chq_approval`
--
ALTER TABLE `chq_approval`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `chq_due_list`
--
ALTER TABLE `chq_due_list`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `current_status`
--
ALTER TABLE `current_status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `demurrage_dispatch`
--
ALTER TABLE `demurrage_dispatch`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `job_entry`
--
ALTER TABLE `job_entry`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payment`
--
ALTER TABLE `payment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pre_defined_ship`
--
ALTER TABLE `pre_defined_ship`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `record_entry`
--
ALTER TABLE `record_entry`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `chq_approval`
--
ALTER TABLE `chq_approval`
  ADD CONSTRAINT `chq_approval_ibfk_1` FOREIGN KEY (`record_entry_id`) REFERENCES `record_entry` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `chq_due_list`
--
ALTER TABLE `chq_due_list`
  ADD CONSTRAINT `chq_due_list_ibfk_1` FOREIGN KEY (`record_entry_id`) REFERENCES `record_entry` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `current_status`
--
ALTER TABLE `current_status`
  ADD CONSTRAINT `current_status_ibfk_1` FOREIGN KEY (`record_entry_id`) REFERENCES `record_entry` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `demurrage_dispatch`
--
ALTER TABLE `demurrage_dispatch`
  ADD CONSTRAINT `demurrage_dispatch_ibfk_1` FOREIGN KEY (`record_entry_id`) REFERENCES `record_entry` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`record_entry_id`) REFERENCES `record_entry` (`id`);

--
-- Constraints for table `record_entry`
--
ALTER TABLE `record_entry`
  ADD CONSTRAINT `record_entry_ibfk_1` FOREIGN KEY (`job_entry_id`) REFERENCES `job_entry` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
