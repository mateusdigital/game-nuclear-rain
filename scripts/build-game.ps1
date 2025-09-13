##----------------------------------------------------------------------------##
##  File      : build-game.ps1                                                ##
##  Project   : game-koliery                                                  ##
##  Date      : 2025-8-17                                                     ##
##  Copyright : 2025                                                          ##
##  Copyright : mateusdigital <hello@mateus.digital>                          ##
##----------------------------------------------------------------------------##


## -----------------------------------------------------------------------------
$ErrorActionPreference = "Stop"

## -----------------------------------------------------------------------------
$OUTPUT_DIR  = "./_build/web-release";

$PACKAGE_JSON = (Get-Content "./package.json" | ConvertFrom-Json);
$GAME_NAME    = $PACKAGE_JSON.name;
$GAME_TAGS    = $PACKAGE_JSON.keywords;
$GAME_VERSION = $PACKAGE_JSON.version;
$GAME_BUILD   = $PACKAGE_JSON.build;


Write-Host "==> Building for Web";
Write-Host "GAME VERSION: ${GAME_VERSION}(${GAME_BUILD})";


## --- Bump the Version --------------------------------------------------------
if( -not $GAME_BUILD ) {
  $GAME_BUILD = 0;
}

$GAME_BUILD = [int]$GAME_BUILD + 1;

$PACKAGE_JSON.build = $GAME_BUILD;
$PACKAGE_JSON | ConvertTo-Json -Depth 10 | Set-Content "./package.json";


## --- Clean Output directory --------------------------------------------------
Remove-Item                      `
  -Recurse -Force                `
  -ErrorAction SilentlyContinue  `
  "${OUTPUT_DIR}"           `
;

New-Item -Type Directory -Force  `
  "${OUTPUT_DIR}" | Out-Null
;


## --- Copy source files ------------------------------------------------------
Copy-Item -Recurse "./index.html"  "${OUTPUT_DIR}";
Copy-Item -Recurse "./src"         "${OUTPUT_DIR}";
Copy-Item -Recurse "./libs"        "${OUTPUT_DIR}";
Copy-Item -Recurse "./fonts"        "${OUTPUT_DIR}";
Copy-Item -Recurse "./css"        "${OUTPUT_DIR}";

(Get-Content "${OUTPUT_DIR}/index.html")                    `
    -replace "__GAME_NAME__",    "${GAME_NAME}"                  `
    -replace "__GAME_TAGS__",    "${GAME_TAGS}"                  `
    -replace "__GAME_VERSION__", "${GAME_VERSION}"               `
    -replace "__GAME_BUILD__",   "${GAME_BUILD}"                 `
    -replace "__GAME_DATE__",    (Get-Date -Format "yyyy-MM-dd") `
| Set-Content "${OUTPUT_DIR}/index.html";


## -----------------------------------------------------------------------------
Write-Output "==> done...";
