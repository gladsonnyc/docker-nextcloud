#!/bin/bash
set -e
source ${NEXTCLOUD_RUNTIME_DIR}/functions

[[ $DEBUG == true ]] && set -x

case ${1} in
  app:nextcloud|app:nginx|app:backup:create|app:backup:restore|storage:apps|occ)

    initialize_system

    case ${1} in
      app:nextcloud)
        configure_nextcloud
        echo "Starting Nextcloud php5-fpm..."
        exec $(which php-fpm${PHP_VERSION}) -F
        ;;
      app:nginx)
        configure_nginx
        echo "Starting nginx..."
        exec $(which nginx) -c /etc/nginx/nginx.conf -g "daemon off;"
        ;;
      app:backup:create)
        shift 1
        backup_create
        ;;
      app:backup:restore)
        shift 1
        backup_restore $@
        ;;
      storage:apps)
        setup_apps_from_original
        ;;
      occ)
        exec $@
        ;;
    esac
    ;;
  app:help)
    echo "Available options:"
    echo " occ                  - Launch the Nextcloud's command-line interface"
    echo " app:nextcloud        - Starts the Nextcloud php5-fpm server (default)"
    echo " app:nginx            - Starts the nginx server"
    echo " app:backup:create    - Create a backup"
    echo " app:backup:restore   - Restore an existing backup"
    echo " app:help             - Displays the help"
    echo " storage:apps         - Setup apps/ directory if it's an ampty volume"
    echo " [command]            - Execute the specified command, eg. bash."
    ;;
  *)
    exec "$@"
    ;;
esac
