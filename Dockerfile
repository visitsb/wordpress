FROM wordpress:apache
LABEL maintainer="Shanti Naik <visitsb@gmail.com>"

# https://serverfault.com/a/960335
# chmod doesn't work correctly
USER root

# Our script that enables hosting Wordpress in a subfolder
# Script name is 'intentional' - has to start with apache2* to allow
# Wordpress ENTRYPOINT ["docker-entrypoint.sh"] to execute it's logic before
# calling our CMD
COPY apache2-wordpress.sh /usr/local/bin/

# Keep Wordpress default entrypoint; do not override it, instead override the CMD
# https://github.com/docker-library/wordpress/blob/master/php7.2/apache/Dockerfile
# ENTRYPOINT ["docker-entrypoint.sh"]

# FYI: Reminder that if ENTRYPOINT is changed in child image
# it resets parent images CMD (makes it null so child image 
# to explicitly specify CMD).
# https://github.com/moby/moby/issues/5147

RUN /bin/chmod +x /usr/local/bin/apache2-wordpress.sh

# When environment variable WORDPRESS_ROOTDIR is set
# The subfolder will be created under default Wordpress root dir
CMD ["apache2-wordpress.sh"]
