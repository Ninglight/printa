package Annuaire_Utilisateur;
use strict;
use Encode;
use utf8;

require "model/class/Subroutine.pm";

sub new {
	my ($class,$matricule,$prenom,$nom) = @_;
	my $this = {};
	bless($this, $class);
	$this->{MATRICULE} = $matricule;
	$this->{PRENOM} = $prenom;
	$this->{NOM} = $nom;
	return $this;
}

sub getMatricule {
	my ($this) = @_;
	return $this->{MATRICULE};
}

sub getPrenom {
	my ($this) = @_;
	return $this->{PRENOM};
}

sub getNom {
	my ($this) = @_;
	return $this->{NOM};
}

sub setMatricule {
	my ($this, $matricule) = @_;
	$this->{MATRICULE} = $matricule;
	return;
}

sub setPrenom {
	my ($this, $prenom) = @_;
	$this->{PRENOM} = $prenom;
	return;
}

sub setNom {
	my ($this, $nom) = @_;
	$this->{NOM} = $nom;
	return;
}

sub get {
	#Demande une instance de Utilisateurs en parametre
	my ($this,$dbh,$getutilisateur) = @_;

	my $getmatricule = $getutilisateur->getMatricule();
	my $getprenom = $getutilisateur->getPrenom();
	my $getnom = $getutilisateur->getNom();
	my $requete = "SELECT Matricule, Prenom, Nom FROM Utilisateur ";
	my @utilisateurs = ();
	my $utilisateur;

	if ($getmatricule){
		$requete = $requete . "WHERE Matricule = " . $getmatricule;
	}
	elsif($getnom){
		$requete = $requete . "WHERE Nom = '" . $getnom . "'";
	}

	$requete = $requete . " ;";

	print "Annuaire : " . $requete."\n";

	my $prep = $dbh->prepare($requete) or die $dbh->errstr;
	$prep->execute() or die "Echec requête\n";

	if ($prep->rows > 0) {

		my ($matricule, $prenom, $nom) = $prep->fetchrow_array;

		$prenom = encode("UTF8", $prenom);
		$nom = encode("UTF8", $nom);

		if ($nom =~ "'") {
			$nom = Subroutine::manageApostrophe($nom);
		}

		if ($prenom =~ "'") {
			$prenom = Subroutine::manageApostrophe($prenom);
		}

		my $utilisateur = new Annuaire_Utilisateur($matricule, $prenom, $nom);

		return $utilisateur;

	}
	else {

		return;

	}

}

1;
