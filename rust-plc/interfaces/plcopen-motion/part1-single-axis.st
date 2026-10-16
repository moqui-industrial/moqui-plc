(* PLCopen Motion Control Part 1 - single-axis function blocks used by moqui-plc.
 *
 * Interface declarations only (no implementation), for type checking with a
 * non-CODESYS compiler. Parameters follow the PLCopen function block
 * interface; MC_Power also carries the drive-start and regulator inputs
 * the moqui-plc code sets.
 * A runtime that hosts moqui-plc implements these blocks with the same
 * signatures.
 *)

FUNCTION_BLOCK MC_Power
VAR_IN_OUT
    Axis : AXIS_REF;
END_VAR
VAR_INPUT
    Enable : BOOL;
    bRegulatorOn : BOOL;
    bDriveStart : BOOL;
END_VAR
VAR_OUTPUT
    Status : BOOL;
    bRegulatorRealState : BOOL;
    bDriveStartRealState : BOOL;
    Busy : BOOL;
    Error : BOOL;
    ErrorID : WORD;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_Home
VAR_IN_OUT
    Axis : AXIS_REF;
END_VAR
VAR_INPUT
    Execute : BOOL;
    Position : LREAL;
    BufferMode : MC_BUFFER_MODE;
END_VAR
VAR_OUTPUT
    Done : BOOL;
    Busy : BOOL;
    CommandAborted : BOOL;
    Error : BOOL;
    ErrorID : WORD;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_Stop
VAR_IN_OUT
    Axis : AXIS_REF;
END_VAR
VAR_INPUT
    Execute : BOOL;
    Deceleration : LREAL;
    Jerk : LREAL;
END_VAR
VAR_OUTPUT
    Done : BOOL;
    Busy : BOOL;
    CommandAborted : BOOL;
    Error : BOOL;
    ErrorID : WORD;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_Halt
VAR_IN_OUT
    Axis : AXIS_REF;
END_VAR
VAR_INPUT
    Execute : BOOL;
    Deceleration : LREAL;
    Jerk : LREAL;
    BufferMode : MC_BUFFER_MODE;
END_VAR
VAR_OUTPUT
    Done : BOOL;
    Busy : BOOL;
    Active : BOOL;
    CommandAborted : BOOL;
    Error : BOOL;
    ErrorID : WORD;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_MoveAbsolute
VAR_IN_OUT
    Axis : AXIS_REF;
END_VAR
VAR_INPUT
    Execute : BOOL;
    Position : LREAL;
    Velocity : LREAL;
    Acceleration : LREAL;
    Deceleration : LREAL;
    Jerk : LREAL;
    Direction : MC_DIRECTION;
    BufferMode : MC_BUFFER_MODE;
END_VAR
VAR_OUTPUT
    Done : BOOL;
    Busy : BOOL;
    Active : BOOL;
    CommandAborted : BOOL;
    Error : BOOL;
    ErrorID : WORD;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_MoveRelative
VAR_IN_OUT
    Axis : AXIS_REF;
END_VAR
VAR_INPUT
    Execute : BOOL;
    Distance : LREAL;
    Velocity : LREAL;
    Acceleration : LREAL;
    Deceleration : LREAL;
    Jerk : LREAL;
    BufferMode : MC_BUFFER_MODE;
END_VAR
VAR_OUTPUT
    Done : BOOL;
    Busy : BOOL;
    Active : BOOL;
    CommandAborted : BOOL;
    Error : BOOL;
    ErrorID : WORD;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_MoveAdditive
VAR_IN_OUT
    Axis : AXIS_REF;
END_VAR
VAR_INPUT
    Execute : BOOL;
    Distance : LREAL;
    Velocity : LREAL;
    Acceleration : LREAL;
    Deceleration : LREAL;
    Jerk : LREAL;
    BufferMode : MC_BUFFER_MODE;
END_VAR
VAR_OUTPUT
    Done : BOOL;
    Busy : BOOL;
    Active : BOOL;
    CommandAborted : BOOL;
    Error : BOOL;
    ErrorID : WORD;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_MoveSuperImposed
VAR_IN_OUT
    Axis : AXIS_REF;
END_VAR
VAR_INPUT
    Execute : BOOL;
    Distance : LREAL;
    VelocityDiff : LREAL;
    Acceleration : LREAL;
    Deceleration : LREAL;
    Jerk : LREAL;
END_VAR
VAR_OUTPUT
    Done : BOOL;
    Busy : BOOL;
    Active : BOOL;
    CommandAborted : BOOL;
    Error : BOOL;
    ErrorID : WORD;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_HaltSuperImposed
VAR_IN_OUT
    Axis : AXIS_REF;
END_VAR
VAR_INPUT
    Execute : BOOL;
    Deceleration : LREAL;
    Jerk : LREAL;
END_VAR
VAR_OUTPUT
    Done : BOOL;
    Busy : BOOL;
    Active : BOOL;
    CommandAborted : BOOL;
    Error : BOOL;
    ErrorID : WORD;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_MoveVelocity
VAR_IN_OUT
    Axis : AXIS_REF;
END_VAR
VAR_INPUT
    Execute : BOOL;
    Velocity : LREAL;
    Acceleration : LREAL;
    Deceleration : LREAL;
    Jerk : LREAL;
    Direction : MC_DIRECTION;
    BufferMode : MC_BUFFER_MODE;
END_VAR
VAR_OUTPUT
    InVelocity : BOOL;
    Busy : BOOL;
    Active : BOOL;
    CommandAborted : BOOL;
    Error : BOOL;
    ErrorID : WORD;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_Jog
VAR_IN_OUT
    Axis : AXIS_REF;
END_VAR
VAR_INPUT
    JogForward : BOOL;
    JogBackward : BOOL;
    Velocity : LREAL;
    Acceleration : LREAL;
    Deceleration : LREAL;
    Jerk : LREAL;
END_VAR
VAR_OUTPUT
    Busy : BOOL;
    CommandAborted : BOOL;
    Error : BOOL;
    ErrorID : WORD;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_PositionProfile
VAR_IN_OUT
    Axis : AXIS_REF;
    TimePosition : MC_TP_REF;
END_VAR
VAR_INPUT
    Execute : BOOL;
    BufferMode : MC_BUFFER_MODE;
END_VAR
VAR_OUTPUT
    Done : BOOL;
    Busy : BOOL;
    Active : BOOL;
    CommandAborted : BOOL;
    Error : BOOL;
    ErrorID : WORD;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_VelocityProfile
VAR_IN_OUT
    Axis : AXIS_REF;
    TimeVelocity : MC_TV_REF;
END_VAR
VAR_INPUT
    Execute : BOOL;
    BufferMode : MC_BUFFER_MODE;
END_VAR
VAR_OUTPUT
    Done : BOOL;
    Busy : BOOL;
    Active : BOOL;
    CommandAborted : BOOL;
    Error : BOOL;
    ErrorID : WORD;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_AccelerationProfile
VAR_IN_OUT
    Axis : AXIS_REF;
    TimeAcceleration : MC_TA_REF;
END_VAR
VAR_INPUT
    Execute : BOOL;
    BufferMode : MC_BUFFER_MODE;
END_VAR
VAR_OUTPUT
    Done : BOOL;
    Busy : BOOL;
    Active : BOOL;
    CommandAborted : BOOL;
    Error : BOOL;
    ErrorID : WORD;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_SetPosition
VAR_IN_OUT
    Axis : AXIS_REF;
END_VAR
VAR_INPUT
    Execute : BOOL;
    Position : LREAL;
    Mode : BOOL;
END_VAR
VAR_OUTPUT
    Done : BOOL;
    Busy : BOOL;
    Error : BOOL;
    ErrorID : WORD;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_SetOverride
VAR_IN_OUT
    Axis : AXIS_REF;
END_VAR
VAR_INPUT
    Enable : BOOL;
    VelFactor : LREAL;
    AccFactor : LREAL;
    JerkFactor : LREAL;
END_VAR
VAR_OUTPUT
    Enabled : BOOL;
    Busy : BOOL;
    Error : BOOL;
    ErrorID : WORD;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_ReadParameter
VAR_IN_OUT
    Axis : AXIS_REF;
END_VAR
VAR_INPUT
    Enable : BOOL;
    ParameterNumber : DINT;
END_VAR
VAR_OUTPUT
    Valid : BOOL;
    Busy : BOOL;
    Error : BOOL;
    ErrorID : WORD;
    Value : LREAL;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_ReadBoolParameter
VAR_IN_OUT
    Axis : AXIS_REF;
END_VAR
VAR_INPUT
    Enable : BOOL;
    ParameterNumber : DINT;
END_VAR
VAR_OUTPUT
    Valid : BOOL;
    Busy : BOOL;
    Error : BOOL;
    ErrorID : WORD;
    Value : BOOL;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_WriteParameter
VAR_IN_OUT
    Axis : AXIS_REF;
END_VAR
VAR_INPUT
    Execute : BOOL;
    ParameterNumber : DINT;
    Value : LREAL;
END_VAR
VAR_OUTPUT
    Done : BOOL;
    Busy : BOOL;
    Error : BOOL;
    ErrorID : WORD;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_WriteBoolParameter
VAR_IN_OUT
    Axis : AXIS_REF;
END_VAR
VAR_INPUT
    Execute : BOOL;
    ParameterNumber : DINT;
    Value : BOOL;
END_VAR
VAR_OUTPUT
    Done : BOOL;
    Busy : BOOL;
    Error : BOOL;
    ErrorID : WORD;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_ReadActualPosition
VAR_IN_OUT
    Axis : AXIS_REF;
END_VAR
VAR_INPUT
    Enable : BOOL;
END_VAR
VAR_OUTPUT
    Valid : BOOL;
    Busy : BOOL;
    Error : BOOL;
    ErrorID : WORD;
    Position : LREAL;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_ReadActualVelocity
VAR_IN_OUT
    Axis : AXIS_REF;
END_VAR
VAR_INPUT
    Enable : BOOL;
END_VAR
VAR_OUTPUT
    Valid : BOOL;
    Busy : BOOL;
    Error : BOOL;
    ErrorID : WORD;
    Velocity : LREAL;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_ReadActualTorque
VAR_IN_OUT
    Axis : AXIS_REF;
END_VAR
VAR_INPUT
    Enable : BOOL;
END_VAR
VAR_OUTPUT
    Valid : BOOL;
    Busy : BOOL;
    Error : BOOL;
    ErrorID : WORD;
    Torque : LREAL;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_ReadStatus
VAR_IN_OUT
    Axis : AXIS_REF;
END_VAR
VAR_INPUT
    Enable : BOOL;
END_VAR
VAR_OUTPUT
    Valid : BOOL;
    Busy : BOOL;
    Error : BOOL;
    ErrorID : WORD;
    ErrorStop : BOOL;
    Disabled : BOOL;
    Stopping : BOOL;
    Homing : BOOL;
    Standstill : BOOL;
    DiscreteMotion : BOOL;
    ContinuousMotion : BOOL;
    SynchronizedMotion : BOOL;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_ReadAxisError
VAR_IN_OUT
    Axis : AXIS_REF;
END_VAR
VAR_INPUT
    Enable : BOOL;
END_VAR
VAR_OUTPUT
    Valid : BOOL;
    Busy : BOOL;
    Error : BOOL;
    ErrorID : WORD;
    AxisErrorID : DWORD;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_Reset
VAR_IN_OUT
    Axis : AXIS_REF;
END_VAR
VAR_INPUT
    Execute : BOOL;
END_VAR
VAR_OUTPUT
    Done : BOOL;
    Busy : BOOL;
    Error : BOOL;
    ErrorID : WORD;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_TouchProbe
VAR_IN_OUT
    Axis : AXIS_REF;
    TriggerInput : TRIGGER_REF;
END_VAR
VAR_INPUT
    Execute : BOOL;
    WindowOnly : BOOL;
    FirstPosition : LREAL;
    LastPosition : LREAL;
END_VAR
VAR_OUTPUT
    Done : BOOL;
    Busy : BOOL;
    CommandAborted : BOOL;
    Error : BOOL;
    ErrorID : WORD;
    RecordedPosition : LREAL;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_AbortTrigger
VAR_IN_OUT
    Axis : AXIS_REF;
    TriggerInput : TRIGGER_REF;
END_VAR
VAR_INPUT
    Execute : BOOL;
END_VAR
VAR_OUTPUT
    Done : BOOL;
    Busy : BOOL;
    Error : BOOL;
    ErrorID : WORD;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_CamTableSelect
VAR_IN_OUT
    Master : AXIS_REF;
    Slave : AXIS_REF;
    CamTable : MC_CAM_REF;
END_VAR
VAR_INPUT
    Execute : BOOL;
    Periodic : BOOL;
    MasterAbsolute : BOOL;
    SlaveAbsolute : BOOL;
END_VAR
VAR_OUTPUT
    Done : BOOL;
    Busy : BOOL;
    Error : BOOL;
    ErrorID : WORD;
    CamTableID : MC_CAM_ID;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_CamIn
VAR_IN_OUT
    Master : AXIS_REF;
    Slave : AXIS_REF;
END_VAR
VAR_INPUT
    Execute : BOOL;
    MasterOffset : LREAL;
    SlaveOffset : LREAL;
    MasterScaling : LREAL;
    SlaveScaling : LREAL;
    StartMode : MC_STARTMODE;
    CamTableID : MC_CAM_ID;
    BufferMode : MC_BUFFER_MODE;
END_VAR
VAR_OUTPUT
    InSync : BOOL;
    Busy : BOOL;
    Active : BOOL;
    CommandAborted : BOOL;
    Error : BOOL;
    ErrorID : WORD;
    EndOfProfile : BOOL;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_CamOut
VAR_IN_OUT
    Slave : AXIS_REF;
END_VAR
VAR_INPUT
    Execute : BOOL;
END_VAR
VAR_OUTPUT
    Done : BOOL;
    Busy : BOOL;
    Error : BOOL;
    ErrorID : WORD;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_GearIn
VAR_IN_OUT
    Master : AXIS_REF;
    Slave : AXIS_REF;
END_VAR
VAR_INPUT
    Execute : BOOL;
    RatioNumerator : DINT;
    RatioDenominator : UDINT;
    Acceleration : LREAL;
    Deceleration : LREAL;
    Jerk : LREAL;
    BufferMode : MC_BUFFER_MODE;
END_VAR
VAR_OUTPUT
    InGear : BOOL;
    Busy : BOOL;
    Active : BOOL;
    CommandAborted : BOOL;
    Error : BOOL;
    ErrorID : WORD;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_GearInPos
VAR_IN_OUT
    Master : AXIS_REF;
    Slave : AXIS_REF;
END_VAR
VAR_INPUT
    Execute : BOOL;
    RatioNumerator : DINT;
    RatioDenominator : UDINT;
    MasterSyncPosition : LREAL;
    SlaveSyncPosition : LREAL;
    MasterStartDistance : LREAL;
    Velocity : LREAL;
    Acceleration : LREAL;
    Deceleration : LREAL;
    Jerk : LREAL;
    BufferMode : MC_BUFFER_MODE;
END_VAR
VAR_OUTPUT
    StartSync : BOOL;
    InSync : BOOL;
    Busy : BOOL;
    Active : BOOL;
    CommandAborted : BOOL;
    Error : BOOL;
    ErrorID : WORD;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_GearOut
VAR_IN_OUT
    Slave : AXIS_REF;
END_VAR
VAR_INPUT
    Execute : BOOL;
END_VAR
VAR_OUTPUT
    Done : BOOL;
    Busy : BOOL;
    Error : BOOL;
    ErrorID : WORD;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MC_Phasing
VAR_IN_OUT
    Master : AXIS_REF;
    Slave : AXIS_REF;
END_VAR
VAR_INPUT
    Execute : BOOL;
    PhaseShift : LREAL;
    Velocity : LREAL;
    Acceleration : LREAL;
    Deceleration : LREAL;
    Jerk : LREAL;
    BufferMode : MC_BUFFER_MODE;
END_VAR
VAR_OUTPUT
    Done : BOOL;
    Busy : BOOL;
    Active : BOOL;
    CommandAborted : BOOL;
    Error : BOOL;
    ErrorID : WORD;
END_VAR
END_FUNCTION_BLOCK
