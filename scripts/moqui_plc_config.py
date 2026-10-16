# -*- coding: utf-8 -*-
"""Central configuration for the moqui-plc Python scripts.

Pure data. Import it, do not execute it. It must stay compatible with both
CPython 3 and IronPython 2.7, because export-codesys.py runs inside the CODESYS
script engine. That rules out pyproject.toml (no TOML parser in IronPython 2.7),
f-strings, pathlib and type annotations here.

Scripts under scripts/ import it directly. Skill scripts under .agents/skills/
add <repo>/scripts to sys.path first.
"""
import os

# ---------------------------------------------------------------------------
# Repository paths
# ---------------------------------------------------------------------------

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SCRIPTS_ROOT = os.path.join(REPO_ROOT, "scripts")

IEC61131_ROOT = os.path.join(REPO_ROOT, "iec61131")
IEC61131_MOQUI_ROOT = os.path.join(IEC61131_ROOT, "moqui")
IEC61131_FRAMEWORK_ROOT = os.path.join(IEC61131_MOQUI_ROOT, "framework")

SIMATIC_AX_ROOT = os.path.join(REPO_ROOT, "simatic-ax")
IOT_FIRMWARE_ROOT = os.path.join(REPO_ROOT, "iot-firmware")
CODEGEN_ROOT = os.path.join(REPO_ROOT, "codegen")

# export-codesys.py defaults (unchanged values, now in one place)
EXPORT_CODESYS_TARGET_ROOT = os.path.join(REPO_ROOT, "st")
EXPORT_CODESYS_AX_SCRIPT = os.path.join(SCRIPTS_ROOT, "convert-iec61131-to-ax.py")
EXPORT_CODESYS_AX_TARGET_ROOT = SIMATIC_AX_ROOT

# ---------------------------------------------------------------------------
# CODESYS library namespaces <-> vendor-neutral names
# ---------------------------------------------------------------------------
#
# The canonical iec61131 tree uses PLCopen Motion Control names without a
# library qualifier. The CODESYS project uses the SoftMotion libraries, whose
# symbols are qualified with the library namespace (SM3_Basic., SM3_Robotics.).
#
# export-codesys.py strips the qualifier on export (CODESYS -> canonical) and
# scripts/codesys_namespaces.py adds it back (canonical -> CODESYS), for
# example when a generated CODESYS application copies the framework.
#
# Rules:
# - every symbol below appears unqualified in the canonical tree;
# - CODESYS_RENAMED_SYMBOLS maps CODESYS-specific reference types to their
#   PLCopen names; the reverse mapping restores the CODESYS name;
# - spelling is exact (IEC identifiers are case-insensitive, but the mapping
#   keeps each spelling found in the project so the round trip is identical);
# - a qualified symbol missing from this table is left qualified by the export
#   and reported: add it here, then export again.
# - only code is transformed; comments, pragmas and string literals are not.

CODESYS_LIBRARY_SYMBOLS = {
    "SM3_Basic": (
        "AXIS_REF_SM3",
        "MC_AbortTrigger",
        "MC_AccelerationProfile",
        "MC_BUFFER_MODE",
        "MC_CAM_ID",
        "MC_CamIn",
        "MC_CamOut",
        "MC_CamTableSelect",
        "MC_DIRECTION",
        "MC_Direction",
        "MC_GearIn",
        "MC_GearInPos",
        "MC_GearOut",
        "MC_Halt",
        "MC_HaltSuperImposed",
        "MC_Home",
        "MC_Jog",
        "MC_MoveAbsolute",
        "MC_MoveAdditive",
        "MC_MoveRelative",
        "MC_MoveSuperImposed",
        "MC_MoveVelocity",
        "MC_Phasing",
        "MC_PositionProfile",
        "MC_Power",
        "MC_ReadActualPosition",
        "MC_ReadActualTorque",
        "MC_ReadActualVelocity",
        "MC_ReadAxisError",
        "MC_ReadBoolParameter",
        "MC_ReadParameter",
        "MC_ReadStatus",
        "MC_Reset",
        "MC_STARTMODE",
        "MC_SetOverride",
        "MC_SetPosition",
        "MC_Stop",
        "MC_TA_REF",
        "MC_TP_REF",
        "MC_TV_REF",
        "MC_TouchProbe",
        "MC_VelocityProfile",
        "MC_WriteBoolParameter",
        "MC_WriteParameter",
        "TRIGGER_REF",
    ),
    "SM3_Robotics": (
        "AXIS_GROUP_REF_SM3",
        "MC_CIRC_PATHCHOICE",
        "MC_COORD_REF",
        "MC_GroupEnable",
        "MC_GroupHalt",
        "MC_GroupReadActualPosition",
        "MC_GroupReadActualVelocity",
        "MC_GroupReadError",
        "MC_GroupReadStatus",
        "MC_GroupReset",
        "MC_GroupSetOverride",
        "MC_GroupStop",
        "MC_MoveCircularAbsolute",
        "MC_MoveCircularRelative",
        "MC_MoveDirectAbsolute",
        "MC_MoveDirectRelative",
        "MC_MoveLinearAbsolute",
        "MC_MoveLinearRelative",
        "MC_SetCoordinateTransform",
        "MC_TRANSITION_MODE",
        "MC_TrackConveyorBelt",
        "MC_TrackRotaryTable",
        "SMC_CIRC_MODE",
        "SMC_COORD_SYSTEM",
        "SMC_Frame",
        "SMC_Frame_To_CoordRef",
        "SMC_GroupPower",
        "SMC_POS_REF",
    ),
}

# CODESYS name -> canonical (PLCopen) name
CODESYS_RENAMED_SYMBOLS = {
    "AXIS_REF_SM3": "AXIS_REF",
    "AXIS_GROUP_REF_SM3": "AXES_GROUP_REF",
}

# CODESYS extensions with no PLCopen counterpart. They stay unqualified in the
# canonical tree; every other platform must provide them under these names.
CODESYS_VENDOR_EXTENSION_SYMBOLS = (
    "SMC_CIRC_MODE",
    "SMC_COORD_SYSTEM",
    "SMC_Frame",
    "SMC_Frame_To_CoordRef",
    "SMC_GroupPower",
    "SMC_POS_REF",
)
