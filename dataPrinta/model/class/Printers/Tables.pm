package Tables;
use strict;

sub new {
	my ($class,$name) = @_;
	my $this = {};
	bless($this, $class);
	$this->{NAME} = $name;
	return $this;
}

sub getName {
	my ($this) = @_;
	return $this->{NAME};
}

sub setName {
	my ($this, $name) = @_;
	$this->{NAME} = $name;
	return;
}

sub get {
	#Demande une instance de Tables en parametre
	my ($this,$dbh,$gettable) = @_;

	my $getname = $gettable->getName();

	my $requete = "SELECT tablename FROM pg_tables WHERE tablename = '" . $getname . "'";
	my $table;

	$requete = $requete . " ;";

	print $requete."\n";

	my $prep = $dbh->prepare($requete) or die $dbh->errstr;
	$prep->execute() or die "Echec requête\n";

	if ($prep->rows > 0) {

		my ($name) = $prep->fetchrow_array;

		$table = new Tables($name);

		return $table;

	}
	else {

		return;

	}

}

1;
