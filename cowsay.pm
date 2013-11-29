# cowsay - a simple preprocessor for cows.
#
# Copyright © Brian Candler <b.candler@pobox.com>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY IKIWIKI AND CONTRIBUTORS ``AS IS''
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
# TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
# PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE FOUNDATION
# OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
# USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
# OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.

package IkiWiki::Plugin::cowsay;

use warnings;
use strict;
use IkiWiki 3.00;
use IPC::Open2;
use CGI 'escapeHTML';

sub import {
    hook(type=>"getsetup", id=>"cowsay", call=>\&getsetup);
    hook(type=>"preprocess", id=>"cowsay", call=>\&preprocess);
}

sub getsetup () {
    return
    plugin => {
        safe => 1,
        rebuild => undef,
    },
}

our %STATE_FLAGS = (
  'borg' => '-b',
  'dead' => '-d',
  'greedy' => '-g',
  'paranoid' => '-p',
  'stoned' => '-s',
  'tired' => '-t',
  'wired' => '-w',
  'youthful' => '-y',
);

sub preprocess {
    my %params=@_;
    error("Missing text") unless $params{text};
    my @cmd = (defined $params{action} && $params{action} eq "think" ? "cowthink" : "cowsay");
    push @cmd, $STATE_FLAGS{$params{state}} if defined $params{state} && $STATE_FLAGS{$params{state}};
    push @cmd, "-e", $params{eyes} if defined $params{eyes};
    push @cmd, "-T", $params{tongue} if defined $params{tongue};
    push @cmd, "-f", $params{type} if defined $params{type} && $params{type} =~ /\A[a-z0-9.-]+\z/;
    my $pid = open2(*IN, *OUT, @cmd);
    print OUT $params{text};
    close OUT;
    local $/ = undef;
    my $cow = <IN>;
    close IN;
    return "<pre class=\"cow\">\n" . escapeHTML($cow) . "</pre>\n"; 
}

1;
