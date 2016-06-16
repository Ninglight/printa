#!/usr/bin/perl -w
use strict;
use Data::Dumper;
use DBI;
use Switch;


# Fonction de recuperation de la date de la veille
sub getToday {

	my @date = localtime(time());

	return ($date[3], $date[4]+1, $date[5]+1900);

}

# Fonction de recuperation de la date de la veille
sub getLastDay {

	# Le mois est code sur 0..11
	# L'annee demarre a 1900, donc on adapte
	my $secondes_par_jour = 60 * 60 * 24;
	my @date = localtime(time() - $secondes_par_jour);

	return ($date[3], $date[4]+1, $date[5]+1900);

}

# Fonction de separation des elements d'une date, avec retrait du time
sub getDate {
	my ($date) = @_;

	my @dateComplete = split (/ /,$date);
	my $dateOnly = $dateComplete[0];
	my @date = split ('/',$dateOnly);

	return ($date[0], $date[1], $date[2]);
}


# Fonction d'ouverture de fichier, avec le choix pour le type d'ouveture
sub openFile {
	my ($file, $handle) = @_;

	if (open(my $fh, $handle, $file)){

		return $fh;

	}
	else {

		return 0;

	}
}

# Fonction permettant de savoir si une ligne est un commentaire ou un espace
sub skipNoKeyword {
	my ($line) = @_;

	if (defined $line) {

		for (;;) {

			switch (substr($line, 0, 1)) {

				case " "	{ return; }
				case "\t"	{ return; }
				case "#"	{ return; }
				case "\n"	{ return; }
				case eof	{ return; }

				else {

					return $line;

				}

			}
		}
	}
	else {

		return;

	}
}

# Fonction lecture des lignes de configuration valide et synthétisation dans un array
sub readKeyword {
	my ($line) = @_;

	if (defined $line) {
		my @info = split (/:/,$line);
		$info[1] = substr $info[1], 1;
		chomp($info[1]);
		return @info;
	}
	else {

		return;

	}
}

# Fonction lecture des lignes des fichiers d'impression
sub readLine {
	my ($line) = @_;

	if (defined $line) {

		my @info = split (/,/,$line);
		my %infoline = ( 	"Date" => $info[0],
		"User" => $info[1],
		"Printer" => $info[2],
		"Quantity" => $info[3],
		"Color" => $info[4]);
		return %infoline;

	}
	else {

		return;

	}
}

# Fonction de fermeture de fichier
sub closeFile {
	my ($fh) = @_;

	close $fh;

}

# Fonction d'enregistrement des erreurs rencontrées (sauf si elles ne sont pas déjà présentes dans le fichier)
sub addFileErreur {
	my ($erreur) = @_;

	my $tmp = 1;
	my $fileerreur ="../PrtStats/Erreur/erreur.txt";

	my $fh = openFile($fileerreur, "+<");

	if ($fh){

		while (my $line = <$fh>){

			chomp $line;
			if ($line eq $erreur){

				$tmp = 0;
				return;

			}
		}
		if ($tmp){

			print( $fh $erreur);
			print( $fh "\n");

		}

		closeFile($fh);

	}
	else{

		return 0;

	}
}

# Fonction d'extraction du fichier de config dans un tableau de hachage
sub readConf {
	my ($file) = @_;

	my $fh = openFile($file, "<");

	if ($fh){

		my $compteur = 0;
		my $curseur;
		my %parameters;

		while (my $line = <$fh>)
		{

			if (skipNoKeyword($line)){

				my @info = readKeyword($line);
				$parameters{$info[0]} = $info[1];

			}

			$compteur++;

		}

		closeFile($fh);
		return %parameters;

	}
	else{

		return 0;

	}
}

1;
