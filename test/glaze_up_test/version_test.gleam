import glaze_up/version.{Version}
import gleeunit/should

pub fn parse_correct_test() {
  "1.6.4"
  |> version.parse()
  |> should.be_ok()
  |> should.equal(Version(1, 6, 4))
}

pub fn parse_correct_long_test() {
  "15644234.664545.4346456"
  |> version.parse()
  |> should.be_ok()
  |> should.equal(Version(15_644_234, 664_545, 4_346_456))
}

pub fn parse_incorrect_test() {
  "1.6"
  |> version.parse()
  |> should.be_error()
}

pub fn to_string_correct_test() {
  Version(1, 6, 4)
  |> version.to_string()
  |> should.equal("1.6.4")
}

pub fn to_string_correct_long_test() {
  Version(15_644_234, 664_545, 4_346_456)
  |> version.to_string()
  |> should.equal("15644234.664545.4346456")
}
