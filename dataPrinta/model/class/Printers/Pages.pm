package Pages;
use strict;

sub new {
	my ($class,$id,$id_type,$id_format,$id_side,$id_color) = @_;
	my $this = {};
	bless($this, $class);
	$this->{ID} = $id;
	$this->{ID_TYPE} = $id_type;
	$this->{ID_FORMAT} = $id_format;
	$this->{ID_SIDE} = $id_side;
	$this->{ID_COLOR} = $id_color;
	return $this;
}

sub getId {
	my ($this) = @_;
	return $this->{ID};
}

sub getId_Type {
	my ($this) = @_;
	return $this->{ID_TYPE};
}

sub getId_Format {
	my ($this) = @_;
	return $this->{ID_FORMAT};
}

sub getId_Side {
	my ($this) = @_;
	return $this->{ID_SIDE};
}

sub getId_Color {
	my ($this) = @_;
	return $this->{ID_COLOR};
}

sub setId {
	my ($this, $id) = @_;
	$this->{ID} = $id;
	return;
}

sub setId_Type {
	my ($this, $id_type) = @_;
	$this->{ID_TYPE} = $id_type;
	return;
}

sub setId_Format {
	my ($this, $id_format) = @_;
	$this->{ID_FORMAT} = $id_format;
	return;
}

sub setId_Side {
	my ($this, $id_side) = @_;
	$this->{ID_SIDE} = $id_side;
	return;
}

sub setId_Color {
	my ($this, $id_color) = @_;
	$this->{ID_COLOR} = $id_color;
	return;
}


sub get {
	#Demande une instance de Page en parametre
	my ($this,$dbh,$getpage) = @_;

	my $getid = $getpage->getId();
	my $getid_type = $getpage->getId_Type();
	my $getid_format = $getpage->getId_Format();
	my $getid_side = $getpage->getId_Side();
	my $getid_color = $getpage->getId_Color();
	my $requete = "SELECT * FROM Pages ";
	my @pages = ();
	my $page;

	if ($getid) {
		$requete = $requete . "WHERE id = " . $getid;
	}
	elsif($getid_type) {
		$requete = $requete . "WHERE id_type = " . $getid_type;
	}

	if($getid_format) {
		$requete = $requete . " AND id_format = " . $getid_format;
	} else {
		$requete = $requete . " AND id_format IS NULL ";
	}

	if ($getid_side) {
		$requete = $requete . " AND id_side = " . $getid_side;
	} else {
		$requete = $requete . " AND id_side IS NULL ";
	}

	if($getid_color) {
		$requete = $requete . " AND id_color = " . $getid_color;
	} else {
		$requete = $requete . " AND id_color IS NULL ";
	}

	$requete = $requete . " ;";

	print $requete."\n";

	my $prep = $dbh->prepare($requete) or die $dbh->errstr;
	$prep->execute() or die "Echec requête\n";

	if ($prep->rows > 1) {

		while (my ($id, $id_type, $id_format, $id_side, $id_color) = $prep->fetchrow_array ) {

			my $page = new Pages($id, $id_type, $id_format, $id_side, $id_color);
			push(@pages, $page);

		}

		return @pages;

	}
	elsif ($prep->rows == 1) {

		my ($id, $id_type, $id_format, $id_side, $id_color) = $prep->fetchrow_array;

		$page = new Pages($id, $id_type, $id_format, $id_side, $id_color);

		return $page;

	}
	else {

		return;

	}

}

sub create {
	#Demande une instance de Pages en parametre
	my ($this,$dbh,$getpage) = @_;

	my $getid_format = $getpage->getId_Format();
	my $getid_side = $getpage->getId_Side();
	my $getid_color = $getpage->getId_Color();
	my $getid_type = $getpage->getId_Type();

	my $requete = "INSERT INTO Pages (id_type, id_format, id_side, id_color) VALUES ($getid_type, $getid_format, $getid_side, $getid_color); ";

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Insertion dans la table Pages : Effectué\n";

	return;
}

sub update {
	#Demande une instance de Pages en parametre
	my ($this,$dbh,$getpage) = @_;

	my $getid = $getpage->getId();
	my $getid_format = $getpage->getId_Format();
	my $getid_side = $getpage->getId_Side();
	my $getid_color = $getpage->getId_Color();
	my $getid_type = $getpage->getId_Type();

	my $requete = "UPDATE Pages SET id_type = '$getid_type', id_format = '$getid_format', id_side = '$getid_side', id_color = '$getid_color' WHERE id = " . $getid;

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Modification dans la table Pages($getid_type, $getid_format, $getid_side, $getid_color) : Effectué\n";

	return;
}


1;
