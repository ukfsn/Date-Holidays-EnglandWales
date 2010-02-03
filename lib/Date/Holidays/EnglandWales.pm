package Date::Holidays::EnglandWales;

use 5.008000;
use strict;
use warnings;

use Time::Piece;
use Time::Seconds;
use DateTime::Event::Easter;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw( is_holiday is_uk_holiday );
our $VERSION = '0.05';


=head1 NAME

Date::Holidays::EnglandWales - Determines bank holidays

=head1 SYNOPSIS

  use Date::Holidays::EnglandWales;
  
  my ($year, $month, $day) = (localtime)[ 5, 4, 3 ];
  $year  += 1900;
  $month += 1;

  my $isodate = "$year-$month-$day";

  print "It's a bank holiday" if is_holiday($year, $month, $day);
  print "Sleep in late!" if Date::Holidays::EnglandWales->is_holiday($isodate);

=head1 DESCRIPTION

Date::Holidays::EnglandWales returns true is a given date is a bank 
holiday in England and wales.

The date can be passed as year, month, day or as an ISO formatted date.

This module uses a simple set of rules to determine whether a date is a 
holiday rather than a static list. This means it isn't limited to just
the next few years and wont require maintainance unless the rules are
changed.

It knows about the proposed bank holiday for the Queen's Diamond Jubilee.

=head2 EXPORT

is_holiday
is_uk_holiday

=head1 DEPENDANCIES 

This module uses the following modules which you can get from CPAN.

Time::Piece
DateTime::Event::Easter

=head1 SEE ALSO

Bank Holidays in England and Wales are determined by the Banking and 
Financial Dealings Act 1971 and by Royal Proclamation. This means that it
is possible that they may change from year to year although in practice
this does not happen.

If you need to be absolutely sure about a date check with the DTI whose
website is http://www.dti.gov.uk/

=head1 AUTHOR

Jason Clifford, E<lt>jason@ukfsn.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Jason Clifford

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. That means either the Artistic
License or the GNU GPL version 2 or later.

=cut

sub is_holiday { goto &is_uk_holiday; }

sub is_uk_holiday {
    my ($date, $MON, $DAY) = @_;

    if ( $MON && $DAY ) {
        $date = sprintf "%s-%s-%s", $date, $MON, $DAY;
    }

    my $d = Time::Piece->strptime($date, "%F");

    if ( $d->mon == 1 ) {
        return "New Years Day" if (
            ( $d->mday == 1 && $d->day =~ /(Mon|Tue|Wed|Thu|Fri)/ ) || 
            ( $d->mday == 2 && $d->day eq "Mon" ) ||
            ( $d->mday == 3 && $d->day eq "Mon" ) );
        return undef;
    }

    if ( $d->mon == 5 ) {
        return "Early May Bank Holiday" if (
            ( $d->mday >= 1 && $d->mday <= 7 && $d->day eq "Mon" ) );

        return "Spring Bank Holiday" if (
            $d->year != 2012 && 
            ( $d->mday >= 25 && $d->day eq "Mon" ) );
    }

    if ( $d->year == 2012 && $d->mon == 6 ) {
        return "Spring Bank Holiday" if $d->mday == 4;
        return "Queen's Diamond Jubilee" if $d->mday == 5;  # Subject to Her Maj not dying first but I cannot be bothered to code for that.
        return undef;
    }

    if ( $d->mon == 8 ) {
        return "Summer Bank Holiday" if (
            $d->mday >= 25 && $d->day eq "Mon" );
        return undef;
    }

    if ( $d->mon == 12 ) {
        return "Christmas Day Bank Holiday" if (
            ( $d->mday == 25 && $d->day =~ /(Mon|Tue|Wed|Thu|Fri)/ ) ||
            ( $d->mday == 26 && $d->day eq "Mon" ) ||
            ( $d->mday == 27 && $d->day eq "Mon" ) );

        return "Boxing Day" if (
            ( $d->mday == 26 && $d->day =~ /(Mon|Tue|Wed|Thu|Fri)/ ) ||
            ( $d->mday == 27 && $d->day =~ /(Mon|Tue)/ ) ||
            ( $d->mday == 28 && $d->day =~ /(Mon|Tue)/ ) );

        return undef;
    }

    my $e = $d;
    $e -= ONE_DAY;  # we need to check to see whether the day BEFORE the current one is Easter Sunday
    return "Easter Monday" if &_Easter($e->year, $e->mon, $e->mday);
    return "Good Friday" if &_GoodFriday($d->year, $d->mon, $d->mday);

}

sub _Easter {
    my ($year, $month, $day) = @_;

    my $dt = DateTime->new( year => $year, month => $month, day => $day );
    my $easter_sunday = DateTime::Event::Easter->new();

    return $easter_sunday->is($dt);
}

sub _GoodFriday {
    my ($year, $month, $day) = @_;

    my $dt = DateTime->new( year => $year, month => $month, day => $day );
    my $good_friday = DateTime::Event::Easter->new(day=>'Good Friday');

    return $good_friday->is($dt);
}

1;
__END__
