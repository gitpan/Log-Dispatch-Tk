# Before `make install' is performed this script should be runnable with
use warnings FATAL => qw(all);
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

use strict;
use Test ;

BEGIN { plan tests => 2 ; }

use Tk ;

use ExtUtils::testlib;
use Log::Dispatch;
use Log::Dispatch::TkText ;

my $trace = shift || 0 ;

my $dispatch = Log::Dispatch->new;

ok($dispatch) ;

my $mw = MainWindow-> new ;

my $tklog = $mw->Scrolled('LogText', name => 'tk',
                          min_level => 'debug');
$tklog -> pack ;

ok($tklog) ;

$dispatch->add($tklog->logger) ;

$dispatch -> log 
  (
   level => 'info',
   message => "You can use <Button-3> Filter menu to filter log levels\n".
   "Please use <Button-3> File->exit to finish the test") ;

$dispatch -> log 
  (
   level => 'crit',
   message => "critical message using abbreviated form (3)"
   );

$dispatch -> log 
  (
   level => 3,
   message => "message using numeric levels (level 3 in this case)"
   );



foreach my $level ($tklog->logger->all_levels())
  {
    $dispatch -> log (level => $level, message => "some $level bla-bla") ;
    my $nb = $tklog->logger -> _level_as_number($level); # naughty ...
    $dispatch -> log (level => $level, message => "some level $nb bla-bla") ;
  }

foreach my $level ($tklog->logger->all_levels())
  {
    $dispatch -> log (level => $level, message => "another very long $level bla-bla\nWell, not so long\n") ;
  }

MainLoop ; # Tk's
