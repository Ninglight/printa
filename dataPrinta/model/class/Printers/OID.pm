package OID;
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
	#Demande une instance de OID en parametre
	my ($this,$dbh,$getoid) = @_;

	my $getid = $getoid->getId();
	my $getname = $getoid->getName();
	my $requete = "SELECT * FROM OID ";
	my @oids = ();
	my $oid;

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

			my $oid = new OID($id, $name);
			push(@oids, $oid);

		}

		return @oids;

	}
	elsif ($prep->rows == 1) {

		my ($id, $name) = $prep->fetchrow_array;

		$oid = new OID($id, $name);

		return $oid;

	}
	else {

		return;
	}

}

sub create {
	#Demande une instance de OID en parametre
	my ($this,$dbh,$getoid) = @_;

	my $getname = $getoid->getName();

	my $requete = "INSERT INTO OID (name) VALUES ('$getname'); ";

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Insertion dans la table OID : Effectué\n";

	return;
}

sub update {
	#Demande une instance de OID en parametre
	my ($this,$dbh,$getoid) = @_;

	my $getid = $getoid->getId();
	my $getname = $getoid->getName();

	my $requete = "UPDATE OID SET name = '$getname' WHERE id = " . $getid;

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Modification dans la table OID($getname) : Effectué\n";

	return;
}

1;
