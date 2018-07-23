# `splatnet2statink`, on Heroku

[splatnet2statink](https://github.com/frozenpandaman/splatnet2statink) (a tool for uploading Splatoon 2 battle data to [stat.ink](https://stat.ink)), but running periodically on free Heroku dynos and free S3-based storage

## Setup

1. You'll need a [Heroku](http://heroku.com) account (with credit card entered, sadly), the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli), and a local clone of this repository.

1. Run these commands:
   ```bash
   heroku create # Create a Heroku application
   heroku addons:create cloudcube:free # Add Cloudcube (so we can store configuration in S3)
   heroku addons:create scheduler:standard # Add the Heroku Scheduler (so we can sync periodically)
   git push heroku master # Push the codebase up to Heroku
   ```

1. Run `heroku addons:open scheduler` and create a schedule to run `./bin/update.sh` once an hour.

1. Go to [your stat.ink profile](https://stat.ink/profile) and copy your API token (you'll need it in the next step!).

1. To configure `splatnet2statink`, run `heroku run ./bin/update.sh` and follow the prompts in your terminal.

_It's worth noting that the Nintendo Account login URL doesn't copy properly via Heroku's web terminal, so make sure you use the listed `heroku run` command._

_If you've already got `splatnet2statink` fully configured elsewhere, you can upload its `config.txt` your application's Cloudcube instance instead of doing the configuration on Heroku. You can access Cloudcube by running `heroku addons:open cloudcube`. If you've done this correctly, you should see a `/config.txt` entry alongside (not in!) the `/public/` folder._

## Updates

This will need periodic updating to sync with [splatnet2statink](https://github.com/frozenpandaman/splatnet2statink).

The revision of the script is pinned in the `requirements.in` file, and once updated needs syncing with `requirements.txt` using `pip-compile` (available from `pip install pip-tools`).
