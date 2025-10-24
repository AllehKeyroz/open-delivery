FROM ruby:2.6-alpine

# Instala dependências do sistema
RUN apk add --no-cache \
  build-base \
  postgresql-dev \
  nodejs \
  yarn \
  tzdata \
  git

# Atualiza o Bundler para a versão usada no projeto
RUN gem uninstall -aIx bundler && \
    gem install bundler -v 1.17.3

WORKDIR /app

# Copia o Gemfile primeiro para otimizar o cache
COPY Gemfile Gemfile.lock ./

# Corrige conflito de rake antes de instalar
RUN bundle _1.17.3_ update rake && \
    bundle _1.17.3_ install --jobs 4 --retry 3

# Copia o restante do código
COPY . .

# Expõe a porta padrão do Rails
EXPOSE 3000

# Comando padrão de execução
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
