#!/usr/bin/perl
# Helper script to find a good algorithm and
# constants for the image comparison.
use Imager;

my($file1, $file2) = @ARGV;

my $img1 = Imager->new;
my $img2 = Imager->new;
$img1->read(file => $file1);
$img2->read(file => $file2);

computeDiff($img1, $img2);

exit;

##################################################
sub computeDiff
{
	my $img1 = shift;
	my $img2 = shift;

	my $w = $img1->getwidth() - 1;
	my $sum;
	for my $y (0 .. $w)
	{
		for my $x (0 .. $w)
		{
			my $c1 =$img1->getpixel(x=> $x, y =>$y);
			my $c2 =$img2->getpixel(x=> $x, y =>$y);
			($r1, $g1, $b1) = $c1->rgba();
			($r2, $g2, $b2) = $c2->rgba();
			$sum += ($r2-$r1)*($r2-$r1) + ($g2-$g1)*($g2-$g1) + ($b2-$b1)*($b2-$b1);
		}
	}
	print "Sum = $sum\n";
	return 0 if ($sum > $THRESHOLD);
	return 1;
}
##################################################

