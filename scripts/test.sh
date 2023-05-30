#!/bin/bash

echo ">>>>>> test.sh: run tests"
npm run test 

echo ">>>>>> test.sh: make coverage report to be UI for server"
rm ./public/*
cp -r ./coverage/lcov-report/* ./public/
rm -r ./public/*.png