
###################MANUFACTURE.TXT

open (IN, "<", $ARGV[0]) or die "can't open file\n";
 chop (@arr=<IN>);
close IN;

foreach $item (@arr){

	($m)= $item =~ m#([M]\d+)#; #matches for the machine needed.
	$item =~ s#$m##; #

	($pM) = $item =~ m#(\w+\d+)#;  #matches for the part being made
	$item =~ s#$pM##; #sub out the part being made with empty string.

	@pN = $item =~ m#(\w+\d+)#g; #matches for the parts needed
	@count = $item =~ m#[ ](\d+)#g; #matches for the amount needed of each part
	
	%buildHash = (
	partMake => $pM,
	mach => $m,
	partsN => [@pN],
	counts => [@count],
	); 

	push @builds, {%buildHash}; #store a copy of the hash to the builds array
	
}

#foreach $i (@builds){ ###TEST
#	print $i -> {partMake} , "\n";
#	print @{$i -> {partsN}}, "\n";
#}  #testing how to access hashtable data from array 

################


##############Inventory.txt

open (IN, "<", $ARGV[1]) or die "can't open file\n";
 chop (@arr2=<IN>);
close IN;

foreach $item (@arr2) {
	($name, $total) = $item =~ m#(\w+\d+)[ ](\d+)#; #matches for name and total
	#print "$name $total \n";  #TEST DELETE ME
	
	%InventoryHash = ( 
		partID => $name,
		total => $total,
	);
	
	push @inventory, {%InventoryHash}; 
}


#########################

open (IN, "<", $ARGV[2]) or die "can't open file\n";
 chop (@arr3=<IN>);
close IN;

foreach $item (@arr3) {
	($name, $total) = $item =~ m#(\w+\d+)[ ](\d+)#; #matches for name and total
	# print "$name $total \n";  #TEST 
	
	%MachineHash = ( 
		mID => $name,
		total => $total,
	);
	
	push @machines, {%MachineHash}; 
}

##########################


sub checkMachine{  #checks that machine in build is valid
	foreach $m (@machines){
		if($_[0] eq $m->{mID}){ return; }
	}
	print "Machine: $_[0], does not exist in the system's machine list. \n";
	exit;
}

sub checkPart{ #checks that part in build is valid 
	foreach my $item (@inventory){
			if($_[0] eq $item->{partID}){return;}
	}
	print "Part $_[0] does not exist in the system's inventory. \n";
	exit;
}


foreach $item (@builds){   #Make sure all values are valid from the manufacture file

	checkMachine($item->{mach});
	foreach $val (@{$item -> {partsN}}){
		checkPart($val);
	}
}

#######################Commands
if($ARGV[3]){

	open (IN, "<", $ARGV[3]) or die "can't open file\n";
		chop (@arr4=<IN>);
	close IN;

	foreach $item (@arr4){
		@values = split (/ /, $item);
	
		if(@values[0] eq "Count"){
			$check = substr("@values[1]", 0, 1);
			if($check eq 'M'){
			$check = CountMachineID(@values[1]);
			print "$check \n";
			}
			else { 
			$check = CountPartID(@values[1]);
			print "$check \n";
			}
		}
		elsif(@values[0] eq "HowMake"){
			HowMake(@values[1]);
		}
		elsif(@values[0] eq "Add"){
			
			$check = substr("@values[1]", 0, 1);
			
			if($check eq 'M'){
				AddMachine(@values[1], @values[2]);
			}
			else{
				AddPart(@values[1], @values[2]);
			}
		}	
	}

}


sub CountMachineID{
	foreach my $m (@machines){
		if($_[0] eq $m->{mID}){ 
		return $m->{total}; 
		}
	}
	return 0;
}


sub CountPartID{
	foreach my $item (@inventory){
			if($_[0] eq $item->{partID}){
			return $item->{total};
		}
	}
	return 0;
}

sub AddPart{
	foreach my $item (@inventory){
		if($_[0] eq $item->{partID}){
			$item->{total} += $_[1];
			print $item->{total};
			return;
		}
	}
	%InventoryHash = ( 
		partID => $_[0],
		total => $_[1],
	); #part wasn't found so create a hash for it and push it to the array
	
	push @inventory, {%InventoryHash}; 
}


sub AddMachine{
	foreach my $item (@machines){
		if($_[0] eq $item->{mID}){
			$item->{total} += $_[1];
			print $item->{total};
		}
	}
		%MachineHash = ( 
		mID => $_[0],
		total => $_[1],
	); #just like with addPart if the part wasn't found in the system, then add it to the array
	
	push @machines, {%MachineHash}; 
}



sub HowMake{
	foreach my $item (@builds){
		if($_[0] eq $item->{partMake}){
			print "To make ", $item -> {partMake}, "\n";
			print "Machine: ", $item->{mach}, "\n";
			$counter = 0;
			foreach my $c (@{$item -> {counts}}){
				print "$c of " , @{$item -> {partsN}}[counter] , "\n";
				$counter+=1;
			}
			return;
		}
	}
return;
}


















