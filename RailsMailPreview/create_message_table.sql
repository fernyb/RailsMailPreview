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
  `body` TEXT,
  `mime_type` TEXT,
  `is_multipart` TEXT,
  `timestamp` TIMESTAMP
   DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS attachments (
  `id` INTEGER PRIMARY KEY,
  `message_id` INTEGER,
  `content_id` TEXT,
  `filename` TEXT,
  `mime_type` TEXT,
  `disposition` TEXT,
  `data` TEXT,
  `timestamp` TIMESTAMP
   DEFAULT CURRENT_TIMESTAMP
);