#!/bin/bash

# Fetch domains
echo $(psadmin -c list) > domains_app
echo $(psadmin -p list) > domains_prcs
echo $(psadmin -w list) > domains_web