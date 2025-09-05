import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn main() -> Nil {
  // Pending to make test of all of this
  let hl7_message =
    "MSH|^_\\&|ZorgDomein||||20160324163509+0100||ORU^R01|ZD200046119|P|2.4\rPID|1||^^^NLMINBIZA^NNNLD||de Mannaam&de&Mannaam^G^A^^^^L||20000101|M|||StraatnaamPatient 666"
  hl7_message
  |> parse_message
  |> result.unwrap(Message(list.new()))
  |> echo

  hl7_message
  |> parse_message
  |> result.unwrap(Message(list.new()))
  |> get_segment("MSH")
  |> get_field(7)
  |> get_component(1)
  |> get_subcomponent(1)
  |> echo

  hl7_message
  |> parse_message
  |> result.unwrap(Message(list.new()))
  |> get("MSH.7.1")
  |> result.unwrap("")
  |> echo

  hl7_message
  |> parse_message
  |> result.unwrap(Message(list.new()))
  |> get("PID.3.4")
  |> result.unwrap("")
  |> echo

  hl7_message
  |> parse_message
  |> result.unwrap(Message(list.new()))
  |> get("MSH.5.4.3.2.1")
  |> result.unwrap("It failed")
  |> echo

  Nil
}

pub type Message {
  Message(List(Segment))
}

pub type Segment {
  Segment(String, Dict(Int, Field))
}

pub type Field {
  Field(String, Dict(Int, Component))
}

pub type Component {
  Component(String, Dict(Int, Subcomponent))
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
    |> dict.from_list
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
    |> dict.from_list
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
    |> dict.from_list
  Component(name, subcomponents)
}

pub fn parse_subcomponent(input: String) -> Subcomponent {
  Subcomponent(input)
}

pub fn get_segment(msg: Message, segment_name: String) -> Segment {
  case msg {
    Message(segments) ->
      segments
      |> list.filter(fn(segment) {
        case segment {
          Segment(name, _) -> name == segment_name
        }
      })
      |> list.first
      |> result.unwrap(Segment("", dict.new()))
  }
}

pub fn get_field(segment: Segment, field_index: Int) -> Field {
  case segment {
    Segment(_, fields) ->
      dict.get(fields, field_index)
      |> result.unwrap(Field("", dict.new()))
  }
}

pub fn get_component(field: Field, component_index: Int) {
  case field {
    Field(_, components) ->
      dict.get(components, component_index)
      |> result.unwrap(Component("", dict.new()))
  }
}

pub fn get_subcomponent(component: Component, subcomponent_index: Int) {
  case component {
    Component(_, subcomponents) ->
      dict.get(subcomponents, subcomponent_index)
      |> result.unwrap(Subcomponent(""))
  }
}

pub fn subcomponent_to_string(subcomponent: Subcomponent) {
  case subcomponent {
    Subcomponent(value) -> value
  }
}

pub fn get(msg: Message, accessor: String) -> Result(String, String) {
  let parsed = string.split(accessor, ".")
  case parsed {
    [segment, field, component] -> {
      msg
      |> get_segment(segment)
      |> get_field(int.parse(field) |> result.unwrap(1))
      |> get_component(int.parse(component) |> result.unwrap(1))
      |> get_subcomponent(1)
      |> subcomponent_to_string
      |> Ok
    }
    [segment, field, component, subcomponent] -> {
      msg
      |> get_segment(segment)
      |> get_field(int.parse(field) |> result.unwrap(1))
      |> get_component(int.parse(component) |> result.unwrap(1))
      |> get_subcomponent(int.parse(subcomponent) |> result.unwrap(1))
      |> subcomponent_to_string
      |> Ok()
    }
    [_] | [] | [_, _] -> Error("Few arguments provided")
    [_, _, _, _, _, ..] -> Error("Too much args")
  }
}

pub fn validate_message(message: Message) {
  // check if MSH segment exists
  // check if message type exists and is valid (MSH-9)
  // check if message control ID exists (MSH-10)
  // check if version ID exists and is valid (MSH-12)
  todo
}
