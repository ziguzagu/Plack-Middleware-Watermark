use inc::Module::Install;
# metadataes
name 'Plack-Middleware-Watermark';
all_from 'lib/Plack/Middleware/Watermark.pm';
# dependencies
build_requires 'Test::More';
# tests
tests 't/*.t';
author_tests 'xt';
use_test_base;
# misc
auto_include;
WriteAll;
