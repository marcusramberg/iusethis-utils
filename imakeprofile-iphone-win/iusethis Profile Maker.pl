#!/usr/bin/perl -w 

use strict;

use XML::TreePP;
use MIME::Base64;
use Data::Plist::BinaryReader;
my $reader=Data::Plist::BinaryReader->new();
my $backupdir=$ENV{HOME}."/Library/Application Support/MobileSync/Backup/";
opendir(DIR,$backupdir)|| terminate( "Could not open Backup dir: ".$@);
my $ts=0;
my $newest;
foreach (readdir(DIR)) {
    next if m/^\./;
    if((stat($backupdir.$_))[9]>$ts) {
        $newest=$_;
        $ts=(stat($backupdir.$_))[9];
    }
}
terminate( "Could not find any backups  in ~/Library/Application Support/MobileSync")
    unless $newest;

use XML::TreePP;
my $tpp = XML::TreePP->new();
my $doc=$tpp->parsefile($backupdir.$newest.'/Manifest.plist');
my $blob=$doc->{plist}->{dict}->{data}->[2] || die('Could not parse manifest. Invalid XML data?');
my $plist_data=$reader->open_string(decode_base64($blob))->data;

my @apps;
foreach my $app (keys %{$plist_data->{Applications}}) {
    push @apps, make_short( $plist_data->{Applications}->{$app}->{AppInfo}->{CFBundleDisplayName}||
         $plist_data->{Applications}->{$app}->{AppInfo}->{CFBundleExecutable});
}
my $data='-F apps='.join(' -F apps=',@apps);
my $res=`curl -s -H \"Expect:\" $data http://iphone.iusethis.com/profile/send`;

if ($res =~ m/^\d+$/) {
	system('open','http://iphone.iusethis.com/profile/view/'.$res.'?match=1');
	terminate("Profile uploaded. Please check your browser");
} else
{
	terminate('Unable to send profile to server '.$res);
}

sub terminate {
    my $message=shift;
#        osascript -l AppleScript -e 'tell Application "Finder" to display alert "Call Frank" '
	system('osascript -l AppleScript -e \'tell Application "Finder" to display alert "'.$message.'" \'');
	exit
}

sub make_short {
    my ($name)=@_;
    $name =~ s/[^\w\@\-]//g;
    return lc $name;
}

sub simple_escape {
	my $text=shift;
	#FIXME: this sucks
	$text =~ s/\&/\&amp;/g;
	$text =~ s/\s/\%20/g;
	return $text;
}
