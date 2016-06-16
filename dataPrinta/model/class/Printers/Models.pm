package Models;
use strict;

require "model/class/Subroutine.pm";

sub new {
	my ($class,$id,$name,$id_trademark, $id_page) = @_;
	my $this = {};
	bless($this, $class);
	$this->{ID} = $id;
	$this->{NAME} = $name;
	$this->{ID_TRADEMARK} = $id_trademark;
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

sub getId_Trademark {
	my ($this) = @_;
	return $this->{ID_TRADEMARK};
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

sub setId_Trademark {
	my ($this, $id_trademark) = @_;
	$this->{ID_TRADEMARK} = $id_trademark;
	return;
}

sub get {
	#Demande une instance de Models en parametre
	my ($this,$dbh,$getmodel) = @_;

	my $getid = $getmodel->getId();
	my $getname = $getmodel->getName();
	my $getid_trademark = $getmodel->getId_Trademark();

	my $requete = "SELECT * FROM Models ";
	my @models = ();
	my $model;

	if ($getname =~ "'") {
		$getname = Subroutine::deleteApostrophe($getname);
	}

	if ($getid) {
		$requete = $requete . "WHERE id = " . $getid;
	}
	elsif($getname) {
		$requete = $requete . "WHERE name = '" . $getname . "'";
	}
	elsif($getid_trademark) {
		$requete = $requete . "WHERE id_trademark = " . $getid_trademark;
	}

	$requete = $requete . " ;";

	print $requete."\n";

	my $prep = $dbh->prepare($requete) or die $dbh->errstr;
	$prep->execute() or die "Echec requête\n";

	if ($prep->rows > 1) {

		while (my ($id, $name, $id_trademark) = $prep->fetchrow_array ) {

			if ($name =~ "'") {
				$name = Subroutine::deleteApostrophe($name);
			}

			my $model = new Models($id, $name, $id_trademark);
			push(@models, $model);

		}

		return @models;

	}
	elsif ($prep->rows == 1) {

		my ($id, $name, $id_trademark) = $prep->fetchrow_array;

		if ($name =~ "'") {
			$name = Subroutine::deleteApostrophe($name);
		}

		$model = new Models($id, $name, $id_trademark);

		return $model;

	}
	else {

		return;

	}

}

sub create {
	#Demande une instance de Models en parametre
	my ($this,$dbh,$getmodel) = @_;

	my $getname = $getmodel->getName();
	my $getid_trademark = $getmodel->getId_Trademark();

	if ($getname =~ "'") {
		$getname = Subroutine::deleteApostrophe($getname);
	}

	my $requete = "INSERT INTO Models (name, id_trademark) VALUES ('$getname', 1); ";

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Insertion dans la table Models : Effectué\n";

	return;
}

sub update {
	#Demande une instance de Models en parametre
	my ($this,$dbh,$getmodel) = @_;

	my $getid = $getmodel->getId();
	my $getname = $getmodel->getName();
	my $getid_trademark = $getmodel->getId_Trademark();

	if ($getname =~ "'") {
		$getname = Subroutine::deleteApostrophe($getname);
	}

	my $requete = "UPDATE Models SET id_trademark = " . $getid_trademark . " WHERE id = " . $getid . " ;";

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Modification dans la table Models($getname) : Effectué\n";

	return;
}

1;
