#!/bin/sh
echo "Checkout done"
cd '${WORKSPACE}\releaseparent'
mvn validate
