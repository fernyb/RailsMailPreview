CREATE TABLE IF NOT EXISTS messages (
  `id` INTEGER PRIMARY KEY,
  `from` TEXT,
  `subject` TEXT,
  `date` TEXT,
  `to` TEXT,
  `cc` TEXT,
  `reply_to` TEXT,
  `html` TEXT,
  `text` TEXT,
  `timestamp` TIMESTAMP
);
