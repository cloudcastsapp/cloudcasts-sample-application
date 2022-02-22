#!/usr/bin/env bash



# Production assets/dependencies

npm install

npm run production

composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev



# Generate a .env file

aws --region eu-central-1 ssm get-parameter \
     --with-decryption \
     --name /cloudcasts/staging/env \
     --output text \
     --query 'Parameter.Value' > .env


# Create our build artifact

git archive -o builds/cloudcasts.zip --worktree-attributes HEAD

zip -qur builds/cloudcasts.zip vendor

zip -qur builds/cloudcasts.zip public

zip -qur builds/cloudcasts.zip .env # Grab our testing .env file for now



# Upload artifact to s3

aws s3 cp builds/cloudcasts.zip s3://cloudcasts-$1-artifacts/"$CODEBUILD_RESOLVED_SOURCE_VERSION".zip
