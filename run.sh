#!/bin/bash

# THe issue is that the Maven Release Plugin insists on creating a tag, and git-flow also wants to create a tag.
# Secondly, the Maven Release Plugin updates the version number to the next SNAPSHOT release before you can
# merge the changes into master, so you end with the SNAPSHOT version number in master, and this is highly undesired.
# This script solves this by doing changes locally, only pushing at the end.
# All git commands are fully automated, without requiring any user input.
# See the required configuration options for the Maven Release Plugin to avoid unwanted pushs.

# Based on the excellent information found here: http://vincent.demeester.fr/2012/07/maven-release-gitflow/

# CHANGE THESE BEFORE RUNNING THE SCRIPT!

# The next development version
#developmentVersion=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version | grep -v '\[')

# The version to be released
#releaseVersion=${developmentVersion%-SNAPSHOT}

developmentVersion=1.0.11-SNAPSHOT
releaseVersion=1.0.10


# Start the release by creating a new release branch
git checkout -b release/$releaseVersion development

# The Maven release
mvn --batch-mode release:prepare release:perform  -DreleaseVersion=$releaseVersion -DdevelopmentVersion=$developmentVersion

# Clean up and finish
# get back to the development branch
git checkout development

# merge the version back into development
git merge --no-ff -m "$scmCommentPrefix Merge release/$releaseVersion into development" release/$releaseVersion
# go to the master branch
git checkout master
# merge the version back into master but use the tagged version instead of the release/$releaseVersion HEAD
git merge --no-ff -m "$scmCommentPrefix Merge previous version into master to avoid the increased version number" release/$releaseVersion~1
# Removing the release branch
git branch -D release/$releaseVersion
# Get back on the development branch
git checkout development
# Finally push everything
git push --all && git push --tags