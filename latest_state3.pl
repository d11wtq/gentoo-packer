#!/usr/bin/env perl
# ABSTRACT: Inject latest stage3 data into .json

use strict;
use warnings;
use 5.010;

sub main {
    my $base       = "http://distfiles.gentoo.org/releases/amd64/autobuilds";
    my $image_name = "install-amd64-minimal";

    my $datestamp = get_datestamp(
        url        => "${base}/latest-iso.txt",
        image_name => $image_name,
    );

    *STDERR->print("* Got datestamp = $datestamp\n");

    my $sha512 = get_hash(
        url => "${base}/${datestamp}/${image_name}-${datestamp}.iso.DIGESTS",
        filename => "${image_name}-${datestamp}.iso",
        label    => "SHA512 HASH"
    );

    *STDERR->print("* Got digest = $sha512\n");

    my $json = read_json('virtualbox.json');

    $json->{variables}->{stage3} = $datestamp;
    for my $builder ( @{ $json->{builders} } ) {
        next unless $builder->{vm_name} eq 'Gentoo';
        $builder->{iso_checksum}      = $sha512;
        $builder->{iso_checksum_type} = "sha512";
    }

    write_json( 'virtualbox.json', $json );

    return 0;
}

exit main();

# get_datestamp(
#   url        => url to fetch datestamps from
#   image_name => basename for image to match, eg: install-amd64-minimal
# );
#
# Emits a number if a number is found in the URL matching :number/:image_name-:number.iso
sub get_datestamp {
    my ($config)   = {@_};
    my $url        = $config->{url};
    my $image_name = $config->{image_name};

    for my $line ( lines( get_url($url) ) ) {
        next if $line =~ /\A#/;
        next unless $line =~ /\A(\d+)\/${image_name}-\d+.iso\s/;
        return "$1";
    }
    die "Did not find /${image_name} in ${url}";
}

# get_hash  (
#   label           => The comment line indicating what kind of hash it is, eg:"SHA512 HASH"
#   filename        => The filename you want the hash for, eg: ":image_name-:datestamp.iso"
#   url             => The URL to fetch digest data from.
#   hash_characters => The number of characters the hash will be ( 128 )
#   hash_dictionary => The characters a hash will be expressed in ( lower hex )
# )
sub get_hash {
    my ($config)      = {@_};
    my $want_label    = $config->{label};
    my $want_filename = $config->{filename};
    my $url           = $config->{url};
    my $hash_characters = $config->{hash_characters} || 128;
    my $hash_dictionary = $config->{hash_dictionary} || '0-9a-f';

    my $hash_expr = '[' . $hash_dictionary . ']{' . $hash_characters . '}';

    my $seen_comment;
    my (@lines) = lines( get_url($url) );
    while (@lines) {
        my ( $label, $content ) = splice @lines, 0, 2, ();
        next if $label !~ /\A#\s\Q${want_label}\E/;
        next unless $content =~ /\A(${hash_expr})\s+\Q${want_filename}\E\z/;
        return "$1";
    }
    die "Did not find ${want_label} for ${want_filename} in ${url}";
}

use JSON::PP;

# json()->
#
# Returns a JSON::PP object configured for keeping the existing indentation of virtualbox.json
sub json {
    return state $encoder = do {
        JSON::PP->new->indent(1)->space_after(1)->canonical(1)
          ->indent_length(2)->utf8(1);
    };
}

# read_json('filename.json')
#  returns filename.json as a hash tree.
sub read_json {
    my ($path) = @_;
    return json()->decode( slurp($path) );
}

# write_json('filename.json', $hash_tree )
#   writes hash tree to filename.json
sub write_json {
    my ( $path, $data ) = @_;
    return spew( $path, json()->encode($data) );
}

# slurp( $filename )
#   reads $filename as a single string.
sub slurp {
    my ($fn) = @_;
    open my $fh, '<:raw:unix', $fn or die "Can't open $fn for reading: $! $?";
    my $content = do { local $/; scalar <$fh> };
    close $fh or warn "Problem closing $fn, $! $?";
    return $content;
}

# spew( filename, $content );
#   write content out to $filename
sub spew {
    my ( $fn, $content ) = @_;
    open my $fh, '>:raw:unix', $fn or die "Can't open $fn for writing: $! $?";
    print {$fh} $content or warn "Problem writing to $fn! $! $?";
    close $fh or warn "Problem closing $fn!, $! $?";
    return;
}

use HTTP::Tiny;

# get_url( $url )
#   return $url's content, or die.
sub get_url {
    my ($url) = @_;
    state $agent = do {
        HTTP::Tiny->new();
    };
    *STDERR->print("* Fetching $url\n");
    my $result = $agent->get($url);
    return $result->{content} if $result->{success};
    die "Could not fetch $url, status: "
      . $result->{status}
      . " reason: "
      . $result->{reason};
}

# my @lines = lines( $content )
#   returns content split into lines with trailing \n's stripped.
sub lines { split /\n/, $_[0] }
