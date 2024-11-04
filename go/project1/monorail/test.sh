#!/bin/bash

# Run the previously compiled test binary. While we could parameterize
# this script with a command definition in Monorail.json, as the 
# rust workspace members do, we're keeping this simple as an example.
../bin/project1.test
