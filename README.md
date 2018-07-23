# SplatNet 2 stats.ink on Heroku

[splatnet2statink](https://github.com/frozenpandaman/splatnet2statink), but running periodically via free Heroku dynos and free S3 storage

## Setup

You'll need a Heroku account (with credit card entered, sadly), the Heroku CLI, and a local checkout of this repository.

```bash
heroku create # Create a Heroku application
git push heroku master # Push the codebase up to Heroku
heroku addons:create cloudcube:free # Add Cloudcube (so we can dump configuration in S3)
heroku addons:create scheduler:standard # Add the Heroku Scheduler (so we can sync periodically)
heroku addons:open scheduler # Open the scheduler
```

From the scheduler, you'll want to create a schedule to run `./bin/update.sh` periodically. I've set it to once an hour.

For configuration, you'll either need to configure `splatnet2statink` locally and upload its `config.txt` to the root of your Cloudcube, or use `heroku run ./bin/update.sh` and follow the prompts.

_It's worth noting that the Nintendo Account login URL doesn't copy properly via Heroku's web terminal, so make sure you use `heroku run` instead._

## Updates

This will need periodic updating to sync with [splatnet2statink](https://github.com/frozenpandaman/splatnet2statink). If the submodule gets out of date, you can cd into `splatnet2statink`, pull in the latest changes, commit and push to Heroku.
