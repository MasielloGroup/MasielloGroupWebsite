## Welcome to the Masiello Group Website Repository

This website is built with [Quarto](https://quarto.org), an open source scientific and technical publishing system.

Note: the `_utils` directory contains helper scripts used when migrating from Wowchemy / Hugo Academic to Quarto.


### Deployment notes to self

- use long-running `updates` branch for deploy previews
- `quarto render` locally and include `_site` in version control
- GitHub action `scp-to-server.yml` deploys to server