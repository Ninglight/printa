package Annuaire_Structures;
use strict;
use Encode;
use utf8;

require "model/class/Subroutine.pm";

sub new {
	my ($class,$id,$sigle,$liblong,$type,$id_parent) = @_;
	my $this = {};
	bless($this, $class);
	$this->{ID} = $id;
	$this->{SIGLE} = $sigle;
	$this->{LIBLONG} = $liblong;
	$this->{TYPE} = $type;
	$this->{ID_PARENT} = $id_parent;
	return $this;
}

sub getId {
	my ($this) = @_;
	return $this->{ID};
}

sub getSigle {
	my ($this) = @_;
	return $this->{SIGLE};
}

sub getLiblong {
	my ($this) = @_;
	return $this->{LIBLONG};
}

sub getType {
	my ($this) = @_;
	return $this->{TYPE};
}

sub getId_Parent {
	my ($this) = @_;
	return $this->{ID_PARENT};
}

sub setId {
	my ($this, $id) = @_;
	$this->{ID} = $id;
	return;
}

sub setSigle {
	my ($this, $sigle) = @_;
	$this->{SIGLE} = $sigle;
	return;
}

sub setLiblong {
	my ($this, $liblong) = @_;
	$this->{LIBLONG} = $liblong;
	return;
}

sub setType {
	my ($this, $type) = @_;
	$this->{TYPE} = $type;
	return;
}

sub setId_Parent {
	my ($this, $id_parent) = @_;
	$this->{ID_PARENT} = $id_parent;
	return;
}

sub get {
	#Demande une instance de Structures en parametre
	my ($this,$dbh,$getstructure) = @_;

	my $getid = $getstructure->getId();
	my $getsigle = $getstructure->getSigle();
	my $getliblong = $getstructure->getLiblong();
	my $gettype = $getstructure->getType();
	my $getid_parent = $getstructure->getId_Parent();
	my $requete = "SELECT Id_structure, Sigle, Liblong, Type, ID_parent FROM Structures ";
	my @structures = ();
	my $structure;

	if ($getid){
		$requete = $requete . "WHERE Id_structure = " . $getid;
	}
	elsif($getsigle){
		$requete = $requete . "WHERE Sigle = " . $getsigle;
	}

	$requete = $requete . " ;";

	print "Annuaire : " . $requete . "\n";

	my $prep = $dbh->prepare($requete) or die $dbh->errstr;
	$prep->execute() or die "Echec requête\n";

	if ($prep->rows > 0) {

		my ($id, $sigle, $liblong, $type, $id_parent) = $prep->fetchrow_array;

		#Encodage en UTF-8 (Données provenant de Latin1)
		$liblong = encode("UTF8", $liblong);

		if ($sigle eq '') {
			#Algorithme de création d'un Acronym
			$sigle = Subroutine::getAcronym($liblong);
		}

		if ($liblong =~ "'") {
			$liblong = Subroutine::manageApostrophe($liblong);
		}

		my $structure = new Annuaire_Structures($id, $sigle, $liblong, $type, $id_parent);

		return $structure;

	}
	else {

		return;

	}

}


1;
