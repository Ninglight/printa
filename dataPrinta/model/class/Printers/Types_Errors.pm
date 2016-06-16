package Types_Errors;
use strict;

sub new {
	my ($class,$id,$name,$direction) = @_;
	my $this = {};
	bless($this, $class);
	$this->{ID} = $id;
	$this->{NAME} = $name;
	$this->{DIRECTION} = $direction;
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

sub getDirection {
	my ($this) = @_;
	return $this->{DIRECTION};
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

sub setDirection {
	my ($this, $direction) = @_;
	$this->{ID_PAGE} = $direction;
	return;
}


sub get {
	#Demande une instance de Types_Errors en parametre
	my ($this,$dbh,$gettypes_error) = @_;

	my $getid = $gettypes_error->getId();
	my $getname = $gettypes_error->getName();
	my $getdirection = $gettypes_error->getDirection();
	my $requete = "SELECT * FROM Types_Errors ";
	my @types_errors = ();
	my $types_error;

	if ($getid) {
		$requete = $requete . "WHERE id = " . $getid;
	}
	elsif($getname & $getdirection) {
		$requete = $requete . "WHERE name = '" . $getname . "' AND direction = '" . $getdirection . "'";
	}

	$requete = $requete . " ;";

	print $requete."\n";

	my $prep = $dbh->prepare($requete) or die $dbh->errstr;
	$prep->execute() or die "Echec requête\n";

	if ($prep->rows > 1) {

		while (my ($id, $name, $direction) = $prep->fetchrow_array ) {

			my $types_error = new Types_Errors($id, $name, $direction);
			push(@types_errors, $types_error);

		}

		return @types_errors;

	}
	elsif ($prep->rows == 1) {

		my ($id, $name, $direction) = $prep->fetchrow_array;

		$types_error = new Types_Errors($id, $name, $direction);

		return $types_error;

	}
	else {

		return;

	}

}

sub create {
	#Demande une instance de Types_Errors en parametre
	my ($this,$dbh,$gettypes_error) = @_;

	my $getname = $gettypes_error->getName();
	my $getdirection = $gettypes_error->getDirection();

	my $requete = "INSERT INTO Types_Errors (name, direction) VALUES ('$getname', '$getdirection'); ";

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Insertion dans la table Pages : Effectué\n";

	return;
}

sub update {
	#Demande une instance de Types_Errors en parametre
	my ($this,$dbh,$gettypes_error) = @_;

	my $getid = $gettypes_error->getId();
	my $getname = $gettypes_error->getName();
	my $getdirection = $gettypes_error->getDirection();

	my $requete = "UPDATE Types_Errors SET ";
	if($getname && $getdirection) {
		$requete = $requete . "name = '$getname', ";
		$requete = $requete . "direction = '$getdirection' ";
	}
	elsif ($getname) {
		$requete = $requete . "name = '$getname' ";
	}
	elsif($getdirection) {
		$requete = $requete . "direction = '$getdirection' ";
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

	print "Modification dans la table Types_Errors($getname) : Effectué\n";

	return;
}

1;
