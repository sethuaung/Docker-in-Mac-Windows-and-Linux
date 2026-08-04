**Docker Compose** is a powerful tool used to define and manage multi-container applications through a single `docker-compose.yml` configuration file. By utilizing this tool, you can deploy, link, and configure multiple isolated services with simple terminal commands instead of handling individual, convoluted `docker run` scripts. [[1](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04), [2](https://www.youtube.com/watch?v=8-pos-ECeY0)]

----------

## Step-by-Step Installation on Ubuntu/Linux

Modern setups utilize Docker Compose V2, which functions directly as a CLI plugin (`docker compose`) rather than the outdated standalone binary (`docker-compose`). [[1](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04), [2](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04)]

### 1. Update Package Index

Refresh your local package repository information to ensure you grab the newest available software versions. [[1](https://www.akamai.com/docs/guides/how-to-use-docker-compose-v2/), [2](https://www.youtube.com/watch?v=4wyXCjSi0w0&t=9)]

bash

```
sudo apt update && sudo apt upgrade -y

```
### 2. Install Docker Engine (`docker.io`) [[1](https://dct.delphix.com/docs/10.0.0/installation-and-setup-for-docker-compose)]

Install the primary Docker engine packages directly from your system repository. [[1](https://linuxconfig.org/how-to-install-docker-compose-on-ubuntu-26-04), [2](https://dct.delphix.com/docs/10.0.0/installation-and-setup-for-docker-compose)]

bash

```
sudo apt install docker.io -y

```

### 3. Install Docker Compose Plugin [[1](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-22-04)]

Install the dedicated plugin to enable modern v2 compose functionality. [[1](https://linuxconfig.org/how-to-install-docker-compose-on-ubuntu-26-04), [2](https://www.digitalocean.com/community/tutorials/how-to-use-ansible-to-install-and-set-up-docker-on-ubuntu-20-04), [3](https://oneuptime.com/blog/post/2026-02-08-how-to-use-docker-compose-commands-v2-cli/view)]

bash

```
sudo apt install docker-compose-plugin -y

```
### 4. Configure User Permissions (Optional) [[1](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04)]

Add your current user account to the system docker group. This allows you to run Docker and Compose commands without prepending `sudo` every time. [[1](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04), [2](https://linuxconfig.org/how-to-install-docker-compose-on-ubuntu-26-04)]

bash

```
sudo usermod -aG docker $USER

```
_Note: You must log out of your session and log back in for this permission adjustment to take effect._ [[1](https://linuxconfig.org/how-to-install-docker-compose-on-ubuntu-26-04)]

### 5. Verify the Installation

Confirm that both the foundational engine and the plugin are functioning smoothly. [[1](https://www.akamai.com/docs/guides/how-to-use-docker-compose-v2/), [2](https://www.youtube.com/watch?v=8-pos-ECeY0)]

bash

```
docker --version
docker compose version

```
## Basic Usage Example

To utilize Docker Compose, you must outline your services inside a configuration text file. [[1](https://www.youtube.com/watch?v=8-pos-ECeY0), [2](https://www.sumologic.com/blog/setting-docker-environment-using-docker-compose)]

-   Create a clean project folder and navigate inside:
    
    bash
    
    ```
    mkdir my-web-app && cd my-web-app
    
    ```
  

-   Create a configuration file exactly named `docker-compose.yml`:
    
    bash
    
    ```
    nano docker-compose.yml
    
    ```
  

-   Paste the following configuration, which sets up an isolated Nginx web server:
    
    yaml
    
    ```
    services:
      web_server:
        image: nginx:latest
        ports:
          - "8080:80"
        restart: always
    
    ```
   
    [[1](https://www.youtube.com/watch?v=DM65_JyGxCo&t=165), [2](https://webdock.io/en/docs/how-guides/docker-guides/how-to-install-and-run-docker-containers-using-docker-compose?srsltid=AfmBOopRfKi4KwB1NcpobBchI5UhJGnF7GUKeXM9uLcMybRXtvYA9kNz), [3](https://www.sumologic.com/blog/setting-docker-environment-using-docker-compose), [4](https://linuxconfig.org/how-to-install-docker-compose-on-ubuntu-26-04), [5](https://labex.io/tutorials/docker-how-to-use-docker-compose-pause-command-to-pause-services-555084)]

----------

## Useful Docker Compose Commands

We must run all of these commands from within the specific directory containing our target `docker-compose.yml` file. [[1](https://webdock.io/en/docs/how-guides/docker-guides/how-to-install-and-run-docker-containers-using-docker-compose?srsltid=AfmBOopRfKi4KwB1NcpobBchI5UhJGnF7GUKeXM9uLcMybRXtvYA9kNz), [2](https://dev.to/dbazhenov/why-and-how-to-use-docker-compose-for-application-development-34n4)]

### Managing Lifecycle

-   `docker compose up` – Launches all containers and streams real-time console logs.

-   `docker compose up -d` – Launches containers silently in detached background mode.

-   `docker compose down` – Safely stops and deletes running containers and networks.

-   `docker compose down -v` – Stops containers and wipes out attached persistent storage volumes.

-   `docker compose restart` – Restarts all underlying application services quickly. [[1](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04), [2](https://webdock.io/en/docs/how-guides/docker-guides/how-to-install-and-run-docker-containers-using-docker-compose?srsltid=AfmBOopRfKi4KwB1NcpobBchI5UhJGnF7GUKeXM9uLcMybRXtvYA9kNz), [3](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-22-04), [4](https://osusarak.medium.com/dockerizing-a-node-and-mongodb-application-fa2d9a617313), [5](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-rocky-linux-8)]

### Monitoring & Debugging

-   `docker compose ps` – Lists status and port maps for your specific app containers.

-   `docker compose logs` – Outputs consolidated log histories from all running services.

-   `docker compose logs -f` – Streams newly generated console logs in real time.

-   `docker compose top` – Displays active host process lists for every service container. [[1](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04), [2](https://xcloud.host/what-is-docker-compose/), [3](https://medium.com/@_____129/master-docker-interview-preparation-questions-and-answers-ecb5bbe4466a), [4](https://labex.io/tutorials/docker-how-to-use-docker-compose-top-command-to-display-running-processes-555094)]

### Administrative & Code Executions

-   `docker compose exec <service_name> <command>` – Executes an interactive command within a running container (e.g., `docker compose exec web_server bash`).

-   `docker compose config` – Validates syntax accuracy and previews your resolved config file.

-   `docker compose pull` – Downloads updated image versions specified inside your file text. [[1](https://www.naukri.com/code360/library/docker-compose), [2](https://medium.com/@vino7tech/essential-docker-commands-for-developing-and-deploying-spring-boot-projects-028501997fba), [3](https://www.cherryservers.com/blog/install-docker-compose-ubuntu), [4](https://tech-insider.org/docker-compose-tutorial-multi-container-apps-2026/), [5](https://strapi.io/blog/what-is-docker-compose-all-you-need-to-know)]
