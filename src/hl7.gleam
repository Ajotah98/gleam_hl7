import get
import gleam/result
import parse
import types

pub fn main() -> Nil {
  // Pending to make test of all of this
  let hl7_message =
    "MSH|^_\\&|ZorgDomein||||20160324163509+0100||ORU^R01|ZD200046119|P|2.4\rPID|1||^^^NLMINBIZA^NNNLD||de Mannaam&de&Mannaam^G^A^^^^L||20000101|M|||StraatnaamPatient 666"
  hl7_message
  |> parse.message
  |> result.unwrap(types.empty_message())
  |> echo

  hl7_message
  |> parse.message
  |> result.unwrap(types.empty_message())
  |> get.from_segment("MSH")
  |> get.from_field(7)
  |> get.from_component(1)
  |> get.from_subcomponent(1)
  |> echo

  hl7_message
  |> parse.message
  |> result.unwrap(types.empty_message())
  |> get.from("MSH.7.1")
  |> result.unwrap("")
  |> echo

  hl7_message
  |> parse.message
  |> result.unwrap(types.empty_message())
  |> get.from("PID.3.4")
  |> result.unwrap("")
  |> echo

  hl7_message
  |> parse.message
  |> result.unwrap(types.empty_message())
  |> get.from("MSH.5.4.3.2.1")
  |> result.unwrap("It failed")
  |> echo

  Nil
}

pub fn validate_message(message: types.Message) -> Result(types.Message, String) {
  // check if MSH segment exists
  let segment = {
    message |> get.from_segment("MSH")
  }

  let field_separator = {
    segment
    |> get.from_field(1)
    |> get.from_component(1)
    |> get.from_subcomponent(1)
    |> get.subcomponent_to_string
  }

  let message_control_id = {
    segment
    |> get.from_field(10)
    |> get.from_component(1)
    |> get.from_subcomponent(1)
    |> get.subcomponent_to_string
  }

  case segment {
    types.Segment("", _) -> Error("MSH segment not found")
    _ -> {
      case field_separator {
        "" -> Error("Field separator (MSH-1) not found")
        _ -> {
          case message_control_id {
            "" -> Error("Message control ID (MSH-10) not found")
            _ -> Ok(message)
          }
        }
      }
    }
  }
  // check if message control ID exists (MSH-10)
  // check if version ID exists and is valid (MSH-12)
}
