package Users_Structures;
use strict;

sub new {
	my ($class,$id_user,$id_structure,$date_start,$date_end) = @_;
	my $this = {};
	bless($this, $class);
	$this->{ID_USER} = $id_user;
	$this->{ID_STRUCTURE} = $id_structure;
	$this->{DATE_START} = $date_start;
	$this->{DATE_END} = $date_end;
	return $this;
}

sub getId_User {
	my ($this) = @_;
	return $this->{ID_USER};
}

sub getId_Structure {
	my ($this) = @_;
	return $this->{ID_STRUCTURE};
}

sub getDate_Start {
	my ($this) = @_;
	return $this->{DATE_START};
}

sub getDate_End {
	my ($this) = @_;
	return $this->{DATE_END};
}

sub setId_User {
	my ($this, $id_user) = @_;
	$this->{ID_USER} = $id_user;
	return;
}

sub setId_Structure {
	my ($this, $id_structure) = @_;
	$this->{ID_STRUCTURE} = $id_structure;
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

sub get {
	#Demande une instance de Users_Structures en parametre
	my ($this,$dbh,$getuser_structure) = @_;

	my $getid_user = $getuser_structure->getId_User();
	my $getid_structure = $getuser_structure->getId_Structure();
	my $getdate_start = $getuser_structure->getDate_Start();
	my $getdate_end = $getuser_structure->getDate_End();
	my $requete = "SELECT * FROM Users_Structures WHERE date_end IS NULL";
	my @users_structures = ();
	my $user_structure;

	if($getid_user) {
		$requete = $requete . " AND id_user = " . $getid_user;
	}

	if($getid_structure) {
		$requete = $requete . " AND id_structure = " . $getid_structure;
	}

	$requete = $requete . " ;";

	print $requete."\n";

	my $prep = $dbh->prepare($requete) or die $dbh->errstr;
	$prep->execute() or die "Echec requête\n";

	if ($prep->rows > 1) {

		while (my ($id_user, $id_structure, $date_start, $date_end) = $prep->fetchrow_array ) {

			my $user_structure = new Users_Structures($id_user, $id_structure, $date_start, $date_end);
			push(@users_structures, $user_structure);

		}

		return @users_structures;

	}
	elsif ($prep->rows == 1) {

		my ($id_user, $id_structure, $date_start, $date_end) = $prep->fetchrow_array;

		$user_structure = new Users_Structures($id_user, $id_structure, $date_start, $date_end);

		return $user_structure;

	}
	else {

		return;

	}

}

sub create {
	#Demande une instance de Users_Structures en parametre
	my ($this,$dbh,$getuser_structure) = @_;

	my $getid_user = $getuser_structure->getId_User();
	my $getid_structure = $getuser_structure->getId_Structure();
	my $getdate_start = $getuser_structure->getDate_Start();

	my $requete = "INSERT INTO Users_Structures (id_user, id_structure, date_start) VALUES ($getid_user, $getid_structure, '$getdate_start'); ";

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Insertion dans la table Users_Structures : Effectué\n";

	return;
}

sub update {
	#Demande une instance de Users_Structures en parametre
	my ($this,$dbh,$getuser_structure) = @_;

	my $getid_user = $getuser_structure->getId_User();
	my $getid_structure = $getuser_structure->getId_Structure();
	my $getdate_end = $getuser_structure->getDate_End();

	my $requete = "UPDATE Users_Structures SET date_end = '$getdate_end' ";
	$requete = $requete . "WHERE id_user = " . $getid_user;
	$requete = $requete . "AND id_structure = " . $getid_structure;
	$requete = $requete . "AND date_end IS NULL ";

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Modification dans la table Users_Structures($getid_user, $getid_structure) : Effectué\n";

	return;
}

1;
