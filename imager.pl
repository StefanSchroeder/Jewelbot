# Grabs the gweled board from the screen and writes
# an ASCII representation of it to STDOUT.
use strict;
use Imager;
use Imager::Screenshot 'screenshot';
use X11::GUITest qw/ FindWindowLike MoveMouseAbs /;
use Statistics::Basic qw /median/;

my $debug = 1;
my $fixy = 24;

# The necessary difference btw. two images to count as different.
my $THRESHOLD = 1600;

exit if (not Imager::Screenshot->have_x11);

my ($boardsize) = @ARGV;

$boardsize = 8 unless($boardsize);
warn "# Boardsize = $boardsize\n";

my ($window_id) = FindWindowLike('Gweled');
die("Cannot find gweled window.\n") unless($window_id);

my $img = screenshot(id => $window_id);

my $wid =$img->getwidth();
my $board = $img->crop(left=>0 , top=> $fixy , width=>$wid, height=>$wid); 
if($debug)
{
    $board->write(file => 'board.png', type => 'png' ) || print "Failed: ", $board->{ERRSTR}, "\n";
}
my $boardwidth = $board->getwidth(); 
my $boardheight = $board->getheight(); 
my $tilewidth = $boardwidth / $boardsize;

warn "# Tilewidth = $tilewidth\n";

# Shave this border from each tile 
# When tilesize is 48px: 15
# When tilesize is 64px: 41
my $frame = 15; 

# A multiline string to hold the result.
my $puzzle = "";

my $w = $tilewidth;

# The dictionary of all known tiletypes. They're identified by index.
my @dict;

for my $j (0 .. $boardsize - 1) 
{
	for my $i (0 .. $boardsize - 1) 
	{
		my $x0 = $i*$w;
		my $y0 = $j*$w;

		my $tile = $board->crop(left=>$x0+$frame , top=>$y0+$frame , width=>$w-2*$frame, height=>$w-2*$frame); 
        if($debug)
        {
		    $tile->write(file => "a$i$j.png", type => 'png' ) || print "Failed: ", $tile->{ERRSTR}, "\n";
        }
		
		my $found = 0;
		for (my $d=0; $d <= $#dict; $d ++)
		{
			my $matches = computeDiff($tile, $dict[$d]);
			if ($matches == 1)
			{
				$found = 1;
				warn "$tile ($i,$j) matches $d\n" if ($debug);
				$puzzle .= sprintf("%x",$d) . " ";
				last;
			}
		}
		if ($found == 0)
		{
			warn  "Image ($i, $j) was not found in the dictionary. Adding to dictionary\n";
			my $current = scalar @dict;
			$puzzle .= sprintf("%x",$current) . " ";
			push @dict, $tile;
		}
	}
	$puzzle .= "\n";
}

print $puzzle;

exit;

##################################################
sub computeDiff
{
	my $img1 = shift;
	my $img2 = shift;

	my $w = $img1->getwidth() - 1;
	my $sum = 0;

    my  @greens2;
    my  @reds2;
    my  @blues2;
    my  @greens1;
    my  @reds1;
    my  @blues1;

	for my $y (0 .. $w)
	{
		for my $x (0 .. $w)
		{
			my $c1 =$img1->getpixel(x=> $x, y =>$y);
			my $c2 =$img2->getpixel(x=> $x, y =>$y);
			my ($r1, $g1, $b1) = $c1->rgba();
			my ($r2, $g2, $b2) = $c2->rgba();
			$sum += ($r2-$r1)*($r2-$r1) + ($g2-$g1)*($g2-$g1) + ($b2-$b1)*($b2-$b1);
            push @greens2, $g2;
            push @reds2, $r2;
            push @blues2, $b2;
            push @greens1, $g1;
            push @reds1, $r1;
            push @blues1, $b1;
		}
	}
    
    my $mg1 = median( @greens1);
    my $mr1 = median( @reds1);
    my $mb1 = median( @blues1);
    my $mr2 = median( @reds2 );
    my $mg2 = median( @greens2 );
    my $mb2 = median( @blues2);
    my $msum = ($mg1-$mg2)* ($mg1-$mg2) + ($mr1-$mr2)* ($mr1-$mr2) + ($mb1-$mb2)* ($mb1-$mb2);
    warn "diff is $msum";
	return 0 if ($msum > $THRESHOLD);
	return 1;
}
##################################################

