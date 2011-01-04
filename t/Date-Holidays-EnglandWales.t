# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Date-Holidays-EnglandWales.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 4;
BEGIN { use_ok('Date::Holidays::EnglandWales') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

ok(!is_uk_holiday(2010, 6, 1), "2010-06-01 is not a holiday");
ok(is_uk_holiday(2010, 12, 27), "2010-12-27 is a holiday");
ok(is_uk_holiday('2011-04-29'), 
    "2011-04-29 is a holiday (William & Kate's wedding");
