#!/usr/bin/perl -w
use strict;

require "controller/environment.pl";
require "controller/class.pl";
require "model/database.pl";

use Data::Dumper;
use DBI;
use Term::UI;
use Term::ReadLine;


# Recuperation de la date de la veille
my ($lastday, $lastmonth, $lastyear) = getLastDay();
my $yesterday = $lastyear.'-'.$lastmonth.'-'.$lastday;

#my $lastday = 12;
#my $lastmonth = 02;
#my $lastyear = 2016;

#my $yesterday = $lastyear.'-'.$lastmonth.'-'.$lastday;

# Recuperation de la date du jour
my ($day, $month, $year) = getToday();
my $today = $year.'-'.$month.'-'.$day;


print "**---------- Bienvenue au sein du programme permettant l'obtention des donnees pour l'application Printers --------**\n";
print "**                                                                                                                 **\n";
print "**                                   Recuperation pour la date du $lastday - $lastmonth - $lastyear                                    **\n";
print "**                                                                                                                 **\n";
print "**                                             Ajout a la base : Printers                                          **\n";
print "**                                                                                                                 **\n";
print "**-----------------------------------------------------------------------------------------------------------------**\n";


# Connexion a la base via les fichiers de configuration
my %parametersPrinters = readConf("/usr/local/test/prtstats/conf/printers.conf");
my ($dbhPrinters) = connectDB(%parametersPrinters);

if ($dbhPrinters) {

	print "**------------------------------------- Connexion a la base 'Printers' effectuee ----------------------------------**\n";

	my %parametersAnnuaire = readConf("/usr/local/test/prtstats/conf/annuaire.conf");
	my ($dbhAnnuaire) = connectDB(%parametersAnnuaire);

	if ($dbhAnnuaire) {

		print "**------------------------------------- Connexion a la base 'Annuaire' effectuee ----------------------------------**\n";

		my $file = "";

		for (my $i = 1; $i <= 3; $i++) {

			# On recupere le nom des fichiers a traiter
			$file = "/mnt/imp-${i}/imp-${i}_${lastday}-${lastmonth}-${lastyear}.csv";

			my $fh = openFile($file, '<');

			if($fh) {

				# Boucle sur chaque ligne
				while (my $line = <$fh>) {

					my %dataline = readLine($line);

					#On saute la première ligne
					if ($dataline{Date} ne "Date") {

						my $user = valideUser($dbhAnnuaire, $dbhPrinters, $dataline{User}, $today, $yesterday);

						if ($user) {

							my $printer = addPrinter($dbhPrinters, $dataline{Printer});

							if ($printer) {

								addPrinting($dbhPrinters, $user, $printer, %dataline);

							}

						}

					}

				}

				closeFile($fh);

			}
			else {

				print "Impossible d'ouvrir $file: $!\n";

			}

		}

		disconnectDB($dbhAnnuaire);

	} else {

		print "Connection impossible a la base de donnees Annuaire !\n ";

	}

	exit;


	my $i = 0;

	#Recuperation de toutes les imprimantes present dans la base Printers
	my $printer = new Printers(0,0,0,0,0);
	my @printers = get Printers($dbhPrinters, $printer);

	# Boucle sur chaque imprimante
	while ($printers[$i]) {

		my $model = addModel($dbhPrinters, $printers[$i], $today, $lastday);

		if ($model) {

			updatePrinter($dbhPrinters, $printers[$i], $model, $today);

			addCounter($dbhPrinters, $printers[$i], $model, $today);

		}

		$i++;
	}

	disconnectDB($dbhPrinters);

	print "**------------------------------- Fermeture du programme pour l'application Printers ------------------------------**\n";

	exit;

} else {

	print "Connection impossible a la base de donnees Printers !\n ";

	exit;

}

<>;
