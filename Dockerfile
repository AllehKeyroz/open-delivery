# Usa Ruby 2.6, mais próximo das versões suportadas pelo Rails 3
FROM ruby:2.6-alpine

# Instala dependências do sistema
RUN apk add --no-cache \
  build-base \
  postgresql-dev \
  nodejs \
  yarn \
  tzdata \
  git

# Corrige Bundler incompatível com Rails 3
RUN gem uninstall -aIx bundler && \
    gem install bundler -v 1.17.3

WORKDIR /app

# Copia e instala gems
COPY Gemfile Gemfile.lock ./
RUN bundle _1.17.3_ install --jobs 4 --retry 3

# Copia o restante do código
COPY . .

# Variáveis de ambiente
ENV RAILS_ENV=production \
    RACK_ENV=production \
    PORT=3000

# Exposição da porta
EXPOSE 3000

# Comando de inicialização
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
