#####################################################################################
#
# CGI::ASP::Lite 
#	Limited implementation of IIS Request/Response objects 
#	for non-IIS environments 
#
# Author: Ross Ferguson <ross.ferguson@cibc.co.uk>
# Revisions: 1.03
#
# Modhist: 
# 07-may-2001	1.03 char conversion on cookies  %21 -> ! 
#		     test script added
# 15-apr-2001	1.02 Cookie support
# 24-jan-2001	1.01 Released
#
#
#####################################################################################

package CGI::ASP::Lite;
$VERSION = "1.03";

sub new {

my $self = { 
  $ContentType = "text/html",
  $sent = false,
  $QueryString = {},
  $ServerVariables = {},
  $Form = {},
  $ClientCertificate = {},
  $Cookies = {}
   }; 

&parse($ENV{'QUERY_STRING'});

if($ENV{'REQUEST_METHOD'} eq "POST") {
    read(STDIN,$query_string,$ENV{'CONTENT_LENGTH'});
    &parse($query_string,true);
}

while(my($key,$value) = each %ENV) {
  $value =~tr/+/ / ;
  $value =~s/%([0-9A-F]{2})/pack("c",hex($1))/gei;
  $self{ServerVariables}{$key} = $value;
 }

foreach $cookie (split(/; /,$ENV{'HTTP_COOKIE'})) {
  my($key,$value) = split(/=/,$cookie);
  $value =~tr/+/ / ;
  $value =~s/%([0-9A-F]{2})/pack("c",hex($1))/gei;
  $self{Cookies}{$key} = $value;
  }   

bless $self, CGI::ASP::Lite;
return($self);	
}

sub parse {

foreach $arg (split(/&/,$_[0])) {
  my ($key,$value) = split(/=/,$arg);
  $value =~tr/+/ / ;
  $value =~s/%([0-9A-F]{2})/pack("c",hex($1))/gei;
  
  if($_[1]) {
     $self{Form}{$key} = $value;
  } else {
     $self{QueryString}{$key} = $value;
     }
  } 
}


####
####
####

sub Write { 

my $self = shift;

if (!$self{$sent}) {
   print "content-type: $ContentType\n\n"; 
   $self{$sent} = true;
}

print @_[0]; 
}

####
####
####

sub Item  { 

my $self = shift;
return($self->{Item});
}

####
####
####

sub Count  { 

my $self = shift;
return($self->{Count});
}


####
####
####

sub QueryString {

my $self = shift;
my $ret = { 
  'Item'  => $self{QueryString}{@_[0]}, 
  'Count' => scalar keys %{ $self{QueryString} }
};

bless $ret, CGI::ASP::Lite;
return($ret);	
}


####
####
####

sub ServerVariables { 

my $self = shift;

my $ret = { 
  'Item'  => $self{ServerVariables}{@_[0]},
  'Count' => scalar keys %{ $self{ServerVariables} }
}; 

bless $ret, CGI::ASP::Lite;
return($ret);	
}


####
####
####

sub Form { 

my $self = shift;

my $ret = { 
   'Item'  => $self{Form}{@_[0]},
   'Count' => scalar keys %{ $self{Form} }
};

bless $ret, CGI::ASP::Lite;
return($ret);	
}


####
####
####

sub Cookies { 

my $self = shift;

my $ret = { 
   'Item'  => $self{Cookies}{@_[0]},
   'Count' => scalar keys %{ $self{Cookies} }
};

bless $ret, CGI::ASP::Lite;
return($ret);	
}


####
####
####

sub ContentType { 

my $self = shift;

return($self->{ContentType});
}

####
####
####

sub BinaryWrite { 

my $self = shift;

if (!$self{$sent}) {
   print "content-type: $ContentType\n\n"; 
   $self{$sent} = true;
}

print @_[0];
}

package main;

$Request  = CGI::ASP::Lite::new(); 
$Response = $Request;

1;

=head1 NAME

CGI::ASP::Lite - Limited IIS Request/Response object implemenation for Apache

You can write "ASP ready" CGI scripts under Apache. Making for future 
porting to IIS almost seamless.

=head1 SYNOPSIS

	use CGI::ASP::Lite; 

	$Response->Write("hello<br>\n");

 	$IE=true if $Request->ServerVariables("HTTP_USER_AGENT")->Item =~/MSIE/;
 
 	$Response->Write("IE=$IE<br>\n");

 	$id    = $Request->QueryString("id")->Item;

 	$name  = $Request->Form("name")->Item;

=head1 DESCRIPTION

Limited implementation of IIS Request/Response objects 
for non-IIS environments. Provides common CGI API.

