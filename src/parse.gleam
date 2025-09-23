//// A simple HL7v2 parser in Gleam
//// It parses a HL7v2 message string into a nested structure of segments, fields, components and subcomponents.
//// It also provides functions to access specific parts of the message using HL7v2 notation.
//// Example:
//// ```gleam
//// let hl7_message =
////   "MSH|^_\\&|ZorgDomein||||20160324163509+0100||ORU^R01|ZD200046119|P|2.4\rPID|1||^^^NLMINBIZA^NNNLD||de Mannaam&de&Mannaam^G^A^^^^L||20000101|    M|||StraatnaamPatient 666"
//// hl7_message
//// |> parse.message
//// |> result.unwrap(types.empty_message())
//// |> get.from_segment("MSH")
//// |> get.from_field(7)
//// |> get.from_component(1)
//// |> get.from_subcomponent(1)
//// |> get.subcomponent_to_string
//// // -> "200202150930"

import get
import gleam/dict
import gleam/list
import gleam/result
import gleam/string
import types

pub fn message(input: String) -> Result(types.Message, String) {
  let delimiters: types.Delimiters =
    types.Delimiters(
      string.slice(input, 3, 1),
      string.slice(input, 4, 1),
      string.slice(input, 5, 1),
      string.slice(input, 6, 1),
      string.slice(input, 7, 1),
    )

  let segments =
    input
    |> string.split("\r")
    |> list.map(segment(_, delimiters))
    |> list.filter(fn(s) {
      case s {
        types.Segment(name, _) -> name != ""
      }
    })

  case segments {
    // todo better error handling
    [] -> Error("No segments found")
    _ -> validate_message(types.Message(segments))
  }
}

pub fn segment(input: String, delimiters: types.Delimiters) -> types.Segment {
  let fields = string.split(input, delimiters.field_delimiter)
  let name = list.first(fields) |> result.unwrap("")
  let fields =
    fields
    |> list.map(field(_, delimiters))
    |> list.index_map(fn(field: types.Field, index: Int) {
      // types.Field start at 0 index to discard the message segment name, except the MSH segment (as MSH delimiters count as 2 fields!)
      case name {
        "MSH" -> #(index + 1, field)
        _ -> #(index, field)
      }
    })
    |> dict.from_list
  types.Segment(name, fields)
}

pub fn field(input: String, delimiters: types.Delimiters) -> types.Field {
  let has_reps = string.contains(input, delimiters.repetition_delimiter)
  case has_reps {
    False -> {
      let components = string.split(input, delimiters.component_delimiter)
      parse_components(components, delimiters)
    }
    True -> parse_repetitions(input, delimiters)
  }
}

fn parse_repetitions(input: String, delimiters: types.Delimiters) -> types.Field {
  let repetitions = string.split(input, delimiters.repetition_delimiter)
  let reps =
    repetitions
    |> list.index_map(fn(part, index) {
      let components = string.split(part, delimiters.component_delimiter)
      #(index, components |> parse_components(delimiters))
    })
    |> dict.from_list
  types.FieldRepetitions(reps)
}

fn parse_components(
  splitted_components: List(String),
  delimiters: types.Delimiters,
) {
  let name = list.first(splitted_components) |> result.unwrap("")
  let components =
    splitted_components
    |> list.map(component(_, delimiters))
    |> list.index_map(fn(component: types.Component, index: Int) {
      // types.Field accessors should always start at index 1 according to HL7v2 standard
      #(index + 1, component)
    })
    |> dict.from_list
  types.FieldUnit(name, components)
}

pub fn component(input: String, delimiters: types.Delimiters) -> types.Component {
  let parts = string.split(input, delimiters.subcomponent_delimiter)
  let name = list.first(parts) |> result.unwrap("")
  let subcomponents =
    parts
    |> list.map(subcomponent)
    |> list.index_map(fn(subcomponent: types.Subcomponent, index: Int) {
      // types.Subcomponent accessors should always start at index 1 according to HL7v2 standard
      #(index + 1, subcomponent)
    })
    |> dict.from_list
  types.Component(name, subcomponents)
}

pub fn subcomponent(input: String) -> types.Subcomponent {
  types.Subcomponent(input)
}

pub fn validate_message(message: types.Message) -> Result(types.Message, String) {
  let segment = {
    message |> get.from_segment_indexed("MSH", 1)
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
      case message_control_id {
        "" -> Error("Message control ID (MSH-10) not found")
        _ -> Ok(message)
      }
    }
  }
}
