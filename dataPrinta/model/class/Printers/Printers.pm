package Printers;
use strict;

sub new {
	my ($class,$id,$name,$serial_number,$inventory_number,$id_statut) = @_;
	my $this = {};
	bless($this, $class);
	$this->{ID} = $id;
	$this->{NAME} = $name;
	$this->{SERIAL_NUMBER} = $serial_number;
	$this->{INVENTORY_NUMBER} = $inventory_number;
	$this->{ID_STATUT} = $id_statut;
	return $this;
}

sub getId {
	my ($this) = @_;
	return $this->{ID};
}

sub getName {
	my ($this) = @_;
	return $this->{NAME};
}

sub getSerial_Number {
	my ($this) = @_;
	return $this->{SERIAL_NUMBER};
}

sub getInventory_Number {
	my ($this) = @_;
	return $this->{INVENTORY_NUMBER};
}

sub getId_Statut {
	my ($this) = @_;
	return $this->{ID_STATUT};
}

sub setId {
	my ($this, $id) = @_;
	$this->{ID} = $id;
	return;
}

sub setName {
	my ($this, $name) = @_;
	$this->{NAME} = $name;
	return;
}

sub setSerial_Number {
	my ($this, $serial_number) = @_;
	$this->{SERIAL_NUMBER} = $serial_number;
	return;
}

sub setInventory_Number {
	my ($this, $inventory_number) = @_;
	$this->{INVENTORY_NUMBER} = $inventory_number;
	return;
}

sub setId_Statut {
	my ($this, $id_statut) = @_;
	$this->{ID_STATUT} = $id_statut;
	return;
}

sub get {
	#Demande une instance de Printers en parametre
	my ($this,$dbh,$getprinter) = @_;

	my $getid = $getprinter->getId();
	my $getname = $getprinter->getName();
	my $getserial_number = $getprinter->getSerial_Number();
	my $getinventory_number = $getprinter->getInventory_Number();
	my $getid_statut = $getprinter->getId_Statut();
	my $requete = "SELECT * FROM Printers ";
	my @printers = ();
	my $printer;

	if ($getid) {
		$requete = $requete . "WHERE id = " . $getid;
	}
	elsif($getname) {
		$requete = $requete . "WHERE name = '" . $getname . "'";
	}
	elsif($getserial_number) {
		$requete = $requete . "WHERE serial_number = '" . $getserial_number  . "'";
	}
	elsif($getinventory_number) {
		$requete = $requete . "WHERE inventory_number = '" . $getinventory_number  . "'";
	}
	elsif($getid_statut) {
		$requete = $requete . "WHERE id_statut = " . $getid_statut;
	}

	$requete = $requete . " ;";

	print $requete."\n";

	my $prep = $dbh->prepare($requete) or die $dbh->errstr;
	$prep->execute() or die "Echec requête\n";

	if ($prep->rows > 1) {

		while (my ($id, $name, $serial_number,$inventory_number,$id_statut) = $prep->fetchrow_array ) {

			my $printer = new Printers($id, $name, $serial_number,$inventory_number,$id_statut);
			push(@printers, $printer);

		}

		return @printers;

	}
	elsif ($prep->rows == 1) {

		my ($id, $name, $serial_number,$inventory_number,$id_statut) = $prep->fetchrow_array;

		$printer = new Printers($id, $name, $serial_number,$inventory_number,$id_statut);

		return $printer;

	}
	else {

		return;

	}

}

sub create {
	#Demande une instance de Printers en parametre
	my ($this,$dbh,$getprinter) = @_;

	my $getname = $getprinter->getName();

	my $requete = "INSERT INTO Printers (name, id_statut) VALUES ('$getname', 1); ";

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Insertion dans la table Printers : Effectué\n";

	return;
}

sub update {
	#Demande une instance de Printers en parametre
	my ($this,$dbh,$getprinter) = @_;

	my $getid = $getprinter->getId();
	my $getname = $getprinter->getName();
	my $getserial_number = $getprinter->getSerial_Number();
	my $getinventory_number = $getprinter->getInventory_Number();
	my $getid_statut = $getprinter->getId_Statut();

	my $requete = "UPDATE Printers SET ";

	if ($getname) {
		$requete = $requete . "name = '$getname' ";
	}
	elsif($getserial_number) {
		$requete = $requete . "serial_number = '$getserial_number' ";
	}
	elsif($getinventory_number) {
		$requete = $requete . "inventory_number = '$getinventory_number' ";
	}
	elsif($getid_statut) {
		$requete = $requete . "id_statut = '$getid_statut' ";
	}


	if ($getid) {
		$requete = $requete . "WHERE id = " . $getid;
	}
	else{
		return;
	}

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Modification dans la table Printers($getname) : Effectué\n";

	return;
}

1;
