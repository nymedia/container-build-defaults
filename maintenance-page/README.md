# Simple "Maintenance Page" Container

This container responds with HTTP status code 503 for all requests, with the exception of `/.healthz` which is used for health checks and returns HTTP status code 204.

The container image is available on GitHub Container Registry at `ghcr.io/nymedia/container-build-defaults/nginx-maintenance-page`

## Features

- Uses the base nginx image from [wodby/nginx](https://github.com/wodby/nginx).
- Always serves a custom maintenance page (`maintenance-page.html`) with HTTP status 503
- Provides a health check endpoint (`/.healthz`) that returns HTTP status 204

## Usage

To use this container, simply pull the Docker image from the repository:

```bash
docker pull ghcr.io/nymedia/container-build-defaults/nginx-maintenance-page:1.x
```

You can run the container with:

```bash
docker run -d -p 8080:80 ghcr.io/nymedia/container-build-defaults/nginx-maintenance-page:1.x
```

Now, if you navigate to `http://localhost:8080` in your web browser, you will see the custom maintenance page.

If you navigate to `http://localhost:8080/.healthz`, you will receive a HTTP 200 status code indicating the container is running properly.

## Customization

To customize the error page, you'll need to build the Docker image yourself.
Simply replace the `maintenance-page.html` with your own.
