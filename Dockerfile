FROM ruby:3.0.0

RUN apt-get update && apt-get install -y build-essential
RUN apt-get install default-mysql-client -y                  
RUN mkdir /app
WORKDIR /app

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock

RUN bundle install

ADD . /app

# ENTRYPOINT ["sh", "./init.sh"]
