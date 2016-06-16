package Actions;
use strict;

require "model/class/Subroutine.pm";

sub new {
	my ($class,$id,$name,$id_page) = @_;
	my $this = {};
	bless($this, $class);
	$this->{ID} = $id;
	$this->{NAME} = $name;
	$this->{ID_PAGE} = $id_page;
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

sub getId_Page {
	my ($this) = @_;
	return $this->{ID_PAGE};
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

sub setId_Page {
	my ($this, $id_page) = @_;
	$this->{ID_PAGE} = $id_page;
	return;
}


sub get {
	#Demande une instance de Actions en parametre
	my ($this,$dbh,$getaction) = @_;

	my $getid = $getaction->getId();
	my $getname = $getaction->getName();
	my $getid_page = $getaction->getId_Page();
	my $requete = "SELECT * FROM Actions ";
	my @actions = ();
	my $action;

	if ($getname =~ "'") {
		$getname = Subroutine::manageApostrophe($getname);
	}

	if ($getid) {
		$requete = $requete . "WHERE id = " . $getid;
	}
	elsif($getname) {
		$requete = $requete . "WHERE name = '" . $getname . "'";
	}
	elsif($getid_page) {
		$requete = $requete . "WHERE id_page = " . $getid_page;
	}

	$requete = $requete . " ;";

	print $requete."\n";

	my $prep = $dbh->prepare($requete) or die $dbh->errstr;
	$prep->execute() or die "Echec requête\n";

	if ($prep->rows > 1) {

		while (my ($id, $name, $id_page) = $prep->fetchrow_array ) {

			my $action = new Actions($id, $name, $id_page);
			push(@actions, $action);

		}

		return @actions;

	}
	elsif ($prep->rows == 1) {

		my ($id, $name, $id_page) = $prep->fetchrow_array;

		$action = new Actions($id, $name, $id_page);

		return $action;

	}
	else {

		return;

	}

}

sub create {
	#Demande une instance de Actions en parametre
	my ($this,$dbh,$getaction) = @_;

	my $getname = $getaction->getName();
	my $getid_page = $getaction->getId_Page();

	if ($getname =~ "'") {
		$getname = Subroutine::manageApostrophe($getname);
	}

	my $requete = "INSERT INTO Actions (name, id_page) VALUES ('$getname', '$getid_page'); ";

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Insertion dans la table Actions : Effectué\n";

	return;
}

sub update {
	#Demande une instance de Actions en parametre
	my ($this,$dbh,$getaction) = @_;

	my $getid = $getaction->getId();
	my $getname = $getaction->getName();
	my $getid_page = $getaction->getId_Page();

	if ($getname =~ "'") {
		$getname = Subroutine::manageApostrophe($getname);
	}

	my $requete = "UPDATE Actions SET ";
	if($getname && $getid_page) {
		$requete = $requete . "name = '$getname', ";
		$requete = $requete . "id_page = '$getid_page' ";
	}
	elsif ($getname) {
		$requete = $requete . "name = '$getname' ";
	}
	elsif($getid_page) {
		$requete = $requete . "id_page = '$getid_page' ";
	}

	if ($getid) {
		$requete = $requete . "WHERE id = " . $getid;
	}
	else {
		return;
	}

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Modification dans la table Actions($getname) : Effectué\n";

	return;
}

1;
