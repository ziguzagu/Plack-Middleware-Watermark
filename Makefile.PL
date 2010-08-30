use inc::Module::Install;
# metadataes
name 'Plack-Middleware-Watermark';
all_from 'lib/Plack/Middleware/Watermark.pm';
readme_from 'lib/Plack/Middleware/Watermark.pm';
# tests
test_requires 'Test::More';
tests 't/*.t';
author_tests 'xt';
# misc
auto_include;
WriteAll;
