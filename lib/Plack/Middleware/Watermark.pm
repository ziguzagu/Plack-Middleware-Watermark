package Plack::Middleware::Watermark;

use strict;
use warnings;

our $VERSION = '0.01';

use parent qw( Plack::Middleware );
use Plack::Util::Accessor qw( comment );

use Plack::Util;
use Carp ();

sub prepare_app {
    my $self = shift;

    unless ($self->comment) {
        Carp::croak "'comment' is not defined";
    }
}

sub call {
    my $self  = shift;
    my ($env) = @_;

    my $res = $self->app->($env);
    $self->response_cb($res, sub {
        my $res  = shift;
        my $type = Plack::Util::header_get($res->[1], 'Content-Type');
        if ($type && $res->[0] == 200) {
            my ($start, $stop)
                = ( $type =~ m{^text/(?:html|xml)} ) ? ( '<!--', '-->' )
                : ( $type =~ m{^application/(?:xml|xhtml\+xml|rss\+xml|atom\+xml)} ) ? ( '<!--', '-->' )
                : ( $type =~ m{^text/css} )          ? ( '/*', '*/' )
                : ( $type =~ m{^text/javascript} )   ? ( '//', '' )
                :                                      ()
                ;
            if ($start or $stop) {
                return sub {
                    my $chunk = shift;
                    return unless defined $chunk;
                    my $comment = ref $self->comment eq 'CODE' ? $self->comment->($env) : $self->comment;
                    $chunk .= join ' ', $start, $comment, $stop;
                    return $chunk;
                };
            }
        }
    });
}

1;
__END__

=pod

=head1 NAME

Plack::Middleware::Watermakr - Add watermark to response body

=head1 SYNOPSIS

  use Plack::Builder;
  my $app = sub {
      [ 200, [ 'Content-Type' => 'text/html' ], [ "Hello World\n" ] ]
  };
  builder {
      enable 'Watermark', comment => 'generated on my server';
      $app;
  }

  # Hello World
  # <!-- generated on my server -->

=head1 DESCRIPTION

Watermrk middleware 

=head1 OPTIONS

=head2 comment

=head1 AUTHOR

Hiroshi Sakai E<lt>ziguzagu@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2010 Six Apart, Ltd. All rights reserved.

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
