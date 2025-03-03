FROM ruby:3.2

WORKDIR /srv/jekyll

# Instalar Jekyll y Bundler
RUN gem install jekyll bundler

# Copiar archivos de dependencias primero
COPY Gemfile Gemfile.lock ./

# Instalar dependencias del proyecto
RUN bundle install

# Copiar todo el proyecto
COPY . .

# Exponer el puerto de Jekyll
EXPOSE 4000

# Comando para ejecutar Jekyll con live reload
CMD ["jekyll", "serve", "--livereload", "--host", "0.0.0.0"]

