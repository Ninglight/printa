package Subroutine;
use strict;

sub getYearCounter {
	my ($date) = @_;

	my @info = split (/-/,$date);

	return $info[0];
}

sub getYearPrinting {
	my ($date) = @_;

	my @info = split (/ /,$date);
	my @info2 = split ('/',$info[0]);

	return $info2[2] ;
}

sub manageApostrophe {
	my ($name) = @_;

	my $c;
	my $tmp = $name;
	$name = "";

	if ($tmp =~ "'") {
		foreach $c (split //, $tmp) {
			if ($c eq "'") {
				$c = "''";
			}
			$name = $name . $c;
		}
	}

	return $name;
}

sub deleteApostrophe {
	my ($name) = @_;

	my $c;
	my $tmp = $name;
	$name = "";

	if ($tmp =~ "'") {
		foreach $c (split //, $tmp) {
			if ($c eq "'") {
				next;
			}
			$name = $name . $c;
		}
	}

	return $name;
}

sub getAcronym{
	my ($name) = @_;

	my @info = split (/ /,$name);

	$name = '00';

	if (scalar(@info) > 2) {

		foreach my $item (@info) {
   	 		$name = $name . substr($item,0,1);
   	 	}

	}
	else {

		foreach my $item (@info) {
   	 		$name = $name . substr($item,0,3);
   	 	}

	}

	$name = uc($name);

	return $name;

}

1;
