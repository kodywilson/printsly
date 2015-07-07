# printsly
Printer provisioning software

Currently reads spreadsheets filled with printer information and then runs the lpadmin commands to add each printer to CUPS (Common Unix Printing System).

You can run in either an interactive menu driven mode or batch mode where you pass two parameters (arguments), the location of a directory with spreadsheets to process and a directory to move processed spreadsheets.

The name printsly was selected to keep the application generic enough in case support for other printing systems is eventually added.

# Scout Badges!
[![Gem Version](https://badge.fury.io/rb/printsly.svg)](http://badge.fury.io/rb/printsly)
[![Build Status](https://travis-ci.org/kodywilson/printsly.svg?branch=master)](https://travis-ci.org/kodywilson/printsly)
