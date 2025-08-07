
# Create a terraform resource named php-httpd-image for building docker image with following specifications: Image name: php-httpd:challenge
# add label in dockerfile: LABEL maintainer="Raghib Nadim 
resource "docker_image" "php_httpd_image" {
  name = "php-httpd:challenge"

  build {
    path = "lamp_stack/php_httpd"
  }
}

resource "docker_image" "mariadb-image" {
  name = "mariadb:challenge"

  build {
    path = "lamp_stack/custom_db"
  }
}