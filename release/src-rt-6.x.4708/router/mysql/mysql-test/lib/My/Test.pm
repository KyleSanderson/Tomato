# -*- cperl -*-
# Copyright (c) 2008 MySQL AB, 2008 Sun Microsystems, Inc.
# Use is subject to license terms.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA


#
# One test
#
package My::Test;

use strict;
use warnings;
use Carp;


sub new {
  my $class= shift;
  my $self= bless {
		   @_,
		  }, $class;
  return $self;
}


#
# Return a unique key that can be used to
# identify this test in a hash
#
sub key {
  my ($self)= @_;
  return $self->{key};
}


sub _encode {
  my ($value)= @_;
  $value =~ s/([|\\\x{0a}\x{0d}])/sprintf('\%02X', ord($1))/eg;
  return $value;
}

sub _decode {
  my ($value)= @_;
  $value =~ s/\\([0-9a-fA-F]{2})/chr(hex($1))/ge;
  return $value;
}

sub is_failed {
  my ($self)= @_;
  my $result= $self->{result};
  croak "'is_failed' can't be called until test has been run!"
    unless defined $result;

  return ($result eq 'MTR_RES_FAILED');
}


sub write_test {
  my ($test, $sock, $header)= @_;

  # Give the test a unique key before serializing it
  $test->{key}= "$test" unless defined $test->{key};

  print $sock $header, "\n";
  while ((my ($key, $value)) = each(%$test)) {
    print $sock  $key, "= ";
    if (ref $value eq "ARRAY") {
      print $sock "[", _encode(join(", ", @$value)), "]";
    } else {
      print $sock _encode($value);
    }
    print $sock "\n";
  }
  print $sock "\n";
}


sub read_test {
  my ($sock)= @_;
  my $test= My::Test->new();
  # Read the : separated key value pairs until a
  # single newline on it's own line
  my $line;
  while (defined($line= <$sock>)) {
    # List is terminated by newline on it's own
    if ($line eq "\n") {
      # Correctly terminated reply
      # print "Got newline\n";
      last;
    }
    chomp($line);

    # Split key/value on the first "="
    my ($key, $value)= split("= ", $line, 2);

    if ($value =~ /^\[(.*)\]/){
      my @values= split(", ", _decode($1));
      push(@{$test->{$key}}, @values);
    }
    else
    {
      $test->{$key}= _decode($value);
    }
  }
  return $test;
}


sub print_test {
  my ($self)= @_;

  print "[", $self->{name}, "]", "\n";
  while ((my ($key, $value)) = each(%$self)) {
    print " ", $key, "= ";
    if (ref $value eq "ARRAY") {
      print "[", join(", ", @$value), "]";
    } else {
      print $value;
    }
    print "\n";
  }
  print "\n";
}


1;
