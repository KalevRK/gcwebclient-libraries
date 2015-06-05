new_version=$1

function showStatus {
  printf "\n$1\n"  
}

function showBanner {
  printf "\n###################################\n"
  echo $1
  echo "###################################"
}

function versionCheck {
  showStatus "Checking for version..."
  if [ ! $new_version ]; then
    showBanner "FATAL:  Need to supply new version."
    exit 1
  fi
}

function executeTask {
  showStatus "Starting $1..."
  $1
  exitIfError "$1 failed!"
  showBanner "$1 completed!"
}

function cloneRelease {
  showStatus "Grabbing current release..."
  mkdir release-tmp
  git clone -b release git@github.com:opentable/gcwebclient-libraries.git release-tmp
  exitIfError "Repo not retrieved."
  showBanner "Cloning successful!"
}

function updateRelease {  
  showStatus "Updating files..."
  rm -rf release-tmp/*
  cp -r dist/ release-tmp/
  cp bower.json release-tmp/
}

function exitIfError {
  if [ ! $? == "0" ]; then
    showBanner "FATAL: $1"
    cleanUp
    exit 1
  fi
}

function commitAndPush {
  git add --all
  git commit -m "Updated to version $new_version"

  showStatus "Pushing to remote release branch..."
  git push --force origin release
  exitIfError "Push to release branch failed."
  showBanner "Push successful!"
}

function pushTags {
  printf "\nTagging $new_version...\n"
  git tag $new_version
  exitIfError "Tag could not be created."

  printf "\nPushing $new_version tag...\n"
  git push origin $new_version
  showBanner "Tagging successful!"
}

function cleanUp {
  if [ ! -d release-tmp ]
    then
      cd ..
  fi
  rm -rf release-tmp
  git checkout master
}

versionCheck

executeTask "npm install"
executeTask "bower install"
executeTask "gulp build"

cloneRelease
updateRelease

cd release-tmp
commitAndPush
pushTags
cd ..

cleanUp
