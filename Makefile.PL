# $Id: Makefile.PL,v 1.3 2004/06/07 13:32:30 dk Exp $
use strict;
use Config;
use ExtUtils::Packlist;

warn "** This package is for win32 installation only!\n" unless $^O =~ /win32|cygwin/i;

open F, "<MANIFEST" or die "Cannot read MANIFEST:$!\n";
my @manifest = <F>;
chomp for @manifest;
close F;

my ( $NAME, $VERSION);

open F, ">Makefile" or die "Cannot write Makefile:$!\n";

$NAME = 'Prima-prigraph-win32';
$VERSION = '1.00';
my $lib = "$Config{archlibexp}/CORE";
my $dll = $Config{installsitebin} || $Config{installbin};
my $arch = "$Config{installsitearch}/$NAME";

my $packlist = ExtUtils::Packlist-> new();
$packlist->{"$dll/prigraph.dll"}++;
$packlist->{"$lib/$_"}++ for 'prigraph.lib', 'prigraph.def', 'libprigraph.a';
$packlist->write('.packlist');


$lib =~ s/\//\\/g;
$dll =~ s/\//\\/g;
$arch =~ s/\//\\/g;

$VERSION =~ /^(\d+)\.(\d+)$/;
my ( $V1, $V2) = ( $1, $2);

print F <<MAKE;
#
# NAME => q[Prima::prigraph::win32]
# VERSION_FROM => q[Makefile.PL]
#
CP=copy /b 
DIST=$NAME-$VERSION

all:

test:

clean:

ppd:
\t\@$^X -e "print qq{<SOFTPKG NAME=\\"$NAME\\" VERSION=\\"$V1,$V2,0,0\\">\\n}. qq{\\t<TITLE>Prima prigraph for win32</TITLE>\\n}. qq{\\t<ABSTRACT>Default image codec for Prima</ABSTRACT>\\n}. qq{\\t<AUTHOR>Dmitry Karasik</AUTHOR>\\n}. qq{\\t<IMPLEMENTATION>\\n}. qq{\\t\\t<OS NAME=\\"$^O\\" />\\n}. qq{\\t\\t<ARCHITECTURE NAME=\\"$Config{myarchname}\\" />\\n}. qq{\\t\\t<CODEBASE HREF=\\"http://www.prima.eu.org/download/gbm-bin-win32.tar.gz\\" />\\n}. qq{\\t</IMPLEMENTATION>\\n}. qq{</SOFTPKG>\\n}" > $NAME.ppd

dist:
\t\@mkdir \$(DIST)
\t\@cp @manifest \$(DIST)
\t\@tar cf - \$(DIST) | gzip > \$(DIST).tar.gz
\t\@rm -rf \$(DIST)

install:
\t\@\$(CP) prigraph.dll $dll
\t\@\$(CP) prigraph.lib $lib
\t\@\$(CP) prigraph.def $lib
\t\@\$(CP) libprigraph.a $lib
\t\@mkdir $arch
\t\@\$(CP) .packlist $arch

deinstall:
\t\@del /f $dll\\prigraph.dll
\t\@del /f $lib\\prigraph.lib
\t\@del /f $lib\\prigraph.def
\t\@del /f $lib\\libprigraph.a
\t\@del /f $arch\\.packlist
\t\@rmdir $arch\\.packlist

MAKE

close F;
