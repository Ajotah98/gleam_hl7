import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string

pub fn main() -> Nil {
  let hl7_message =
    "MSH|^_\\&|ZorgDomein||||20160324163509+0100||ORU^R01|ZD200046119|P|2.4\rPID|1||^^^NLMINBIZA^NNNLD||de Mannaam&de&Mannaam^G^A^^^^L||20000101|M|||StraatnaamPatient 666"
  hl7_message
  |> parse_message
  |> echo

  Nil
}

pub type Message {
  Message(List(Segment))
}

pub type Segment {
  Segment(String, List(#(Int, Field)))
}

pub type Field {
  Field(String, List(#(Int, Component)))
}

pub type Component {
  Component(String, List(#(Int, Subcomponent)))
}

pub type Subcomponent {
  Subcomponent(String)
}

pub type Delimiters {
  Delimiters(
    field_delimiter: String,
    component_delimiter: String,
    repetition_delimiter: String,
    escape_character: String,
    subcomponent_delimiter: String,
  )
}

pub fn parse_message(input: String) -> Result(Message, String) {
  let delimiters: Delimiters =
    Delimiters(
      string.slice(input, 3, 1),
      string.slice(input, 4, 1),
      string.slice(input, 5, 1),
      string.slice(input, 6, 1),
      string.slice(input, 7, 1),
    )

  let segments =
    input
    |> string.split("\r")
    |> list.map(parse_segment(_, delimiters))

  case segments {
    // todo better error handling
    [] -> Error("Bad HL7 format")
    _ -> Ok(Message(segments))
  }
}

pub fn parse_segment(input: String, delimiters: Delimiters) -> Segment {
  let fields = string.split(input, delimiters.field_delimiter)
  let name = list.first(fields) |> result.unwrap("")
  let fields =
    fields
    |> list.map(parse_field(_, delimiters))
    |> list.index_map(fn(field: Field, index: Int) {
      // Fields start at 0 index to discard the message segment name, except the MSH segment (as MSH delimiters count as 2 fields!)
      case name {
        "MSH" -> #(index + 1, field)
        _ -> #(index, field)
      }
    })
  Segment(name, fields)
}

pub fn parse_field(input: String, delimiters: Delimiters) -> Field {
  let components = string.split(input, delimiters.component_delimiter)
  let name = list.first(components) |> result.unwrap("")
  let components =
    components
    |> list.map(parse_component(_, delimiters))
    |> list.index_map(fn(component: Component, index: Int) {
      // Field accessors should always start at index 1 according to HL7v2 standard
      #(index + 1, component)
    })
  Field(name, components)
}

pub fn parse_component(input: String, delimiters: Delimiters) -> Component {
  let parts = string.split(input, delimiters.subcomponent_delimiter)
  let name = list.first(parts) |> result.unwrap("")
  let subcomponents =
    parts
    |> list.map(parse_subcomponent)
    |> list.index_map(fn(subcomponent: Subcomponent, index: Int) {
      // Subcomponent accessors should always start at index 1 according to HL7v2 standard
      #(index + 1, subcomponent)
    })
  Component(name, subcomponents)
}

pub fn parse_subcomponent(input: String) -> Subcomponent {
  Subcomponent(input)
}

pub fn get_field(
  message: Message,
  segment_name: String,
  field_index: Int,
) -> Option(Field) {
  // It should be smth like:
  // case message {
  //   Message(segments) ->
  //     segments
  //     |> list.filter(fn(s) {
  //       case s {
  //         Segment(name, _) -> name == segment_name
  //       }
  //     })
  //     |> list.first
  //     |> option.and_then(fn(s) {
  //       case s {
  //         Segment(_, fields) -> fields....
  //       }

  //     })
  // }
  // but using the accessors properly
  todo
}
