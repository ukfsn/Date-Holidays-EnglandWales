# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Date-Holidays-EnglandWales.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 4;
BEGIN { use_ok('Date::Holidays::EnglandWales') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

ok ! is_uk_holiday(2010, 6, 1);
ok is_uk_holiday(2010, 12, 27);
ok is_uk_holiday('2011-04-29');
