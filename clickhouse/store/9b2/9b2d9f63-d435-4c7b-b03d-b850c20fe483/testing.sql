ATTACH TABLE _ UUID 'dec01f39-419f-4cca-be45-c0220a226f53'
(
    `id` Int16,
    `name` String
)
ENGINE = MergeTree
PRIMARY KEY tuple(id)
ORDER BY tuple(id)
SETTINGS index_granularity = 8192
