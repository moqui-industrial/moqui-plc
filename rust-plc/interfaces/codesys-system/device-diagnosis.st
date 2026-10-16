(* CODESYS Device Diagnosis API used by moqui-plc (library namespace DED, with
 * the CAA base types it re-exports).
 *
 * Interface declarations only (no implementation), for type checking with a
 * non-CODESYS compiler. The vendor library walks the device tree through
 * interfaces (INode, IDevice); here they are function blocks reached by
 * reference, with methods for the calls moqui-plc makes.
 *)

TYPE PVOID : POINTER TO BYTE; END_TYPE
TYPE SIZE : UDINT; END_TYPE

TYPE DED_ERROR : (NO_ERROR, INVALID_INPUT, NOT_AVAILABLE); END_TYPE
TYPE DEVICE_STATE : (UNKNOWN, NOT_CONFIGURED, OK, ERROR); END_TYPE

TYPE DEVICE_INFO :
STRUCT
    eType : DINT;
    idInstance : UDINT;
    idSystem : UDINT;
END_STRUCT
END_TYPE

FUNCTION_BLOCK INode
VAR_OUTPUT
    ChildNodeCount : UDINT;
    SiblingNodeCount : UDINT;
    FirstChildNode : REFERENCE TO INode;
    NextSiblingNode : REFERENCE TO INode;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK IDevice EXTENDS INode
VAR_OUTPUT
    Enable : BOOL;
END_VAR
METHOD GetDeviceInfo : DED_ERROR
VAR_IN_OUT
    deiInfo : DEVICE_INFO;
END_VAR
END_METHOD
METHOD GetDeviceState : DEVICE_STATE
VAR_OUTPUT
    xDiagnosisinfoAvailable : BOOL;
    eError : DED_ERROR;
END_VAR
END_METHOD
METHOD GetDeviceDiagnosisInfo : DED_ERROR
VAR_INPUT
    pData : PVOID;
    szSize : SIZE;
END_VAR
VAR_OUTPUT
    szCount : SIZE;
END_VAR
END_METHOD
END_FUNCTION_BLOCK

FUNCTION INode_TO_IDevice : REFERENCE TO IDevice
VAR_INPUT
    itfNode : REFERENCE TO INode;
END_VAR
RETURN;
END_FUNCTION

FUNCTION GetDeviceNameString : STRING
VAR_INPUT
    itfDevice : REFERENCE TO IDevice;
END_VAR
RETURN;
END_FUNCTION
