import glaze_up/cmd
import glaze_up/toml
import gleam/io
import gleam/list
import gleam/result
import simplifile

pub fn main() {
  io.println("Starting Glaze up!")

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

  io.println("Finished Glaze up!")
}

fn do_error(result: Result(a, b), message: String) {
  result.lazy_unwrap(result, fn() { panic as message })
}
