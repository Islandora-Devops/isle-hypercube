---

hypercube:
  # path to the convert executable
  tesseract_executable: tesseract
  pdftotext_executable: pdftotext

fedora_resource:
  base_url: http://fcrepo:8080/fcrepo/rest

log:
  # Valid log levels are:
  # DEBUG, INFO, NOTICE, WARNING, ERROR, CRITICAL, ALERT, EMERGENCY, NONE
  # log level none won't open logfile
  level: {{getv "/hypercube/log/level"}}
  file: /var/log/islandora/hypercube.log

syn:
  # toggles JWT security for service
  enable: true
  # Path to the syn config file for authentication.
  # example can be found here:
  # https://github.com/Islandora/Syn/blob/master/conf/syn-settings.example.xml
  config: ../syn-settings.xml
