(* CODESYS SoftMotion extensions used by moqui-plc: the SMC_ vendor extensions.
 *
 * Interface declarations only (no implementation), for type checking with a
 * non-CODESYS compiler. These names keep their CODESYS spelling because
 * PLCopen has no equivalent; a runtime that hosts moqui-plc maps them to its
 * own kinematics.
 *)

TYPE SMC_COORD_SYSTEM : (ACS, MCS, WCS, PCS_1, PCS_2); END_TYPE
TYPE SMC_CIRC_MODE : (BORDER, CENTER, RADIUS); END_TYPE

(* Upper bound for transition parameters; the value is runtime specific. *)
TYPE SMC_RCNST : (MAX_TRANS_PARAMS := 8); END_TYPE

(* Position of an axis group: Cartesian (c) or per-axis values (v).
 * CODESYS declares it as a UNION; a STRUCT gives the same member access. *)
TYPE SMC_POS_REF :
STRUCT
    c : MC_COORD_REF;
    v : ARRAY [0..5] OF LREAL;
END_STRUCT
END_TYPE

TYPE SMC_Frame :
STRUCT
    origin : MC_COORD_REF;
END_STRUCT
END_TYPE

(* Moving coordinate system returned by MC_TrackConveyorBelt / MC_TrackRotaryTable. *)
FUNCTION_BLOCK SMC_CoordinateSystem
METHOD GetPose
VAR_INPUT
    fTime : LREAL;
END_VAR
VAR_IN_OUT
    cs : SMC_Frame;
END_VAR
END_METHOD
END_FUNCTION_BLOCK

FUNCTION SMC_Frame_To_CoordRef : BOOL
VAR_IN_OUT
    f : SMC_Frame;
    c : MC_COORD_REF;
END_VAR
RETURN;
END_FUNCTION

FUNCTION_BLOCK SMC_GroupPower
VAR_IN_OUT
    AxisGroup : AXES_GROUP_REF;
END_VAR
VAR_INPUT
    Enable : BOOL;
    bRegulatorOn : BOOL;
    bDriveStart : BOOL;
END_VAR
VAR_OUTPUT
    Status : BOOL;
    Busy : BOOL;
    Error : BOOL;
    ErrorID : WORD;
END_VAR
END_FUNCTION_BLOCK
