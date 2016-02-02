#!/usr/bin/perl -w
 
use strict;
 
my %files;
 
undef $/;
 
# The input file type is the type of the first prereq; this can be fragile if you have multiple make rules
my $inftype = $ARGV[0];
$inftype =~ s/.*\.//;
 
# Read files into file hash:
foreach my $fn (@ARGV){
	open F, $fn;
	$fn =~ /[^.]*$/;
	$files{$&} .= <F>;
}
 
# Process format file
$files{fmt} =~ s/^\s+//;
my (%spec, %com);
foreach (split /\n+/, $files{fmt}){
	next if /^#/;
 
	if (s/^!//){
		die ("Unrecognized format line $_") unless s/^\s*(\S+)\s+//;
		my $tag = $1;
		$spec{$tag}=$_;
		$spec{$tag} =~ s/\\n\b/\n/g;
		$spec{$tag} =~ s/\\t\b/\t/g;
	} else {
		die ("Unrecognized format line $_") unless s/^\s*(\S+)\s*//;
		$com{$1}=$_;
	}
}

$spec{PERC} = "\\%" unless defined $spec{PERC};
 
# Top of template file
my @tmp = split(/----------------------+\s+/, $files{tmp});
print $tmp[0] if defined $tmp[0];
 
# Split input file
$files{$inftype} =~ s/.*$spec{START}//s if defined $spec{START};
$files{$inftype} =~ s/$spec{END}.*//s if defined $spec{END};
my @tex;
if (defined $spec{SLIDESEP}){
	@tex = split (/$spec{SLIDESEP}/,$files{$inftype});
} else {
	@tex = ($files{$inftype});
}
 
## Process slides
foreach(@tex){
	my @slide;
	my $currlevel=0;
 
	#Slides that start with ! are not slides (allows cross-slide commands)
	#Disabled, instead use reserved word STARTSLIDE in command
 
	# Don't choke on non-blank blank lines
	s/\n[\s]+\n/\n\n/g;
 
	# What should our comment syntax be?
	s/^#+[ #][^\n]*\n//;
	s/\n#+[ #][^\n]*//g;
 
	my $first=1;
 
	# Split into paragraphs
	foreach (split(/\n{2,}/, $_)){
 
		# Leading newlines bad
		s/\n*//;
		next if /^$/;
 
		# Count $linelevel of this line, compare to global $currlevel
		my $linelevel=0;
 
		#Hot changes (where should these go?)
 
		# Underscores
		# Latex math Trick: EM does not span tab.
		# E.g. !EM \emph{%}
		if (defined $spec{EM}){
			my @em = split /%/, $spec{EM};
			s/_([A-Za-z0-9 .,;-]*)_/$em[0]$1$em[1]/g;
		}
 
		# Square brackets
		if (defined $spec{SQUARE}){
			my @em = split /%/, $spec{SQUARE};
			s/\[([^\]]*)]/$em[0]$1$em[1]/g;
		}
 
		# Double quotes
		if (defined $spec{QUOTE}){
			my @em = split /%/, $spec{QUOTE};
			s/"([^"]*)"/$em[0]$1$em[1]/g;
		}
 
		# Text following a |
		if (defined $spec{PIPE}){
			if (s/[|](.*)//s){
				my $pipe = $1;
				unless ($spec{PIPE} =~ /\bDEL\b/){
					my $pat = $spec{PIPE};
					$pat =~ s/%/$pipe/;
					$_ .= $pat;
				}
			}
		}

		s/^[*]/$spec{STAR}/ if defined $spec{STAR};
 
		# Find "command" word
		my ($lead, $head) = /(\s*)([\w*]*)/;
 
		# Look up commands
		my $pat = "";
		if (defined $com{$head}){
			$pat = $com{$head};
			s/\s*[\w*]+[ 	]*//;
		} elsif ($first and $head and defined $com{DEFHEAD}){
			$pat = $com{DEFHEAD};
		} elsif (defined $com{DEFCOMM}){
			$pat = $com{DEFCOMM};
		}
		$first=0 if $head;
 
		# Replace % with an illegal string (whether or not we're doing pattern processing)
		s/%/@#PERC/gs;
 
		# Replace lines by appropriate patterns
		if ($pat){
			s/^\s*//; # Lead stays with pattern, strip from string
			my $str = $_;
			$_ = $lead.$pat;
 
			#Expand escapes before pattern expansion
			s/\\n /\n/gs;
			s/\\n\b/\n/gs;
			s/\\t /\t/gs;
			s/\\t\b/\t/gs;
 
 
			while (/%/){
				# Replace %% with whole remaining string
				if (/^[^%]*%%/){
					s/%%/$str/g;
					$str = "";
				}
 
				# %+ uses, keeps whole remaining string
				elsif (/^[^%]*%[+]/){
					s/%[+]/$str/gs;
				}
 
				# %! eats whole remaining string
				elsif (/^[^%]*%!/){
					s/%!//gs;
					$str = "";
				}
 
				# %| gets next sentence (use | to avoid period)
				elsif (/^[^%]*%[|]/){
					$str =~ s/^([^|.!?]*[|.!?])\s*// or 
						die "%| doesn't match $str";
					my $p = $1;
					$p =~ s/[|]$//;
					s/%[|]/$p/;
				}
 
				# %_ gets current line (not required to exist)
				elsif (/^[^%]*%_/){
					$str =~ s/^([^\n]*)\n?//;
					my $p = $1;
					s/%_/$p/;
				}
 
				# %^ optionally takes next word
				elsif (/^[^%]*%\^/){
					$str =~ s/\s*(\S*)\s*//;
					my $p = $1;
					s/%\^/$p/;
				}
 
				# Otherwise, % requires next word
				else{
					$str =~ s/\s*([^\s|]+)\s*//
						or die "% doesn't match $str in $_\n (head $head)";
					my $p = $1;
					s/%/$p/;
				}
			}
			print STDERR "WARNING: orphan text $str\n"
				unless ($str =~ /^\s*$/) or (/NULLSLIDE/);
		}
 
		redo if  s/^(\s*)\^/$1/;
 
		# Hack (tex only, for now)
		s/@#PERC/$spec{PERC}/gs;
 
		# Leading tabs
		s/\s+$//;
		next if /^$/;
		if (defined $spec{TAB}){
			$linelevel++ while s/^$spec{TAB}//;
			while ($currlevel<$linelevel){
				push @slide, $spec{BIZ} if defined $spec{BIZ};
				$currlevel++;
				die ("Too many tabs ($linelevel > $currlevel) on line $_") 
					if $currlevel<$linelevel;
			}
		}
 
		while ($currlevel>$linelevel){
			push @slide, $spec{EIZ} if defined $spec{EIZ};
			$currlevel--;
		}
		s/^/$spec{ITEM} / unless $currlevel==0;
 
 		$_ = "\n\n$_" unless
			s/\bNOPAR\b//;
		push @slide, "$_" unless /^\s*$/;
	}
	# End of paragraph loop
 
	while ($currlevel>0){
		push @slide, $spec{EIZ} if defined $spec{EIZ};
		$currlevel--;
	}
 
	next if (@slide==0); # Don't print blank slide (if you can help it)
	my $slide = join ("", @slide);
 
 	# Reserved word NULLSLIDE disables the slide?
	next if $slide =~ /^\s*NULLSLIDE\b/;
	$slide =~ s/\bENDOFSLIDE\b.*//s;
 
	unless ($slide =~ s/\bNOFRAME\b//g){
		if (defined $spec{BSL}){
			$slide =~ s/^/\n$spec{BSL}\n/ unless $slide =~ s/SLIDESTART/\n$spec{BSL}\n/;
		}
		$slide .=  "\n$spec{ESL}\n" if defined $spec{ESL};
	}
 
	print "$slide";
}
 
# Bottom of template file
print "\n$tmp[1]" if defined $tmp[1];
