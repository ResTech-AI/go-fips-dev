#!/usr/bin/env bash
set -e
export GOROOT=/usr/local/go 
export PATH="${GOROOT}/bin:${HOME}/go/bin:$PATH"
go version
exec nohup /bin/bash -c "while :; do sleep 1; done"
