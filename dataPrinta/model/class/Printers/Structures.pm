package Structures;
use strict;

require "model/class/Subroutine.pm";

sub new {
	my ($class,$id,$acronym,$name,$type,$id_structure) = @_;
	my $this = {};
	bless($this, $class);
	$this->{ID} = $id;
	$this->{ACRONYM} = $acronym;
	$this->{NAME} = $name;
	$this->{TYPE} = $type;
	$this->{ID_STRUCTURE} = $id_structure;
	return $this;
}

sub getId {
	my ($this) = @_;
	return $this->{ID};
}

sub getAcronym {
	my ($this) = @_;
	return $this->{ACRONYM};
}

sub getName {
	my ($this) = @_;
	return $this->{NAME};
}

sub getType {
	my ($this) = @_;
	return $this->{TYPE};
}

sub getId_Structure {
	my ($this) = @_;
	return $this->{ID_STRUCTURE};
}

sub setId {
	my ($this, $id) = @_;
	$this->{ID} = $id;
	return;
}

sub setAcronym {
	my ($this, $acronym) = @_;
	$this->{ACRONYM} = $acronym;
	return;
}

sub setName {
	my ($this, $name) = @_;
	$this->{NAME} = $name;
	return;
}

sub setType {
	my ($this, $type) = @_;
	$this->{TYPE} = $type;
	return;
}

sub setId_Structure {
	my ($this, $id_structure) = @_;
	$this->{ID_STRUCTURE} = $id_structure;
	return;
}

sub get {
	#Demande une instance de Structures en parametre
	my ($this,$dbh,$getstructure) = @_;

	my $getid = $getstructure->getId();
	my $getacronym = $getstructure->getAcronym();
	my $getname = $getstructure->getName();
	my $gettype = $getstructure->getType();
	my $getid_structure = $getstructure->getId_Structure();
	my $requete = "SELECT * FROM Structures ";
	my @structures = ();
	my $structure;

	if ($getid) {
		$requete = $requete . "WHERE id = " . $getid;
	}
	elsif($getacronym) {
		$requete = $requete . "WHERE acronym = '" . $getacronym . "'";
	}
	elsif($getname) {
		$requete = $requete . "WHERE name = '" . $getname . "'";
	}

	$requete = $requete . " ;";

	print $requete."\n";

	my $prep = $dbh->prepare($requete) or die $dbh->errstr;
	$prep->execute() or die "Echec requête\n";

	if ($prep->rows > 1) {

		while (my ($id, $acronym, $name, $type, $id_structure) = $prep->fetchrow_array ) {

			if ($name =~ "'") {
				$name = Subroutine::manageApostrophe($name);
			}

			my $structure = new Structures($id, $acronym, $name, $type, $id_structure);
			push(@structures, $structure);

		}

		return @structures;

	}
	elsif ($prep->rows == 1) {

		my ($id, $acronym, $name, $type, $id_structure) = $prep->fetchrow_array;

		if ($name =~ "'") {
			$name = Subroutine::manageApostrophe($name);
		}

		$structure = new Structures($id, $acronym, $name, $type, $id_structure);

		return $structure;

	}
	else {

		return;

	}

}

sub create {
	#Demande une instance de Structures en parametre
	my ($this,$dbh,$getstructure) = @_;

	my $getid = $getstructure->getId();
	my $getacronym = $getstructure->getAcronym();
	my $getname = $getstructure->getName();
	my $gettype = $getstructure->getType();
	my $getid_structure = $getstructure->getId_Structure();

	if ($getid_structure == 0) {

		$getid_structure = "NULL";

	}

	my $requete = "INSERT INTO Structures (id, acronym, name, type, id_structure) VALUES ($getid, '$getacronym', '$getname', '$gettype', $getid_structure); ";

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Insertion dans la table Structures : Effectué\n";

	return;
}

sub update {
	#Demande une instance de Structures en parametre
	my ($this,$dbh,$getstructure) = @_;

	my $getid = $getstructure->getId();
	my $getacronym = $getstructure->getAcronym();
	my $getname = $getstructure->getName();
	my $gettype = $getstructure->getType();
	my $getid_structure = $getstructure->getId_Structure();
	my $requete = "";

	if ($getname && $gettype) {
		$requete = "UPDATE Structures SET name = '$getname', type = '$gettype'";
	}
	elsif ($getid_structure) {
		$requete = "UPDATE Structures SET id_structure=$getid_structure ";
	}
	else {
		return;
	}

	if ($getid) {
		$requete = $requete . " WHERE id = " . $getid;
	}
	elsif($getacronym) {
		$requete = $requete . " WHERE acronym = " . $getacronym;
	}
	else {
		return;
	}

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Modification dans la table Structures($getacronym) : Effectué\n";

	return;
}

1;
