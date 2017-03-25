#
# Script to click at a screen coordinate
# The coordinates are read from stdin in 
# the form x,y, e.g. 2,3
# The coords are shifted to the offset of
# the game board and scaled according to
# the size and topology of the board.
# Several constants are available.
# 
use strict;
use X11::GUITest qw/M_LEFT ClickWindow ClickMouseButton GetWindowPos FindWindowLike MoveMouseAbs GetMousePos WaitSeconds/;
use Imager::Screenshot 'screenshot';
use Getopt::Long;

my $debug = 1;
my $sleep = 0.3;
my $columns = 8;
my $fixy = 0;

GetOptions(
    'columns=i' => \$columns,
    'fixy=i' => \$fixy,
);

my ($windowsid) = FindWindowLike('Gweled');
die("FATAL: Cannot find gweled window.\n") unless( $windowsid );
my $img = screenshot(id => $windowsid);
my $tilewidth = $img->getwidth() / $columns;

my ($offset_x,  $offset_y) = GetWindowPos($windowsid);
warn "tilewidth=$tilewidth\n" if ($debug);

foreach (@ARGV)
{
    my $coords = $_;
    chomp $coords;
    warn "NO SOLUTION", exit if($coords =~ m/NO/);
    my ($x, $y) = split(",", $coords);
	print "Clicking at tile $x, $y\n" if($debug);
    ClickWindow($windowsid, $x*$tilewidth + $tilewidth / 2, $fixy + $y*$tilewidth + $tilewidth / 2 );
    WaitSeconds($sleep);
}

# Click into terminal to permit pressinc Ctrl-C
MoveMouseAbs($offset_x-10, $offset_y);
#ClickMouseButton(M_LEFT);

