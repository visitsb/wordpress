#!/bin/bash
set -euo pipefail
set -o nounset

# https://unix.stackexchange.com/a/50488
# How to move all files and folders via mv command
# Need to include .htaccess
shopt -s dotglob

# https://stackoverflow.com/questions/7832080/test-if-a-variable-is-set-in-bash-when-using-set-o-nounset
# Test if a variable is set in bash when using “set -o nounset”
if [ ! -z ${WORDPRESS_ROOTDIR:-} ]; then
  echo >&2 "Working on ${PWD} to adjust for subfolder '${WORDPRESS_ROOTDIR}' ..."
  /bin/mkdir -p ${WORDPRESS_ROOTDIR}

  # Create symbolic links to Wordpress files excluding few that need to be left/changed
  /usr/bin/find ./ -mindepth 1 -maxdepth 1 ! -path "./${WORDPRESS_ROOTDIR}" ! -path "./.htaccess" ! -path "./index.php" -print0 | /usr/bin/xargs -0 -n1 /bin/ln --force --relative --symbolic --target-directory="./${WORDPRESS_ROOTDIR}"

  /bin/cp -f .htaccess ${WORDPRESS_ROOTDIR}
  /bin/cp -f index.php ${WORDPRESS_ROOTDIR}

  # https://codex.wordpress.org/Giving_WordPress_Its_Own_Directory
  /bin/sed -i -r -e "s;'/wp-blog-header.php';'/${WORDPRESS_ROOTDIR}/wp-blog-header.php';mgi" index.php

  echo >&2 "Wordpress should be accessible under subfolder '/${WORDPRESS_ROOTDIR}'"
fi

# Fix permissions to correct user:group (borrowed from docker-entrypoint.sh)
/bin/chown -R "${APACHE_RUN_USER:-www-data}":"${APACHE_RUN_GROUP:-www-data}" .

# Run the default CMD for Wordpress
# https://github.com/docker-library/wordpress/blob/master/php7.2/apache/Dockerfile
# CMD ["apache2-foreground"]
apache2-foreground
