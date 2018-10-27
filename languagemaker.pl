#!/usr/bin/perl
#language_maker
use strict; use warnings;
#finds n letter frequencies in a file and prints them and their frequencies out

die "Must only input one file\n" if (@ARGV > 1);
die "Must input one file\n" if (@ARGV <1);

my ($file) = @ARGV; 


my %wordcount;
open (my $in, "<$file") or die "Can't open $file\n";
my $outfile = "text created from $file.txt";
open (my $out, ">$outfile") or die "error creating $outfile";
while (my $words = <$in>) {
	    chomp $words;
	    my $last_duo_idx = length($words) - 3;
	    	for my $i (0 .. $last_duo_idx) {
	    		my $duo = substr($words, $i, 3); 
	    		++$wordcount{$duo};
	}   
}

my @skeys = sort { $wordcount{$b} <=> $wordcount{$a} } keys %wordcount;

foreach my $word (@skeys) {
	    print $out "$word\t$wordcount{$word}\n";
} 

#finds the total number of digrams
use List::Util 'sum';
my $value_count = sum values %wordcount;


#changes hash values from frequencies to relative frequencies

foreach my $rel_freq (values %wordcount){
	$rel_freq /= $value_count;
}
my @cum_sum;

foreach my $cumsum (values %wordcount){
	push (@cum_sum, $cumsum);
}

my $sum = 0;
for (my $i = 0; $i < @cum_sum; $i++){
	$sum += $cum_sum[$i];
	@cum_sum[$i] = $sum;
} 

my $i = 0;
foreach my $cum_sum (values %wordcount){
	$cum_sum = $cum_sum[$i]; 
	$i++;	
}

#reverse hash so frequencies are keys and digrams are values
my @keys;
my $a = 0;
foreach my $key (keys %wordcount){
	$keys[$a] = $key;
	$a++;
}

#my %reversed_wordcount;
#while(my ($key, $value) = each %wordcount){
#	$reversed_wordcount{$value} = $key;
#}
#%wordcount = %reversed_wordcount;


#prints out digrams at observed frequencies	
my $punctuation = join '|', map { quotemeta } qw(& ! : ' . ; ?);

for my $j (0..100) {
	my $outcome = rand();
        for my $k (0..$#cum_sum) {
		if ($keys[$k] =~ m/\"|\/|\<|\>|\\|\`|\~|\@|\#|\$|\%|\^|\*|[0-9]|\(|\)|\[|\]|\{|\}/) {

			print $out "";
		}
		elsif ($keys[$k] =~ m/\s|[-]/){
			print $out " ";
		}
        	elsif ($keys[$k] =~ /($punctuation)/) { 
			$keys[$k] = "$1";
			print $out $keys[$k];
		}
		else {
			print $out $keys[$k];
		}
	}
}

#	print "$outcome\n";


close($in);
