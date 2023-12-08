#!/bin/bash

# Script for building RocksDB, Speicher, Tweezer (your choice!)
# Make sure to run in directory where tweezer directory exists

# cd into Tweezer base directory
cd tweezer

i=0
while [[ $i -le 10 ]] ; do
    # Prompt user for which system(s) to build
    echo -e "\nWhich system do you wish to build?\nPlease enter one of the following: ROCKSDB, SPEICHER/TWEEZER, or BOTH"
    read to_build
    
    case $to_build in
        "ROCKSDB")
            # Build only RocksDB
            script/compile_unmodified.sh
            break
            ;;
        "SPEICHER/TWEEZER")
            # Build only Speicher and Tweezer
            script/compile.sh
            break
            ;;
        "BOTH")
            # Build Both
            script/compile_unmodified.sh
            script/compile.sh
            break
            ;;
        *)
            # Everything else, invalid input :(
            echo -e "\nPlease choose a valid option!\n"
            ;;
    esac
done

while [[ $i -le 10 ]] ; do
    # Prompt user for running for testing or not
    echo -e "\nFinished building $to_build!\nWould you like to run the system(s) for testing (y/n)?"
    read test_flag
    
    if [ $test_flag = "y" -o $test_flag = "Y" ]; then
        # Run for testing
        # Generate tmpfs for untrusted memory
        cd script
        sudo ./generate_tmpfs.sh
        # Run test Python script
        cd ..
        cd test 
        python3 csv-to-run.py
        # Delete tmpfs
        cd ..
        cd script
        sudo ./delete_tmpfs.sh
        echo -e "\nSuccessfully finished running test script!"
        break
    elif [ $test_flag = "n" -o $test_flag = "N" ]; then
        # Do not run for script
        break
    else
        # Invalid input :(
        echo -e "\nPlease choose a valid input!\n"
    fi
done

echo -e "\nSuccessfully finished building $to_build!"
