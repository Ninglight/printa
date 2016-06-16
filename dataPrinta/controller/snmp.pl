#!/usr/bin/perl
use strict;
use Net::Ping;
use IO::Socket;
use Net::Nslookup;
use DBI;

sub call_snmp {
    my ($action, $version, $nomPrt, $oid) = @_;

    my $res=`snmp$action -v $version -c public $nomPrt $oid`;

    if ($res !~ m/Timeout/ || $res !~ m/No Such/) {

        if($res){

            #Retrait du nom de la commande dans le résultat
            my @info = split (/:/,$res);
            $res = $info[3];
            chop $res;

            #Retrait de l'espace devant le nom
            $_ = reverse($res);
            chop($_);
            $res = reverse($_);

            #Split sur l'apostrophe afin d'obtenir des noms
            #my @info = split (/''/,$res);
            #$res = $info[3];
            #chop $res;

            chop $res;
            return $res;

        }
        else{

            return;

        }

    }
    else{

        print "Time Out ou No Such\n";
        return;

    }

}

1;
