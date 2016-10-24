CREATE TABLE tables (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  owner_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES human(id)
);

CREATE TABLE humans (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  house_id INTEGER,

  FOREIGN KEY(house_id) REFERENCES human(id)
);

CREATE TABLE houses (
  id INTEGER PRIMARY KEY,
  address VARCHAR(255) NOT NULL
);

INSERT INTO
  houses (id, address)
VALUES
  (1, "598 Broadway"), (2, "1115 Broadway");

INSERT INTO
  humans (id, fname, lname, house_id)
VALUES
  (1, "Jared", "Johnson", 1),
  (2, "Anthony", "Pensinero", 1),
  (3, "Taisha", "Bowman", 2),
  (4, "Tableless", "Human", NULL);

INSERT INTO
  tables (id, name, owner_id)
VALUES
  (1, "Pine", 1),
  (2, "Oak", 2),
  (3, "Cherrywood", 3),
  (4, "Spruce", 3),
  (5, "Plastic", NULL);
