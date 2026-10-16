(* CODESYS Net Base Services TLS types used by moqui-plc (library namespace NBS).
 *
 * Interface declarations only (no implementation), for type checking with a
 * non-CODESYS compiler.
 *)

TYPE PURPOSE : (CLIENT_SIDE, SERVER_SIDE); END_TYPE

TYPE CIPHER_LIST :
STRUCT
    psList : POINTER TO STRING;
    udiSize : UDINT;
END_STRUCT
END_TYPE

TYPE CERT_INFO :
STRUCT
    psInfo : POINTER TO STRING;
    udiSize : UDINT;
END_STRUCT
END_TYPE

(* CODESYS passes the TLS context as an interface; 0 means no TLS. *)
TYPE ITLSContext : POINTER TO TLSContext; END_TYPE

FUNCTION_BLOCK TLSContext
VAR_INPUT
    sUseCaseName : STRING;
    ePurpose : PURPOSE;
    sTLSVersion : STRING;
    sCipherList : CIPHER_LIST;
    sHostname : STRING(255);
    ciCertInfo : CERT_INFO;
    udiVerificationMode : UDINT;
    itfCertVerifer : LWORD; (* certificate verifier interface; 0 = none *)
END_VAR
END_FUNCTION_BLOCK
