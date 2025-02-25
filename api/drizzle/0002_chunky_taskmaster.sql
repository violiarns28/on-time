ALTER TABLE `users` MODIFY COLUMN `password` varchar(255) NOT NULL;--> statement-breakpoint
ALTER TABLE `users` ADD `device_id` varchar(255);