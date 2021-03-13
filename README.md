# Code Reading Club runner

[![Netlify Status](https://api.netlify.com/api/v1/badges/7a05708c-1ea0-4f7c-8639-1b18715fe47e/deploy-status)](https://app.netlify.com/sites/code-reading-runner/deploys)

[Latest Release](https://runner.code-reading.org)

### Prerequisites
Follow official install instructions for your setup:
- [Elm](http://elm-lang.org/) 0.19
- node
- yarn

### Development build
- `yarn start` for a hot-reload dev server

### Tests
- `yarn test`

### Production build
- `yarn build`

### Deployment
#### Needs to be configured in settings
- When a pull request is created against `main`, netlify builds a preview site
- When code is merged into `main` it is deployed to [current release](https://code-reading-runner.netlify.app)
