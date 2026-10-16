(* PLCopen Motion Control - data types used by moqui-plc.
 *
 * Interface declarations only, for type checking with a non-CODESYS compiler.
 * Names follow PLCopen Motion Control Part 1 (single axis) and Part 4
 * (coordinated motion), with the enumeration spellings used in the canonical
 * iec61131 tree. A runtime that hosts moqui-plc provides the real types.
 *
 * AXIS_REF and AXES_GROUP_REF are opaque in PLCopen; the members below are the
 * only ones the moqui-plc code reads.
 *)

TYPE AXIS_REF :
STRUCT
    wDriveId : WORD; (* drive identifier, used for log naming *)
    fTaskCycle : LREAL; (* cycle time of the motion task that runs the axis [s] *)
END_STRUCT
END_TYPE

TYPE AXES_GROUP_REF :
STRUCT
    nAxes : INT;
END_STRUCT
END_TYPE

TYPE TRIGGER_REF :
STRUCT
    iTriggerNumber : INT;
END_STRUCT
END_TYPE

TYPE MC_BUFFER_MODE : (aborting, Buffered, BlendingLow, BlendingPrevious, BlendingNext, BlendingHigh); END_TYPE
TYPE MC_DIRECTION : (negative := -1, shortest, positive, current, fastest); END_TYPE
TYPE MC_STARTMODE : (absolute, relative, ramp_in); END_TYPE
TYPE MC_TRANSITION_MODE : (TMNone, TMStartVelocity, TMConstantVelocity, TMCornerDistance, TMMaxCornerDeviation); END_TYPE
TYPE MC_CIRC_PATHCHOICE : (CLOCKWISE, COUNTER_CLOCKWISE); END_TYPE

TYPE MC_COORD_REF :
STRUCT
    X : LREAL;
    Y : LREAL;
    Z : LREAL;
    A : LREAL;
    B : LREAL;
    C : LREAL;
END_STRUCT
END_TYPE

(* Profile and cam references: content is runtime specific. *)
TYPE MC_TP_REF : STRUCT nPoints : INT; END_STRUCT END_TYPE
TYPE MC_TV_REF : STRUCT nPoints : INT; END_STRUCT END_TYPE
TYPE MC_TA_REF : STRUCT nPoints : INT; END_STRUCT END_TYPE
TYPE MC_CAM_REF : STRUCT nElements : INT; END_STRUCT END_TYPE
TYPE MC_CAM_ID : STRUCT nId : UDINT; END_STRUCT END_TYPE
