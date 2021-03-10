#!/bin/bash

echo "Starting"

powershell Compress-Archive index.js ttr.zip

read -p "Did it work?"