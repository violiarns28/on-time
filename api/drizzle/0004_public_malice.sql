CREATE TABLE `blockchain_ledger` (
	`id` serial AUTO_INCREMENT NOT NULL,
	`block_index` int NOT NULL,
	`timestamp` timestamp NOT NULL,
	`data` text NOT NULL,
	`previous_hash` varchar(64) NOT NULL,
	`hash` varchar(64) NOT NULL,
	`nonce` int NOT NULL,
	CONSTRAINT `blockchain_ledger_id` PRIMARY KEY(`id`)
);
