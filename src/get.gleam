//// A module to get values from a parsed HL7 message using:
//// A string accessor like "MSH.7.1" (Segment.Field.Component.Subcomponent)
//// or using functions to get each level separately.
//// Example:
//// ```gleam
//// import hl7.{get, types}
//// let hl7_message = "MSH|^~\\&|HIS|RIH|EKG|EKG|200202150930||ADT^A01|010529|P|2.5\rPID|||555-44-4444||EVERYWOMAN^EVE^E^^MISS||19610615|F|||2222 HOME ST^^METROPOLIS^IL^44130||(216)123-4567|(216)123-4567||S||555-55-5555||||||||||||||||N"
//// parse.message(hl7_message)
//// |> result.unwrap(types.empty_message())
//// |> get.from("MSH.7.1")
//// |> result.unwrap("")
//// // -> "200202150930"
//// ```
//// or
//// ```gleam
//// import hl7.{get, types}
//// let hl7_message = "MSH|^~\\&|HIS|RIH|EKG|EKG|200202150930||ADT^A01|010529|P|2.5\rPID|||555-44-4444||EVERYWOMAN^EVE^E^^MISS||19610615|F|||2222 HOME ST^^METROPOLIS^IL^44130||(216)123-4567|(216)123-4567||S||555-55-5555||||||||||||||||N"
//// parse.message(hl7_message)
//// |> result.unwrap(types.empty_message())
//// |> get.from_segment("MSH")
//// |> get.from_field(7)
//// |> get.from_component(1)
//// |> get.from_subcomponent(1)
//// |> get.subcomponent_to_string
//// // -> "200202150930"
//// ```  

import gleam/dict
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import types

pub fn from_segment(msg: types.Message, segment_name: String) -> types.Segment {
  case msg {
    types.Message(segments) ->
      segments
      |> list.filter(fn(segment) {
        case segment {
          types.Segment(name, _) -> name == segment_name
        }
      })
      |> list.first
      |> result.unwrap(types.Segment("", dict.new()))
  }
}

pub fn from_field(segment: types.Segment, field_index: Int) -> types.Field {
  case segment {
    types.Segment(_, fields) ->
      dict.get(fields, field_index)
      |> result.unwrap(types.Field("", dict.new()))
  }
}

pub fn from_component(field: types.Field, component_index: Int) {
  case field {
    types.Field(_, components) ->
      dict.get(components, component_index)
      |> result.unwrap(types.Component("", dict.new()))
  }
}

pub fn from_subcomponent(component: types.Component, subcomponent_index: Int) {
  case component {
    types.Component(_, subcomponents) ->
      dict.get(subcomponents, subcomponent_index)
      |> result.unwrap(types.Subcomponent(""))
  }
}

pub fn subcomponent_to_string(subcomponent: types.Subcomponent) {
  case subcomponent {
    types.Subcomponent(value) -> value
  }
}

pub fn from(msg: types.Message, accessor: String) -> Result(String, String) {
  let parsed = string.split(accessor, ".")
  case parsed {
    [segment, field, component] -> {
      msg
      |> from_segment(segment)
      |> from_field(int.parse(field) |> result.unwrap(1))
      |> from_component(int.parse(component) |> result.unwrap(1))
      |> from_subcomponent(1)
      |> subcomponent_to_string
      |> Ok
    }
    [segment, field, component, subcomponent] -> {
      msg
      |> from_segment(segment)
      |> from_field(int.parse(field) |> result.unwrap(1))
      |> from_component(int.parse(component) |> result.unwrap(1))
      |> from_subcomponent(int.parse(subcomponent) |> result.unwrap(1))
      |> subcomponent_to_string
      |> Ok()
    }
    [_] | [] | [_, _] -> Error("Few arguments provided")
    [_, _, _, _, _, ..] -> Error("Too much args")
  }
}
