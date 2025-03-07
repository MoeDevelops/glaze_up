import gleam/erlang/charlist.{type Charlist}

pub fn run(cmd: String) -> String {
  cmd
  |> charlist.from_string()
  |> os_cmd()
  |> charlist.to_string()
}

@external(erlang, "os", "cmd")
fn os_cmd(cmd: Charlist) -> Charlist
