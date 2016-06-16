package Formats;
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
	#Demande une instance de Formats en parametre
	my ($this,$dbh,$getformat) = @_;

	my $getid = $getformat->getId();
	my $getname = $getformat->getName();
	my $requete = "SELECT * FROM Formats ";
	my @formats = ();
	my $format;

	if ($getid){
		$requete = $requete . "WHERE id = " . $getid;
	}
	elsif($getname){
		$requete = $requete . "WHERE name = '" . $getname . "'";
	}

	my $prep = $dbh->prepare($requete) or die $dbh->errstr;
	$prep->execute() or die "Echec requête\n";

	if ($prep->rows > 1){

		while (my ($id, $name) = $prep->fetchrow_array ) {

			my $format = new Formats($id, $name);
			push(@formats, $format);

		}

		return @formats;

	}
	elsif ($prep->rows == 1) {

		my ($id, $name) = $prep->fetchrow_array;

		$format = new Formats($id, $name);

		return $format;

	}
	else {

		return;

	}

}

sub create {
	#Demande une instance de Formats en parametre
	my ($this,$dbh,$getformat) = @_;

	my $getname = $getformat->getName();

	my $requete = "INSERT INTO Formats (name) VALUES ('$getname'); ";

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Insertion dans la table Formats : Effectué\n";

	return;
}

sub update {
	#Demande une instance de Formats en parametre
	my ($this,$dbh,$getformat) = @_;

	my $getid = $getformat->getId();
	my $getname = $getformat->getName();

	my $requete = "UPDATE Formats SET name = '$getname'";
	$requete = $requete . "WHERE id = " . $getid;

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Modification dans la table Formats($getname) : Effectué\n";

	return;
}

1;
