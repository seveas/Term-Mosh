package Term::Mosh;
use v5.18.0;

use strict;
use warnings;
use Sys::Utmp;

use vars qw($VERSION @EXPORT @EXPORT_OK @ISA);
$VERSION = "0.1";

BEGIN {
    require Exporter;
    @ISA = qw(Exporter);
    @EXPORT = ();
    @EXPORT_OK = qw(mosh mosh_pid attached detached);
}

sub find_mosh_pid {
    my $pid = $$;
    while (1) {
        open(my $pf, "<", "/proc/$pid/stat") || die "Cannot open /proc/$pid/stat";
        my $stat = <$pf>;
        close($pf);
        $stat =~ m/^[0-9]+ \((.*?)\) [A-Z] ([0-9]+)/;
        return $pid if ($1 eq 'mosh-server');
        last if ($2 == 0);
        $pid = $2;
    }
}

sub find_mosh {
    my ($pid) = @_;
    my $utmp = Sys::Utmp->new();
    while(my $utent = $utmp->getutent()) {
        if($utent->ut_pid == $pid) {
            $utmp->endutent;
            return $utent;
        }
    }
    $utmp->endutent;
}

BEGIN {
    require constant;
    my $mosh_pid = find_mosh_pid;
    constant->import({
        mosh_pid => $mosh_pid,
        mosh => !!$mosh_pid,
    });
}

sub attached { 
    if(mosh) {
        my $utent = find_mosh(mosh_pid);
        return $utent->ut_host =~ /^mosh / ? 0 : 1;
    }
    else {
        warn "Not running under mosh";
        return undef;
    }
}
sub detached { !attached }
1;

__END__

=head1 NAME

Term::Mosh - Detect mosh

=head1 SYNOPSIS

  use Term::Mosh qw(using_mosh attached detached);
  if(using_mosh) {
      say "Using mosh, currently " . ( detached ? "not " : ) .  "attached";
  }

=head1 DESCRIPTION

When running scripts under mosh, it's often useful to detect this and to
detect whether mosh is currently attached or not. This module does exactly
that and nothing more.

=head2 EXPORTS

=head3 mosh

Returns whether we are running under mosh or not.

=head3 mosh_pid

Returns the process ID of the mosh server process

=head3 attached

Returns true when mosh is attached. Returns undef when we are not running
under mosh.

=head3 detached

Returns true when mosh is detached. Returns undef when we are not running
under mosh.

=head1 SEE ALSO

Manpages: mosh(1)

=head1 AUTHOR

Dennis Kaarsemaker E<lt>dennis@kaarsemaker.netE<gt>

=head1 COPYRIGHT AND LICENSE

This software is placed in the public domain, no rights reserved
