#!/usr/bin/perl -w
use strict;

require "model/class/printers/Actions.pm";
require "model/class/printers/Colors.pm";
require "model/class/printers/Commands.pm";
require "model/class/printers/Commands_Default.pm";
require "model/class/printers/Costs.pm";
require "model/class/printers/Counter.pm";
require "model/class/printers/Errors.pm";
require "model/class/printers/Formats.pm";
require "model/class/printers/Models_Printers.pm";
require "model/class/printers/Models.pm";
require "model/class/printers/OID.pm";
require "model/class/printers/Pages.pm";
require "model/class/printers/Printers.pm";
require "model/class/printers/Printing.pm";
require "model/class/printers/Sides.pm";
require "model/class/printers/Statuts.pm";
require "model/class/printers/Structures.pm";
require "model/class/printers/Tables.pm";
require "model/class/printers/Trademarks.pm";
require "model/class/printers/Types_Errors.pm";
require "model/class/printers/Types.pm";
require "model/class/printers/Users_Structures.pm";
require "model/class/printers/Users.pm";

require "model/class/annuaire/Annuaire_Droits.pm";
require "model/class/annuaire/Annuaire_Utilisateur.pm";
require "model/class/annuaire/Annuaire_UtilStruct.pm";
require "model/class/annuaire/Annuaire_Structures.pm";

require "model/database.pl";
require "controller/environment.pl";
require "controller/snmp.pl";


use Data::Dumper;
use DBI;

use Net::Ping;
use IO::Socket;
use Net::Nslookup;


# Fonction de validation sur les informations utilisateurs
sub valideUser {
	my ($dbhAnnuaire, $dbhPrinters, $login, $today, $lastday) = @_;

	my ($user, $existUser);

	# On recupere le matricule a partir du login dans la base Annuaire, dans la table Droits
	my $droit_Annuaire = new Annuaire_Droits($login, 0);
	$droit_Annuaire = get Annuaire_Droits($dbhAnnuaire, $droit_Annuaire);

	if($droit_Annuaire) {

		#On recherche l'utilisateur dans la base Annuaire
		my $user_Annuaire = new Annuaire_Utilisateur($droit_Annuaire->getMatricule(), 0, 0);
		$user_Annuaire = get Annuaire_Utilisateur($dbhAnnuaire, $user_Annuaire);

		if($user_Annuaire) {

			#On recherche le lien entre l'utilisateur et sa structure dans la base Annuaire
			my $user_structure_Annuaire = new Annuaire_UtilStruct($droit_Annuaire->getMatricule(), 0);
			$user_structure_Annuaire = get Annuaire_UtilStruct($dbhAnnuaire, $user_structure_Annuaire);

			if($user_structure_Annuaire) {

				#On recherche la structure dans la base Annuaire
				my $structure_Annuaire = new Annuaire_Structures($user_structure_Annuaire->getStructure(), 0, 0, 0, 0);
				$structure_Annuaire = get Annuaire_Structures($dbhAnnuaire, $structure_Annuaire);

				if($structure_Annuaire) {

					my $structure;

					if(substr($structure_Annuaire->getSigle(),0,2) ne '00') {

						#On recherche la structure dans la base Printers en fonction du Sigle
						$structure = new Structures(0, $structure_Annuaire->getSigle(), 0, 0, 0);
						$structure = get Structures($dbhPrinters, $structure);

					}
					else {

						#On recherche la structure dans la base Printers en fonction du Liblong
						$structure = new Structures(0, 0, $structure_Annuaire->getLiblong(), 0, 0);
						$structure = get Structures($dbhPrinters, $structure);

					}

					#Si la structure existe : on verifie qu'il a bien conservé les informations d'origine, celles de la base Annuaire
					if ($structure) {

						my $structure_param = new Structures($structure_Annuaire->getId(), $structure_Annuaire->getSigle(), $structure_Annuaire->getLiblong(), $structure_Annuaire->getType(), $structure_Annuaire->getId_Parent());
						updateStructure($dbhPrinters, $structure_param, $structure);

					}
					#Sinon la structure n'existe pas dans la base : on l'insere
					else {

						$structure = addStructure($dbhAnnuaire, $dbhPrinters, $structure_Annuaire);

					}

					#On recherche l'utilisateur dans la base Printers
					$user = new Users(0, $user_Annuaire->getMatricule(), 0, 0, 0);
					$user = get Users($dbhPrinters, $user);

					#Si l'utilisateur existe : on verifie qu'il a bien conservé les informations d'origine, celles de la base Annuaire
					if($user) {

						updateUser($dbhPrinters, $user_Annuaire, $user, $login);

						#On recherche le lien entre l'utilisateur et sa structure dans la base Printers
						my $user_structure = new Users_Structures($user->getId(), $structure->getId(), 0, 0);
						$user_structure = get Users_Structures($dbhPrinters, $user_structure);

						#Si le lien entre l'utilisateur existe : on verifie qu'il a bien conservé les informations d'origine, celles de la base Annuaire
						if($user_structure) {

							updateUser_Structure($dbhPrinters, $user, $structure, $user_structure, $today, $lastday);

						}
						#Sinon le lien entre l'utilisateur n'existe pas dans la base : on l'insere
						else {

							addUser_Structure($dbhPrinters, $user, $structure, $today);

						}

					}
					#Sinon l'utilisateur n'existe pas dans la base : on l'insere
					else {

						addUser($dbhPrinters, $user_Annuaire, $login, $structure, $today);

					}

					#On recherche, de nouveau, l'utilisateur dans la base Printers
					$user = new Users(0, $user_Annuaire->getMatricule(), 0, 0, 0);
					$user = get Users($dbhPrinters, $user);

					return $user;

			} else {

				addError($dbhPrinters, "Database", "Récupération", "Structures", "id", $user_structure_Annuaire->getStructure(), $today);

				return;

			}

		} else {

			#On recherche si l'utilisateur n'est pas créé dans la base Printers
			$user = new Users(0, $user_Annuaire->getMatricule(), $login, $user_Annuaire->getNom(), $user_Annuaire->getPrenom());
			$existUser = get Users($dbhPrinters, $user);

			if(!$existUser){

				#Insertion dans la base Printers
				create Users($dbhPrinters, $user);

				#Ajout d'une erreur de manière à prevenir qu'il existe un utilisateur non présent dans la base Tribu
				addError($dbhPrinters, "Database", "Récupération", "UtilStruct", "matricule", $droit_Annuaire->getMatricule(), $today);

				#On recherche, l'utilisateur fraichement créé dans la base Printers
				$user = get Users($dbhPrinters, $user);

				return $user;

			}
			else {

				return $existUser;

			}


			return;

		}

	} else {

		#On recherche si l'utilisateur n'est pas créé dans la base Printers
		$user = new Users(0, $droit_Annuaire->getMatricule(), $login, 0, 0);
		$existUser = get Users($dbhPrinters, $user);

		if(!$existUser){

			#Insertion dans la base Printers
			create Users($dbhPrinters, $user);

			#Ajout d'une erreur de manière à prevenir qu'il existe un utilisateur non présent dans la base Tribu
			addError($dbhPrinters, "Database", "Récupération", "Utilisateur", "matricule", $droit_Annuaire->getMatricule(), $today);

			#On recherche, l'utilisateur fraichement créé dans la base Printers
			$user = get Users($dbhPrinters, $user);

			return $user;

		}
		else {

			return $existUser;

		}


	}

} else {

	#On recherche si l'utilisateur n'est pas créé dans la base Printers
	$user = new Users(0, 0, $login, 0, 0);
	$existUser = get Users($dbhPrinters, $user);

	if(!$existUser){

		#Génération du num unique
		$user = getIncrement Users($dbhPrinters, $user);

		#Insertion dans la base Printers
		create Users($dbhPrinters, $user);

		#Ajout d'une erreur de manière à prevenir qu'il existe un utilisateur non présent dans la base Tribu
		addError($dbhPrinters, "Database", "Récupération", "Droits", "login", $login, $today);

		#On recherche, l'utilisateur fraichement créé dans la base Printers
		$user = get Users($dbhPrinters, $user);

		return $user;

	}
	else {

		return $existUser;

	}

}

}

sub addUser {
	my ($dbhPrinters, $user_Annuaire, $login, $structure, $today) = @_;

	my $user = new Users(0, $user_Annuaire->getMatricule(), $login, $user_Annuaire->getNom(), $user_Annuaire->getPrenom());
	create Users($dbhPrinters, $user);

	#On récupére l'utilisateur fraichement créé
	$user = get Users($dbhPrinters, $user);

	my $user_structure = new Users_Structures($user->getId(), $structure->getId(), $today, 0);
	create Users_Structures($dbhPrinters, $user_structure);

	return;

}

sub updateUser {
	my ($dbhPrinters, $user_Annuaire, $user, $login) = @_;

	my $newuser;

	#On regarde si il n'a pas été créer avant avec un Num généré, dans ce cas, on lui affecte le nouveau de la base Tribu
	if($user->getNum() >= 790000 && $user->getNum() <= 799999) {

		$newuser = new Users($user->getId(), $user_Annuaire->getMatricule(), $login, $user_Annuaire->getNom(), $user_Annuaire->getPrenom());
		update Users($dbhPrinters,$newuser);

	}


	# Si le nom ou prenom ont change, on les modifie
	if(($user->getLogin() ne $login) || ($user->getFirst_Name() ne $user_Annuaire->getPrenom()) || ($user->getName() ne $user_Annuaire->getNom())) {

		$newuser = new Users(0, $user_Annuaire->getMatricule(), $login, $user_Annuaire->getNom(), $user_Annuaire->getPrenom());
		update Users($dbhPrinters,$newuser);

	}

	return;

}

sub addUser_Structure {
	my ($dbhPrinters, $user, $structure, $today) = @_;

	my $user_structure = new Users_Structures($user->getId(), $structure->getId(), $today, 0);
	create Users_Structures($dbhPrinters, $user_structure);

	return;

}

sub updateUser_Structure {
	my ($dbhPrinters, $user, $structure, $user_structure, $today, $lastday) = @_;

	if(($user->getId() ne $user_structure->getId_User()) || ($structure->getId() ne $user_structure->getId_Structure())) {

		my $user_structure = new Users_Structures($user->getNum(), $structure->getId(), 0, $lastday);
		update Users_Structures($dbhPrinters, $user_structure);

		$user_structure = new Users_Structures($user->getNum(), $structure->getId(), $today, 0);
		create Users_Structures($dbhPrinters, $user_structure);

	}

	return;

}

sub addStructure {
	my ($dbhAnnuaire, $dbhPrinters, $structure_Annuaire) = @_;

	my $structure;

	# On test si la structure parent est dans la base Printers
	my $structure_parent = new Structures($structure_Annuaire->getId_Parent(),0,0,0,0);
	$structure_parent = get Structures($dbhPrinters, $structure_parent);

	if (!$structure_parent){

		my @structures;

		#Enregistrement dans la liste de hash de la première Structure
		push @structures, { id => $structure_Annuaire->getId(), acronym => $structure_Annuaire->getSigle(), name => $structure_Annuaire->getLiblong(), type => $structure_Annuaire->getType(), id_structure => $structure_Annuaire->getId_Parent()};

		my $i = 1;

		#On boucle jusqu'à ce que la structure parent soit égale à 0, cela signifie que nous sommes tout en haut de l'arboresence
		#Obtention d'une liste de hash avec toutes les infos des structures parentes
		while ($structures[$i-1]{id_structure} ne 0) {

			#On recupère la structure parent existante dans la base Annuaire
			my $structure_Annuaire = new Annuaire_Structures($structures[$i-1]{id_structure},0,0,0,0);
			$structure_Annuaire = get Annuaire_Structures($dbhAnnuaire, $structure_Annuaire);

			push @structures, { id => $structure_Annuaire->getId(), acronym => $structure_Annuaire->getSigle(), name => $structure_Annuaire->getLiblong(), type => $structure_Annuaire->getType(), id_structure => $structure_Annuaire->getId_Parent()};

			$i++;

		}

		while ($i ne 0) {

			$i--;

			my $structure_test = new Structures($structures[$i]{id},0,0,0,0);
			$structure_test = get Structures($dbhPrinters, $structure_test);

			if (!$structure_test) {

				$structure = new Structures($structures[$i]{id},$structures[$i]{acronym},$structures[$i]{name},$structures[$i]{type},$structures[$i]{id_structure});
				create Structures($dbhPrinters, $structure);

			}
			else {

				$structure = new Structures($structures[$i]{id},$structures[$i]{acronym},$structures[$i]{name},$structures[$i]{type},$structures[$i]{id_structure});
				updateStructure($dbhPrinters, $structure, $structure_test);

			}

		}

	}
	else {

		$structure = new Structures($structure_Annuaire->getId(),$structure_Annuaire->getSigle(),$structure_Annuaire->getLiblong(),$structure_Annuaire->getType(),$structure_Annuaire->getId_Parent());
		$structure_exist = get Structures($dbhPrinters, $structure);

		if (!$structure_exist) {

			create Structures($dbhPrinters, $structure);

		}
		else {

			updateStructure($dbhPrinters, $structure, $structure_exist);

	}

	return $structure;

}

sub updateStructure {
	my ($dbhPrinters, $structure1, $structure2) = @_;
	#structure1 = Annuaire
	#structure2 = Printers

	my $structure_update;

	if ($structure1->getName() ne $structure2->getName() || $structure1->getType() ne $structure2->getType()) {

		$structure_update = new Structures($structure2->getId(), $structure1->getAcronym(),$structure1->getName(), $structure1->getType(), 0);
		update Structures($dbhPrinters, $structure_update);

	}

	if ($structure1->getId_Structure() || $structure2->getId_Structure()){

		if ($structure1->getId_Structure() eq 0) {

			return;

		}

		if ($structure1->getId_Structure() ne $structure2->getId_Structure()){

			$structure_update = new Structures($structure2->getId(), $structure1->getAcronym(), 0, 0, $structure1->getId_Structure());
			update Structures($dbhPrinters, $structure_update);

		}

	}

}

sub addError {
	my ($dbhPrinters, $type, $direction, $table, $column, $var_info, $date_error) = @_;

	my ($error, $type_error, $geterror) = 0;

	$type_error = new Types_Errors(0,$type,$direction);
	$type_error = get Types_Errors($dbhPrinters, $type_error);

	$error = new Errors(0,$type_error->getId(),$table,$column,$var_info,$date_error);
	$geterror = get Errors($dbhPrinters, $error);

	if (!$geterror) {

		create Errors($dbhPrinters, $error);

		return;

	}
	else {

		return;

	}

}

sub addPrinter {
	my ($dbhPrinters, $name_printer) = @_;

	my $printer = new Printers(0, $name_printer, 0, 0, 0);
	$printer = get Printers($dbhPrinters, $printer);

	#On test si l'imprimante existe déjà, si non on l'insère dans la base Printers
	if (!$printer) {

		$printer = new Printers(0, $name_printer, 0, 0, 0);
		create Printers($dbhPrinters, $printer);
		$printer = get Printers($dbhPrinters, $printer);

	}

	return $printer;

}

sub addPrinting {
	my ($dbhPrinters, $user, $printer, %line) = @_;

	my $cout = 0;

	# On decompose la date d'impression
	my ($jour, $mois, $year) = getDate($line{Date});

	# On teste si la table d'impression de l'annee de l'impression existe
	my $table = new Tables("printing$year");
	$table = get Tables($dbhPrinters, $table);

	# Si elle n'existe pas, on la creer
	if(!$table) {

		create_table Printing($dbhPrinters, $year);

	}

	# On teste si la quantite n'est pas egale a 0
	if($line{Quantity} eq 0) {

		$line{Quantity} = 1;

	}

	#On recherche les id_pages pour une Impression-A4-Couleur et une Impression-A4-Noir & Blanc
	my $type = new Types( 0, "Impression");
	$type = get Types($dbhPrinters, $type);

	my $format = new Formats( 0, "A4");
	$format = get Formats($dbhPrinters, $format);

	my ($page, $color, $printing);

	#On selectionne la page adéquate
	if($line{Color} eq 2) {

		$color = new Colors( 0, "Couleur");
		$color = get Colors($dbhPrinters, $color);

	}
	else {

		$color = new Colors( 0, "Noir & Blanc");
		$color = get Colors($dbhPrinters, $color);

	}

	$page = new Pages(0, $type->getId(), $format->getId(), 0, $color->getId());
	$page = get Pages($dbhPrinters, $page);

	# On verifie que l'impression n'a pas deja ete enregistre dans la base
	$printing = new Printing(0, $user->getId(), $printer->getId(), $line{Date}, $line{Quantity}, $page->getId());
	my $existPrinting = get Printing($dbhPrinters, $printing);

	# Si elle ne l'es pas, on l'ajoute
	if(!$existPrinting) {

		create Printing($dbhPrinters, $printing);


	}

}

sub addModel {
	my ($dbhPrinters, $printer, $today, $lastday) = @_;

	my $model;

	# On recherche l'id action de l'action recherche le nom du Modèle
	my $action = new Actions( 0, "Nom Modèle", 0);
	$action = get Actions($dbhPrinters, $action);

	# On recherche la commande correspondante à cette action
	my $command = new Commands(0, $action->getId(), 0, 0);
	$command = get Commands($dbhPrinters, $command);

	if ($command){

		#On va maintenant récupérer l'oid correspondant a la commande
		my $oid = new OID($command->getId_OID(), 0);
		$oid = get OID($dbhPrinters, $oid);

		#Appel SNMP : recuperation du modele
		my $name_model = call_snmp("get", 1, $printer->getName(), $oid->getName());

		#Si la commande retourne un resultat
		if ($name_model) {

			#On test si il existe deja
			$model = new Models(0, $name_model, 0);
			$model = get Models($dbhPrinters, $model);

			my $trademark;

			#Si le modele existe, on va recrée la liaison avec L'imprimante
			if ($model) {

				addModel_Printer($dbhPrinters, $printer, $model, $today, $lastday);

				#On recherche la marque correspondante au model
				$trademark = new Trademarks($model->getId_Trademark(), 0);
				$trademark = get Trademarks($dbhPrinters, $trademark);

			}
			#Sinon on crée le modele, sa marque, ainsi que la lisaison
			else {

				#On crée le modele
				$model = new Models(0, $name_model, 0);
				create Models($dbhPrinters, $model);
				$model = get Models($dbhPrinters, $model);

				#On récupère le nom de la marque dans le nom du modele, On part sur l'hypothèse que le nom de la marque est toujours le premier mot du Modele
				my @info = split (/ /,$model->getName());
				my $name_trademark = $info[0];

				#On test si la marque existe deja
				$trademark = new Trademarks(0, $name_trademark);
				$trademark = get Trademarks($dbhPrinters, $trademark);

				#Si oui, on affecte la marque au modele
				if ($trademark) {

					$model->setId_Trademark($trademark->getId());
					update Models($dbhPrinters, $model);

				}
				#Sinon, on crée la marque et on l'affecte après
				else {

					#On crée la marque
					$trademark = new Trademarks(0, $name_trademark);
					create Trademarks($dbhPrinters, $trademark);
					$trademark = get Trademarks($dbhPrinters, $trademark);

					#On affecte la marque au modele
					$model->setId_Trademark($trademark->getId());
					update Models($dbhPrinters, $model);

				}

				#On va ensuite crée la liaison entre le modele et l'imprimante
				addModel_Printer($dbhPrinters, $printer, $model, $today, $lastday);

			}

			#On ajoute les commandes provenant de celle défini par défaut
			addCommand($dbhPrinters, $model, $trademark, $today);

			return $model;

		}
		else{

			addError($dbhPrinters, "SNMP", "Récupération", "Models", "name", $printer->getName(), $today);

			return;

		}

	}
	else {

		addError($dbhPrinters, "SNMP", "Récupération", "Commands", "Model", $printer->getName(), $today);

	}

}

sub addModel_Printer {
	my ($dbhPrinters, $printer, $model, $today, $lastday) = @_;

	#On récupère la relation entre l'imprimante et le modèle
	my $model_printer = new Models_Printers($printer->getId(), 0, 0, 0);
	$model_printer = get Models_Printers($dbhPrinters, $model_printer);

	#Si elle n'existe pas, on l'ajoute
	if(!$model_printer) {

		$model_printer = new Models_Printers($printer->getId(), $model->getId(), $today, 0);
		create Models_Printers($dbhPrinters, $model_printer);

	}
	#Sinon on teste si elle est bon
	else{
		#Si le modele etait different on met à jour la table
		if($model_printer->getId_Model() ne $model->getId()) {

			$model_printer = new Models_Printers($printer->getId(), 0, 0, $lastday);
			update Models_Printers($dbhPrinters, $model_printer);
			$model_printer = new Models_Printers($printer->getId(), $model->getId(), $today, 0);
			create Models_Printers($dbhPrinters, $model_printer);

		}

	}

}

sub addCommand {
	my ($dbhPrinters, $model, $trademark, $today) = @_;

	#On récupère les commandes SNMP générique pour cette marque
	#Penser à la différenciation pour Lexmark
	my $command_default = new Commands_Default(0,0,$trademark->getId(),0,0,0);
	my @commands_default = get Commands_Default($dbhPrinters, $command_default);

	#Si il existe des commandes générique pour cette marque
	if (@commands_default) {

		my $i = 0;
		my ($existcommand, $command);

		# Boucle sur chaque commande pour affecter les commandes lié à la marque sur le model
		while ($commands_default[$i]) {

			$command = new Commands(0,$commands_default[$i]->getId_Action(), $model->getId(),$commands_default[$i]->getId_OID());
			$existcommand = get Commands($dbhPrinters, $command);

			#Si la commande n'existe pas, on ajoute
			if (!$existcommand) {
				create Commands($dbhPrinters, $command);
			}

			$i++;

		}

		return $model;

	}
	else {

		addError($dbhPrinters, "Database", "Récupération", "Commands_Default", "id_trademark", $trademark->getId(), $today);

		return $model;

	}

}


# Fonction de Recuperation des Numero de serie et d'inventaire
sub updatePrinter {
	my ($dbhPrinters, $printer, $model, $today) = @_;

	#On recherche l'action de recuperation du numero de serie
	my $action_serie = new Actions( 0, "Numéro de série", 0);
	$action_serie = get Actions($dbhPrinters, $action_serie);

	#On recherche l'action de recuperation du numero d'inventaire
	my $action_inventory = new Actions( 0, "Numéro d'inventaire", 0);
	$action_inventory = get Actions($dbhPrinters, $action_inventory);

	# On recherche la commande correspondante au numero de serie
	my $command_serie = new Commands(0, $action_serie->getId(), $model->getId(), 0);
	$command_serie = get Commands($dbhPrinters, $command_serie);

	# On recherche la commande correspondante au numero d'inventaire
	my $command_inventory = new Commands(0, $action_inventory->getId(), $model->getId(), 0);
	$command_inventory = get Commands($dbhPrinters, $command_inventory);

	#Si la commande existe
	if ($command_serie) {

		#On va maintenant récupérer l'oid correspondant a la commande
		my $oid_serie = new OID($command_serie->getId_OID(), 0);
		$oid_serie = get OID($dbhPrinters, $oid_serie);

		#Appel SNMP : recuperation du modele
		my $serial_number_printer = call_snmp("get", 1, $printer->getName(), $oid_serie->getName());

		#Si la commande retourne un resultat
		if ($serial_number_printer) {

			$printer->setSerial_Number($serial_number_printer);
			update Printers($dbhPrinters, $printer);

		}
		else {

			addError($dbhPrinters, "SNMP", "Récupération", "Commands", "serial_number", $printer->getName(), $today);

		}

	}
	else {

		addError($dbhPrinters, "Database", "Récupération", "Commands", "serial_number", $printer->getName(), $today);

	}

	#Si la commande existe
	if ($command_inventory) {

		#On va maintenant récupérer l'oid correspondant a la commande
		my $oid_inventory = new OID($command_inventory->getId_OID(), 0);
		$oid_inventory = get OID($dbhPrinters, $oid_inventory);

		#Appel SNMP : recuperation du modele
		my $inventory_number_printer = call_snmp("get", 1, $printer->getName(), $oid_inventory->getName());

		#Si la commande retourne un resultat
		if ($inventory_number_printer) {

			$printer->setInventory_Number($inventory_number_printer);
			update Printers($dbhPrinters, $printer);

		}
		else {

			addError($dbhPrinters, "SNMP", "Récupération", "Commands", "inventory_number", $printer->getName(), $today);

		}

	}
	else {

		addError($dbhPrinters, "Database", "Récupération", "Commands", "inventory_number", $printer->getName(), $today);

	}

}

sub addCounter {
	my ($dbhPrinters, $printer, $model, $today) = @_;

	# On decompose la date d'impression
	my ($jour, $mois, $year) = getToday();

	# On teste si la table de compteur de l'annee en cours existe
	my $table = new Tables("counter$year");
	$table = get Tables($dbhPrinters, $table);

	# Si elle n'existe pas, on la creer
	if(!$table) {

		create_table Counter($dbhPrinters, $year);

	}

	# On recherche les commandes liés au modele
	my $command = new Commands(0,0,$model->getId(), 0);
	my @commands = get Commands($dbhPrinters, $command);

	#Si il existe des commandes générique pour cette marque
	if (@commands) {

		my $i = 0;

		# Boucle sur chaque commande
		while ($commands[$i]) {

			my $action = new Actions($commands[$i]->getId_Action(), 0);
			$action = get Actions($dbhPrinters, $action);

			if ($action->getName ne "Nom Modèle" && $action->getName ne "Numéro de série" &&  $action->getName ne "Numéro d'inventaire") {

				#On va maintenant récupérer l'oid correspondant a la commande
				my $oid = new OID($commands[$i]->getId_OID(), 0);
				$oid = get OID($dbhPrinters, $oid);

				#Appel SNMP : recuperation du modele
				my $tmp = call_snmp("get", 1, $printer->getName(), $oid->getName());

				#Si la commande retourne un resultat
				if ($tmp) {

					my $counter = new Counter(0, $printer->getId(), $today, $tmp, $action->getId_Page());
					create Counter($dbhPrinters, $counter);

				}
				else {

					addError($dbhPrinters, "SNMP", "Récupération", "Commands", 0, $commands[$i]->getId(), $today);

				}

			}

			$i++;

		}

	}
	else {

		addError($dbhPrinters, "Database", "Récupération", "Commands", 0, $model->getName(), $today);


	}

}

1;
