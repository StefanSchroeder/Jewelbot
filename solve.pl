# This script is part of Jewel-Bot. It solves a puzzle 
# of NxN letters to find two tiles to swap to get three symbols
# in a row.
# Author: Stefan Schroeder
#
#-1     4     3
#0    5 x o o x 1
#1      6     2
#    -2-1 0 1 2 3 j
#
#         7
#       o x o
#         8
use strict;

my $IN;
my @a; # Store initial puzzle.

warn "# Now reading puzzle from $ARGV[0]\n";

open($IN, "<", $ARGV[0]) or die("FATAL: Cannot open file.\n");
while ( <$IN> ) 
{
	chomp;
	last unless $_;
	push @a, [ split ];
}
close($IN);

# store result in extra array.
my @r = @a;

my $size = scalar @a;
my $solution_cnt = 0;
my @solutions = ();

warn "# Puzzle-Size=$size\n";

foreach( examine_puzzle(\@a) ) 
{
	my($b, $a) = split(",", $_);
	push @solutions, "$b,$a";
}

my @a_t = transpose(@a);
foreach( examine_puzzle(\@a_t) )
{
	my($a, $b) = split(",", $_);
	push @solutions, "$b,$a";
}

$solution_cnt and print_solution($solution_cnt) and exit;

print "NO SOLUTION";

exit;

##################################################
sub print_solution
{
    my $index = shift;
    my $pick = int(rand($index));
	print "$solutions[$pick*2] $solutions[$pick*2+1]\n";
}

##################################################
# examine_puzzle check each of the 8 different solutions if any of them
# is a hit.
sub examine_puzzle
{
    my $a_ref = shift;

    my @collect = ();
    foreach my $j ( 0 .. $size-1 )
    {
        foreach my $i ( 0 .. $size-1 )
        {
            push @collect, tryn($a_ref, $i,$j, $i,$j+1, $i  ,$j+3, $i,$j+2); # 1
            push @collect, tryn($a_ref, $i,$j, $i,$j+1, $i+1,$j+2, $i,$j+2); # 2
            push @collect, tryn($a_ref, $i,$j, $i,$j+1, $i-1,$j+2, $i,$j+2); # 3
            push @collect, tryn($a_ref, $i,$j, $i,$j+1, $i-1,$j-1, $i,$j-1); # 4
            push @collect, tryn($a_ref, $i,$j, $i,$j+1, $i+1,$j-1, $i,$j-1); # 6
            push @collect, tryn($a_ref, $i,$j, $i,$j+1, $i,  $j-2, $i,$j-1); # 5
            push @collect, tryn($a_ref, $i,$j, $i,$j+2, $i+1,$j+1, $i,$j+1); # 7
            push @collect, tryn($a_ref, $i,$j, $i,$j+2, $i-1,$j+1, $i,$j+1); # 8
        }
    }
    return(@collect);
}

##################################################
sub transpose
{
	my @in = @_;
	my @out = ();

	foreach my $j ( 0 .. $size-1 )
	{
		foreach my $i ( 0 .. $size-1 )
		{
			$out[$i][$j] = $in[$j][$i];
		}
	}
	return(@out);
}

##################################################
sub tryn
{
	my $a_ref = shift;
	my ($y1, $x1, $y2, $x2, $y3, $x3, $y4, $x4) = @_;

	grep {return if $_ < 0} @_;
	my @a = @$a_ref;

	if (( $a[$y1][$x1] eq $a[$y2][$x2]) and
			( $a[$y1][$x1] eq $a[$y3][$x3]))
	{
		warn "## There is a pair ($x1,$y1 - $x2,$y2) and a swapper at ($x3,$y3) target is ($x4,$y4)\n";
		$solution_cnt++;
		return("$x3,$y3", "$x4,$y4");
	}
	return;
}

##################################################
# for debugging only
sub dump_puzzle
{
	my @puzzle = @_;
	foreach my $i ( 0.. $size-1 )
	{
		foreach my $j ( 0.. $size-1 )
		{
			print STDERR "$puzzle[$i][$j] ";
		}
		print STDERR "\n";
	}
}

##################################################

