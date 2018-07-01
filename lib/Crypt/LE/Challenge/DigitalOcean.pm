package Crypt::LE::Challenge::DigitalOcean;
use strict;
use warnings;
use feature ':5.10';
use Try::Tiny;
use DigitalOcean;
use Digest::SHA 'sha256';
use MIME::Base64 'encode_base64url';

our $VERSION = 1;

my $basename = sub { ($_[0] =~ m{^(?:\*\.)?(.+)$})[0] };

sub new { bless {}, shift }

sub handle_challenge_dns {
	my ($self, $challenge, $params) = @_;

	my $name = $basename->($challenge->{'domain'});
	my $data = join '.', @{ $challenge }{qw{ token fingerprint }};

	try {
		my $do = DigitalOcean
			->new(oauth_token => $params->{'token'});

		my $domain = $do->domain($name);

		$domain->create_record(
			type => 'TXT',
			name => '_acme-challenge',
			data => encode_base64url(sha256($data)),
		);

		sleep 2;
	} catch {
		return 0;
	};

	return 1;
} # handle_challenge_dns

sub handle_verification_dns {
	my ($self, $results, $params) = @_;

	my $name = $basename->($results->{'domain'});

	try {
		my $do = DigitalOcean
			->new(oauth_token => $params->{'token'});

		my $records = $do->domain($name)
			->records();

		while (my $record = $records->next()) {
			next if $record->type ne 'TXT';
			next if $record->name ne '_acme-challenge';

			$record->delete();
		}
	} catch {
		return 0;
	};

	return 1;
} # handle_verification_dns

1;
