(* CODESYS IIoT MQTT client API used by moqui-plc (library namespace MQTT).
 *
 * Interface declarations only (no implementation), for type checking with a
 * non-CODESYS compiler. Only the members moqui-plc uses are declared. A Rust
 * runtime would implement them on top of an MQTT 5 client crate.
 *)

TYPE MQTT_VERSION : (V3_1_1 := 4, V5 := 5); END_TYPE
TYPE MQTT_QOS : (QoS0, QoS1, QoS2); END_TYPE
TYPE MQTT_RETAIN_HANDLING : (On_Subscribe, If_Not_Exists, Not_Exists); END_TYPE
TYPE COMMUNICATION_MODE : (TCP, WEBSOCKET); END_TYPE
TYPE FILTER_MODE : (FILTER_OFF, FILTER_ON); END_TYPE
TYPE MQTT_ERROR : (NO_ERROR, TIMEOUT, CONNECTION_REFUSED, DISCONNECTED, PROTOCOL_ERROR); END_TYPE

(* Library parameters (CODESYS: MQTT.MQTTParam). Values are runtime specific. *)
VAR_GLOBAL CONSTANT
    g_udiMaxPacketSize : UDINT := 268435455;
    g_udiMaxUserProperties : UDINT := 8;
END_VAR

TYPE MQTTConnectProperties :
STRUCT
    udiSessionExpiryInterval : UDINT;
    udiMaximumPacketSize : UDINT;
END_STRUCT
END_TYPE

TYPE MQTTWillProperties :
STRUCT
    bPayloadFormatIndicator : BYTE;
    udiMessageExpiryInterval : UDINT;
    wsContentType : WSTRING;
    udiWillDelayInterval : UDINT;
END_STRUCT
END_TYPE

TYPE MQTTPublishProperties :
STRUCT
    bPayloadFormatIndicator : BYTE;
    udiMessageExpiryInterval : UDINT;
    wsContentType : WSTRING;
END_STRUCT
END_TYPE

TYPE MQTTSubscribeProperties :
STRUCT
    udiSubscriptionIdentifier : UDINT;
    xNoLocalOption : BOOL;
    xRetainAsPublished : BOOL;
    eRetainHandling : MQTT_RETAIN_HANDLING;
END_STRUCT
END_TYPE

FUNCTION_BLOCK MQTTClient
VAR_INPUT
    xEnable : BOOL;
    sHostname : STRING(255);
    uiPort : UINT;
    eCommunicationMode : COMMUNICATION_MODE;
    sWebSocketUrl : STRING(255);
    itfTLSContext : ITLSContext;
    eMQTTVersion : MQTT_VERSION;
    sClientId : STRING(255);
    wsUsername : WSTRING(255);
    wsPassword : WSTRING(255);
    uiKeepAlive : UINT;
    xCleanSession : BOOL;
    udiTimeOut : UDINT;
    tPingInterval : TIME;
    wsWillTopic : WSTRING(1024);
    pbWillMessage : POINTER TO BYTE;
    uiWillMessageSize : UINT;
    eWillQoS : MQTT_QOS;
    xWillRetain : BOOL;
    mQTTConnectProperties : MQTTConnectProperties;
    mQTTWillProperties : MQTTWillProperties;
END_VAR
VAR_OUTPUT
    xConnectedToBroker : BOOL;
    xBusy : BOOL;
    xError : BOOL;
    eMQTTError : MQTT_ERROR;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MQTTPublish
VAR_INPUT
    xExecute : BOOL;
    mqttClient : REF_TO MQTTClient;
    wsTopicName : WSTRING(1024);
    pbPayload : POINTER TO BYTE;
    udiPayloadSize : UDINT;
    eQoS : MQTT_QOS;
    xRetain : BOOL;
    xReDelivery : BOOL;
    udiTimeOut : UDINT;
    mQTTPublishProperties : MQTTPublishProperties;
END_VAR
VAR_OUTPUT
    xDone : BOOL;
    xBusy : BOOL;
    xError : BOOL;
    eMQTTError : MQTT_ERROR;
END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MQTTSubscribe
VAR_INPUT
    xEnable : BOOL;
    mqttClient : REF_TO MQTTClient;
    wsTopicFilter : WSTRING(1024);
    eFilterMode : FILTER_MODE;
    eSubscribeQoS : MQTT_QOS;
    pbPayload : POINTER TO BYTE;
    udiMaxPayloadSize : UDINT;
    udiTimeout : UDINT;
    mQTTSubscribeProperties : MQTTSubscribeProperties;
END_VAR
VAR_OUTPUT
    xDone : BOOL;
    xBusy : BOOL;
    xError : BOOL;
    eMQTTError : MQTT_ERROR;
    xSubscribeActive : BOOL;
    xReceived : BOOL;
    wsLastTopic : WSTRING(1024);
END_VAR
END_FUNCTION_BLOCK
