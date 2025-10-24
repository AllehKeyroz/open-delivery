# Use imagem oficial do Ruby
FROM ruby:3.2-alpine

# Instalar dependências de sistema
RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    nodejs \
    yarn \
    tzdata \
    git

# Diretório de trabalho
WORKDIR /app

# Copiar Gemfile e instalar gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3

# Copiar o restante do app
COPY . .

# Pré-compilar assets se usar Rails com assets pipeline
RUN RAILS_ENV=production bundle exec rake assets:precompile

# Variáveis de ambiente
ENV RAILS_ENV=production \
    RACK_ENV=production \
    PORT=3000

# Expor porta
EXPOSE 3000

# Comando para iniciar a aplicação
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
