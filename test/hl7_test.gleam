import builder
import get
import gleam/dict
import gleam/result
import gleeunit
import parse
import types.{
  Component, FieldRepetitions, FieldUnit, Message, Segment, Subcomponent,
}

const hl7_message = "MSH|^_\\&|ZorgDomein||||20160324163509+0100||ORU^R01|ZD200046119|P|2.4\rPID|1||^^^NLMINBIZA^NNNLD||de Mannaam&de&Mannaam^G^A^^^^L||20000101|M|||StraatnaamPatient 666\r"

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn parse_message_test() {
  let result = {
    hl7_message
    |> parse.message
    |> result.unwrap(types.empty_message())
  }
  let message =
    Message([
      Segment(
        "MSH",
        dict.from_list([
          #(
            1,
            FieldUnit(
              "MSH",
              dict.from_list([
                #(
                  1,
                  Component("MSH", dict.from_list([#(1, Subcomponent("MSH"))])),
                ),
              ]),
            ),
          ),
          #(
            2,
            FieldUnit(
              "",
              dict.from_list([
                #(1, Component("", dict.from_list([#(1, Subcomponent(""))]))),
                #(
                  2,
                  Component(
                    "_\\",
                    dict.from_list([
                      #(1, Subcomponent("_\\")),
                      #(2, Subcomponent("")),
                    ]),
                  ),
                ),
              ]),
            ),
          ),
          #(
            3,
            FieldUnit(
              "ZorgDomein",
              dict.from_list([
                #(
                  1,
                  Component(
                    "ZorgDomein",
                    dict.from_list([#(1, Subcomponent("ZorgDomein"))]),
                  ),
                ),
              ]),
            ),
          ),
          #(
            4,
            FieldUnit(
              "",
              dict.from_list([
                #(1, Component("", dict.from_list([#(1, Subcomponent(""))]))),
              ]),
            ),
          ),
          #(
            5,
            FieldUnit(
              "",
              dict.from_list([
                #(1, Component("", dict.from_list([#(1, Subcomponent(""))]))),
              ]),
            ),
          ),
          #(
            6,
            FieldUnit(
              "",
              dict.from_list([
                #(1, Component("", dict.from_list([#(1, Subcomponent(""))]))),
              ]),
            ),
          ),
          #(
            7,
            FieldUnit(
              "20160324163509+0100",
              dict.from_list([
                #(
                  1,
                  Component(
                    "20160324163509+0100",
                    dict.from_list([#(1, Subcomponent("20160324163509+0100"))]),
                  ),
                ),
              ]),
            ),
          ),
          #(
            8,
            FieldUnit(
              "",
              dict.from_list([
                #(1, Component("", dict.from_list([#(1, Subcomponent(""))]))),
              ]),
            ),
          ),
          #(
            9,
            FieldUnit(
              "ORU",
              dict.from_list([
                #(
                  1,
                  Component("ORU", dict.from_list([#(1, Subcomponent("ORU"))])),
                ),
                #(
                  2,
                  Component("R01", dict.from_list([#(1, Subcomponent("R01"))])),
                ),
              ]),
            ),
          ),
          #(
            10,
            FieldUnit(
              "ZD200046119",
              dict.from_list([
                #(
                  1,
                  Component(
                    "ZD200046119",
                    dict.from_list([#(1, Subcomponent("ZD200046119"))]),
                  ),
                ),
              ]),
            ),
          ),
          #(
            11,
            FieldUnit(
              "P",
              dict.from_list([
                #(1, Component("P", dict.from_list([#(1, Subcomponent("P"))]))),
              ]),
            ),
          ),
          #(
            12,
            FieldUnit(
              "2.4",
              dict.from_list([
                #(
                  1,
                  Component("2.4", dict.from_list([#(1, Subcomponent("2.4"))])),
                ),
              ]),
            ),
          ),
        ]),
      ),
      Segment(
        "PID",
        dict.from_list([
          #(
            0,
            FieldUnit(
              "PID",
              dict.from_list([
                #(
                  1,
                  Component("PID", dict.from_list([#(1, Subcomponent("PID"))])),
                ),
              ]),
            ),
          ),
          #(
            1,
            FieldUnit(
              "1",
              dict.from_list([
                #(1, Component("1", dict.from_list([#(1, Subcomponent("1"))]))),
              ]),
            ),
          ),
          #(
            2,
            FieldUnit(
              "",
              dict.from_list([
                #(1, Component("", dict.from_list([#(1, Subcomponent(""))]))),
              ]),
            ),
          ),
          #(
            3,
            FieldUnit(
              "",
              dict.from_list([
                #(1, Component("", dict.from_list([#(1, Subcomponent(""))]))),
                #(2, Component("", dict.from_list([#(1, Subcomponent(""))]))),
                #(3, Component("", dict.from_list([#(1, Subcomponent(""))]))),
                #(
                  4,
                  Component(
                    "NLMINBIZA",
                    dict.from_list([#(1, Subcomponent("NLMINBIZA"))]),
                  ),
                ),
                #(
                  5,
                  Component(
                    "NNNLD",
                    dict.from_list([#(1, Subcomponent("NNNLD"))]),
                  ),
                ),
              ]),
            ),
          ),
          #(
            4,
            FieldUnit(
              "",
              dict.from_list([
                #(1, Component("", dict.from_list([#(1, Subcomponent(""))]))),
              ]),
            ),
          ),
          #(
            5,
            FieldUnit(
              "de Mannaam&de&Mannaam",
              dict.from_list([
                #(
                  1,
                  Component(
                    "de Mannaam",
                    dict.from_list([
                      #(1, Subcomponent("de Mannaam")),
                      #(2, Subcomponent("de")),
                      #(3, Subcomponent("Mannaam")),
                    ]),
                  ),
                ),
                #(2, Component("G", dict.from_list([#(1, Subcomponent("G"))]))),
                #(3, Component("A", dict.from_list([#(1, Subcomponent("A"))]))),
                #(4, Component("", dict.from_list([#(1, Subcomponent(""))]))),
                #(5, Component("", dict.from_list([#(1, Subcomponent(""))]))),
                #(6, Component("", dict.from_list([#(1, Subcomponent(""))]))),
                #(7, Component("L", dict.from_list([#(1, Subcomponent("L"))]))),
              ]),
            ),
          ),
          #(
            6,
            FieldUnit(
              "",
              dict.from_list([
                #(1, Component("", dict.from_list([#(1, Subcomponent(""))]))),
              ]),
            ),
          ),
          #(
            7,
            FieldUnit(
              "20000101",
              dict.from_list([
                #(
                  1,
                  Component(
                    "20000101",
                    dict.from_list([#(1, Subcomponent("20000101"))]),
                  ),
                ),
              ]),
            ),
          ),
          #(
            8,
            FieldUnit(
              "M",
              dict.from_list([
                #(1, Component("M", dict.from_list([#(1, Subcomponent("M"))]))),
              ]),
            ),
          ),
          #(
            9,
            FieldUnit(
              "",
              dict.from_list([
                #(1, Component("", dict.from_list([#(1, Subcomponent(""))]))),
              ]),
            ),
          ),
          #(
            10,
            FieldUnit(
              "",
              dict.from_list([
                #(1, Component("", dict.from_list([#(1, Subcomponent(""))]))),
              ]),
            ),
          ),
          #(
            11,
            FieldUnit(
              "StraatnaamPatient 666",
              dict.from_list([
                #(
                  1,
                  Component(
                    "StraatnaamPatient 666",
                    dict.from_list([#(1, Subcomponent("StraatnaamPatient 666"))]),
                  ),
                ),
              ]),
            ),
          ),
        ]),
      ),
    ])
  assert result == message
}

pub fn parse_message_should_fail_test() {
  let result = {
    hl7_message
    |> parse.message
    |> result.unwrap(types.empty_message())
    |> get.from("MSH.5.4.3.2.1")
    |> result.unwrap("It failed")
  }
  assert result == "It failed"
}

pub fn get_from_extended_test() {
  let result = {
    hl7_message
    |> parse.message
    |> result.unwrap(types.empty_message())
    |> get.from_segment_indexed("MSH", 1)
    |> get.from_field(7)
    |> get.from_component(1)
    |> get.from_subcomponent(1)
  }
  assert result == types.Subcomponent("20160324163509+0100")
}

pub fn get_from_test() {
  let result = {
    hl7_message
    |> parse.message
    |> result.unwrap(types.empty_message())
    |> get.from("PID.3.4")
    |> result.unwrap("")
  }
  assert result == "NLMINBIZA"
}

pub fn get_from_2_test() {
  let result = {
    hl7_message
    |> parse.message
    |> result.unwrap(types.empty_message())
    |> get.from("PID.5.1.2")
    |> result.unwrap("")
  }
  assert result == "de"
}

pub fn get_from_3_test() {
  let result = {
    hl7_message
    |> parse.message
    |> result.unwrap(types.empty_message())
    |> get.from("MSH.7.1")
    |> result.unwrap("")
  }
  assert result == "20160324163509+0100"
}

pub fn build_test() {
  let hl7_parsed =
    Message([
      Segment(
        "MSH",
        dict.from_list([
          #(
            1,
            FieldUnit(
              "MSH",
              dict.from_list([
                #(
                  1,
                  Component("MSH", dict.from_list([#(1, Subcomponent("MSH"))])),
                ),
              ]),
            ),
          ),
          #(
            2,
            FieldUnit(
              "",
              dict.from_list([
                #(1, Component("", dict.from_list([#(1, Subcomponent(""))]))),
                #(
                  2,
                  Component(
                    "_\\",
                    dict.from_list([
                      #(1, Subcomponent("_\\")),
                      #(2, Subcomponent("")),
                    ]),
                  ),
                ),
              ]),
            ),
          ),
          #(
            3,
            FieldUnit(
              "ZorgDomein",
              dict.from_list([
                #(
                  1,
                  Component(
                    "ZorgDomein",
                    dict.from_list([#(1, Subcomponent("ZorgDomein"))]),
                  ),
                ),
              ]),
            ),
          ),
          #(
            4,
            FieldUnit(
              "",
              dict.from_list([
                #(1, Component("", dict.from_list([#(1, Subcomponent(""))]))),
              ]),
            ),
          ),
          #(
            5,
            FieldUnit(
              "",
              dict.from_list([
                #(1, Component("", dict.from_list([#(1, Subcomponent(""))]))),
              ]),
            ),
          ),
          #(
            6,
            FieldUnit(
              "",
              dict.from_list([
                #(1, Component("", dict.from_list([#(1, Subcomponent(""))]))),
              ]),
            ),
          ),
          #(
            7,
            FieldUnit(
              "20160324163509+0100",
              dict.from_list([
                #(
                  1,
                  Component(
                    "20160324163509+0100",
                    dict.from_list([#(1, Subcomponent("20160324163509+0100"))]),
                  ),
                ),
              ]),
            ),
          ),
          #(
            8,
            FieldUnit(
              "",
              dict.from_list([
                #(1, Component("", dict.from_list([#(1, Subcomponent(""))]))),
              ]),
            ),
          ),
          #(
            9,
            FieldUnit(
              "ORU",
              dict.from_list([
                #(
                  1,
                  Component("ORU", dict.from_list([#(1, Subcomponent("ORU"))])),
                ),
                #(
                  2,
                  Component("R01", dict.from_list([#(1, Subcomponent("R01"))])),
                ),
              ]),
            ),
          ),
          #(
            10,
            FieldUnit(
              "ZD200046119",
              dict.from_list([
                #(
                  1,
                  Component(
                    "ZD200046119",
                    dict.from_list([#(1, Subcomponent("ZD200046119"))]),
                  ),
                ),
              ]),
            ),
          ),
          #(
            11,
            FieldUnit(
              "P",
              dict.from_list([
                #(1, Component("P", dict.from_list([#(1, Subcomponent("P"))]))),
              ]),
            ),
          ),
          #(
            12,
            FieldUnit(
              "2.4",
              dict.from_list([
                #(
                  1,
                  Component("2.4", dict.from_list([#(1, Subcomponent("2.4"))])),
                ),
              ]),
            ),
          ),
        ]),
      ),
      Segment(
        "PID",
        dict.from_list([
          #(
            0,
            FieldUnit(
              "PID",
              dict.from_list([
                #(
                  1,
                  Component("PID", dict.from_list([#(1, Subcomponent("PID"))])),
                ),
              ]),
            ),
          ),
          #(
            1,
            FieldUnit(
              "1",
              dict.from_list([
                #(1, Component("1", dict.from_list([#(1, Subcomponent("1"))]))),
              ]),
            ),
          ),
          #(
            2,
            FieldUnit(
              "",
              dict.from_list([
                #(1, Component("", dict.from_list([#(1, Subcomponent(""))]))),
              ]),
            ),
          ),
          #(
            3,
            FieldUnit(
              "",
              dict.from_list([
                #(1, Component("", dict.from_list([#(1, Subcomponent(""))]))),
                #(2, Component("", dict.from_list([#(1, Subcomponent(""))]))),
                #(3, Component("", dict.from_list([#(1, Subcomponent(""))]))),
                #(
                  4,
                  Component(
                    "NLMINBIZA",
                    dict.from_list([#(1, Subcomponent("NLMINBIZA"))]),
                  ),
                ),
                #(
                  5,
                  Component(
                    "NNNLD",
                    dict.from_list([#(1, Subcomponent("NNNLD"))]),
                  ),
                ),
              ]),
            ),
          ),
          #(
            4,
            FieldUnit(
              "",
              dict.from_list([
                #(1, Component("", dict.from_list([#(1, Subcomponent(""))]))),
              ]),
            ),
          ),
          #(
            5,
            FieldUnit(
              "de Mannaam&de&Mannaam",
              dict.from_list([
                #(
                  1,
                  Component(
                    "de Mannaam",
                    dict.from_list([
                      #(1, Subcomponent("de Mannaam")),
                      #(2, Subcomponent("de")),
                      #(3, Subcomponent("Mannaam")),
                    ]),
                  ),
                ),
                #(2, Component("G", dict.from_list([#(1, Subcomponent("G"))]))),
                #(3, Component("A", dict.from_list([#(1, Subcomponent("A"))]))),
                #(4, Component("", dict.from_list([#(1, Subcomponent(""))]))),
                #(5, Component("", dict.from_list([#(1, Subcomponent(""))]))),
                #(6, Component("", dict.from_list([#(1, Subcomponent(""))]))),
                #(7, Component("L", dict.from_list([#(1, Subcomponent("L"))]))),
              ]),
            ),
          ),
          #(
            6,
            FieldUnit(
              "",
              dict.from_list([
                #(1, Component("", dict.from_list([#(1, Subcomponent(""))]))),
              ]),
            ),
          ),
          #(
            7,
            FieldUnit(
              "20000101",
              dict.from_list([
                #(
                  1,
                  Component(
                    "20000101",
                    dict.from_list([#(1, Subcomponent("20000101"))]),
                  ),
                ),
              ]),
            ),
          ),
          #(
            8,
            FieldUnit(
              "M",
              dict.from_list([
                #(1, Component("M", dict.from_list([#(1, Subcomponent("M"))]))),
              ]),
            ),
          ),
          #(
            9,
            FieldUnit(
              "",
              dict.from_list([
                #(1, Component("", dict.from_list([#(1, Subcomponent(""))]))),
              ]),
            ),
          ),
          #(
            10,
            FieldUnit(
              "",
              dict.from_list([
                #(1, Component("", dict.from_list([#(1, Subcomponent(""))]))),
              ]),
            ),
          ),
          #(
            11,
            FieldUnit(
              "StraatnaamPatient 666",
              dict.from_list([
                #(
                  1,
                  Component(
                    "StraatnaamPatient 666",
                    dict.from_list([#(1, Subcomponent("StraatnaamPatient 666"))]),
                  ),
                ),
              ]),
            ),
          ),
        ]),
      ),
    ])
  let result = hl7_message
  let message =
    hl7_parsed
    |> builder.build_message(types.Delimiters("|", "^", "_", "\\", "&"))
  assert message == result
}
