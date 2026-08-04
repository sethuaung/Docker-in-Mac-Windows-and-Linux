# Multi-service local environment
We can orchestrate everything using a single unified `docker-compose.yml` file. This stack will set up **MySQL (with row-level binlogs enabled)**, **Prometheus** for metrics collection, and the complete event-streaming backend (**Zookeeper, Kafka, and Debezium Connect**), along with a **Next.js sample application** designed to communicate with this ecosystem. [[1](https://medium.com/@shivammishra20121999/a-practical-guide-to-real-time-mysql-cdc-using-debezium-kafka-and-docker-aa490761519d), [2](https://medium.com/towardsdev/change-data-capture-cdc-with-docker-apache-kafka-debezium-and-apache-spark-streaming-0922fa901c21), [3](https://stefanprodan.com/blog/2016/a-monitoring-solution-for-docker-hosts-containers-and-containerized-services/)]

## Complete Architecture Configuration (`docker-compose.yml`)

Create a folder for your project and place the following configuration into a file named `docker-compose.yml`: [[1](https://memgraph.com/docs/data-streams/kafka)]

YAML

```
version: '3.8'

networks:
  app-network:
    driver: bridge

volumes:
  mysql_data:
  prometheus_data:

services:
  # --- Container 1: MySQL (with CDC Binlog Config) ---
  mysql:
    image: debezium/example-mysql:2.5
    container_name: mysql_container
    ports:
      - "3306:3306"
    environment:
      - MYSQL_ROOT_PASSWORD=rootpassword
      - MYSQL_USER=appuser
      - MYSQL_PASSWORD=apppassword
      - MYSQL_DATABASE=sampledb
    volumes:
      - mysql_data:/var/lib/mysql
    networks:
      - app-network

  # --- Container 2: Prometheus Monitoring ---
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus_container
    ports:
      - "9090:9090"
    volumes:
      - prometheus_data:/prometheus
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    networks:
      - app-network

  # --- Event Streaming Layer (Zookeeper, Kafka, Debezium) ---
  zookeeper:
    image: debezium/zookeeper:2.5
    container_name: zookeeper_container
    ports:
      - "2181:2181"
    networks:
      - app-network

  kafka:
    image: debezium/kafka:2.5
    container_name: kafka_container
    ports:
      - "9092:9092"
    environment:
      - ZOOKEEPER_CONNECT=zookeeper:2181
    depends_on:
      - zookeeper
    networks:
      - app-network

  debezium:
    image: debezium/connect:2.5
    container_name: debezium_container
    ports:
      - "8083:8083"
    environment:
      - BOOTSTRAP_SERVERS=kafka:9092
      - GROUP_ID=1
      - CONFIG_STORAGE_TOPIC=my_connect_configs
      - OFFSET_STORAGE_TOPIC=my_connect_offsets
      - STATUS_STORAGE_TOPIC=my_connect_statuses
    depends_on:
      - kafka
      - mysql
    networks:
      - app-network

  # --- Container 3: Next.js Sample App Application ---
  nextjs-app:
    image: node:18-alpine
    container_name: nextjs_container
    working_dir: /app
    ports:
      - "3000:3000"
    volumes:
      - ./nextjs-app:/app
    command: sh -c "npm install && npm run dev"
    environment:
      - DATABASE_URL=mysql://appuser:apppassword@mysql:3306/sampledb
      - KAFKA_BROKER=kafka:9092
    depends_on:
      - mysql
      - kafka
    networks:
      - app-network
```

## Step-by-Step Setup Guide

### Step 1: Configure Prometheus Metrics Tracking [[1](https://coralogix.com/guides/prometheus-monitoring/prometheus-docker-ways-to-use-together/)]

Before spinning up the containers, Prometheus needs a configuration file targeting itself and your application dependencies. Create a file named `prometheus.yml` in the same directory: [[1](https://medium.com/xebia-engineering/container-and-system-monitoring-on-aws-e6f385588ee5), [2](https://dev.to/chauhoangminhnguyen/monitoring-with-cadvisor-prometheus-and-grafana-on-docker-1feo), [3](https://ragug.medium.com/server-monitoring-with-docker-prometheus-and-grafana-made-simple-f23ef1b898ff)]

YAML

```
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'nextjs-app'
    static_configs:
      - targets: ['nextjs-app:3000']

```

### Step 2: Initialize Next.js Sample Application

To provide files for the docker mount volume, run the initialization command locally in a new subfolder named `nextjs-app`:

bash

```
npx create-next-app@latest nextjs-app --ts --eslint --tailwind --src-dir --app --import-alias "@/*"

```


_(When prompted, accept the default layout preferences)._

Inside our Next.js application folder, add a Kafka client capability using a package like `kafkajs` to interact with your streaming environment:

bash

```
cd nextjs-app && npm install kafkajs

```

### Step 3: Run the Containers Together

From your root folder (where the `docker-compose.yml` is located), command Docker to build and orchestrate the full runtime infrastructure: [[1](https://medium.com/@vizslatarreii/docker-compose-tutorial-run-spring-boot-microservices-from-code-to-containers-8a2be37d8e1a)]

bash

```
docker compose up -d

```

Verify that all 6 infrastructure modules are active and running: [[1](https://medium.com/@shivammishra20121999/a-practical-guide-to-real-time-mysql-cdc-using-debezium-kafka-and-docker-aa490761519d)]

bash

```
docker compose ps

```

### Step 4: Register Debezium to Stream Changes from MySQL [[1](https://materialize.com/blog/join-kafka-with-database-debezium-materialize/)]

Debezium needs a configuration profile submitted via REST API to establish target row tracking. Send a JSON payload targeting your internal MySQL database: [[1](https://hub.docker.com/r/debezium/connect), [2](https://medium.com/@shivammishra20121999/a-practical-guide-to-real-time-mysql-cdc-using-debezium-kafka-and-docker-aa490761519d)]

bash

```
curl -X POST http://localhost:8083/connectors -H "Content-Type: application/json" -d '{
  "name": "mysql-cdc-connector",
  "config": {
    "connector.class": "io.debezium.connector.mysql.MySqlConnector",
    "tasks.max": "1",
    "database.hostname": "mysql",
    "database.port": "3306",
    "database.user": "root",
    "database.password": "rootpassword",
    "database.server.id": "184054",
    "topic.prefix": "cdc",
    "database.include.list": "sampledb",
    "schema.history.internal.kafka.bootstrap.servers": "kafka:9092",
    "schema.history.internal.kafka.topic": "schemahistory.sampledb"
  }
}'

```

### Step 5: Verify Active Pipeline Endpoints [[1](https://blog.dataengineerthings.org/implementing-change-data-capture-cdc-with-kafka-connect-and-apache-kafka-on-kubernetes-a-d3c5ca2fa6d7)]

We can now directly access each respective dashboard component to ensure system operation:

-   **Next.js Project Instance**: Access your active web framework at `http://localhost:3000`.

-   **Prometheus Metrics Core**: Check infrastructure monitoring targets via `http://localhost:9090`.

-   **Debezium Status API**: Run `curl http://localhost:8083/connectors/mysql-cdc-connector/status` to ensure database binlogs are streaming cleanly into Kafka topics. [[1](https://medium.com/@imyounas/setting-up-kind-kubernetes-cluster-with-prometheus-grafana-and-k6-for-monitoring-and-stress-14d658c4e66e), [2](https://medium.com/@os.sybil/part-ii-prometheus-and-grafana-for-infra-and-app-monitoring-with-docker-setting-up-cadvisor-for-e69d128bbc3b), [3](https://medium.com/@shivammishra20121999/a-practical-guide-to-real-time-mysql-cdc-using-debezium-kafka-and-docker-aa490761519d)]
