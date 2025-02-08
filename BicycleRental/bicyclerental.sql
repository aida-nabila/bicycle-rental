-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 08, 2025 at 05:47 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bicyclerental`
--

-- --------------------------------------------------------

--
-- Table structure for table `bicycle`
--

CREATE TABLE `bicycle` (
  `bicycle_id` int(11) NOT NULL,
  `tag_no` varchar(10) NOT NULL,
  `bicycle_type` varchar(15) NOT NULL,
  `status` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bicycle`
--

INSERT INTO `bicycle` (`bicycle_id`, `tag_no`, `bicycle_type`, `status`) VALUES
(1, 'CB10001', 'City Bike', 'Available'),
(2, 'CB10002', 'City Bike', 'Available'),
(3, 'CB10003', 'City Bike', 'Available'),
(4, 'CB10004', 'City Bike', 'Available'),
(5, 'CB10005', 'City Bike', 'Available'),
(6, 'CB10006', 'City Bike', 'Available'),
(7, 'CB10007', 'City Bike', 'Available'),
(8, 'CB10008', 'City Bike', 'Available'),
(9, 'CB10009', 'City Bike', 'Available'),
(10, 'CB10010', 'City Bike', 'Available'),
(11, 'HB20001', 'Hybrid Bike', 'Available'),
(12, 'HB20002', 'Hybrid Bike', 'Available'),
(13, 'HB20003', 'Hybrid Bike', 'Available'),
(14, 'HB20004', 'Hybrid Bike', 'Available'),
(15, 'HB20005', 'Hybrid Bike', 'Available'),
(16, 'HB20006', 'Hybrid Bike', 'Available'),
(17, 'HB20007', 'Hybrid Bike', 'Available'),
(18, 'HB20008', 'Hybrid Bike', 'Available'),
(19, 'HB20009', 'Hybrid Bike', 'Available'),
(20, 'HB20010', 'Hybrid Bike', 'Available'),
(21, 'EB30001', 'Electric Bike', 'Available'),
(22, 'EB30002', 'Electric Bike', 'Available'),
(23, 'EB30003', 'Electric Bike', 'Available'),
(24, 'EB30004', 'Electric Bike', 'Available'),
(25, 'EB30005', 'Electric Bike', 'Available'),
(26, 'EB30006', 'Electric Bike', 'Available'),
(27, 'EB30007', 'Electric Bike', 'Available'),
(28, 'EB30008', 'Electric Bike', 'Available'),
(29, 'EB30009', 'Electric Bike', 'Available'),
(30, 'EB30010', 'Electric Bike', 'Available'),
(31, 'CB40001', 'Cruiser Bike', 'Available'),
(32, 'CB40002', 'Cruiser Bike', 'Available'),
(33, 'CB40003', 'Cruiser Bike', 'Available'),
(34, 'CB40004', 'Cruiser Bike', 'Available'),
(35, 'CB40005', 'Cruiser Bike', 'Available'),
(36, 'CB40006', 'Cruiser Bike', 'Available'),
(37, 'CB40007', 'Cruiser Bike', 'Available'),
(38, 'CB40008', 'Cruiser Bike', 'Available'),
(39, 'CB40009', 'Cruiser Bike', 'Available'),
(40, 'CB40010', 'Cruiser Bike', 'Available'),
(41, 'FB50001', 'Folding Bike', 'Available'),
(42, 'FB50002', 'Folding Bike', 'Available'),
(43, 'FB50003', 'Folding Bike', 'Available'),
(44, 'FB50004', 'Folding Bike', 'Available'),
(45, 'FB50005', 'Folding Bike', 'Available'),
(46, 'FB50006', 'Folding Bike', 'Available'),
(47, 'FB50007', 'Folding Bike', 'Available'),
(48, 'FB50008', 'Folding Bike', 'Available'),
(49, 'FB50009', 'Folding Bike', 'Available'),
(50, 'FB50010', 'Folding Bike', 'Available');

-- --------------------------------------------------------

--
-- Table structure for table `bicycle_rentals`
--

CREATE TABLE `bicycle_rentals` (
  `rental_id` int(11) NOT NULL,
  `bicycle_id` int(11) NOT NULL,
  `rental_hours` int(11) NOT NULL,
  `rental_date` date NOT NULL,
  `rental_time` time NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `user_id` int(11) DEFAULT NULL,
  `rental_status` varchar(10) NOT NULL,
  `penalty` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` int(11) NOT NULL,
  `card_holder_name` varchar(255) NOT NULL,
  `card_number` varchar(16) NOT NULL,
  `expiry_month` int(11) NOT NULL,
  `expiry_year` int(11) NOT NULL,
  `cvv` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `rental_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `support_tickets`
--

CREATE TABLE `support_tickets` (
  `ticket_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `issue_type` varchar(255) NOT NULL,
  `issue_desc` text NOT NULL,
  `image_path` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_id` int(11) NOT NULL,
  `firstname` varchar(50) NOT NULL,
  `lastname` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bicycle`
--
ALTER TABLE `bicycle`
  ADD PRIMARY KEY (`bicycle_id`);

--
-- Indexes for table `bicycle_rentals`
--
ALTER TABLE `bicycle_rentals`
  ADD PRIMARY KEY (`rental_id`),
  ADD KEY `fk_user_id` (`user_id`),
  ADD KEY `fk_bicycle_id` (`bicycle_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_rental_id` (`rental_id`);

--
-- Indexes for table `support_tickets`
--
ALTER TABLE `support_tickets`
  ADD PRIMARY KEY (`ticket_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bicycle`
--
ALTER TABLE `bicycle`
  MODIFY `bicycle_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT for table `bicycle_rentals`
--
ALTER TABLE `bicycle_rentals`
  MODIFY `rental_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `support_tickets`
--
ALTER TABLE `support_tickets`
  MODIFY `ticket_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bicycle_rentals`
--
ALTER TABLE `bicycle_rentals`
  ADD CONSTRAINT `fk_bicycle_id` FOREIGN KEY (`bicycle_id`) REFERENCES `bicycle` (`bicycle_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `fk_rental_id` FOREIGN KEY (`rental_id`) REFERENCES `bicycle_rentals` (`rental_id`);

--
-- Constraints for table `support_tickets`
--
ALTER TABLE `support_tickets`
  ADD CONSTRAINT `support_tickets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
