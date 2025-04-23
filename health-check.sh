#!/bin/bash

touch /health-check.failed

echo "health check not configured for odoo" && exit 1
pgrep odoo || exit 1

# all passed
# push result to webhook

rm /health-check.failed
