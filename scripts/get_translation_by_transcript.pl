use warnings;
use strict;

use Bio::EnsEMBL::DBSQL::DBAdaptor;
use Getopt::Long;
use Pod::Usage qw(pod2usage);

my ($host, $port, $user, $pass, $dbname, $species, $stable_id);

# defaults
my $help = 0;

&GetOptions(
  'host=s'      => \$host,
  'port=s'      => \$port,
  'user=s'      => \$user,
  'pass=s'      => \$pass,
  'dbname=s'    => \$dbname,
  'species=s'   => \$species,
  'transcript_id=s'        => \$stable_id,

  'help|?'      => \$help,
) or pod2usage(-message => "use -help", -verbose => 1);

pod2usage(-verbose => 2) if $help;

my $add_species_id = 1 if ($species);

my $core_db = new Bio::EnsEMBL::DBSQL::DBAdaptor(
    -host => $host,
    -user => $user,
    -port => $port,
    -dbname => $dbname,
    -species => $species,
    #-multispecies_db => 1,
    -add_species_id => $add_species_id,
  );

die "unable to open core_db. exiting...\n" if (!$core_db);

#$core_db->species_id(235);
warn  "species: ", $core_db->species, ", species_id: ", $core_db->species_id, "\n";

my $ta = $core_db->get_adaptor("Transcript");
die "unable to get transcript aptor. exiting...\n" if (!$ta);

my $t = $ta->fetch_by_stable_id($stable_id);
die "unable to get transcript object. exiting...\n" if (!$t);

my $translation= $t->translation();
die "no translation for $stable_id. exiting...n" if (!$translation);

print $stable_id, "\t", $translation->seq, "\n" if ($translation);

