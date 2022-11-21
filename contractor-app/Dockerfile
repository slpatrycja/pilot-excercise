FROM ruby:3.1.2-alpine AS builder
RUN apk add build-base postgresql-dev gcompat
COPY Gemfile* .
RUN bundle install
FROM ruby:3.1.2-alpine AS runner
RUN apk add tzdata nodejs postgresql-dev gcompat
WORKDIR /app
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY . .
EXPOSE 3000
CMD ["rails", "server", "-p", "3000", "-b", "0.0.0.0"]
