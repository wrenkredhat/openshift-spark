#!/bin/bash

if [ -z $SIABNORMAL ]
then
  export SIABNORMAL=white-on-black
fi

if [ -z $SIABREVERSE ]
then
  export SIABREVERSE=black-on-white
fi

/usr/sbin/shellinaboxd -t -p 8080 --disable-peer-check -d \
  -s "/:developer:developer:/home/developer:/usr/bin/su developer" -u developer -g developer 2>&1

echo "---------- ERROR! ----------"
echo "---------- ERROR! ----------"
echo "---------- ERROR! ----------"
