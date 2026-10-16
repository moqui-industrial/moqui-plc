(* CODESYS Recipe Management API used by moqui-plc (library namespace
 * Recipe_Management). Interface declarations only (no implementation).
 * A Rust runtime would store recipes as files under the storage path.
 *)

FUNCTION_BLOCK RecipeManCommands
METHOD SetStoragePath : DWORD
VAR_INPUT
    stPath : STRING;
END_VAR
END_METHOD
METHOD ReloadRecipes : DWORD
VAR_INPUT
    RecipeDefinitionName : STRING;
END_VAR
END_METHOD
METHOD GetRecipeNames : DWORD
VAR_INPUT
    RecipeDefinitionName : STRING;
    pStrings : POINTER TO STRING;
    iSize : INT;
    iStartIndex : INT;
END_VAR
END_METHOD
METHOD GetRecipeCount : DINT
VAR_INPUT
    RecipeDefinitionName : STRING;
END_VAR
END_METHOD
METHOD CreateRecipe : DWORD
VAR_INPUT
    RecipeDefinitionName : STRING;
    RecipeName : STRING;
END_VAR
END_METHOD
METHOD ReadAndSaveRecipe : DWORD
VAR_INPUT
    RecipeDefinitionName : STRING;
    RecipeName : STRING;
END_VAR
END_METHOD
METHOD LoadAndWriteRecipe : DWORD
VAR_INPUT
    RecipeDefinitionName : STRING;
    RecipeName : STRING;
END_VAR
END_METHOD
METHOD DeleteRecipeFile : DWORD
VAR_INPUT
    RecipeDefinitionName : STRING;
    RecipeName : STRING;
END_VAR
END_METHOD
METHOD DeleteRecipe : DWORD
VAR_INPUT
    RecipeDefinitionName : STRING;
    RecipeName : STRING;
END_VAR
END_METHOD
METHOD ResetLastError
END_METHOD
METHOD ResetLastInfo
END_METHOD
END_FUNCTION_BLOCK
