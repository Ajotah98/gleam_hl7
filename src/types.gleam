import gleam/dict.{type Dict}
import gleam/list

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

/// Return an empty message. Useful for error handling and message builders.
pub fn empty_message() -> Message {
  Message(list.new())
}

pub fn empty_segment() -> Segment {
  Segment("", dict.new())
}

pub fn empty_field() -> Field {
  Field("", dict.new())
}

pub fn empty_component() -> Component {
  Component("", dict.new())
}
