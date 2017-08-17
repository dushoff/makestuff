#!/usr/bin/perl -w

use strict;

while(<>){
	s/PAUSE.*/PAUSE */;
	s/\\pause//;
	print;
}

