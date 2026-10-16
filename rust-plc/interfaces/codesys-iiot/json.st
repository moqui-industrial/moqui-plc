(* CODESYS IIoT JSON API used by moqui-plc (library namespace JSON).
 *
 * Interface declarations only (no implementation), for type checking with a
 * non-CODESYS compiler. The vendor library is object oriented (methods on
 * function blocks); the declarations mirror only the calls moqui-plc makes.
 *)

TYPE JSON_ERROR : (NO_ERROR, INVALID_INPUT, NO_MEMORY, NOT_FOUND, PARSE_ERROR); END_TYPE
TYPE JSONType : (JSON_OBJECT, JSON_ARRAY, KEY, VALUE); END_TYPE

TYPE JSONValue :
STRUCT
    wsValue : WSTRING(255);
    lrValue : LREAL;
    diValue : DINT;
    xValue : BOOL;
END_STRUCT
END_TYPE

TYPE JSONElement :
STRUCT
    eType : JSONType;
    diIndex : DINT;
    diParentIndex : DINT;
    value : JSONValue;
END_STRUCT
END_TYPE

FUNCTION_BLOCK JSONData
METHOD Clear
END_METHOD
METHOD GetElementByIndex : JSON_ERROR
VAR_INPUT
    diIndex : DINT;
END_VAR
VAR_OUTPUT
    jsonElement : JSONElement;
END_VAR
END_METHOD
METHOD GetChildren : JSON_ERROR
VAR_INPUT
    diIndex : DINT;
    pResult : POINTER TO JSONElement;
    udiMaxSize : UDINT;
END_VAR
VAR_OUTPUT
    udiResultSize : UDINT;
END_VAR
END_METHOD
END_FUNCTION_BLOCK

FUNCTION_BLOCK JSONDataFactory
METHOD Create : POINTER TO JSONData
VAR_OUTPUT
    eError : JSON_ERROR;
END_VAR
END_METHOD
END_FUNCTION_BLOCK

FUNCTION_BLOCK JSONBuilder
VAR_INPUT
    pJsonData : POINTER TO JSONData;
END_VAR
VAR_OUTPUT
    diRootObj : DINT;
END_VAR
METHOD Reset
END_METHOD
METHOD SetKeyWithObject : DINT
VAR_INPUT
    wsKey : WSTRING;
    diParentIndex : DINT;
END_VAR
END_METHOD
METHOD SetKeyWithValue : DINT
VAR_INPUT
    wsKey : WSTRING;
    value : ANY;
    diParentIndex : DINT;
END_VAR
END_METHOD
END_FUNCTION_BLOCK

FUNCTION_BLOCK JSONByteArrayWriter
VAR_INPUT
    xExecute : BOOL;
    xAsyncMode : BOOL;
    pwData : POINTER TO WORD;
    udiSize : UDINT;
    wsLineBreak : WSTRING(2);
END_VAR
VAR_IN_OUT
    jsonData : JSONData;
END_VAR
VAR_OUTPUT
    xDone : BOOL;
    xBusy : BOOL;
    xError : BOOL;
    eError : JSON_ERROR;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK JSONByteArrayReader
VAR_INPUT
    xExecute : BOOL;
    xAsyncMode : BOOL;
    pwData : POINTER TO WORD;
END_VAR
VAR_IN_OUT
    jsonData : JSONData;
END_VAR
VAR_OUTPUT
    xDone : BOOL;
    xBusy : BOOL;
    xError : BOOL;
    eError : JSON_ERROR;
END_VAR
END_FUNCTION_BLOCK
