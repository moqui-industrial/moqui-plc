(* CODESYS Ethernet I/O driver types used by moqui-plc (library namespace
 * IODrvEthernet). Interface declarations only (no implementation).
 *)

TYPE EthernetState : (NOT_CONFIGURED, CONNECTED, DISCONNECTED, SET_IP_ERROR, ERROR); END_TYPE

(* Ethernet adapter node of the device tree. *)
FUNCTION_BLOCK IoDrvEthernet EXTENDS INode
VAR_OUTPUT
    DeviceName : STRING;
    NICName : STRING;
    Enable : BOOL;
    State : EthernetState;
END_VAR
END_FUNCTION_BLOCK
