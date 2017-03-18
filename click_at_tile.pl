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
my $jewels = 8;

GetOptions(
    'jewels=i' => \$jewels,
);

my ($windowsid) = FindWindowLike('Gweled');
my $img = screenshot(id => $windowsid);
my $wid =$img->getwidth();
my $tilewidth = $wid / $jewels;

my @pos = GetWindowPos($windowsid);
my ($offset_x,  $offset_y) = @pos;

if (@ARGV)
{
	foreach (@ARGV)
	{
		my $coords = $_;
		chomp $coords;
		warn "NO SOLUTION", exit if($coords =~ m/NO/);
		my ($x, $y) = split(",", $coords);
		click_at($x, $y+1);
		WaitSeconds($sleep);
	}
}

MoveMouseAbs(100, 100); # Click into terminal.
ClickMouseButton(M_LEFT);

exit;

sub click_at
{
	my ($x, $y) = @_;
	print "Clicking at tile $x, $y\n";

	my $real_x = $offset_x + ($x*$tilewidth + $tilewidth / 2);
	my $real_y = $offset_y + ($y*$tilewidth + $tilewidth / 2);
	print "Clicking at coord $real_x, $real_y\n";
	MoveMouseAbs($real_x, $real_y);
	ClickMouseButton(M_LEFT);
}

