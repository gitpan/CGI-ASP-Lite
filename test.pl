#
#
$chars = "%20%21%22%23%24%25%26%27%28%29%2A%2b%2C%2d%2E%2f";

$ENV{'QUERY_STRING'} = "a=1&b=2&c=$chars";

$ENV{'REQUEST_METHOD'} = "POST";
$post = "d=4&e=5&f=$chars";
$ENV{'CONTENT_LENGTH'} = length($post);

$ENV{'G'} = "7";
$ENV{'H'} = "8";
$ENV{'I'} = $chars;

$ENV{'HTTP_COOKIE'} = "j=10; k=11; l=$chars; ";

open(F,"| perl t/harness.pl |") || die("Cannot open");
print F $post;

