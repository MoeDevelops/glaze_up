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

### With testing action

A pull request made by a github action can't invoke other github action
If you want to run a testing action you need to create an access token

1. Create an access token (classic) with the `repo` permission

2. Add the token as the repository secret `GLAZE_UP_TOKEN`

3. Replace the `github.token` with `secrets.GLAZE_UP_TOKEN`

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
        GH_TOKEN: ${{ secrets.GLAZE_UP_TOKEN }}
      permissions:
        contents: write
        pull-requests: write
      steps:
        - uses: actions/checkout@v4
        - uses: moedevelops/glaze_up@v0.1.0
  ```
