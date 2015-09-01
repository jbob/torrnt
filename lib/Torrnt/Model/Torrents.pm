package Torrnt::Model::Torrents;

use strict;
use warnings;

use Mango;
use Mojo::Base -base;

use Data::Dumper;

has 'mango' => sub { Mango->new(shift->{mongouri}); };

sub find {
    my $self = shift;
    my $q    = shift;

    my $collection = $self->mango->db->collection('torrents');
    return $collection->find({'$or' => [{title => qr/$q/},
                                        {desc  => qr/$q/},
                                        {files => qr/$q/}
                                       ]})->all;
}

sub all {
    my $self = shift;

    my $collection = $self->mango->db->collection('torrents');
    return $collection->find()->all;
};

sub count {
    my $self = shift;

    my $collection = $self->mango->db->collection('torrents');
    return $collection->find()->count;
}

1;
