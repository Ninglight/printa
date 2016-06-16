package Commands;
use strict;

sub new {
	my ($class,$id,$id_action,$id_model,$id_oid) = @_;
	my $this = {};
	bless($this, $class);
	$this->{ID} = $id;
	$this->{ID_ACTION} = $id_action;
	$this->{ID_MODEL} = $id_model;
	$this->{ID_OID} = $id_oid;
	return $this;
}

sub getId {
	my ($this) = @_;
	return $this->{ID};
}

sub getId_Action {
	my ($this) = @_;
	return $this->{ID_ACTION};
}

sub getId_Model {
	my ($this) = @_;
	return $this->{ID_MODEL};
}

sub getId_OID {
	my ($this) = @_;
	return $this->{ID_OID};
}

sub setId {
	my ($this, $id) = @_;
	$this->{ID} = $id;
	return;
}

sub setId_Action {
	my ($this, $id_action) = @_;
	$this->{ID_ACTION} = $id_action;
	return;
}

sub setId_Model {
	my ($this, $id_model) = @_;
	$this->{ID_MODEL} = $id_model;
	return;
}

sub setId_OID {
	my ($this, $id_oid) = @_;
	$this->{ID_OID} = $id_oid;
	return;
}

sub get {
	#Demande une instance de Commands en parametre
	my ($this,$dbh,$getcommand) = @_;

	my $getid = $getcommand->getId();
	my $getid_action = $getcommand->getId_Action();
	my $getid_model = $getcommand->getId_Model();
	my $getid_oid = $getcommand->getId_OID();
	my $requete = "SELECT * FROM Commands ";
	my @commands = ();
	my $command;

	if ($getid) {
		$requete = $requete . "WHERE id = " . $getid;
	}
	elsif($getid_action) {
		$requete = $requete . "WHERE id_action = " . $getid_action;

		if($getid_model) {
			$requete = $requete . " AND id_model = " . $getid_model;
		}
		if($getid_oid) {
			$requete = $requete . " AND id_oid = " . $getid_oid;
		}
	}
	elsif($getid_model) {
		$requete = $requete . "WHERE id_model = " . $getid_model;

		if($getid_oid) {
			$requete = $requete . " AND id_oid = " . $getid_oid;
		}

	}

	$requete = $requete . " ;";

	print $requete."\n";

	my $prep = $dbh->prepare($requete) or die $dbh->errstr;
	$prep->execute() or die "Echec requête\n";

	if ($prep->rows > 1) {

		while (my ($id, $id_action, $id_model, $id_oid) = $prep->fetchrow_array ) {

			my $command = new Commands($id, $id_action, $id_model, $id_oid);
			push(@commands, $command);

		}

		return @commands;

	}
	elsif ($prep->rows == 1) {

		my ($id, $id_action, $id_model, $id_oid) = $prep->fetchrow_array;

		$command = new Commands($id, $id_action, $id_model, $id_oid);

		return $command;

	}
	else {

		return;

	}

}

sub create {
	#Demande une instance de Commands en parametre
	my ($this,$dbh,$getcommand) = @_;

	my $getid_action = $getcommand->getId_Action();
	my $getid_model = $getcommand->getId_Model();
	my $getid_oid = $getcommand->getId_OID();

	my $requete = "INSERT INTO Commands (id_action, id_model, id_oid) VALUES ($getid_action, $getid_model, $getid_oid); ";

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Insertion dans la table Commands : Effectué\n";

	return;
}

sub update {
	#Demande une instance de Commands en parametre
	my ($this,$dbh,$getcommand) = @_;

	my $getid = $getcommand->getId();
	my $getid_action = $getcommand->getId_Action();
	my $getid_model = $getcommand->getId_Model();
	my $getid_oid = $getcommand->getId_OID();

	my $requete = "UPDATE Commands SET id_action = '$getid_action', id_model = '$getid_model', id_oid = '$getid_oid' WHERE id = " . $getid;

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Modification dans la table Commands($getid_action, $getid_model, $getid_oid) : Effectué\n";

	return;
}

1;
