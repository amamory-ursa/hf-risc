#!/bin/bash

vcover report -html -htmldir coverage -verbose -threshL 50 -threshH 90 coverage.ucdb
