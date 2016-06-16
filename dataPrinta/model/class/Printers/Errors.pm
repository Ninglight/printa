package Errors;
use strict;

sub new {
	my ($class,$id,$id_typeerror,$table_target,$column_target,$var_info, $date_error) = @_;
	my $this = {};
	bless($this, $class);
	$this->{ID} = $id;
	$this->{ID_TYPEERROR} = $id_typeerror;
	$this->{TABLE_TARGET} = $table_target;
	$this->{COLUMN_TARGET} = $column_target;
	$this->{VAR_INFO} = $var_info;
	$this->{DATE_ERROR} = $date_error;
	return $this;
}

sub getId {
	my ($this) = @_;
	return $this->{ID};
}

sub getId_TypeError {
	my ($this) = @_;
	return $this->{ID_TYPEERROR};
}

sub getTable_Target {
	my ($this) = @_;
	return $this->{TABLE_TARGET};
}

sub getColumn_Target {
	my ($this) = @_;
	return $this->{COLUMN_TARGET};
}

sub getVar_Info {
	my ($this) = @_;
	return $this->{VAR_INFO};
}

sub getDate_Error {
	my ($this) = @_;
	return $this->{DATE_ERROR};
}

sub setId {
	my ($this, $id) = @_;
	$this->{ID} = $id;
	return;
}

sub setId_TypeError {
	my ($this, $id_typeerror) = @_;
	$this->{CODE} = $id_typeerror;
	return;
}

sub setTable_Target {
	my ($this, $table_target) = @_;
	$this->{ID_INFO} = $table_target;
	return;
}

sub setColumn_Target {
	my ($this, $column_target) = @_;
	$this->{COLUMN_TARGET} = $column_target;
	return;
}

sub setVar_Info {
	my ($this, $var_info) = @_;
	$this->{VAR_INFO} = $var_info;
	return;
}

sub setDate_Error {
	my ($this, $date_error) = @_;
	$this->{DATE_ERROR} = $date_error;
	return;
}

sub get {
	#Demande une instance de Errors en parametre
	my ($this,$dbh,$geterror) = @_;

	my $getid = $geterror->getId();
	my $getid_typeerror = $geterror->getId_TypeError();
	my $gettable_target = $geterror->getTable_Target();
	my $getcolumn_target = $geterror->getColumn_Target();
	my $getvar_info = $geterror->getVar_Info();
	my $getdate_error = $geterror->getDate_Error();
	my $requete = "SELECT * FROM Errors ";
	my @errors = ();
	my $error;

	if ($getid) {
		$requete = $requete . "WHERE id = " . $getid;
	}
	elsif($getid_typeerror) {
		$requete = $requete . "WHERE id_typeerror = " . $getid_typeerror;
	}
	elsif($gettable_target) {
		$requete = $requete . "WHERE table_target = " . $gettable_target;
	}

	if ($getid_typeerror) {
		$requete = $requete . " AND id_typeerror = " . $getid_typeerror;
	}
	if ($gettable_target) {
		$requete = $requete . " AND table_target = '" . $gettable_target . "'";
	}
	if ($getcolumn_target) {
		$requete = $requete . " AND column_target = '" . $getcolumn_target . "'";
	}
	if($getvar_info) {
		$requete = $requete . " AND var_info = '" . $getvar_info . "'";
	}
	if($getdate_error) {
		$requete = $requete . " AND date_error = '" . $getdate_error . "'";
	}

	$requete = $requete . " ;";

	print $requete."\n";

	my $prep = $dbh->prepare($requete) or die $dbh->errstr;
	$prep->execute() or die "Echec requête\n";

	if ($prep->rows > 1) {

		while (my ($id,$id_typeerror,$table_target,$column_target,$var_info, $date_error) = $prep->fetchrow_array ) {

			my $error = new Errors($id,$id_typeerror,$table_target,$column_target,$var_info, $date_error);
			push(@errors, $error);

		}

		return @errors;

	}
	elsif ($prep->rows == 1) {

		my ($id,$id_typeerror,$table_target,$column_target,$var_info, $date_error) = $prep->fetchrow_array;

		$error = new Errors($id,$id_typeerror,$table_target,$column_target,$var_info, $date_error);

		return $error;

	}
	else {

		return;

	}

}

sub create {
	#Demande une instance de Errors en parametre
	my ($this,$dbh,$geterror) = @_;

	my $getid_typeerror = $geterror->getId_TypeError();
	my $gettable_target = $geterror->getTable_Target();
	my $getcolumn_target = $geterror->getColumn_Target();
	my $getvar_info = $geterror->getVar_Info();
	my $getdate_error = $geterror->getDate_Error();

	my $requete = "INSERT INTO Errors (id_typeerror,table_target,column_target,var_info,date_error) VALUES ($getid_typeerror, '$gettable_target', '$getcolumn_target', '$getvar_info', '$getdate_error'); ";

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Insertion dans la table Errors : Effectué\n";

	return;
}

sub update {
	#Demande une instance de errors en parametre
	my ($this,$dbh,$geterror) = @_;

	my $getid = $geterror->getId();
	my $getid_typeerror = $geterror->getId_TypeError();
	my $gettable_target = $geterror->getTable_Target();
	my $getcolumn_target = $geterror->getColumn_Target();
	my $getvar_info = $geterror->getVar_Info();
	my $getdate_error = $geterror->getDate_Error();

	my $requete = "UPDATE Errors SET ";

	if($getid_typeerror) {
		$requete = $requete . "id_typeerror = '$getid_typeerror' ";
	}
	elsif($gettable_target) {
		$requete = $requete . "table_target = '$gettable_target' ";
	}
	elsif($getcolumn_target) {
		$requete = $requete . "column_target = '$getcolumn_target' ";
	}
	elsif($getvar_info) {
		$requete = $requete . "var_info = '$getvar_info' ";
	}
	elsif($getdate_error) {
		$requete = $requete . "date_error = '$getdate_error' ";
	}

	if ($getid) {
		$requete = $requete . "WHERE id = " . $getid;
	}
	else {
		return;
	}

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Modification dans la table Errors($getid) : Effectué\n";

	return;
}

1;
