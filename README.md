# Glaze up!

Automatically update your Gleam dependencies!

## Usage

1. Enable pull requests in the repository
  `Settings > Actions > General > Workflow permissions > Allow GitHub Actions to create and approve pull requests`

2. Add the workflow `.github/workflows/glaze_up.yml`

  ```yml
  name: Glaze up

  on:
    workflow_dispatch: # Start manually
    schedule:
      - cron: "00 9 * * *" # 09:00 UTC every day

  jobs:
    update:
      runs-on: ubuntu-latest
      env:
        GH_TOKEN: ${{ github.token }}
      permissions:
        contents: write
        pull-requests: write
      steps:
        - uses: actions/checkout@v4
        - uses: moedevelops/glaze_up@v0.1.0
  ```
