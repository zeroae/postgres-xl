--Distribution column definition can be changed, however values should be within limits of the changed data type. Distribution column cannot be dropped. This works for HASH and not for MODULO now (bug). So failing test for now. 

--integer - converting to varchar, to INT8, 

CREATE TABLE xl_at (
    product_no integer,
    product_id integer PRIMARY KEY
) DISTRIBUTE BY HASH (product_id);

ALTER TABLE xl_at ALTER COLUMN product_id TYPE INT2;

ALTER TABLE xl_at ALTER COLUMN product_id TYPE INT4;

ALTER TABLE xl_at ALTER COLUMN product_id TYPE varchar(80);

ALTER TABLE xl_at ALTER COLUMN product_id TYPE INT8 USING product_id::bigint;

ALTER TABLE xl_at ALTER COLUMN product_no TYPE INT2;

ALTER TABLE xl_at ALTER COLUMN product_no TYPE INT4;

ALTER TABLE xl_at ALTER COLUMN product_no TYPE varchar(80);

ALTER TABLE xl_at ALTER COLUMN product_no TYPE INT8 USING product_no::bigint;

INSERT into xl_at (product_no, product_id) VALUES (9223372036854775807, 9223372036854775807);

-- Value is beyond limit for below smaller integer conversions - so these fail
ALTER TABLE xl_at ALTER COLUMN product_id TYPE integer;--fail

ALTER TABLE xl_at ALTER COLUMN product_id TYPE INT2;--fail

ALTER TABLE xl_at ALTER COLUMN product_id TYPE INT4;--fail

ALTER TABLE xl_at ALTER COLUMN product_no TYPE integer;--fail

ALTER TABLE xl_at ALTER COLUMN product_no TYPE INT2;--fail

ALTER TABLE xl_at ALTER COLUMN product_no TYPE INT4;--fail

ALTER TABLE xl_at ALTER COLUMN product_id TYPE varchar(80);

ALTER TABLE xl_at ALTER COLUMN product_no TYPE varchar(80);


--INT8 - converting to varchar, to integer, 

CREATE TABLE xl_at1 (
    product_no INT8,
    product_id INT8 PRIMARY KEY
) DISTRIBUTE BY HASH (product_id);

ALTER TABLE xl_at1 ALTER COLUMN product_id TYPE INT2 USING product_id::smallint;

ALTER TABLE xl_at1 ALTER COLUMN product_id TYPE INT4 USING product_id::integer;

ALTER TABLE xl_at1 ALTER COLUMN product_id TYPE varchar(80);

ALTER TABLE xl_at1 ALTER COLUMN product_id TYPE integer USING product_id::integer;

ALTER TABLE xl_at1 ALTER COLUMN product_no TYPE INT2 USING product_no::smallint;

ALTER TABLE xl_at1 ALTER COLUMN product_no TYPE INT4 USING product_no::integer;

ALTER TABLE xl_at1 ALTER COLUMN product_no TYPE varchar(80);

ALTER TABLE xl_at1 ALTER COLUMN product_no TYPE integer USING product_no::integer;

INSERT into xl_at1 (product_no, product_id) VALUES (42, 42);

-- Value is within limit for smaller integer conversions - so these pass
ALTER TABLE xl_at1 ALTER COLUMN product_id TYPE INT8;

ALTER TABLE xl_at1 ALTER COLUMN product_id TYPE INT2;

ALTER TABLE xl_at1 ALTER COLUMN product_id TYPE INT4;

ALTER TABLE xl_at1 ALTER COLUMN product_no TYPE INT8;

ALTER TABLE xl_at1 ALTER COLUMN product_no TYPE INT2;

ALTER TABLE xl_at1 ALTER COLUMN product_no TYPE INT4;

ALTER TABLE xl_at1 ALTER COLUMN product_id TYPE varchar(80);

ALTER TABLE xl_at1 ALTER COLUMN product_no TYPE varchar(80);

-- HASH Distributed table:
-- Distribution column cannot be dropped. 
CREATE TABLE xl_at2h (
    product_no INT8,
    product_id INT2
) DISTRIBUTE BY HASH (product_id);

ALTER TABLE xl_at2h DROP COLUMN product_id;--fail - distribution column cannot be dropped. 

ALTER TABLE xl_at2h DISTRIBUTE BY MODULO(product_id);

ALTER TABLE xl_at2h DISTRIBUTE BY HASH(product_id);

ALTER TABLE xl_at2h DROP COLUMN product_no;

ALTER TABLE xl_at2h ADD COLUMN product_no INT8;

ALTER TABLE xl_at2h ALTER COLUMN product_no SET NOT NULL;

ALTER TABLE xl_at2h ALTER COLUMN product_id SET NOT NULL;

ALTER TABLE xl_at2h ALTER COLUMN product_no DROP NOT NULL;

ALTER TABLE xl_at2h ALTER COLUMN product_id DROP NOT NULL; 

ALTER TABLE xl_at2h ALTER COLUMN product_no SET DEFAULT 0;

ALTER TABLE xl_at2h ALTER COLUMN product_id SET DEFAULT 0;

ALTER TABLE xl_at2h ALTER COLUMN product_no DROP DEFAULT;

ALTER TABLE xl_at2h ALTER COLUMN product_id DROP DEFAULT;

ALTER TABLE xl_at2h RENAME COLUMN product_no TO product_number;

ALTER TABLE xl_at2h RENAME COLUMN product_id TO product_identifier;

ALTER TABLE xl_at2h RENAME TO xl_at3h;

ALTER TABLE xl_at3h DELETE NODE (datanode2);

ALTER TABLE xl_at3h ADD NODE (datanode2);

ALTER TABLE xl_at3h DISTRIBUTE BY REPLICATION; 

-- MODULO Distributed table:
-- Distribution column cannot be dropped (BUG: It can be dropped now. Test Fails). 

CREATE TABLE xl_at2m (
    product_no INT8,
    product_id INT2
) DISTRIBUTE BY MODULO (product_id); 

ALTER TABLE xl_at2m DISTRIBUTE BY HASH(product_id);

ALTER TABLE xl_at2m DISTRIBUTE BY MODULO(product_id);

ALTER TABLE xl_at2m DROP COLUMN product_no;

ALTER TABLE xl_at2m ADD COLUMN product_no INT8;

ALTER TABLE xl_at2m ALTER COLUMN product_no SET NOT NULL;

ALTER TABLE xl_at2m ALTER COLUMN product_id SET NOT NULL;

ALTER TABLE xl_at2m ALTER COLUMN product_no DROP NOT NULL;

ALTER TABLE xl_at2m ALTER COLUMN product_id DROP NOT NULL;

ALTER TABLE xl_at2m ALTER COLUMN product_no SET DEFAULT 0;

ALTER TABLE xl_at2m ALTER COLUMN product_id SET DEFAULT 0;

ALTER TABLE xl_at2m ALTER COLUMN product_no DROP DEFAULT;

ALTER TABLE xl_at2m ALTER COLUMN product_id DROP DEFAULT;

ALTER TABLE xl_at2m RENAME COLUMN product_no TO product_number;

ALTER TABLE xl_at2m RENAME COLUMN product_id TO product_identifier;

ALTER TABLE xl_at2m RENAME TO xl_at3m;

ALTER TABLE xl_at3m DELETE NODE (datanode2);

ALTER TABLE xl_at3m ADD NODE (datanode2);

ALTER TABLE xl_at3m DROP COLUMN product_identifier;--fail - distribution column cannot be dropped.

ALTER TABLE xl_at3m DISTRIBUTE BY REPLICATION;

DROP TABLE xl_at;
DROP TABLE xl_at1;
DROP TABLE xl_at2h;
DROP TABLE xl_at3h;
DROP TABLE xl_at2m;
DROP TABLE xl_at3m;
