package Statuts;
use strict;

sub new {
	my ($class,$id,$name) = @_;
	my $this = {};
	bless($this, $class);
	$this->{ID} = $id;
	$this->{NAME} = $name;
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

sub get {
	#Demande une instance de Statuts en parametre
	my ($this,$dbh,$getstatut) = @_;

	my $getid = $getstatut->getId();
	my $getname = $getstatut->getName();
	my $requete = "SELECT * FROM Statuts ";
	my @statuts = ();
	my $statut;

	if ($getid) {
		$requete = $requete . "WHERE id = " . $getid;
	}
	elsif($getname) {
		$requete = $requete . "WHERE name = '" . $getname . "'";
	}

	$requete = $requete . " ;";

	print $requete."\n";

	my $prep = $dbh->prepare($requete) or die $dbh->errstr;
	$prep->execute() or die "Echec requête\n";

	if ($prep->rows > 1) {

		while (my ($id, $name) = $prep->fetchrow_array ) {

			my $statut = new Statuts($id, $name);
			push(@statuts, $statut);

		}

		return @statuts;

	}
	elsif ($prep->rows == 1) {

		my ($id, $name) = $prep->fetchrow_array;

		$statut = new Statuts($id, $name);

		return $statut;

	}
	else {

		return;

	}

}

sub create {
	#Demande une instance de Statuts en parametre
	my ($this,$dbh,$getstatut) = @_;

	my $getname = $getstatut->getName();

	my $requete = "INSERT INTO Statuts (name) VALUES ('$getname'); ";

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Insertion dans la table Statuts : Effectué\n";

	return;
}

sub update {
	#Demande une instance de Statuts en parametre
	my ($this,$dbh,$getstatut) = @_;

	my $getid = $getstatut->getId();
	my $getname = $getstatut->getName();

	my $requete = "UPDATE Statuts SET name = '$getname' WHERE id = " . $getid;

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Modification dans la table Statuts($getname) : Effectué\n";

	return;
}

1;
