package Colors;
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
	#Demande une instance de Colors en parametre
	my ($this,$dbh,$getcolor) = @_;

	my $getid = $getcolor->getId();
	my $getname = $getcolor->getName();
	my $requete = "SELECT * FROM Colors ";
	my @colors = ();
	my $color;

	if ($getid){
		$requete = $requete . "WHERE id = " . $getid;
	}
	elsif($getname){
		$requete = $requete . "WHERE name = '" . $getname . "'";
	}

	$requete = $requete . " ;";

	print $requete."\n";

	my $prep = $dbh->prepare($requete) or die $dbh->errstr;
	$prep->execute() or die "Echec requête\n";

	if ($prep->rows > 1) {

		while (my ($id, $name) = $prep->fetchrow_array ) {

			my $color = new Colors($id, $name);
			push(@colors, $color);

		}

		return @colors;

	}
	elsif ($prep->rows == 1) {

		my ($id, $name) = $prep->fetchrow_array;

		$color = new Colors($id, $name);

		return $color;

	}
	else {

		return;

	}

}

sub create {
	#Demande une instance de Colors en parametre
	my ($this,$dbh,$getcolor) = @_;

	my $getname = $getcolor->getName();

	my $requete = "INSERT INTO Colors (name) VALUES ('$getname'); ";

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Insertion dans la table Colors : Effectué\n";

	return;
}

sub update {
	#Demande une instance de Colors en parametre
	my ($this,$dbh,$getcolor) = @_;

	my $getid = $getcolor->getId();
	my $getname = $getcolor->getName();

	my $requete = "UPDATE Colors SET name = '$getname'";
	$requete = $requete . "WHERE id = " . $getid;

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Modification dans la table Colors($getname) : Effectué\n";

	return;
}

1;
