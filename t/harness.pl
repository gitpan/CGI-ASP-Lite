use Test;
use CGI::ASP::Lite;

BEGIN { plan tests => 5; }

$chars = " !\"#\$%&'()*+,-./";

$a = $Request->QueryString("a")->Item; 
$b = $Request->QueryString("b")->Item; 
$c = $Request->QueryString("c")->Item; 

ok($a==1 && $b==2 && $c eq $chars);

$d = $Request->Form("d")->Item; 
$e = $Request->Form("e")->Item; 
$f = $Request->Form("f")->Item; 

ok($d==4 && $e==5 && $f eq $chars);

$g = $Request->ServerVariables("G")->Item; 
$h = $Request->ServerVariables("H")->Item; 
$i = $Request->ServerVariables("I")->Item; 

ok($g==7 && $h==8 && $i eq $chars);

$j = $Request->Cookies('j')->Item;
$k = $Request->Cookies('k')->Item;
$l = $Request->Cookies('l')->Item;

ok($j==10 && $k==11 && $l==$chars);

ok(   $Request->QueryString->Count==3
   && $Request->Form->Count==3
   && $Request->Cookies->Count==3);
