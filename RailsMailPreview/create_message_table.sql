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
   DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS attachments (
  `id` INTEGER PRIMARY KEY,
  `message_id` INTEGER,
  `filename` TEXT,
  `mime_type` TEXT,
  `data` TEXT,
  `timestamp` TIMESTAMP
   DEFAULT CURRENT_TIMESTAMP
);
