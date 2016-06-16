package Counter;
use strict;

require "model/class/Subroutine.pm";

sub new {
	my ($class,$id,$id_printer,$date_counter,$quantity,$id_page) = @_;
	my $this = {};
	bless($this, $class);
	$this->{ID} = $id;
	$this->{ID_PRINTER} = $id_printer;
	$this->{DATE_COUNTER} = $date_counter;
	$this->{QUANTITY} = $quantity;
	$this->{ID_PAGE} = $id_page;
	return $this;
}

sub getId {
	my ($this) = @_;
	return $this->{ID};
}

sub getId_Printer {
	my ($this) = @_;
	return $this->{ID_PRINTER};
}

sub getDate_Counter {
	my ($this) = @_;
	return $this->{DATE_COUNTER};
}

sub getQuantity {
	my ($this) = @_;
	return $this->{QUANTITY};
}

sub getId_Page {
	my ($this) = @_;
	return $this->{ID_PAGE};
}

sub setId {
	my ($this, $id) = @_;
	$this->{ID} = $id;
	return;
}

sub setId_Printer {
	my ($this, $id_printer) = @_;
	$this->{ID_PRINTER} = $id_printer;
	return;
}

sub setDate_Counter {
	my ($this, $date_counter) = @_;
	$this->{DATE_COUNTER} = $date_counter;
	return;
}

sub setQuantity {
	my ($this, $quantity) = @_;
	$this->{QUANTITY} = $quantity;
	return;
}

sub setId_Page {
	my ($this, $id_page) = @_;
	$this->{ID_PAGE} = $id_page;
	return;
}



sub get {
	#Demande une instance de Counter en parametre
	my ($this,$dbh,$getcounter) = @_;

	my $getid = $getcounter->getId();
	my $getid_printer = $getcounter->getId_Printer();
	my $getdate_counter = $getcounter->getDate_Counter();
	my $getquantity = $getcounter->getQuantity();
	my $getid_page = $getcounter->getId_Page();

	# On decompose la date d'impression
	my $year = Subroutine::getYearCounter($getdate_counter);

	my $requete = "SELECT * FROM Counter$year ";
	my @counters = ();
	my $counter;

	if ($getid){
		$requete = $requete . "WHERE id = " . $getid;
	}
	elsif($getid_printer){
		$requete = $requete . "WHERE id_printer = " . $getid_printer;
	}
	elsif($getid_page){
		$requete = $requete . "WHERE id_page = " . $getid_page;
	}

	$requete = $requete . " ;";

	print $requete."\n";

	my $prep = $dbh->prepare($requete) or die $dbh->errstr;
	$prep->execute() or die "Echec requête\n";

	if ($prep->rows > 1){

		while (my ($id, $id_printer, $date_counter, $quantity, $id_page) = $prep->fetchrow_array ) {

			my $counter = new Counter($id, $id_printer, $date_counter, $quantity, $id_page);
			push(@counters, $counter);

		}

		return @counters;

	}
	elsif ($prep->rows == 1) {

		my ($id, $id_printer, $date_counter, $quantity, $id_page) = $prep->fetchrow_array;

		$counter = new Counter($id, $id_printer, $date_counter, $quantity, $id_page);

		return $counter;

	}
	else {

		return;

	}

}

sub create {
	#Demande une instance de Counter en parametre
	my ($this,$dbh,$getcounter) = @_;

	my $getid_printer = $getcounter->getId_Printer();
	my $getdate_counter = $getcounter->getDate_Counter();
	my $getquantity = $getcounter->getQuantity();
	my $getid_page = $getcounter->getId_Page();

	# On decompose la date d'impression
	my $year = Subroutine::getYearCounter($getdate_counter);

	my $requete = "INSERT INTO Counter$year (id_printer, date_counter, quantity, id_page) VALUES ($getid_printer, '$getdate_counter', $getquantity, $getid_page); ";

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Insertion dans la table Counter$year : Effectué\n";

	return;
}

sub create_table {
	my ($this,$dbh,$year) = @_;

	$year = int($year);

	my $requete = <<"SQL";
	CREATE TABLE Counter$year (
		id SERIAL PRIMARY KEY,
		id_printer int REFERENCES Printers(id),
		date_counter timestamp,
		quantity int,
		id_page int REFERENCES Pages(id)
	);

SQL

	print $requete."\n";

	my $statement = $dbh->prepare($requete);
	$statement->execute();

	print "Création de la table Counter$year : Effectué\n";

	return;
}

sub update {
	#Demande une instance de Counter en parametre
	my ($this,$dbh,$getcounter) = @_;

	my $getid = $getcounter->getId();
	my $getid_printer = $getcounter->getId_Printer();
	my $getdate_counter = $getcounter->getDate_Counter();
	my $getquantity = $getcounter->getQuantity();
	my $getid_page = $getcounter->getId_Page();

	# On decompose la date d'impression
	my $year = Subroutine::getYearCounter($getdate_counter);

	my $requete = "UPDATE Counter$year SET ";

	if($getid_printer){
		$requete = $requete . "id_printer = '$getid_printer' ";
	}
	elsif($getdate_counter){
		$requete = $requete . "date_counter = '$getdate_counter' ";
	}
	elsif($getquantity){
		$requete = $requete . "quantity = '$getquantity' ";
	}
	elsif($getid_page){
		$requete = $requete . "id_page = '$getid_page' ";
	}

	$requete = $requete . "WHERE id = " . $getid;

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Modification dans la table Counter$year($getid) : Effectué\n";

	return;
}


1;
