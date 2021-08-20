FROM ruby:2.7

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1
RUN apt-get clean
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install imagemagick ffmpeg -y

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ruby video_maker.rb --length $LENGTH --direction $DIRECTION
