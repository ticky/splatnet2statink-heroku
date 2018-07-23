# SplatNet 2 stats.ink on Heroku

[splatnet2statink](https://github.com/frozenpandaman/splatnet2statink), but running periodically via free Heroku dynos and free S3 storage

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

## Setup

Pick from either push-button or manual setup.

### Push-button

Push this button, and follow the prompts: [![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

### Manual

1. You'll need a Heroku account (with credit card entered, sadly), the Heroku CLI, and a local checkout of this repository.

1. Run these commands:
   ```bash
   heroku create # Create a Heroku application
   heroku addons:create cloudcube:free # Add Cloudcube (so   we can dump configuration in S3)
   heroku addons:create scheduler:standard # Add the Heroku   Scheduler (so we can sync periodically)
   git push heroku master # Push the codebase up to Heroku
   ```

### Configuration

1. Run `heroku addons:open scheduler` and create a schedule to run `./bin/update.sh` once an hour.

1. Go to [your stat.ink profile](https://stat.ink/profile) and copy your API token (you'll need it in the next step!).

1. To log in to stat.ink and your Nintendo account, you'll either need to configure `splatnet2statink` locally and upload its `config.txt` to the root of your Cloudcube, or use `heroku run ./bin/update.sh` and follow the prompts.

_It's worth noting that the Nintendo Account login URL doesn't copy properly via Heroku's web terminal, so make sure you use the listed `heroku run` command._

## Updates

This will need periodic updating to sync with [splatnet2statink](https://github.com/frozenpandaman/splatnet2statink). If the submodule gets out of date, you can cd into `splatnet2statink`, pull in the latest changes, commit and push to Heroku.
