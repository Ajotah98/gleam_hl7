# gleam_hl7

A HL7 v2.x parser implementation in Gleam. This is a Work in Progress project, initially created as a learning exercise for Gleam and functional programming concepts.

## Status

This project is in early development stages. Currently, it can parse basic HL7 v2.x messages into a structured format, handling:
- Message segments
- Fields
- Components
- Subcomponents

## Installation

```sh
gleam add hl7@1
```

## Usage

Basic message parsing example:

```gleam
import hl7

pub fn main() {
  let message = "MSH|^~\\&|ZorgDomein||||20160324163509+0100||ORU^R01|ZD200046119|P|2.4\rPID|1||^^^NLMINBIZA^NNNLD||Smith^John" // Extracted from here: https://integrator.zorgdomein.com/hl7v2-specs/sample-oru-pdf-referral-letter/
  
  case hl7.parse_message(message) {
    Ok(parsed) -> // Work with parsed message
    Error(err) -> // Handle error
  }

  // Some examples I did while creating this before they became tests:
  
  let hl7_message ="MSH|^_\\&|ZorgDomein||||20160324163509+0100||ORU^R01|ZD200046119|P|2.4\rPID|1||^^^NLMINBIZA^NNNLD||de Mannaam&de&Mannaam^G^A^^^^L||20000101|M|||StraatnaamPatient 666"
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

}
```

## TODO
- [x] First implementation to destructure an HL7v2 message into Gleam indexed lists
- [ ] Implement proper error handling
- [ ] Add message validation
- [ ] Support message encoding/escaping
- [x] Implement field, component and subcomponent accessors
- [x] Implement a _get_ accessor with HL7 common format (MSH.5.1, PID.3.4.1, etc.)
- [ ] Support repeating fields
- [ ] Add support for custom segment definitions
- [ ] Implement message builder
- [ ] Add comprehensive test suite
- [ ] Add documentation and examples
- [ ] Support for different HL7 versions (such as XML ones...)

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```

## Contributing

This is a learning project, but contributions and suggestions are welcome!