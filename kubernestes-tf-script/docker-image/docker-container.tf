resource "docker_network" "my_network" {
  name = "my_network"
}


resource "docker_container" "php-httpd" {
  name     = "webserver"
  hostname = "php-httpd"
  image    = "php-httpd:challenge"

  labels {
    label = "challenge"
    value = "second"
  }

  networks_advanced {
    name = "my_network"
  }

  ports {
    internal = 80
    external = 80
    ip       = "0.0.0.0"
  }

  volumes {
    host_path      = "/root/code/terraform-challenges/challenge2/lamp_stack/website_content/"
    container_path = "/var/www/html"
  }
}


resource "docker_container" "phpmyadmin" {
  name     = "db_dashboard"
  hostname = "phpmyadmin"
  image    = "phpmyadmin/phpmyadmin"

  labels {
    label = "challenge"
    value = "second"
  }

  networks_advanced {
    name = docker_network.my_network.name
  }

  ports {
    internal = 80
    external = 8081
    ip       = "0.0.0.0"
  }

  # Link to db container (deprecated but included as requested)
  links = [docker_container.mariadb.name]

  depends_on = [docker_container.mariadb]
}

resource "docker_volume" "mariadb_volume" {
  name = "mariadb-volume"
}

resource "docker_container" "mariadb" {
  name     = "db"
  hostname = "db"
  image    = "mariadb:challenge"

  labels {
    label = "challenge"
    value = "second"
  }

  networks_advanced {
    name = docker_network.my_network.name
  }

  ports {
    internal = 3306
    external = 3306
    ip       = "0.0.0.0"
  }

  volumes {
    volume_name    = docker_volume.mariadb_volume.name
    container_path = "/var/lib/mysql"
  }

  env = [
    "MYSQL_ROOT_PASSWORD=1234",
    "MYSQL_DATABASE=simple-website"
  ]
}