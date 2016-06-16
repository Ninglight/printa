#!/usr/bin/perl -w
use strict;
use Data::Dumper;
use DBI;
use Encode;
use utf8;

# Fonction de connexion aux bases de donnees
sub connectDB {
	my (%parameters) = @_;

	my $sgbd = $parameters{sgbd};
	my $dbname = $parameters{dbname};
	my $host = $parameters{host};
	my $user = $parameters{user};
	my $password = $parameters{password};
	my $port = $parameters{port};

	my $dbh = DBI->connect( "DBI:$sgbd:database=$dbname;host=$host;port=$port",
		$user, $password, {
		RaiseError => 1
		}
	) or return;

	return $dbh;
}

# Fonction de deconnexion aux bases de donnees
sub disconnectDB {
	my ($connexion) = @_;

	$connexion->disconnect();

}

1;
