# Introduction
This repo is meant to be a development environment for analytics on lakehouse defined in the repo [open-data-lakehouse](https://github.com/Thue77/open-data-lakehouse). The project holds scripts that are sepcifically relevant for my project, but the general structure can be resused for any lake based data warehouse. 

# Architecture

# Setup 

## Register secrets in environment
Secrets need to be stored as environmental variables. The following suggests a procedure to do so 
- Remove ".temp" from [.env.temp](.env.temp) and populate the values. 
- Execute [dot_env_to_env_vars.ps1](dot_env_to_env_vars.ps1) to load the values in the `.env` file as environment variables
- Execute [env_vars_in_files.ps1](env_vars_in_files.ps1) to create non-temp versions populated with secrets of the relevant configuration files

## Spinning up containers

### Superset
After spinning up container for the first time, the following commands should be executed from inside the superset container:

- `
superset fab create-admin \
              --username admin \
              --firstname Superset \
              --lastname Admin \
              --email admin@superset.com \
              --password admin
`

- `superset db upgrade`
- `superset init`

See more in the [Docker Hub](https://hub.docker.com/r/apache/superset)


# Delta Lake example - From bitsondatadev/trino-getting-started

This examples showcases the Delta Lake connector. It uses MinIO for
S3-compatible objects storage for Delta Lake and a Hive Metastore Service backed
by a MariaDB instance.

The following files are included:

* `docker-conmpose.yml`, configuration file for docker-compose to start all
  needed containers.
* `conf/metastore-site.xml`, configuration file for the Hive Metastore Service
* `etc/` - various configuration files for Trino
* `etc/catalog/delta.properties`, configuration file for the catalog in Trino
  that allows querying the Delta Lake storage.

Watch [Trino Community Broadcast episode 34](https://trino.io/episodes/34.html)
for a full demo, and check the show notes for SQL sample queries.

## Step by step

Start the Docker containers:

```
docker compose up -d
```

Connect with your SQL client of choice. The following steps are applicable with
[DBeaver](https://dbeaver.io/download).

1. Download and install DBeaver.
2. Select **Database->New Database Connection** from the menu.
3. Select the Trino driver and click **next**.
4. This demo is set up without authentication.
5. Put anything in the **Username** field and leave the **Password** field
   blank.
6. Open the SQL console and run the command to create a schema.

From here you can follow along with the demo, or try your own SQL queries. The
following queries are used in the demo.

Verify that the catalog is available:

```sql
SHOW CATALOGS;
```

Check if there are any schemas:

```sql
SHOW SCHEMAS FROM delta;
```

Let's create a new schema:

```sql
CREATE SCHEMA delta.myschema WITH (location='s3a://claudiustestbucket/myschema');
```

Create a table, insert some records, and then verify:

```sql
CREATE TABLE delta.myschema.mytable (name varchar, id integer);
INSERT INTO delta.myschema.mytable VALUES ( 'John', 1), ('Jane', 2);
SELECT * FROM delta.myschema.mytable;
```

Run a query to get more data and insert it into a new table:

```sql
CREATE TABLE delta.myschema.myothertable AS
  SELECT * FROM delta.myschema.mytable;

SELECT * FROM delta.myschema.myothertable ;
```

Now for some data manipulation:

```sql
UPDATE delta.myschema.myothertable set name='Jonathan' where id=1;
SELECT * FROM delta.myschema.myothertable ;
DELETE FROM delta.myschema.myothertable where id=2;
SELECT * FROM delta.myschema.myothertable ;
```

And finally, lets clean up:

```sql
ALTER TABLE delta.myschema.mytable EXECUTE optimize(file_size_threshold => '10MB');
ANALYZE delta.myschema.myothertable;
DROP TABLE delta.myschema.myothertable ;
DROP TABLE delta.myschema.mytable ;
DROP SCHEMA delta.myschema;
```

