# Grabs the gweled board from the screen and writes
# an ASCII representation of it to STDOUT.
use strict;
use Imager;
use Imager::Screenshot 'screenshot';
use X11::GUITest qw/ FindWindowLike MoveMouseAbs /;

exit if (not Imager::Screenshot->have_x11);

#my $THRESHOLD = 1_570_000;
my $THRESHOLD = 1_330_000;
my $black = Imager::Color->new(255, 255, 255);

my ($jewels) = @ARGV;

unless($jewels)
{
	$jewels = 8;
}
warn "Jewels = $jewels\n";

my ($windowsid) = FindWindowLike('Gweled');
my $img = screenshot(id => $windowsid);
# $img->write(file => 'screen.png', type => 'png' ) || print "Failed: ", $img->{ERRSTR}, "\n";

my $cnt = $jewels - 1;

MoveMouseAbs(100,100); # Move cursor away.

my $wid =$img->getwidth();
my $board = $img->crop(left=>0 , top=>20 , width=>$wid, height=>$wid); 
$board->write(file => 'board.png', type => 'png' ) || print "Failed: ", $board->{ERRSTR}, "\n";
my $boardwidth = $board->getwidth(); 
my $boardheight = $board->getheight(); 
my $tilewidth = $boardwidth / $jewels;
warn "# Tilesize = $tilewidth\n";
my $frame = 15; # Shave this border from each tile
# 48px - 15 -> 23
# 64px - 41 -> 23

my $puzzle = "";
my $w = $tilewidth;
my @dict;
for my $j (0 .. $cnt) 
{
	for my $i (0 .. $cnt) 
	{
		my $x0 = $i*$w;
		my $y0 = $j*$w;
		my $tile = $board->crop(left=>$x0+$frame , top=>$y0+$frame , width=>$w-2*$frame, height=>$w-2*$frame); 
		$tile->write(file => "a$i$j.png", type => 'png' ) || print "Failed: ", $tile->{ERRSTR}, "\n";
		
		my $found = 0;
		for (my $d=0; $d <= $#dict; $d ++)
		{
			my $matches = computeDiff($tile, $dict[$d]);
			if ($matches == 1)
			{
				$found = 1;
				warn "$tile ($i,$j) matches $d\n"; 
				$puzzle .= sprintf("%x",$d) . " ";
				last;
			}
		}
		if ($found == 0)
		{
			warn  "Adding ($i, $j) to dictionary\n";
			my $current = scalar @dict;
			$puzzle .= sprintf("%x",$current) . " ";
			push @dict, $tile;
		}
	}
	$puzzle .= "\n";
}

print $puzzle;

##################################################
sub computeDiff
{
	my $img1 = shift;
	my $img2 = shift;

	my $w = $img1->getwidth() - 1;
	my $sum = 0;
	for my $y (0 .. $w)
	{
		for my $x (0 .. $w)
		{
			my $c1 =$img1->getpixel(x=> $x, y =>$y);
			my $c2 =$img2->getpixel(x=> $x, y =>$y);
			my ($r1, $g1, $b1) = $c1->rgba();
			my ($r2, $g2, $b2) = $c2->rgba();
			$sum += ($r2-$r1)*($r2-$r1) + ($g2-$g1)*($g2-$g1) + ($b2-$b1)*($b2-$b1);
		}
	}
	#print "Sum = $sum\n";
	return 0 if ($sum > $THRESHOLD);
	return 1;
}
##################################################

