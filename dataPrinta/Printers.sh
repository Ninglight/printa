#!/bin/bash

PATH=$PATH:/usr/local/test/prtstats
export PATH

/usr/bin/perl -I/usr/local/test/prtstats -I/usr/local/test/prtstats/model/class/annuaire -I/usr/local/test/prtstats/model/class/printers /usr/local/test/prtstats/Printers.pl

