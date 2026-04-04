# zola-in-a-can

🦀🥫 - it's Zola in a container

## usage

change directories into your project's root directory, then run it

```shell
docker run --rm \
  -v $PWD:/app \
  -p 1111:1111 \
  --workdir /app \
  ghcr.io/some-natalie/zola-in-a-can:latest serve \
  --interface 0.0.0.0
```

## notes

it's rebuilt once a week automatically. all versions are unpinned by default and will float to latest or whatever is in the gemfile. the base image is Chainguard's `rust:latest-dev` tag, then the `glibc-dynamic:latest` tag for runtime.

this isn't for production use, just local development of static sites.

images older than 2 months are deleted automatically.
