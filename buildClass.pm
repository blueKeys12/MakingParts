package build;

sub new{
	my $class = shift;
	my $self  ={
		_MID => shift,
		_PIDs => [],
		_quants => [],
	};
	bless $self, $class;
	return $self;
}


getMachineID{
	return @{${_[0]}->{_MID}};
}


getPartIDs{
	return @{${_[0]}->{_PIDs}};
}

getQuants{
	return @{${_[0]}->{_quants}};
}
1;