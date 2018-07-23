# SplatNet 2 stats.ink on Heroku

[splatnet2statink](https://github.com/frozenpandaman/splatnet2statink), but running periodically on Heroku

## Setup

You'll need a Heroku account, the Heroku CLI, and a local checkout of this repository.

```bash
heroku create # Create a Heroku application
heroku addons:create cloudcube:free # Add Cloudcube (so we can dump configuration in S3)
heroku addons:create scheduler:standard # Add the Heroku Scheduler (so we can sync periodically)
heroku addons:open scheduler # Open the scheduler
```

From the scheduler, you'll want to create a schedule to run `./bin/update.sh` periodically. I've set it to once an hour.

For configuration, you'll either need to configure splatnet2statink locally and upload its `config.txt` to the root of your Cloudcube, or use `heroku run ./bin/update.sh` and follow the prompts.