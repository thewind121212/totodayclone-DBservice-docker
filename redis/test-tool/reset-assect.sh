#!/bin/bash

master_directory="/home/linh/Project-assets/totodayshop/redis/master/"
replicandir="/home/linh/Project-assets/totodayshop/redis/repl/"
sentineldir="/home/linh/Project-assets/totodayshop/redis/sentinel/"

echo "begin clean master"
# Check if the master directory exists


if [ -d "$master_directory" ]; then
    # Remove contents of both 'conf' and 'dump' folders
    conf_directory="$master_directory/conf"
    dump_directory="$master_directory/dump"

    if [ -d "$conf_directory" ] && [ -d "$dump_directory" ]; then
        sudo rm -rf "$conf_directory"/* "$dump_directory"/*
        echo "Contents of $conf_directory and $dump_directory have been removed."
    else
        echo "One or more subdirectories do not exist."
    fi
else
    echo "Directory $master_directory does not exist."
fi

echo "begin clean repl setting"

# Check if the main directory exists
if [ -d "$replicandir" ]; then
    # Array of replica directories
    replicas=("repl1" "repl2" "repl3")

    # Iterate over replica directories
    for replica in "${replicas[@]}"; do
        replica_directory="$replicandir/$replica"

        # Check if the replica directory exists
        if [ -d "$replica_directory" ]; then
            # Remove contents of 'conf' and 'dump' folders
            conf_directory="$replica_directory/conf"
            dump_directory="$replica_directory/dump"

            if [ -d "$conf_directory" ] && [ -d "$dump_directory" ]; then
                sudo rm -rf "$conf_directory"/* "$dump_directory"/*
                echo "Contents of $conf_directory and $dump_directory have been removed in $replica."
            else
                echo "One or more subdirectories do not exist in $replica."
            fi
        else
            echo "Directory $replica_directory does not exist."
        fi
    done
else
    echo "Main directory $replicandir does not exist."
fi


echo "begin clean sentinel setting"

# Check if the main directory exists
if [ -d "$sentineldir" ]; then
    # Array of replica directories
    sentinels=("sen1" "sen2" "sen3" "sen4" "sen5")

    # Iterate over replica directories
    for sentinel in "${sentinels[@]}"; do
        sentinel_directory="$sentineldir/$sentinel"

        # Check if the replica directory exists
        if [ -d "$sentinel_directory" ]; then
          sudo rm -rf "$sentinel_directory"/* 
          echo "Contents of $sentinel_directory have been removed."
        else
            echo "Directory $sentinel_directory does not exist."
        fi
    done
else
    echo "Main directory $sentineldir does not exist."
fi


echo "begin write file to test and run"

echo "begin write to master"



if [ -d "$master_directory" ]; then
    # Remove contents of both 'conf' and 'dump' folders
    conf_directory="$master_directory/conf"

    if [ -d "$conf_directory" ] ; then
        cp -f ../redis.conf ../users.acl "$conf_directory" 
        echo "Contents of $conf_directory have been writen."
    else
        echo "One or more subdirectories do not exist."
    fi
else
    echo "Directory $master_directory does not exist."
fi

echo "begin write for replica"


if [ -d "$replicandir" ]; then
    # Array of replica directories
    replicas=("repl1" "repl2" "repl3")

    # Iterate over replica directories
    for replica in "${replicas[@]}"; do
        replica_directory="$replicandir/$replica"

        # Check if the replica directory exists
        if [ -d "$replica_directory" ]; then
            # Remove contents of 'conf' and 'dump' folders
            conf_directory="$replica_directory/conf"

            if [ -d "$conf_directory" ]; then

                cp -f ../replica-sentinel/redis.conf "$conf_directory"/ 
                cp -f ../users.acl "$conf_directory"/ 
                echo "Contents of $conf_directory and have been writen in $replica."
            else
                echo "One or more subdirectories do not exist in $replica."
            fi
        else
            echo "Directory $replica_directory does not exist."
        fi
    done
else
    echo "Main directory $replicandir does not exist."
fi

echo "begin write to sentinel"

if [ -d "$sentineldir" ]; then
    # Array of replica directories
    sentinels=("sen1" "sen2" "sen3" "sen4" "sen5")

    # Iterate over replica directories
    for sentinel in "${sentinels[@]}"; do
        sentinel_directory="$sentineldir/$sentinel"

        # Check if the replica directory exists
        if [ -d "$sentinel_directory" ]; then
          cp ../replica-sentinel/sentinel.conf  "$sentinel_directory"/
          cp ../replica-sentinel/sentinel-users.acl "$sentinel_directory"/
          echo "Contents of $sentinel_directory have been writen."
        else
            echo "Directory $sentinel_directory does not exist."
        fi
    done
else
    echo "Main directory $sentineldir does not exist."
fi


sudo chmod -R 777 /home/linh/Project-assets/totodayshop/redis/
