import glaze_up/toml.{Dependency}
import glaze_up/version.{Version}
import gleam/io
import gleeunit/should

const toml = "
name = \"glaze_up\"
version = \"0.1.0\"

[dependencies]
gleam_stdlib = \">= 0.55.0 and < 1.0.0\"
tom = \">= 1.1.1 and < 2.0.0\"
simplifile = \">= 2.2.0 and < 3.0.0\"
gleam_erlang = \">= 0.34.0 and < 1.0.0\"

[dev-dependencies]
gleeunit = \">= 1.0.0 and < 2.0.0\"
"

pub fn parse_test() {
  toml.parse(toml)
  |> should.be_ok()
  |> io.debug()
  |> should.equal([
    Dependency("gleeunit", True, Version(1, 0, 0), Version(2, 0, 0)),
    Dependency("gleam_erlang", False, Version(0, 34, 0), Version(1, 0, 0)),
    Dependency("gleam_stdlib", False, Version(0, 55, 0), Version(1, 0, 0)),
    Dependency("simplifile", False, Version(2, 2, 0), Version(3, 0, 0)),
    Dependency("tom", False, Version(1, 1, 1), Version(2, 0, 0)),
  ])
}

pub fn dependency_to_string_test() {
  Dependency("gleam_stdlib", False, Version(0, 44, 0), Version(2, 0, 0))
  |> toml.dependency_to_string()
  |> should.equal("gleam_stdlib = \">= 0.44.0 and < 2.0.0\"")
}
