package Types;
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
	#Demande une instance de Types en parametre
	my ($this,$dbh,$gettype) = @_;

	my $getid = $gettype->getId();
	my $getname = $gettype->getName();
	my $requete = "SELECT * FROM Types ";
	my @types = ();
	my $type;

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

			my $type = new Types($id, $name);
			push(@types, $type);

		}

		return @types;

	}
	elsif ($prep->rows == 1) {

		my ($id, $name) = $prep->fetchrow_array;

		$type = new Types($id, $name);

		return $type;

	}
	else {

		return;

	}

}

sub create {
	#Demande une instance de Types en parametre
	my ($this,$dbh,$gettype) = @_;

	my $getname = $gettype->getName();

	my $requete = "INSERT INTO Types (name) VALUES ('$getname'); ";

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Insertion dans la table Types : Effectué\n";

	return;
}

sub update {
	#Demande une instance de Types en parametre
	my ($this,$dbh,$gettype) = @_;

	my $getid = $gettype->getId();
	my $getname = $gettype->getName();

	my $requete = "UPDATE Types SET name = '$getname' WHERE id = " . $getid;

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Modification dans la table Types($getname) : Effectué\n";

	return;
}

1;
