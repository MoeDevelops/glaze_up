import glaze_up/version.{type Version}
import gleam/dict.{type Dict}
import gleam/list
import gleam/result
import gleam/string
import tom.{type Toml}

pub type Dependency {
  Dependency(
    name: String,
    dev: Bool,
    min_version: Version,
    max_version: Version,
  )
}

pub fn parse_dependency(
  name: String,
  version: String,
) -> Result(Dependency, Nil) {
  use #(min_ver, max_ver) <- result.try(case
    version
    |> string.drop_start(3)
    |> string.split(" and < ")
  {
    [min_ver_str, max_ver_str] -> {
      use min_ver <- result.try(version.parse(min_ver_str))
      use max_ver <- result.try(version.parse(max_ver_str))
      Ok(#(min_ver, max_ver))
    }
    _ -> Error(Nil)
  })

  Ok(Dependency(name, False, min_ver, max_ver))
}

pub fn dependency_to_string(dep: Dependency) -> String {
  dep.name
  <> " = \">= "
  <> version.to_string(dep.min_version)
  <> " and < "
  <> version.to_string(dep.max_version)
  <> "\""
}

pub fn parse(toml: String) -> Result(List(Dependency), Nil) {
  use parsed_toml <- result.try(tom.parse(toml) |> result.replace_error(Nil))

  use dependencies <- result.try(do_parse(parsed_toml, "dependencies"))
  use dev_dependencies <- result.try(do_parse(parsed_toml, "dev-dependencies"))

  dev_dependencies
  |> list.map(fn(dep) { Dependency(..dep, dev: True) })
  |> list.append(dependencies)
  |> Ok()
}

pub fn do_parse(
  toml: Dict(String, Toml),
  table: String,
) -> Result(List(Dependency), Nil) {
  use dependencies_table <- result.try(
    tom.get_table(toml, [table])
    |> result.replace_error(Nil),
  )

  dependencies_table
  |> dict.map_values(fn(_, val) { tom.as_string(val) })
  |> dict.to_list()
  |> list.filter_map(fn(pair) {
    case pair {
      #(key, Ok(val)) -> Ok(#(key, val))
      _ -> Error(Nil)
    }
  })
  |> list.map(fn(dep_strs) { parse_dependency(dep_strs.0, dep_strs.1) })
  |> result.values()
  |> Ok()
}
