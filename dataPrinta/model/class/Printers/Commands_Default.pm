package Commands_Default;
use strict;

sub new {
	my ($class,$id,$id_action,$id_trademark,$id_oid,$id_model,$complement) = @_;
	my $this = {};
	bless($this, $class);
	$this->{ID} = $id;
	$this->{ID_ACTION} = $id_action;
	$this->{ID_TRADEMARK} = $id_trademark;
	$this->{ID_OID} = $id_oid;
	$this->{ID_MODEL} = $id_model;
	$this->{COMPLEMENT} = $complement;
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

sub getId_Trademark {
	my ($this) = @_;
	return $this->{ID_TRADEMARK};
}

sub getId_OID {
	my ($this) = @_;
	return $this->{ID_OID};
}

sub getId_Model {
	my ($this) = @_;
	return $this->{ID_MODEL};
}

sub getComplement {
	my ($this) = @_;
	return $this->{COMPLEMENT};
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

sub setId_Trademark {
	my ($this, $id_trademark) = @_;
	$this->{ID_TRADEMARK} = $id_trademark;
	return;
}

sub setId_OID {
	my ($this, $id_oid) = @_;
	$this->{ID_OID} = $id_oid;
	return;
}

sub setId_Model {
	my ($this, $id_model) = @_;
	$this->{ID_MODEL} = $id_model;
	return;
}

sub setComplement {
	my ($this, $complement) = @_;
	$this->{COMPLEMENT} = $complement;
	return;
}



sub get {
	#Demande une instance de Commands_Default en parametre
	my ($this,$dbh,$getcommand_default) = @_;

	my $getid = $getcommand_default->getId();
	my $getid_action = $getcommand_default->getId_Action();
	my $getid_trademark = $getcommand_default->getId_Trademark();
	my $getid_oid = $getcommand_default->getId_OID();
	my $getid_model = $getcommand_default->getId_Model();
	my $getcomplement = $getcommand_default->getComplement();
	my $requete = "SELECT * FROM Commands_Default ";
	my @commands = ();
	my $command;

	if ($getid) {
		$requete = $requete . "WHERE id = " . $getid;
	}
	elsif($getid_trademark) {
		$requete = $requete . "WHERE id_trademark = " . $getid_trademark;

		if($getid_action) {
			$requete = $requete . "AND id_action = " . $getid_action;
		}
	}

	$requete = $requete . " ;";

	print $requete."\n";

	my $prep = $dbh->prepare($requete) or die $dbh->errstr;
	$prep->execute() or die "Echec requête\n";

	if ($prep->rows > 1) {

		while (my ($id,$id_action,$id_trademark,$id_oid,$id_model,$complement) = $prep->fetchrow_array ) {

			my $command = new Commands($id,$id_action,$id_trademark,$id_oid,$id_model,$complement);
			push(@commands, $command);

		}

		return @commands;

	}
	else {

		return;

	}

}

sub create {
	#Demande une instance de Commands_Default en parametre
	my ($this,$dbh,$getcommand_default) = @_;

	my $getid_action = $getcommand_default->getId_Action();
	my $getid_trademark = $getcommand_default->getId_Trademark();
	my $getid_oid = $getcommand_default->getId_OID();
	my $getid_model = $getcommand_default->getId_Model();
	my $getcomplement = $getcommand_default->getComplement();

	my $requete = "INSERT INTO Commands_Default (id_action, id_trademark, id_oid, id_model, complement) VALUES ($getid_action, $getid_trademark, $getid_oid, $getid_model, '$getcomplement'); ";

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Insertion dans la table Commands_Default : Effectué\n";

	return;
}

sub update {
	#Demande une instance de Commands_Default en parametre
	my ($this,$dbh,$getcommand_default) = @_;

	my $getid = $getcommand_default->getId();
	my $getid_action = $getcommand_default->getId_Action();
	my $getid_trademark = $getcommand_default->getId_Trademark();
	my $getid_oid = $getcommand_default->getId_OID();
	my $getid_model = $getcommand_default->getId_Model();
	my $getcomplement = $getcommand_default->getComplement();

	my $requete = "UPDATE Commands_Default SET id_action = '$getid_action', id_trademark = '$getid_trademark', id_oid='$getid_oid', id_model='$getid_model', complement='$getcomplement' WHERE id = " . $getid;

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Modification dans la table Commands_Default($getid_action, $getid_trademark, $getid_oid) : Effectué\n";

	return;
}

1;
