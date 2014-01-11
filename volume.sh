#!/bin/sh

echo $(amixer sget Master | sed -n "$ p" | awk '{print $4}' | sed "s/[^0-9]//g")%
