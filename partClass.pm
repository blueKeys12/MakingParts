package part;

sub new{

	my $class = shift;
	my $self = {
		_name => shift,
		_total => shift,
		
	};
	bless $self, $class;
	return $self;
}

sub getName{
	my ($self) = @_;
	return $self -> {_name};
}

sub getTotal{
	my($self)=@_;
	return $self -> {_total};
}

sub addTo(amount){
	@{${_[0]}->{_total}} += $_[1];
}



1;