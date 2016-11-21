#!/bin/bash
docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=mypass --name=asciinema_postgres postgres
docker run -d -p 6379:6379 --name=asciinema_redis redis
docker run --rm --link asciinema_postgres:postgres -e DATABASE_URL="postgresql://postgres:mypass@postgres/asciinema" --link asciinema_redis:redis -e REDIS_URL="redis://redis:6379" asciinema/asciinema.org bundle exec rake db:setup
# starting sidekiq using the provided start_sidekiq.rb file will also start sendmail service if you don't want to use SMTP
# otherwise start sidekiq by starting: bundle exec sidekiq
docker run -d --link asciinema_postgres:postgres -e DATABASE_URL="postgresql://postgres:mypass@postgres/asciinema" --link asciinema_redis:redis -e REDIS_URL="redis://redis:6379" asciinema/asciinema.org ruby  start_sidekiq.rb
docker run -d --link asciinema_postgres:postgres -e DATABASE_URL="postgresql://postgres:mypass@postgres/asciinema" --link asciinema_redis:redis -e REDIS_URL="redis://redis:6379" -p 3000:3000 asciinema/asciinema.org
