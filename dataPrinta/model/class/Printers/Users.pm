package Users;
use strict;

sub new {
	my ($class,$id,$num,$login,$name,$first_name) = @_;
	my $this = {};
	bless($this, $class);
	$this->{ID} = $id;
	$this->{NUMERO} = $num;
	$this->{LOGIN} = $login;
	$this->{NAME} = $name;
	$this->{FIRST_NAME} = $first_name;
	return $this;
}

sub getId {
	my ($this) = @_;
	return $this->{ID};
}

sub getNum {
	my ($this) = @_;
	return $this->{NUMERO};
}

sub getLogin {
	my ($this) = @_;
	return $this->{LOGIN};
}

sub getName {
	my ($this) = @_;
	return $this->{NAME};
}

sub getFirst_Name {
	my ($this) = @_;
	return $this->{FIRST_NAME};
}

sub setId {
	my ($this, $id) = @_;
	$this->{ID} = $id;
	return;
}

sub setNum {
	my ($this, $num) = @_;
	$this->{NUMERO} = $num;
	return;
}

sub setLogin {
	my ($this, $login) = @_;
	$this->{LOGIN} = $login;
	return;
}

sub setName {
	my ($this, $name) = @_;
	$this->{NAME} = $name;
	return;
}

sub setFirst_Name {
	my ($this, $first_name) = @_;
	$this->{FIRST_NAME} = $first_name;
	return;
}

sub get {
	#Demande une instance de Users en parametre
	my ($this,$dbh,$getuser) = @_;

	my $getid = $getuser->getId();
	my $getnum = $getuser->getNum();
	my $getlogin = $getuser->getLogin();
	my $getname = $getuser->getName();
	my $getfirst_name = $getuser->getFirst_Name();
	my $requete = "SELECT id, num, login, name, first_name FROM Users ";
	my @users = ();
	my $user;

	if ($getid) {
		$requete = $requete . "WHERE id = " . $getid;
	}
	elsif($getnum) {
		$requete = $requete . "WHERE num = " . $getnum;
	}
	elsif($getlogin) {
		$requete = $requete . "WHERE login = '" . $getlogin . "'";
	}

	$requete = $requete . " ;";

	print $requete."\n";

	my $prep = $dbh->prepare($requete) or die $dbh->errstr;
	$prep->execute() or die "Echec requête\n";

	if ($prep->rows > 1) {

		while (my ($id, $num, $login, $name, $first_name) = $prep->fetchrow_array ) {

			my $user = new Users($id, $num, $login, $name, $first_name);
			push(@users, $user);

		}

		return @users;

	}
	elsif($prep->rows == 1) {

		my ($id, $num, $login, $name, $first_name) = $prep->fetchrow_array;

		$user = new Users($id, $num, $login, $name, $first_name);

		return $user;

	}
	else {

		return;

	}

}

sub getIncrement {
	#Demande une instance de Users en parametre
	my ($this,$dbh,$user) = @_;

	my $requete = "SELECT MAX(num)+1 AS Increment FROM Users WHERE num BETWEEN 789999 AND 799999;";

	print $requete."\n";

	my $prep = $dbh->prepare($requete) or die $dbh->errstr;
	$prep->execute() or die "Echec requête\n";

	my $numincrement = $prep->fetchrow_array;

	$user->setNum($numincrement);

	print "Increment : $numincrement\n";

	return $user;
}

sub create {
	#Demande une instance de Users en parametre
	my ($this,$dbh,$getuser) = @_;

	my $getnum = $getuser->getNum();
	my $getname = $getuser->getName();
	my $getlogin = $getuser->getLogin();
	my $getfirst_name = $getuser->getFirst_Name();

	my $requete = "INSERT INTO Users (num, login, name, first_name) VALUES ($getnum, '$getlogin', '$getname', '$getfirst_name'); ";

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Insertion dans la table Users : Effectué\n";

	return;
}

sub update {
	#Demande une instance de Users en parametre
	my ($this,$dbh,$getuser) = @_;

	my $getid = $getuser->getId();
	my $getnum = $getuser->getNum();
	my $getlogin = $getuser->getLogin();
	my $getname = $getuser->getName();
	my $getfirst_name = $getuser->getFirst_Name();

	my $requete = "UPDATE Users SET login = '$getlogin', name = '$getname', first_name = '$getfirst_name' ";

	if ($getid) {
		$requete = $requete . ", num = " . $getnum;
		$requete = $requete . " WHERE id = " . $getid;
	}
	elsif($getnum) {
		$requete = $requete . "WHERE num = " . $getnum;
	}
	else{
		return;
	}

	print $requete."\n";

	my $statement = $dbh->prepare($requete) or die $dbh->errstr;
	$statement->execute() or die "Echec requête\n";

	print "Modification dans la table Users($getnum) : Effectué\n";

	return;
}

1;
