package Trademarks;
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
	#Demande une instance de Trademarks en parametre
	my ($this,$dbh,$gettrademarks) = @_;

	my $getid = $gettrademarks->getId();
	my $getname = $gettrademarks->getName();
	my $requete = "SELECT * FROM Trademarks ";
	my @trademarks = ();
	my $trademark;

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

			my $trademark = new Trademarks($id, $name);
			push(@trademarks, $trademark);

		}

		return @trademarks;

	}
	elsif ($prep->rows == 1) {

		my ($id, $name) = $prep->fetchrow_array;

		$trademark = new Trademarks($id, $name);

		return $trademark;

	}
	else {

		return;

	}

}

sub create {
	#Demande une instance de Trademarks en parametre
	my ($this,$dbh,$gettrademarks) = @_;

	my $getname = $gettrademarks->getName();

	my $requete = "INSERT INTO Trademarks (name) VALUES ('$getname'); ";

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Insertion dans la table Pages : Effectué\n";

	return;
}

sub update {
	#Demande une instance de Trademarks en parametre
	my ($this,$dbh,$gettrademarks) = @_;

	my $getid = $gettrademarks->getId();
	my $getname = $gettrademarks->getName();

	my $requete = "UPDATE Trademarks SET name = '$getname' WHERE id = " . $getid;

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Modification dans la table Trademarks($getname) : Effectué\n";

	return;
}

1;
