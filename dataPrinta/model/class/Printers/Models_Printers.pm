package Models_Printers;
use strict;

sub new {
	my ($class,$id_printer,$id_model,$date_start,$date_end) = @_;
	my $this = {};
	bless($this, $class);
	$this->{ID_PRINTER} = $id_printer;
	$this->{ID_MODEL} = $id_model;
	$this->{DATE_START} = $date_start;
	$this->{DATE_END} = $date_end;
	return $this;
}

sub getId_Printer {
	my ($this) = @_;
	return $this->{ID_PRINTER};
}

sub getId_Model {
	my ($this) = @_;
	return $this->{ID_MODEL};
}

sub getDate_Start {
	my ($this) = @_;
	return $this->{DATE_START};
}

sub getDate_End {
	my ($this) = @_;
	return $this->{DATE_END};
}

sub setId_Printer {
	my ($this, $id_printer) = @_;
	$this->{ID_PRINTER} = $id_printer;
	return;
}

sub setId_Model {
	my ($this, $id_model) = @_;
	$this->{ID_MODEL} = $id_model;
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
	#Demande une instance de Models_Printers en parametre
	my ($this,$dbh,$getmodel_printer) = @_;

	my $getid_printer = $getmodel_printer->getId_Printer();
	my $getid_model = $getmodel_printer->getId_Model();
	my $getdate_start = $getmodel_printer->getDate_Start();
	my $getdate_end = $getmodel_printer->getDate_End();
	my $requete = "SELECT * FROM Models_Printers WHERE date_end IS NULL ";
	my @models_printers = ();
	my $model_printer;

	if($getid_printer) {
		$requete = $requete . "AND id_printer = " . $getid_printer;
	}
	if($getid_model) {
		$requete = $requete . "AND id_model = " . $getid_model;
	}



	$requete = $requete . " ;";

	print $requete."\n";

	my $prep = $dbh->prepare($requete) or die $dbh->errstr;
	$prep->execute() or die "Echec requête\n";

	if ($prep->rows > 1) {

		while (my ($id_printer, $id_model, $date_start, $date_end) = $prep->fetchrow_array ) {

			my $model_printer = new Models_Printers($id_printer, $id_model, $date_start, $date_end);
			push(@models_printers, $model_printer);

		}

		return @models_printers;

	}
	elsif ($prep->rows == 1) {

		my ($id_printer, $id_model, $date_start, $date_end) = $prep->fetchrow_array;

		$model_printer = new Models_Printers($id_printer, $id_model, $date_start, $date_end);

		return $model_printer;

	}
	else {

		return;

	}

}

sub create {
	#Demande une instance de Models_Printers en parametre
	my ($this,$dbh,$getmodel_printer) = @_;

	my $getid_printer = $getmodel_printer->getId_Printer();
	my $getid_model = $getmodel_printer->getId_Model();
	my $getdate_start = $getmodel_printer->getDate_Start();

	my $requete = "INSERT INTO Models_Printers (id_printer, id_model, date_start) VALUES ($getid_printer, $getid_model, '$getdate_start'); ";

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Insertion dans la table Models_Printers : Effectué\n";

	return;
}

sub update {
	#Demande une instance de Models_Printers en parametre
	my ($this,$dbh,$getmodel_printer) = @_;

	my $getid_printer = $getmodel_printer->getId_Printer();
	my $getid_model = $getmodel_printer->getId_Model();
	my $getdate_end = $getmodel_printer->getDate_End();

	my $requete = "UPDATE Models_Printers SET date_end = '$getdate_end' WHERE date_end IS NULL ";

	if($getid_printer) {
		$requete = $requete . "AND id_printer = " . $getid_printer;
	}

	if($getid_model) {
		$requete = $requete . "AND id_model = " . $getid_model;
	}

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Modification dans la table Models_Printers($getid_printer, $getid_model) : Effectué\n";

	return;
}
1;
