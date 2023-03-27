#!/bin/bash

py_version=`python3 -V 2>&1|awk '{print $2}'|awk -F '.' '{print $1$2}'`
if [ "$py_version" -lt "39" ];then
    echo "version: "$py_version
    
fi

echo $py_version