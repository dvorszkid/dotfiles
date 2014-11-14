#!/usr/bin/perl -w

use strict;

my $TARGET = shift || "/etc";
my $DB_DIR = "/var/db/pkg";
my (%VALID, %PACKAGES);

for my $dir (<$DB_DIR/*>) {
    for my $package (<$dir/*>) {
        open(CONTENTS, "$package/CONTENTS") or next;
        while (<CONTENTS>) {
            m/^(?:obj|dir|sym) ($TARGET\S*)/o or next;           
            my $file = $1;
            #print "$file\n";           
            $package =~ s{^$DB_DIR/}{};
            $package =~ s/-\d(?:[\d.r-]|_p)*$//;
            $VALID{$file} = $package;
            $PACKAGES{$package}++;
        }
        close CONTENTS;
    }
}

scan_target($TARGET);

sub scan_target {
    my $target = shift;
    print ">> scanning $target ...\n";

    for my $file (<$target/*>) {
        $VALID{$file} or print "$file\n";
        -d $file and scan_target($file);
    }
}

__END__
