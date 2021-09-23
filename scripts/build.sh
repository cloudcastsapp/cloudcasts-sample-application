#!/usr/bin/env bash

DO_BUILD="nah"


if [[ "$CODEBUILD_WEBHOOK_TRIGGER" == "branch/main" ]]; then
    DO_BUILD="yes"
fi

if [[ "$CODEBUILD_WEBHOOK_TRIGGER" == "tag/"* ]]; then
    DO_BUILD="yes"
fi


if [[ "$DO_BUILD" == "yes" ]]; then
    # Production assets/dependencies
    npm install
    npm run production
    composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev

    # Create our build artifact
    git archive -o builds/cloudcasts.zip --worktree-attributes HEAD
    zip -qur builds/cloudcasts.zip vendor
    zip -qur builds/cloudcasts.zip public

    # Upload artifact to s3
    aws s3 cp builds/cloudcasts.zip s3://cloudcasts-artifacts/$CODEBUILD_RESOLVED_SOURCE_VERSION.zip
fi
