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
import glearray
import types

/// Pass a message and get the segment name with segment ocurrence n
/// 
/// Example:
/// If you want the PID segment:
/// ```gleam
/// let msg = ...
/// msg
/// |> get.from_segment("PID",1) // This will search the segment "PID|1|..."
/// ```
/// 
/// But if you want the 4th OBX, you can do:
/// ```gleam
/// let msg = ...
/// msg
/// |> get.from_segment("OBX",4) // This will search the segment "OBX|4|..."
/// ```
/// 
/// For MSH (or if you only want the first repetition segment), you should use "get.from_segment" (as is indexed by 1 by default)
pub fn from_segment_indexed(
  msg: types.Message,
  segment_name: String,
  segment_rep: Int,
) -> types.Segment {
  case msg {
    types.Message(segments) ->
      segments
      |> list.filter(fn(segment) {
        case segment {
          types.Segment(name, _) -> name == segment_name
        }
      })
      |> list.find(fn(s) { repetition_aux(s, segment_rep) })
      |> result.unwrap(types.Segment("", dict.new()))
  }
}

fn repetition_aux(segment: types.Segment, segment_rep: Int) -> Bool {
  case segment {
    types.Segment(name, fields) -> {
      case name {
        "MSH" -> True
        _ -> {
          let field_accessor_val =
            dict.values(fields)
            |> list.filter(fn(f) {
              case f {
                types.FieldUnit(_, _) -> {
                  let number =
                    from_component(f, 1)
                    |> from_subcomponent(1)
                    |> subcomponent_to_string
                    |> int.parse
                    |> result.unwrap(1)
                  number == segment_rep
                }
                types.FieldRepetitions(_) ->
                  panic as "Field 2 (accessor) shouldn't have repetitions."
              }
            })
          case field_accessor_val {
            [] -> False
            _ -> True
          }
        }
      }
    }
  }
}

pub fn from_segment(msg: types.Message, segment_name: String) {
  from_segment_indexed(msg, segment_name, 1)
}

pub fn from_field(segment: types.Segment, field_index: Int) -> types.Field {
  case segment {
    types.Segment(_, fields) ->
      dict.get(fields, field_index)
      |> result.unwrap(types.FieldUnit("", dict.new()))
  }
}

pub fn from_component(field: types.Field, component_index: Int) {
  from_component_rep(field, component_index, 1)
}

pub fn from_component_rep(
  field: types.Field,
  component_index: Int,
  repetition_at: Int,
) {
  case field {
    types.FieldUnit(_, components) ->
      dict.get(components, component_index)
      |> result.unwrap(types.Component("", dict.new()))
    types.FieldRepetitions(reps) -> {
      let first_unit =
        reps
        |> glearray.get(repetition_at)
        |> result.unwrap(types.FieldUnit("", dict.new()))
      case first_unit {
        types.FieldUnit(_, components) ->
          dict.get(components, component_index)
          |> result.unwrap(types.Component("", dict.new()))
        types.FieldRepetitions(_) ->
          panic as "A repetition inside a repetition???"
      }
    }
  }
}

pub fn from_subcomponent(component: types.Component, subcomponent_index: Int) {
  case component {
    types.Component(_, subcomponents) ->
      dict.get(subcomponents, subcomponent_index)
      |> result.unwrap(types.Subcomponent(""))
  }
}

pub fn subcomponent_to_string(subcomponent: types.Subcomponent) -> String {
  case subcomponent {
    types.Subcomponent(value) -> value
  }
}

/// Returns the first subcomponent into a String. Useful to avoid this:
/// ```gleam
/// let my_msg = ...
///  
/// let my_comp = 
/// // Instead of doing this:
///   my_msg
///   |> get.from_segment("OBX",1)
///   |> get.from_field(3)
///   |> get.from_component(1)
///   |> get.from_subcomponent(1)
///   |> get.subcomponent_to_string
/// 
/// // You can do:
///   my_msg
///   |> get.from_segment("OBX",1)
///   |> get.from_field(3)
///   |> get.from_component(1)
///   |> get.component_to_string
/// 
/// ```
pub fn component_to_string(component: types.Component) -> String {
  component
  |> from_subcomponent(1)
  |> subcomponent_to_string
}

/// Get a value from a parsed HL7 message using a string accessor like "MSH.7.1" (Segment.Field.Component.Subcomponent) Also, subcomponents are optional (if not specified, the first subcomponent will be getted).
/// If the int values are not valid integers, it will access the first coincidence (it will use 1 as index).
/// Example: "PID.X.Y" is the same as "PID.1.1.1"
/// If the accessor has too few or too many arguments, an error will be returned.
/// Returns a Result with the value or an error message.
pub fn from(msg: types.Message, accessor: String) -> Result(String, String) {
  let parsed = string.split(accessor, ".")
  case parsed {
    [segment, field, component] -> {
      msg
      |> from_segment_indexed(segment, 1)
      |> from_field(int.parse(field) |> result.unwrap(1))
      |> from_component(int.parse(component) |> result.unwrap(1))
      |> from_subcomponent(1)
      |> subcomponent_to_string
      |> Ok
    }
    [segment, field, component, subcomponent] -> {
      msg
      |> from_segment_indexed(segment, 1)
      |> from_field(int.parse(field) |> result.unwrap(1))
      |> from_component(int.parse(component) |> result.unwrap(1))
      |> from_subcomponent(int.parse(subcomponent) |> result.unwrap(1))
      |> subcomponent_to_string
      |> Ok
    }
    [_] | [] | [_, _] -> Error("Few arguments provided")
    [_, _, _, _, _, ..] -> Error("Too much args")
  }
}
