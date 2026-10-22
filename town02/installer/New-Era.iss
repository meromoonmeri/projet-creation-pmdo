; ============================================================================
;  New Era: Abyss to Ascension — installateur Windows
; ============================================================================
;  Convention Halcyon (Palikadude/Halcyon) : le mod se pose dans PMDO/MODS/.
;  Cet installateur ne redistribue PAS PMDO — l'utilisateur doit avoir
;  installé PMDO via PMDOSetup.exe (audinowho/PMDODump) au préalable.
;
;  Ce que fait cet installateur :
;    1. Détecte automatiquement le dossier PMDO (registry + heuristiques)
;    2. Propose PMDO\MODS\New-Era comme cible par défaut
;    3. Décompacte le contenu (Mod.xml + Data\ + Content\ + Strings\ + ...)
;    4. Vérifie que Mod.xml se retrouve bien directement dans New-Era\
;       (jamais New-Era\New-Era\ — erreur classique déjà observée)
;    5. Crée un raccourci « Jouer à New Era » qui lance PMDO.exe du parent
;    6. Installe un désinstalleur standard
; ============================================================================

#define AppName        "New Era: Abyss to Ascension"
#define AppShort       "New-Era"
#define AppVersion     "0.5.1"
#define AppPublisher   "Minori"
#define AppURL         "https://github.com/meromoonmeri/new-era-abyss-to-ascension-V4"
#define AppUUID        "{{CAE98609-7A96-4CFC-B5AB-0E1D41F6A1FF}"
#define PMDOExeName    "PMDO.exe"
#define ModRootMarker  "Mod.xml"

; SourceDir est passé en ligne de commande via /DSourceDir=... par CI.
#ifndef SourceDir
  #define SourceDir "..\build\stage\New-Era"
#endif

#ifndef OutputDir
  #define OutputDir "..\build\out"
#endif

[Setup]
AppId={#AppUUID}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppURL}
AppSupportURL={#AppURL}/issues
AppUpdatesURL={#AppURL}/releases
VersionInfoVersion={#AppVersion}.0
VersionInfoProductName={#AppName}
VersionInfoCompany={#AppPublisher}
VersionInfoDescription=Installateur du mod PMDO "New Era: Abyss to Ascension"

; Cible par défaut : <PMDO>\MODS\New-Era
; Résolue dynamiquement dans code section (voir InitializeWizard).
DefaultDirName={code:GetDefaultInstallDir}
DirExistsWarning=no
UsePreviousAppDir=yes

; Nom du menu Démarrer
DefaultGroupName={#AppName}
AllowNoIcons=yes

; Exécutable de sortie
OutputDir={#OutputDir}
OutputBaseFilename=New-Era-Setup
SetupIconFile=
Compression=lzma2/max
SolidCompression=yes
LZMANumBlockThreads=4
LZMAUseSeparateProcess=yes

; Compatible Windows 7+ (aligné sur PMDO)
MinVersion=6.1sp1
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog commandline

; Assistants
WizardStyle=modern
DisableWelcomePage=no
DisableProgramGroupPage=no
DisableReadyPage=no
DisableFinishedPage=no
ShowLanguageDialog=auto
UninstallDisplayName={#AppName} {#AppVersion}
UninstallDisplayIcon={app}\Mod.xml

; Espace disque estimé (release ~440 MB décompressée)
ExtraDiskSpaceRequired=470000000

[Languages]
Name: "french";  MessagesFile: "compiler:Languages\French.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"

[Messages]
french.WelcomeLabel1=Bienvenue dans l'installateur de [name]
french.WelcomeLabel2=Ce programme va installer le mod PMDO %n%n[name/ver]%n%npar {#AppPublisher}.%n%nAssurez-vous d'avoir installé PMDO (via PMDOSetup) au préalable.%n%nIl est recommandé de fermer PMDO avant de continuer.

[Tasks]
Name: "startmenuicon"; Description: "Créer un raccourci dans le menu Démarrer pour lancer PMDO avec New Era"; GroupDescription: "Raccourcis :"; Flags: unchecked
Name: "desktopicon";   Description: "Créer un raccourci sur le Bureau";                                                            GroupDescription: "Raccourcis :"; Flags: unchecked

[Files]
; ------------------------------------------------------------------
; Contenu du mod (arborescence Halcyon-conforme)
; ------------------------------------------------------------------
; recursesubdirs + createallsubdirs : préserve la structure exacte
; Le contenu de {#SourceDir} est censé être la racine New-Era\
;   (Mod.xml, Data\, Content\, Strings\, CONVERSION\, readme.md, etc.)
Source: "{#SourceDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
; Raccourci menu Démarrer : lance PMDO.exe du dossier PARENT parent (racine PMDO)
Name: "{group}\Jouer à {#AppName}"; \
  Filename: "{code:GetPmdoExePath}"; \
  WorkingDir: "{code:GetPmdoRootDir}"; \
  Comment: "Lance PMDO — sélectionnez ensuite New Era via Special Episodes"; \
  Tasks: startmenuicon; \
  Check: PmdoExeFound

Name: "{group}\Dossier d'installation de New Era"; \
  Filename: "{app}"; \
  IconFilename: "{sys}\shell32.dll"; IconIndex: 4

Name: "{group}\{cm:UninstallProgram,{#AppName}}"; \
  Filename: "{uninstallexe}"

Name: "{autodesktop}\Jouer à {#AppName}"; \
  Filename: "{code:GetPmdoExePath}"; \
  WorkingDir: "{code:GetPmdoRootDir}"; \
  Tasks: desktopicon; \
  Check: PmdoExeFound

[Run]
; Proposer de lancer PMDO à la fin de l'installation.
Filename: "{code:GetPmdoExePath}"; \
  Description: "Lancer PMDO maintenant"; \
  WorkingDir: "{code:GetPmdoRootDir}"; \
  Flags: postinstall skipifsilent nowait; \
  Check: PmdoExeFound

[Code]
{ ============================================================================
   Détection PMDO et validation
   ============================================================================ }

var
  PmdoRootCached: String;

function TryPmdoRoot(const Candidate: String): Boolean;
begin
  Result := (Candidate <> '') and DirExists(Candidate) and FileExists(Candidate + '\{#PMDOExeName}');
end;

function FindPmdoRoot(): String;
var
  Candidates: array of String;
  i: Integer;
  RegVal: String;
  Drive: String;
begin
  Result := '';

  { 1) Registry courant (si un installateur PMDO a laissé une trace) }
  if RegQueryStringValue(HKCU, 'Software\audinowho\PMDO', 'InstallDir', RegVal) then
    if TryPmdoRoot(RegVal) then begin Result := RegVal; Exit; end;
  if RegQueryStringValue(HKLM, 'Software\audinowho\PMDO', 'InstallDir', RegVal) then
    if TryPmdoRoot(RegVal) then begin Result := RegVal; Exit; end;

  { 2) Heuristiques : chemins usuels de PMDOSetup, tous drives possibles }
  SetArrayLength(Candidates, 0);
  for i := 0 to 25 do begin
    Drive := Chr(Ord('C') + i) + ':';
    SetArrayLength(Candidates, Length(Candidates) + 4);
    Candidates[Length(Candidates)-4] := Drive + '\PMDOSetup\PMDO';
    Candidates[Length(Candidates)-3] := Drive + '\PMDO';
    Candidates[Length(Candidates)-2] := Drive + '\Games\PMDO';
    Candidates[Length(Candidates)-1] := Drive + '\Pokemon\PMDO';
  end;

  { 3) Répertoires utilisateur usuels }
  SetArrayLength(Candidates, Length(Candidates) + 4);
  Candidates[Length(Candidates)-4] := ExpandConstant('{localappdata}\PMDO');
  Candidates[Length(Candidates)-3] := ExpandConstant('{userappdata}\PMDO');
  Candidates[Length(Candidates)-2] := ExpandConstant('{userdocs}\PMDO');
  Candidates[Length(Candidates)-1] := ExpandConstant('{userdesktop}\PMDO');

  for i := 0 to Length(Candidates) - 1 do
    if TryPmdoRoot(Candidates[i]) then begin
      Result := Candidates[i];
      Exit;
    end;
end;

function GetPmdoRootDir(Param: String): String;
begin
  if PmdoRootCached = '' then
    PmdoRootCached := FindPmdoRoot();
  Result := PmdoRootCached;
end;

function GetPmdoExePath(Param: String): String;
begin
  Result := GetPmdoRootDir('') + '\{#PMDOExeName}';
end;

function PmdoExeFound(): Boolean;
begin
  Result := GetPmdoRootDir('') <> '';
end;

function GetDefaultInstallDir(Param: String): String;
var
  Root: String;
begin
  Root := GetPmdoRootDir('');
  if Root <> '' then
    Result := Root + '\MODS\{#AppShort}'
  else
    { Fallback si PMDO introuvable : proposer un chemin explicite pour que
      l'utilisateur le corrige manuellement. }
    Result := ExpandConstant('{sd}\PMDOSetup\PMDO\MODS\{#AppShort}');
end;

{ ============================================================================
   Assistant d'installation
   ============================================================================ }

procedure InitializeWizard();
begin
  { Rien à faire — le chemin par défaut est calculé via GetDefaultInstallDir }
end;

function InitializeSetup(): Boolean;
begin
  Result := True;
  { Si PMDO n'est pas trouvé, on ne bloque pas — on avertit. }
  if not PmdoExeFound() then
    if MsgBox(
      'PMDO n''a pas été détecté automatiquement sur cette machine.' + #13#10 + #13#10 +
      'New Era est un mod qui a besoin de PMDO pour fonctionner :' + #13#10 +
      '  1. Téléchargez PMDOSetup depuis :' + #13#10 +
      '     https://github.com/audinowho/PMDODump/releases' + #13#10 +
      '  2. Installez PMDO' + #13#10 +
      '  3. Relancez cet installateur' + #13#10 + #13#10 +
      'Continuer quand même l''installation ? (Vous devrez alors choisir manuellement ' +
      'le dossier PMDO\MODS\New-Era à l''écran suivant.)',
      mbConfirmation, MB_YESNO) = IDNO then
      Result := False;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  ModXmlPath: String;
begin
  if CurStep = ssPostInstall then begin
    { Vérification anti double-niveau : Mod.xml DOIT être directement dans
      le dossier d'installation. On a déjà observé le bug New-Era\New-Era\. }
    ModXmlPath := ExpandConstant('{app}\{#ModRootMarker}');
    if not FileExists(ModXmlPath) then
      MsgBox(
        'AVERTISSEMENT : le fichier Mod.xml n''a pas été trouvé dans :' + #13#10 +
        '  ' + ExpandConstant('{app}') + #13#10 + #13#10 +
        'PMDO ne verra pas le mod. Vérifiez le contenu du dossier.',
        mbError, MB_OK);
  end;
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  Result := False;
end;
