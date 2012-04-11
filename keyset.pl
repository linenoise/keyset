#!/usr/bin/perl -w
use strict;

###
# keyset script - a utility for managing multiple keysets within the same UNIX account
# Copyright (C) 2012 Dann Stayskal
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
###
 
my $current_keyset = `readlink ~/.keysets/current`;
chomp $current_keyset;

if (scalar(@ARGV)){

  my $command = shift @ARGV;
  chomp $command;

  if ($command eq 'list') {

    my @keysets = `ls ~/.keysets`;

    foreach my $keyset_name (@keysets){
      chomp $keyset_name;
      next if $keyset_name eq 'current';
      if ($keyset_name eq $current_keyset) {
        print " * $keyset_name\n";
      } else {
        print " $keyset_name\n";
      }
    }

  } elsif ($command eq 'load') {

    ### Figure out which keyset they want to use
    my $new_keyset = '';
    $new_keyset = shift @ARGV if scalar @ARGV;
    chomp $new_keyset;
    unless ($new_keyset) {
      print "Usage: keyset load [keyset_name]\n";
      exit 1;
    }

    ### Make sure the keyset they've selected actually exists
    my $valid_new_keyset = `ls ~/.keysets/$new_keyset`;
    chomp $valid_new_keyset;
    unless ($valid_new_keyset) {
      print "$new_keyset isn't a valid keyset. For a list of keysets available, use 'keyset list'\n";
      exit 1;
    }

    ### Go through and remove links to current keyset materials
    if ($current_keyset) {
      my @links = `find ~/.keysets/$current_keyset | awk -Fkeysets\/$current_keyset\/ '{print \$2}'`;
      chomp @links;
      foreach my $link (@links) {
        chomp $link;
        my $link_source = "$ENV{HOME}/.keysets/$current_keyset/$link";
        my $link_target = "$ENV{HOME}/.$link";

        ### We're only symlinking source files
        next unless -f $link_source;

        ### Before unlinking something, make sure it's a symlink
        next unless -l $link_target;

        # print "$link_source ---> $link_target\n";
        print "Removing link to $link\n";
        unlink($link_target);
      }
    }

    ### Go through and set links to new keyset materials
    my @links = `find ~/.keysets/$new_keyset | awk -Fkeysets\/$new_keyset\/ '{print \$2}'`;
    chomp @links;
    foreach my $link (@links) {
      chomp $link;
      my $link_source = "$ENV{HOME}/.keysets/$new_keyset/$link";
      my $link_target = "$ENV{HOME}/.$link";

      ### We're only symlinking source files
      next unless -f $link_source;

      print "Setting link $link_source ---> $link_target\n";
      `ln -s $link_source $link_target`;
    }

    ### Reset ~/.keysets/current
    `rm ~/.keysets/current`;
    `cd ~/.keysets/ && ln -s $new_keyset ~/.keysets/current`;

    ### Add the new key to ssh-agent if able
    `killall -9 ssh-agent`;
    `ssh-add`;
  }

} else {

  ### Running with no arguments.
  ### If they have a keyset loaded, print its name and exit clean.
  ### If they don't have a keyset loaded, direct them to the keyset list and exit with error status.
  if ($current_keyset) {
    print "$current_keyset\n";
    exit 0;
  } else {
    print "No keyset currently loaded.\nRun 'keyset list' for a list of availbale keysets\n";
    exit 1;
  }

}


