## com.n4kz.certificate

Request SSL certificate from Let's Encrypt using DNS challenge on DigitalOcean

## Installation

```bash
	cpanm --installdeps .
```

## Usage

```bash
	./request.sh <example.com> <test@example.com> <token> \
		--domains "*.example.com, example.com" \
		--renew 30
```

## Copyright and License

BSD License

Copyright 2018-2019 Alexander Nazarov. All rights reserved.
