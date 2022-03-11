#!/bin/bash
set -e

rails db:migrate

exec "$@"
