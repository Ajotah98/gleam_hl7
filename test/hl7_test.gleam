import gleam/result
import gleeunit
import hl7/get
import hl7/parse
import hl7/types

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn parse_message_test() {
  let hl7_message =
    "MSH|^_\\&|ZorgDomein||||20160324163509+0100||ORU^R01|ZD200046119|P|2.4\rPID|1||^^^NLMINBIZA^NNNLD||de Mannaam&de&Mannaam^G^A^^^^L||20000101|M|||StraatnaamPatient 666"
  let result = {
    hl7_message
    |> parse.message
    |> result.unwrap(types.empty_message())
  }
}

pub fn parse_message_should_fail_test() {
  let hl7_message =
    "MSH|^_\\&|ZorgDomein||||20160324163509+0100||ORU^R01|ZD200046119|P|2.4\rPID|1||^^^NLMINBIZA^NNNLD||de Mannaam&de&Mannaam^G^A^^^^L||20000101|M|||StraatnaamPatient 666"
  let result = {
    hl7_message
    |> parse.message
    |> result.unwrap(types.empty_message())
    |> get.from("MSH.5.4.3.2.1")
    |> result.unwrap("It failed")
  }
  assert result == "It failed"
}

pub fn get_from_extended_test() {
  let hl7_message =
    "MSH|^_\\&|ZorgDomein||||20160324163509+0100||ORU^R01|ZD200046119|P|2.4\rPID|1||^^^NLMINBIZA^NNNLD||de Mannaam&de&Mannaam^G^A^^^^L||20000101|M|||StraatnaamPatient 666"
  let result = {
    hl7_message
    |> parse.message
    |> result.unwrap(types.empty_message())
    |> get.from_segment("MSH")
    |> get.from_field(7)
    |> get.from_component(1)
    |> get.from_subcomponent(1)
  }

  assert result == types.Subcomponent("20160324163509+0100")
}

pub fn get_from_test() {
  let hl7_message =
    "MSH|^_\\&|ZorgDomein||||20160324163509+0100||ORU^R01|ZD200046119|P|2.4\rPID|1||^^^NLMINBIZA^NNNLD||de Mannaam&de&Mannaam^G^A^^^^L||20000101|M|||StraatnaamPatient 666"
  let result = {
    hl7_message
    |> parse.message
    |> result.unwrap(types.empty_message())
    |> get.from("PID.3.4")
    |> result.unwrap("")
  }

  assert result == "NLMINBIZA"
}

pub fn get_from_2_test() {
  let hl7_message =
    "MSH|^_\\&|ZorgDomein||||20160324163509+0100||ORU^R01|ZD200046119|P|2.4\rPID|1||^^^NLMINBIZA^NNNLD||de Mannaam&de&Mannaam^G^A^^^^L||20000101|M|||StraatnaamPatient 666"
  let result = {
    hl7_message
    |> parse.message
    |> result.unwrap(types.empty_message())
    |> get.from("PID.5.1.2")
    |> result.unwrap("")
  }

  assert result == "de"
}

pub fn get_from_3_test() {
  let hl7_message =
    "MSH|^_\\&|ZorgDomein||||20160324163509+0100||ORU^R01|ZD200046119|P|2.4\rPID|1||^^^NLMINBIZA^NNNLD||de Mannaam&de&Mannaam^G^A^^^^L||20000101|M|||StraatnaamPatient 666"
  let result = {
    hl7_message
    |> parse.message
    |> result.unwrap(types.empty_message())
    |> get.from("MSH.7.1")
    |> result.unwrap("")
  }
  assert result == "20160324163509+0100"
}
