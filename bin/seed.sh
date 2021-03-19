#!/bin/bash

aws dynamodb batch-write-item --request-items file://data/DuClass.json

read -p "Database seeded."