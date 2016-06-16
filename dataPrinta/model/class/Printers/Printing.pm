package Printing;
use strict;

require "model/class/Subroutine.pm";

sub new {
	my ($class,$id,$id_user,$id_printer,$date_printing,$quantity,$id_page) = @_;
	my $this = {};
	bless($this, $class);
	$this->{ID} = $id;
	$this->{ID_USER} = $id_user;
	$this->{ID_PRINTER} = $id_printer;
	$this->{DATE_PRINTING} = $date_printing;
	$this->{QUANTITY} = $quantity;
	$this->{ID_PAGE} = $id_page;
	return $this;
}

sub getId {
	my ($this) = @_;
	return $this->{ID};
}

sub getId_User {
	my ($this) = @_;
	return $this->{ID_USER};
}

sub getId_Printer {
	my ($this) = @_;
	return $this->{ID_PRINTER};
}

sub getDate_Printing {
	my ($this) = @_;
	return $this->{DATE_PRINTING};
}

sub getQuantity {
	my ($this) = @_;
	return $this->{QUANTITY};
}

sub getId_Page {
	my ($this) = @_;
	return $this->{ID_PAGE};
}

sub setId {
	my ($this, $id) = @_;
	$this->{ID} = $id;
	return;
}

sub setId_User {
	my ($this, $id_user) = @_;
	$this->{ID_USER} = $id_user;
	return;
}

sub setId_Printer {
	my ($this, $id_printer) = @_;
	$this->{ID_PRINTER} = $id_printer;
	return;
}

sub setDate_Printing {
	my ($this, $date_printing) = @_;
	$this->{DATE_PRINTING} = $date_printing;
	return;
}

sub setQuantity {
	my ($this, $quantity) = @_;
	$this->{QUANTITY} = $quantity;
	return;
}

sub setId_Page {
	my ($this, $id_page) = @_;
	$this->{ID_PAGE} = $id_page;
	return;
}


sub get {
	#Demande une instance de Printing en parametre
	my ($this,$dbh,$getprinting) = @_;

	my $getid = $getprinting->getId();
	my $getid_user = $getprinting->getId_User();
	my $getid_printer = $getprinting->getId_Printer();
	my $getdate_printing = $getprinting->getDate_Printing();
	my $getquantity = $getprinting->getQuantity();
	my $getid_page = $getprinting->getId_Page();

	# On decompose la date d'impression
	my $year = Subroutine::getYearPrinting($getdate_printing);

	my $requete = "SELECT * FROM Printing$year ";
	my @printings = ();
	my $printing;

	if ($getid) {
		$requete = $requete . "WHERE id = " . $getid;
	}
	elsif($getid_user && $getid_printer) {
		$requete = $requete . "WHERE id_user = " . $getid_user;
		$requete = $requete . " AND id_printer = " . $getid_printer;
	}
	elsif($getid_user) {
		$requete = $requete . "WHERE id_user = " . $getid_user;
	}
	elsif($getid_printer) {
		$requete = $requete . "WHERE id_printer = " . $getid_printer;
	}
	elsif($getid_page) {
		$requete = $requete . "WHERE id_page = " . $getid_page;
	}

	if ($getdate_printing) {
		$requete = $requete . " AND date_printing = '" . $getdate_printing . "'";
	}
	if ($getquantity) {
		$requete = $requete . " AND quantity = " . $getquantity;
	}
	if ($getid_page) {
		$requete = $requete . " AND id_page = " . $getid_page;
	}

	$requete = $requete . " ;";

	print $requete."\n";

	my $prep = $dbh->prepare($requete) or die $dbh->errstr;
	$prep->execute() or die "Echec requête\n";

	if ($prep->rows > 1) {

		while (my ($id, $id_user, $id_printer, $date_printing, $quantity, $id_page) = $prep->fetchrow_array ) {

			my $printing = new Printing($id, $id_user, $id_printer, $date_printing, $quantity, $id_page);
			push(@printings, $printing);

		}

		return @printings;

	}
	elsif ($prep->rows == 1) {

		my ($id, $id_user, $id_printer, $date_printing, $quantity, $id_page) = $prep->fetchrow_array;

		$printing = new Printing($id, $id_user, $id_printer, $date_printing, $quantity, $id_page);

		return $printing;

	}
	else {

		return;

	}

}

sub create {
	#Demande une instance de Printing en parametre
	my ($this,$dbh,$getprinting) = @_;

	my $getid_user = $getprinting->getId_User();
	my $getid_printer = $getprinting->getId_Printer();
	my $getdate_printing = $getprinting->getDate_Printing();
	my $getquantity = $getprinting->getQuantity();
	my $getid_page = $getprinting->getId_Page();

	# On decompose la date d'impression
	my $year = Subroutine::getYearPrinting($getdate_printing);

	my $requete = "INSERT INTO Printing$year (id_user, id_printer, date_printing, quantity, id_page) VALUES ($getid_user, $getid_printer, '$getdate_printing', $getquantity, $getid_page); ";

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Insertion dans la table Printing$year : Effectué\n";

	return;
}

sub create_table {
	my ($this,$dbh,$year) = @_;

	$year = int($year);

	my $requete = <<"SQL";
	CREATE TABLE Printing$year (
		id SERIAL PRIMARY KEY,
		id_user int REFERENCES Users(id),
		id_printer int REFERENCES Printers(id),
		date_printing timestamp,
		quantity int,
		id_page int REFERENCES Pages(id)
	);

SQL

	print $requete."\n";

	my $statement = $dbh->prepare($requete);
	$statement->execute();

	print "Création de la table Printing$year : Effectué\n";

	return;
}

sub update {
	#Demande une instance de Printing en parametre
	my ($this,$dbh,$getprinting) = @_;

	my $getid = $getprinting->getId();
	my $getid_user = $getprinting->getId_User();
	my $getid_printer = $getprinting->getId_Printer();
	my $getdate_printing = $getprinting->getDate_Printing();
	my $getquantity = $getprinting->getQuantity();
	my $getid_page = $getprinting->getId_Page();

	# On decompose la date d'impression
	my $year = Subroutine::getYearPrinting($getdate_printing);

	my $requete = "UPDATE Printing$year SET ";

	if($getid_user) {
		$requete = $requete . "id_user = $getid_user ";
	}
	elsif($getid_printer) {
		$requete = $requete . "id_printer = $getid_printer ";
	}
	elsif($getdate_printing) {
		$requete = $requete . "date_printing = '$getdate_printing' ";
	}
	elsif($getquantity) {
		$requete = $requete . "quantity = $getquantity ";
	}
	elsif($getid_page) {
		$requete = $requete . "id_page = $getid_page ";
	}

	$requete = $requete . "WHERE id = " . $getid;

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Modification dans la table Printing$year($getid_user, $getid_printer) : Effectué\n";

	return;
}


1;
