import gleam/int
import gleam/result
import gleam/string

pub type Version {
  Version(major: Int, minor: Int, patch: Int)
}

pub fn parse(str: String) -> Result(Version, Nil) {
  case
    str
    |> string.split(".")
  {
    [major_s, minor_s, patch_s] -> {
      use major <- result.try(int.parse(major_s))
      use minor <- result.try(int.parse(minor_s))
      use patch <- result.try(int.parse(patch_s))

      Ok(Version(major, minor, patch))
    }
    _ -> Error(Nil)
  }
}

pub fn to_string(version: Version) -> String {
  int.to_string(version.major)
  <> "."
  <> int.to_string(version.minor)
  <> "."
  <> int.to_string(version.patch)
}
