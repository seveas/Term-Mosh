use ExtUtils::MakeMaker;
use strict;
use warnings;

WriteMakefile (
    NAME           => 'Term::Mosh',
    VERSION_FROM   => 'lib/Term/Mosh.pm',
    ABSTRACT_FROM  => 'lib/Term/Mosh.pm',
    AUTHOR         => 'Dennis Kaarsemaker <dennis@kaarsemaker.net>',
    LICENSE        => 'Public domain',
    PREREQ_PM      => {'Sys::Utmp' => 0},
);
