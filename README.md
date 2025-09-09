# gleam_hl7

A HL7 v2.x parser implementation in Gleam. 

This works as a library: It has no main-file. You can just download it or append it from Hex (not published **yet**) and import the packages you need to parse them.

## Status

This project is in early development stages. Currently, it can parse basic HL7 v2.x messages into a structured format, handling:
- Message segments
- Fields
- Components
- Subcomponents

Also, you can use the builder to build messages from the Gleam definition/structure

## Installation

This package is not published **yet** to Hex as is in early development. So, if you want to use it or modify it, you will need to download the project and copy paste the /src gleam files into your /src and the /test files into your /tests

## Usage

Basic message parsing example:

```gleam
import hl7

pub fn main() {
  let message = "MSH|^~\\&|ZorgDomein||||20160324163509+0100||ORU^R01|ZD200046119|P|2.4\rPID|1||^^^NLMINBIZA^NNNLD||Smith^John\r" // Extracted from here: https://integrator.zorgdomein.com/hl7v2-specs/sample-oru-pdf-referral-letter/
  
  case hl7.parse.message(message) {
    Ok(parsed) -> // Work with parsed message
    Error(err) -> // Handle error
  }

  // Some examples I did while creating this before they became tests:

  let hl7_message =
    "MSH|^_\\&|ZorgDomein||||20160324163509+0100||ORU^R01|ZD200046119|P|2.4\rPID|1||^^^NLMINBIZA^NNNLD||de Mannaam&de&Mannaam^G^A^^^^L||20000101|M|||StraatnaamPatient 666\r"
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
}
```

## TODO
- [x] First implementation to destructure an HL7v2 message into Gleam indexed lists
- [x] Implement proper error handling
- [x] Add message validation
- [x] Implement field, component and subcomponent accessors
- [x] Implement a _get_ accessor with HL7 common format (MSH.5.1, PID.3.4.1, etc.)
- [x] Implement message builder
- [x] Add comprehensive test suite
- [ ] Add documentation and examples
- [ ] Support repeating fields

### Future things that would be good to have
- [ ] Support for different HL7 versions (such as XML ones...)
- [ ] Support message encoding/escaping
- [ ] Add support for custom segment definitions
- [ ] Add MLLP Protocol

## Development

```sh
gleam test  # Run the tests
```

## Contributing

This is a learning project, but contributions and suggestions are welcome!