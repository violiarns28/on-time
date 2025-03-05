CREATE TABLE `attendances` (
	`id` int NOT NULL,
	`user_id` int NOT NULL,
	`latitude` decimal(12,5) NOT NULL,
	`longitude` decimal(12,5) NOT NULL,
	`attendance_type` enum('GENESIS','CLOCK_IN','CLOCK_OUT') NOT NULL,
	`date` date NOT NULL,
	`timestamp` bigint NOT NULL,
	`hash` varchar(64) NOT NULL,
	`previous_hash` varchar(64) NOT NULL,
	`nonce` int NOT NULL,
	CONSTRAINT `attendances_id` PRIMARY KEY(`id`)
);
--> statement-breakpoint
CREATE TABLE `users` (
	`id` serial AUTO_INCREMENT NOT NULL,
	`name` varchar(255) NOT NULL,
	`email` varchar(255) NOT NULL,
	`password` varchar(255) NOT NULL,
	`device_id` varchar(255) NOT NULL,
	`created_at` timestamp DEFAULT (now()),
	`updated_at` timestamp DEFAULT (now()),
	CONSTRAINT `users_id` PRIMARY KEY(`id`),
	CONSTRAINT `users_email_unique` UNIQUE(`email`)
);
