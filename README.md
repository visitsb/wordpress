# Wordpress

Supports Wordpress hosting in a sub directory when an environment variable `WORDPRESS_ROOTDIR` is set. 

This allows you to host Wordpress from a web path other than root domain.

Run it like this inside a Docker stack. The same can also be run using `docker run` too.

```yaml
  wordpress:
    depends_on:
      - mysql
    image: visitsb/wordpress:latest
    volumes:
       - ...
    deploy:
      ...
    environment:
      WORDPRESS_DB_HOST: <Your MySQL link from `depends_on`>
      WORDPRESS_DB_USER: <Database user>
      WORDPRESS_DB_PASSWORD: <Password>
      WORDPRESS_DB_NAME: <Database name>
      WORDPRESS_ROOTDIR: <Sub folder under which your wordpress resides. E.g. blog, or blog/myawesomeblog. Leading / is not necessary>
```

Your container will show that Wordpress files are copied into the sub-folder `WORDPRESS_ROOTDIR`. 

You should be able to use Wordpress from a path inside your domain `https://mysite/blog`