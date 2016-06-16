package Annuaire_Droits;
use strict;

sub new {
	my ($class,$login,$matricule) = @_;
	my $this = {};
	bless($this, $class);
	$this->{LOGIN} = $login;
	$this->{MATRICULE} = $matricule;
	return $this;
}

sub getLogin {
	my ($this) = @_;
	return $this->{LOGIN};
}

sub getMatricule {
	my ($this) = @_;
	return $this->{MATRICULE};
}

sub setLogin {
	my ($this, $login) = @_;
	$this->{LOGIN} = $login;
	return;
}

sub setMatricule {
	my ($this, $matricule) = @_;
	$this->{MATRICULE} = $matricule;
	return;
}

sub get {
	#Demande une instance de Droits en parametre
	my ($this,$dbh,$getdroit) = @_;

	my $getlogin = $getdroit->getLogin();
	my $getmatricule = $getdroit->getMatricule();
	my $requete = "SELECT Login, Matricule FROM Droits ";
	my @droits = ();
	my $droit;

	if ($getmatricule){
		$requete = $requete . "WHERE Matricule = " . $getmatricule;
	}
	elsif($getlogin){
		$requete = $requete . "WHERE Login = '" . $getlogin . "'";
	}

	$requete = $requete . " ;";

	print "Annuaire : " . $requete."\n";

	my $prep = $dbh->prepare($requete) or die $dbh->errstr;
	$prep->execute() or die "Echec requête\n";

	if ($prep->rows > 0) {

		my ($login, $matricule) = $prep->fetchrow_array;

		my $droit = new Annuaire_Droits($login, $matricule);

		return $droit;

	}
	else {

		return;

	}

}

1;
