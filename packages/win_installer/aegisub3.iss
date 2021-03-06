; Copyright (c) 2007-2009, Niels Martin Hansen
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
;   * Redistributions of source code must retain the above copyright notice,
;     this list of conditions and the following disclaimer.
;   * Redistributions in binary form must reproduce the above copyright notice,
;     this list of conditions and the following disclaimer in the documentation
;     and/or other materials provided with the distribution.
;   * Neither the name of the Aegisub Group nor the names of its contributors
;     may be used to endorse or promote products derived from this software
;     without specific prior written permission.
;
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
; CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
; POSSIBILITY OF SUCH DAMAGE.
;
; -----------------------------------------------------------------------------
;
; AEGISUB
;
; Website: http://www.aegisub.org/
; Contact: mailto:nielsm@indvikleren.dk
;

#define ARCH 64

#include "fragment_setupbase.iss"
#include "fragment_strings.iss"

[Setup]
AppID={{24BC8B57-716C-444F-B46B-A3349B9164C5}
DefaultDirName={pf}\Aegisub
PrivilegesRequired=poweruser
ArchitecturesInstallIn64BitMode=x64
ArchitecturesAllowed=x64

#include "fragment_mainprogram.iss"
#include "fragment_associations.iss"
#include "fragment_codecs.iss"
#include "fragment_automation.iss"
#include "fragment_translations.iss"
#include "fragment_spelling.iss"
#ifdef DEPCTRL
#include "fragment_runtimes.iss"
#endif

[Code]
#include "fragment_shell_code.iss"
#include "fragment_migrate_code.iss"
#include "fragment_beautify_code.iss"

procedure InitializeWizard;
begin
  InitializeWizardBeautify;
end;

function InitializeSetup: Boolean;
begin
  Result := InitializeSetupMigration;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  Updates: String;
begin
  CurStepChangedMigration(CurStep);

  if CurStep = ssPostInstall then
  begin
    if IsTaskSelected('checkforupdates') then
      Updates := 'true'
    else
      Updates := 'false';

    SaveStringToFile(
      ExpandConstant('{app}\installer_config.json'),
      FmtMessage('{"App": {"Auto": {"Check For Updates": %1}, "First Start": false, "Language": "%2"}}', [
        Updates,
        ExpandConstant('{language}')]),
      False);
  end;
end;

