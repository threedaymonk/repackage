#!/bin/bash

rm $( \
  comm -23 <(realpath debs/*.deb | sort) \
    <((realpath debs/*-latest.deb; readlink -f debs/*-latest.deb) | sort) \
)
