import builder
import get
import gleam/io
import gleam/result
import parse
import types

const hl7_oru_complete_message = "MSH|^~&|SomeSystem||TransformationAgent||201410060931||ORU^R01|ControlID|T|2.5|||||USA||EN\rPID|1||10006579^^^1^MR^1||DUCK^DONALD^D||19241010|M||1|111 DUCK ST^^FOWL^CA^999990000^^M|1|8885551212|8885551212|1|2||40007716^^^AccMgr^VN^1|123121234|||||||||||NO \rOBR|1|855238581|890775544|26464-8^Differential WBC Count, buffy coat^LN||||||^COLLECT^JOHN|P| ||||^URO^^^^DR|||||||201410060929|||F|||||||&CYTO&JANE^201410060929\rOBX|1|NM|30180-4^BASOPHILS/100 LEUKOCYTES^LN||0|%||N|||F|||201410060830\rOBX|2|NM|23761-0^NEUTROPHILS/100 LEUKOCYTES^LN||72|%||N|||F|||201410060830\rOBX|3|NM|26450-7^EOSINOPHILS/100 LEUKOCYTES^LN||2|%||N|||F|||201410060830\rOBX|4|NM|26478-8^LYMPHOCYTES/100 LEUKOCYTES^LN||20|%||N|||F|||201410060830\rOBX|5|NM|26485-3^MONOCYTES/100 LEUKOCYTES^LN||6|%||N|||F|||201410060830\rSPM|1|SpecimenID||BLD|||||||P||||||201410060535|201410060621||Y||||||1\rOBR|2|88502218|82503246|24317-0^Hemogram and platelet count, automated^LN||||||^COLLECT^JOHN|P|| |||^URO^^^^DR|||||||201410060929|||F|||||||&CYTO&JANE^201410060929\rOBX|1|NM|20509-6^HEMOGLOBIN^LN||13.4|g/l-1||N|||F|||201410060830\rOBX|2|NM|11156-7^LEUKOCYTES^LN||8.2|giga.l-1||N|||F|||201410060830\rOBX|3|NM|11273-0^ERYTHROCYTES^LN||4.08|tera.l-1||N|||F|||201410060830\rOBX|4|NM|20570-8^HEMATOCRIT^LN||39.7|%||N|||F|||201410060830\rOBX|5|NM|11125-2^PLATELETS^LN||220|giga.l-1||N|||F|||201410060830\rSPM|1|SpecimenID||BLD|||||||P||||||201410060535|201410060621||Y||||||1"

pub fn main() {
  let parsed =
    parse.message(hl7_oru_complete_message)
    |> result.unwrap(types.empty_message())
    |> echo

  let lab_test =
    get.from_segment_indexed(parsed, "OBX", 3)
    |> get.from_field(3)
    |> get.from_component(2)
    |> get.from_subcomponent(1)
    |> get.subcomponent_to_string

  let result =
    parsed
    |> get.from_segment_indexed("OBX", 3)
    |> get.from_field(5)
    |> get.from_component(1)
    |> get.from_subcomponent(1)
    |> get.subcomponent_to_string

  let units =
    parsed
    |> get.from_segment_indexed("OBX", 3)
    |> get.from_field(6)
    |> get.from_component(1)
    |> get.from_subcomponent(1)
    |> get.subcomponent_to_string

  io.println(lab_test <> " is " <> result <> " " <> units)
}
