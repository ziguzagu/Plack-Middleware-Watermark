#!/usr/bin/env perl
use strict;
use warnings;

use Plack::Test;
use Plack::Builder;
use HTTP::Request::Common;
use Test::More;

## test return content length
my $app = sub {
    return [
        200,
        [ 'Content-Type' => 'text/html', 'Content-Length' => 7 ],
        [ 'Hello!!' ],
    ];
};
$app = builder {
    enable 'ContentLength';
    enable 'Watermark', 'comment' => 'TEST';
    $app;
};
test_psgi $app, sub {
    my $cb = shift;
    my $res = $cb->(GET '/');
    is $res->content, qq{Hello!!<!-- TEST -->};
    is $res->header('Content-Length'), 20;
};

done_testing();
