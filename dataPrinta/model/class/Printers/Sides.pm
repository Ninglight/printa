package Sides;
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
	#Demande une instance de Sides en parametre
	my ($this,$dbh,$getside) = @_;

	my $getid = $getside->getId();
	my $getname = $getside->getName();
	my $requete = "SELECT * FROM Sides ";
	my @sides = ();
	my $side;

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

			my $side = new Sides($id, $name);
			push(@sides, $side);

		}

		return @sides;

	}
	elsif ($prep->rows == 1) {

		my ($id, $name) = $prep->fetchrow_array;

		$side = new Sides($id, $name);

		return $side;

	}
	else {

		return;

	}

}

sub create {
	#Demande une instance de Sides en parametre
	my ($this,$dbh,$getside) = @_;

	my $getname = $getside->getName();

	my $requete = "INSERT INTO Sides (name) VALUES ('$getname'); ";

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Insertion dans la table Sides : Effectué\n";

	return;
}

sub update {
	#Demande une instance de Sides en parametre
	my ($this,$dbh,$getside) = @_;

	my $getid = $getside->getId();
	my $getname = $getside->getName();

	my $requete = "UPDATE Sides SET name = '$getname' WHERE id = " . $getid;

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Modification dans la table Sides($getname) : Effectué\n";

	return;
}

1;
