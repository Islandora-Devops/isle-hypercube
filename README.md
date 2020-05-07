# ISLE 8 - Hypercube image

Designed to used with:

* The `isle-hypercube-connector` container and docker-compose service
* The Drupal 8 site

Based on:

* [isle-crayfish-base](https://github.com/Islandora-Devops/isle-crayfish-base)

Contains and includes:

* [Composer](https://getcomposer.org/)
* [Tesseract](https://packages.debian.org/buster/tesseract-ocr)
  * Language packs installed:
    * `eng`
    * `fra`
    * `spa`
    * `ita`
    * `por`
    * `hin`
    * `deu`
    * `jpn`
    * `rus`
* [Poppler Utils](https://poppler.freedesktop.org/)
* [Hypercube](https://github.com/Islandora/Crayfish/tree/dev/Hypercube)

### Running

To run the container, you'll need to bind mount two things:

* A public key from the key pair used to sign and verify JWT tokens at `/opt/keys/public.key`
* A `php.ini` file with output buffering enabled at `/usr/local/etc/php/php.ini`

You'll also want to set two environment variables, which affect configuration of the microservice

* HYPERCUBE_JWT_ADMIN_TOKEN - An easy to remember token to replace an actual JWT when testing (usually "islandora")
* HYPERCUBE_LOG_LEVEL - Logging level for the Hypercube microservice (DEBUG, INFO, WARN, ERROR, etc...)

`docker run -d -p 8000:8000 -e HYPERCUBE_JWT_ADMIN_TOKEN=islandora -e HYPERCUBE_LOG_LEVEL=DEBUG -v /path/to/public.key:/opt/keys/public.key -v /path/to/php.ini:/usr/local/etc/php/php.ini isle-houdini`

### Testing

To test Hypercube, you can issue a curl command against it to verify its endpoint is working.  For example, to run OCR on a sample TIFF:

* `curl -i -H "Authorization: Bearer islandora" -H "Apix-Ldp-Resource: https://www.fileformat.info/format/tiff/sample/3794038f08df403bb446a97f897c578d/download" idcp.localhost:8000`

Note the the `Authorization` header contains the HYPERCUBE_JWT_ADMIN_TOKEN value after `Bearer`.
