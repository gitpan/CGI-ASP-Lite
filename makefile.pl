use ExtUtils::MakeMaker;

WriteMakefile(
    NAME	 => 'CGI::ASP::Lite',
    VERSION_FROM => 'Lite.pm',
    ($] < '5.005') ? () :
      (
      'AUTHOR'   => 'Ross Ferguson <ross.ferguson@cibc.co.uk>',
      'ABSTRACT' => 'IIS Request/Response object implemenation for Apache',
      ),
    'dist' => {
	COMPRESS=>'gzip -9f', 
	SUFFIX  => 'gz',
	PREOP   => 'perl -MPod::Text -e "pod2text q(Lite.pm)" > README'
      }
);
