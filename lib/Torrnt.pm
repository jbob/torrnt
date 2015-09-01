package Torrnt;
use Mojo::Base 'Mojolicious';

use Mango;
use Mango::BSON::ObjectID;

use Torrnt::Model::Torrents;

# This method will run once at server start
sub startup {
  my $self = shift;

  my $config = $self->plugin('Config');

  $self->secrets($config->{secret});
  $self->helper(torrents => sub {
      state $torrents = Torrnt::Model::Torrents->new(mongouri => $config->{mongouri});
  });
  $self->types->type(json => 'application/json; charset=utf-8');

  # Router
  my $r = $self->routes;

  $r->get('/')->to('torrnt#index')->name('index');
  $r->post('/')->to('posts#create');
  $r->get('/show/:oid')->to('posts#show');
  $r->get('/delete')->to('posts#delete');
  $r->any('/delete/:oid/:delete')->to('posts#delete', oid => '', delete => '');
  $r->any('/search/:q')->to('torrnt#search', q => '');
  $r->get('/latest')->to('posts#latest');
  $r->get('/about')->to('posts#about');

}

1;
