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
}
```

## TODO
- [x] First implementation to destructure an HL7v2 message into Gleam indexed lists
- [ ] Implement proper error handling
- [ ] Add message validation
- [ ] Support message encoding/escaping
- [ ] Implement field, component and subcomponent accessors
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