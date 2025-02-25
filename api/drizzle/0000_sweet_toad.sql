CREATE TABLE `attendances` (
	`id` serial AUTO_INCREMENT NOT NULL,
	`user_id` bigint NOT NULL,
	`latitude` decimal(12,5) NOT NULL,
	`longitude` decimal(12,5) NOT NULL,
	`date` datetime NOT NULL,
	`clock_in` time NOT NULL,
	`clock_out` time,
	`created_at` timestamp DEFAULT (now()),
	`updated_at` timestamp DEFAULT (now()),
	CONSTRAINT `attendances_id` PRIMARY KEY(`id`)
);
--> statement-breakpoint
CREATE TABLE `users` (
	`id` serial AUTO_INCREMENT NOT NULL,
	`name` varchar(255) NOT NULL,
	`email` varchar(255) NOT NULL,
	`password` varchar(255),
	`created_at` timestamp DEFAULT (now()),
	`updated_at` timestamp DEFAULT (now()),
	CONSTRAINT `users_id` PRIMARY KEY(`id`),
	CONSTRAINT `users_email_unique` UNIQUE(`email`)
);
--> statement-breakpoint
ALTER TABLE `attendances` ADD CONSTRAINT `attendances_user_id_users_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE cascade ON UPDATE no action;