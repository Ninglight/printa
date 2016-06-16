package Annuaire_UtilStruct;
use strict;

sub new {
	my ($class,$matricule,$structure) = @_;
	my $this = {};
	bless($this, $class);
	$this->{MATRICULE} = $matricule;
	$this->{STRUCTURE} = $structure;
	return $this;
}

sub getMatricule {
	my ($this) = @_;
	return $this->{MATRICULE};
}

sub getStructure {
	my ($this) = @_;
	return $this->{STRUCTURE};
}

sub setMatricule {
	my ($this, $matricule) = @_;
	$this->{MATRICULE} = $matricule;
	return;
}

sub setStructure {
	my ($this, $structure) = @_;
	$this->{STRUCTURE} = $structure;
	return;
}

sub get {
	#Demande une instance de Utilstruct en parametre
	my ($this,$dbh,$getutilstruct) = @_;

	my $getmatricule = $getutilstruct->getMatricule();
	my $getstructure = $getutilstruct->getStructure();
	my $requete = "SELECT Matricule, Id_structure FROM UtilStruct ";
	my @utilstructs = ();
	my $utilstruct;

	if ($getmatricule){
		$requete = $requete . "WHERE Matricule = " . $getmatricule;
	}
	elsif($getstructure){
		$requete = $requete . "WHERE Id_structure = " . $getstructure;
	}

	$requete = $requete . " ;";

	print "Annuaire : " . $requete."\n";

	my $prep = $dbh->prepare($requete) or die $dbh->errstr;
	$prep->execute() or die "Echec requête\n";

	if ($prep->rows > 0) {

		my ($matricule, $structure) = $prep->fetchrow_array;

		my $utilstruct = new Annuaire_UtilStruct($matricule, $structure);

		return $utilstruct;

	}
	else {

		return;

	}

}

1;
