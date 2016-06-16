package Costs;
use strict;

sub new {
	my ($class,$id,$id_model,$id_page,$date_start,$date_end,$amount) = @_;
	my $this = {};
	bless($this, $class);
	$this->{ID} = $id;
	$this->{ID_MODEL} = $id_model;
	$this->{ID_PAGE} = $id_page;
	$this->{DATE_START} = $date_start;
	$this->{DATE_END} = $date_end;
	$this->{AMOUNT} = $amount;
	return $this;
}

sub getId {
	my ($this) = @_;
	return $this->{ID};
}

sub getId_Model {
	my ($this) = @_;
	return $this->{ID_MODEL};
}

sub getId_Page {
	my ($this) = @_;
	return $this->{ID_PAGE};
}

sub getDate_Start {
	my ($this) = @_;
	return $this->{DATE_START};
}

sub getDate_End {
	my ($this) = @_;
	return $this->{DATE_END};
}

sub getAmount {
	my ($this) = @_;
	return $this->{AMOUNT};
}

sub setId {
	my ($this, $id) = @_;
	$this->{ID} = $id;
	return;
}

sub setId_Model {
	my ($this, $id_model) = @_;
	$this->{ID_MODEL} = $id_model;
	return;
}

sub setId_Page {
	my ($this, $id_page) = @_;
	$this->{ID_PAGE} = $id_page;
	return;
}

sub setDate_Start {
	my ($this, $date_start) = @_;
	$this->{DATE_START} = $date_start;
	return;
}

sub setDate_End {
	my ($this, $date_end) = @_;
	$this->{DATE_END} = $date_end;
	return;
}

sub setAmount {
	my ($this, $amount) = @_;
	$this->{AMOUNT} = $amount;
	return;
}

sub get {
	#Demande une instance de Costs en parametre
	my ($this,$dbh,$getcost) = @_;

	my $getid = $getcost->getId();
	my $getid_model = $getcost->getId_Model();
	my $getid_page = $getcost->getId_Page();
	my $getdate_start = $getcost->getDate_Start();
	my $getdate_end = $getcost->getDate_End();
	my $getamount = $getcost->getAmount();
	my $requete = "SELECT * FROM Costs ";
	my @costs = ();
	my $cost;

	if ($getid) {
		$requete = $requete . "WHERE id = " . $getid;
	}
	elsif($getid_model && $getid_page) {
		$requete = $requete . "WHERE id_model = " . $getid_model;
		$requete = $requete . "AND id_page = " . $getid_page;
	}
	elsif($getid_model) {
		$requete = $requete . "WHERE id_model = " . $getid_model;
	}
	elsif($getid_page) {
		$requete = $requete . "WHERE id_page = " . $getid_page;
	}

	$requete = $requete . " ;";

	print $requete."\n";

	my $prep = $dbh->prepare($requete) or die $dbh->errstr;
	$prep->execute() or die "Echec requête\n";

	if ($prep->rows > 1) {

		while (my ($id, $id_model, $id_page, $date_start, $date_end, $amount) = $prep->fetchrow_array ) {

			my $cost = new Costs($id, $id_model, $id_page, $date_start, $date_end, $amount);
			push(@costs, $cost);

		}

		return @costs;

	}
	elsif ($prep->rows == 1) {

		my ($id, $id_model, $id_page, $date_start, $date_end, $amount) = $prep->fetchrow_array;

		$cost = new Costs($id, $id_model, $id_page, $date_start, $date_end, $amount);

		return $cost;

	}
	else {

		return;

	}

}

sub create {
	#Demande une instance de Costs en parametre
	my ($this,$dbh,$getcost) = @_;

	my $getid_model = $getcost->getId_Model();
	my $getid_page = $getcost->getId_Page();
	my $getdate_start = $getcost->getDate_Start();
	my $getdate_end = $getcost->getDate_End();
	my $getamount = $getcost->getAmount();

	my $requete = "INSERT INTO Costs (id_model, id_page, date_start, amount) VALUES ($getid_model, $getid_page, '$getdate_start', $getamount); ";

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Insertion dans la table Costs : Effectué\n";

	return;
}

sub update {
	#Demande une instance de Costs en parametre
	my ($this,$dbh,$getcost) = @_;

	my $getid = $getcost->getId();
	my $getdate_end = $getcost->getDate_End();
	my $getamount = $getcost->getAmount();

	my $requete = "UPDATE Costs SET ";

	if($getdate_end) {
		$requete = $requete . "date_end = '$getdate_end' ";
	}
	elsif($getamount) {
		$requete = $requete . "amount = '$getamount' ";
	}

	$requete = $requete . "WHERE id = " . $getid;
	$requete = $requete . "AND date_end IS NULL ";

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Modification dans la table Costs($getid) : Effectué\n";

	return;
}

1;
