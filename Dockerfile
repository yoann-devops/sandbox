FROM httpd:2.4

# Copier les fichiers du site web dans le répertoire Apache
COPY ./site-web/ /usr/local/apache2/htdocs/

# Exposer le port 80 pour le serveur web
EXPOSE 80
