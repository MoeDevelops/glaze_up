import glaze_up/cmd
import glaze_up/toml
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/time/timestamp
import simplifile

pub fn main() {
  io.println("Starting Glaze Up!")

  cmd.run("git config --global user.name 'github-actions'")
  cmd.run("git config --global user.email 'github-actions@github.com'")
  cmd.run("git config --global --add safe.directory /app")

  let toml =
    simplifile.read("gleam.toml")
    |> do_error("'gleam.toml' not found")

  let dependencies =
    toml.parse(toml)
    |> do_error("Couldn't parse toml data")

  dependencies
  |> list.each(fn(dep) {
    let pre_text = case dep.dev {
      True -> "gleam add --dev "
      False -> "gleam add "
    }
    io.println(cmd.run(pre_text <> dep.name))
  })

  let timestamp =
    timestamp.system_time()
    |> timestamp.to_unix_seconds()
    |> float.truncate()
    |> int.to_string()

  cmd.run("git branch -m glaze_up_" <> timestamp)
  |> io.println()
  cmd.run("git add .")
  |> io.println()
  cmd.run("git commit -m 'Update dependencies'")
  |> io.println()
  cmd.run("git push")
  |> io.println()
  cmd.run("gh pr create -t 'Update dependencies' -b 'Update dependencies'")
  |> io.println()

  io.println("Finished Glaze Up!")

  Ok(Nil)
}

fn do_error(result: Result(a, b), message: String) {
  result.lazy_unwrap(result, fn() { panic as message })
}
