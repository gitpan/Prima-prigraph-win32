use strict;
use Config;

my $lib1 = "$Config{installsitelib}\\auto\\Prima";
my $lib2 = "$Config{installsitelib}\\Prima\\prigraph";

my $version;
open F, 'win32.pm';
while (<F>) {
	next unless /VERSION\s*=\s*\'([\d\.]+)\'/;
	$version = $1;
}
close F;
die "Cannot determine version from win32.pm\n"
	unless defined $version;
$version = "Prima-prigraph-win32-$version";

open F, "< MANIFEST" or die "Cannot open MANIFEST:$!\n";
my @F     = <F>;
my $dist_files_copy = join("\n\t", map { chomp; "copy /b $_ $version"} @F);
my $dist_files_rm   = join("\n\t", map { chomp; "del $version\\$_" } @F);
close F;

open F, "> Makefile" or die "Cannot open Makefile:$!\n";
print F <<MAKEFILE;
all:

$lib1:
	mkdir $lib1

$lib2:
	mkdir $lib2

install: $lib1 $lib2
	copy /b prigraph.dll $lib1
	copy /b prigraph.lib $lib1
	copy /b libprigraph.a $lib1
	copy win32.pm $lib2

deinstall:
	del $lib1\\prigraph.dll
	del $lib1\\prigraph.lib
	del $lib1\\libprigraph.a
	del $lib2\\win32.pm
	rmdir $lib1
	rmdir $lib2

dist:
	mkdir $version
	$dist_files_copy
	zip -r $version.zip $version
	$dist_files_rm
	rmdir $version

test:
MAKEFILE
close F;
