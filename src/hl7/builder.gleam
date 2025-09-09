import gleam/dict
import gleam/list
import gleam/string
import hl7/types.{
  type Component, type Delimiters, type Field, type Message, type Segment,
  type Subcomponent,
}

pub fn build_message(msg: Message, delimiters: types.Delimiters) -> String {
  case msg {
    types.Message(segments) -> {
      segments
      |> list.map(build_segment(_, delimiters))
      |> string.join("")
    }
  }
}

fn build_segment(segment: Segment, delimiters: Delimiters) -> String {
  case segment {
    types.Segment(_, fields) -> {
      let fields_str =
        fields
        |> dict.values()
        |> list.map(build_field(_, delimiters))
        |> string.join(delimiters.field_delimiter)
      fields_str <> "\r"
    }
  }
}

fn build_field(field: Field, delimiters: Delimiters) -> String {
  case field {
    types.Field(_, components) -> {
      let components_str =
        components
        |> dict.values()
        |> list.map(build_component(_, delimiters))
        |> string.join(delimiters.component_delimiter)
      components_str
    }
  }
}

// fn build_repetition(
//   repetition: types.Repetitions,
//   delimiters: types.Delimiters,
// ) -> String {
//   case repetition {
//     types.Repetitions(fields) -> {
//       let fields_str =
//         fields
//         |> list.first()
//         |> result.unwrap(dict.new())
//         |> dict.values()
//         |> list.map(build_component(_, delimiters))
//         |> string.join(delimiters.repetition_delimiter)
//       fields_str
//     }
//   }
// }

fn build_component(component: Component, delimiters: Delimiters) -> String {
  case component {
    types.Component(_, subcomponents) -> {
      let subcomponents_str =
        subcomponents
        |> dict.values()
        |> list.map(build_subcomponent)
        |> string.join(delimiters.subcomponent_delimiter)
      subcomponents_str
    }
  }
}

fn build_subcomponent(subcomponent: Subcomponent) -> String {
  case subcomponent {
    types.Subcomponent(value) -> value
  }
}
