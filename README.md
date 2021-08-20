# Getting Started

## Running locally
### Requirements
- Ruby 2.7.4

### Steps
- Clone repo
- `$ bundle install`
- `$ ruby video_maker.rb -l <enter length here> -d <enter direction here>`
    - `-l` or `--length` is expected to be in the format `HH:mm:ss`
    - `-d` or `--direction` is expected to be `up` or `down`

## With Docker

- Clone repo
- Create the docker container

```
$ docker build -t counter_video_maker .
```

- Run the container

```
$ docker run -it --env LENGTH=<enter length here> --env DIRECTION=<enter direction here> -v /desired/host/path:/usr/src/app/videos counter_video_maker
```
Note that the length and directions are specified as the `LENGTH` and `DIRECTION` environment variable and a volume is added to get the output file.
