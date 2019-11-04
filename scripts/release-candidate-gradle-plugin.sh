#!/bin/bash

function show_banner()
{
    echo '.........................................................'
    echo '                                    __  __      _        ' 
    echo '     /\                            |  \/  |    | |       ' 
    echo '    /  \   _ __ _ __ _____      __ | \  / | ___| |_ __ _ ' 
    echo '   / /\ \ | `__| `__/ _ \ \ /\ / / | |\/| |/ _ \ __/ _` |' 
    echo '  / /  \ \| |  | | | (_) \ V  V /  | |  | |  __/ || (_| |' 
    echo ' /_/    \_\_|  |_|  \___/ \_/\_/   |_|  |_|\___|\__\__,_|'
    echo '.........................................................'
    echo '         - RELEASE CANDIDATE FOR GRADLE PLUGIN -'
    echo '.........................................................'
    echo ''
    echo ''
    echo '                      release/gradle-plugin'
    echo ''
    echo '                              ^'
    echo '                              | PR'
    echo '                              |'
    echo ''
    echo '    master  ------->  preparation-branch'
    echo ''
    echo ''
    echo ' When merging on release/gradle-plugin:'
    echo '   publication in Gradle Plugin Repository is triggered'
    echo ''
    echo '.........................................................'
    echo ''
}

function jump_to_master_and_pull()
{
    echo -e "\nJumping to master branch and pulling (it can take a few seconds)..."
    git checkout master
    if [[ $? -ne 0 ]]; then
        echo "Check the error and try again"
        exit $0
    fi
    git pull origin master
}

function ask_for_new_version()
{
    ACTUAL_VERSION=$(grep -e "^version = .*$" gradle-plugin/build.gradle | cut -d' ' -f3)
    echo -e "\n$ACTUAL_VERSION found!"
    read -p "What's the next release candidate? " EXPECTED_VERSION
    echo "Expected: $EXPECTED_VERSION"
}

function update_file()
{
    echo -e "\nUpdating the version in gradle-plugin/build.gradle ..."
    sed -i "s/version = $ACTUAL_VERSION/version = '$EXPECTED_VERSION'/g" gradle-plugin/build.gradle
}

function create_release_branch()
{
    echo -e "\nCreating a new branch ..."
    git checkout -b release/$EXPECTED_VERSION
    git add gradle-plugin/build.gradle
    git commit -m "Gradle Plugin: release candidate $EXPECTED_VERSION"
    git push origin release/$EXPECTED_VERSION
}

show_banner
cd $(dirname $0)
cd ..

jump_to_master_and_pull
ask_for_new_version
update_file
create_release_branch


echo -e "\nDone!"
echo -e "Next step:\n"
echo " - Pull request from release/$EXPECTED_VERSION to release/gradle-plugin"
