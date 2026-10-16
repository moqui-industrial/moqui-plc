(* CODESYS SysTimeRtc API used by moqui-plc. Interface declarations only (no
 * implementation). A Rust runtime maps these to the system real-time clock.
 *)

TYPE RTS_IEC_RESULT : UDINT; END_TYPE
TYPE SYSTIME : ULINT; END_TYPE

FUNCTION SysTimeRtcGet : UDINT
VAR_IN_OUT
    pResult : RTS_IEC_RESULT;
END_VAR
RETURN;
END_FUNCTION

FUNCTION SysTimeRtcConvertUtcToLocal : RTS_IEC_RESULT
VAR_INPUT
    dwTimestampUtc : UDINT;
END_VAR
VAR_IN_OUT
    pdwTimestampLocal : UDINT;
END_VAR
RETURN;
END_FUNCTION

FUNCTION SysTimeRtcHighResGet : RTS_IEC_RESULT
VAR_IN_OUT
    pTimestamp : SYSTIME;
END_VAR
RETURN;
END_FUNCTION
