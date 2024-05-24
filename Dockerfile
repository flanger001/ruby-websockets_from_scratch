FROM ruby:latest

WORKDIR /app
COPY Gemfile* .
RUN bundle install
COPY config.ru app.rb ./
COPY ./app /app/app
EXPOSE 9292

CMD ["bundle", "exec", "puma"]
