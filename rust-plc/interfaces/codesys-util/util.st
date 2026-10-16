(* CODESYS Util library blocks used by moqui-plc (PID, RAMP_REAL, GEN).
 *
 * Interface declarations only (no implementation), for type checking with a
 * non-CODESYS compiler. A runtime that hosts moqui-plc provides equivalent
 * blocks with the same signatures.
 *)

FUNCTION_BLOCK PID
VAR_INPUT
    actual : REAL;
    set_point : REAL;
    kp : REAL;
    tn : REAL;
    tv : REAL;
    y_manual : REAL;
    y_offset : REAL;
    y_min : REAL;
    y_max : REAL;
    manual : BOOL;
    reset : BOOL;
END_VAR
VAR_OUTPUT
    y : REAL;
    limits_active : BOOL;
    overflow : BOOL;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK RAMP_REAL
VAR_INPUT
    in : REAL;
    ascend : REAL;
    descend : REAL;
    timebase : TIME;
    reset : BOOL;
END_VAR
VAR_OUTPUT
    out : REAL;
END_VAR
END_FUNCTION_BLOCK

TYPE GEN_MODE : (TRIANGLE, TRIANGLE_POS, SAWTOOTH_RISE, SAWTOOTH_FALL, RECTANGLE, SINE, COSINE); END_TYPE

FUNCTION_BLOCK GEN
VAR_INPUT
    MODE : GEN_MODE;
    BASE : BOOL;
    PERIOD : TIME;
    CYCLES : INT;
    AMPLITUDE : INT;
    RESET : BOOL;
END_VAR
VAR_OUTPUT
    OUT : INT;
END_VAR
END_FUNCTION_BLOCK
