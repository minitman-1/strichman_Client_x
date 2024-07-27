
% Header START
%
% Zweck: Dieses Skript startet direkt den Bewertungsprozess.
%
% Skriptname: startEvaluation.m
% Funktion: startEvaluation
%
% Erstellt von: Bernd Schmidt
% Erstelldatum: 1. August 2024
%
% Änderungshistorie:
% Datum: 1. August 2024: Erstellt
% Datum: 23. Juli 2024: Änderungen für zentrale Logdatei
% Datum: 23. Juli 2024: Nutzung von config zur Initialisierung
%
% Funktionsart: Standalone-Funktion
%               User-Funktion
%
% Verwendete Funktionen:
%   - config(): Lädt die Konfigurationsdaten.
%   - fileListenerClient_x(): Startet den Bewertungsprozess.
%
% Listung der Anonymous-Funktion: (Keine vorhanden)
% Listung der Callback-Funktion: (Keine vorhanden)
%
% Syntax für die Verwendung: (nur im Falle einer Funktion)
%   startEvaluation()
%
% Eingaben/ Übergaben: Keine
%
% Outputs/ Rückgaben: Keine
%
% Beispiele: (für die Verwendung der Funktion)
%   - Aufruf der Funktion ohne Eingaben:
%       startEvaluation();
%
% Header END

function startEvaluation()
    try
        % Konfigurationsdaten laden
        cfg = config();
        
        % Log-Eintrag für den Start des Bewertungsprozesses
        logEintrag(cfg.logDatei, 'Nachricht', 'StartEvaluation start.');

        % Schritt 1: Verzeichnis des aktuellen Skripts bestimmen
        scriptDir = fileparts(mfilename('fullpath')); 
        disp(['Aktuelles Skriptverzeichnis: ', scriptDir]);
        
        % Schritt 2: Drei Ebenen höher navigieren
        baseDir = fullfile(scriptDir, '..', '..', '..'); 
        disp(['Basisverzeichnis (drei Ebenen höher): ', baseDir]);
        
        % Schritt 3: Verzeichnis zur Konfigurationsdatei hinzufügen
        configPath = fullfile(baseDir, 'config');
        disp(['Pfad zur Konfigurationsdatei: ', configPath]);
        
        % Überprüfen, ob das Verzeichnis existiert
        if ~isfolder(configPath)
            error('Das Verzeichnis %s existiert nicht.', configPath);
        end
        addpath(configPath);
        
        % Schritt 4: Konfigurationsdaten laden
        cfg = config();
        disp('Konfigurationsdaten geladen.');
        
        % Schritt 5: Pfad zum Verzeichnis `functions` hinzufügen
        functionsPath = fullfile(baseDir, 'src', 'main', 'functions');
        disp(['Pfad zum Verzeichnis functions: ', functionsPath]);
        
        % Überprüfen, ob das Verzeichnis existiert
        if ~isfolder(functionsPath)
            error('Das Verzeichnis %s existiert nicht.', functionsPath);
        end
        addpath(functionsPath);
        
        % Debug: Ausgabe des Pfads zur Funktion `fileListenerClient_x`
        disp(['Pfad zur Funktion fileListenerClient_x hinzugefügt: ', functionsPath]);
        
        % Schritt 6: Bewertungsprozess starten
        fileListenerClient_x();
        
        % Log-Eintrag für das Ende des Bewertungsprozesses
        logEintrag(cfg.logDatei, 'Nachricht', 'StartEvaluation end.');
        
    catch ME
        errorMsg = sprintf('Fehler in startEvaluation.m: %s', ME.message);
        disp(errorMsg);
        logEintrag(cfg.logDatei, 'Fehler', errorMsg);
    end
end

% % % Header START
% % %
% % % Zweck: Dieses Skript startet direkt den Bewertungsprozess.
% % %
% % % Skriptname: startEvaluation.m
% % % Funktion: startEvaluation
% % %
% % % Erstellt von: Bernd Schmidt
% % % Erstelldatum: 1. August 2024
% % %
% % % Änderungshistorie:
% % % Datum: 1. August 2024: Erstellt
% % % Datum: 23. Juli 2024: Änderungen für zentrale Logdatei
% % % Datum: 23. Juli 2024: Nutzung von config zur Initialisierung
% % %
% % % Funktionsart: Standalone-Funktion
% % %               User-Funktion
% % %
% % % Verwendete Funktionen:
% % %   - config(): Lädt die Konfigurationsdaten.
% % %   - fileListenerClient_x(): Startet den Bewertungsprozess.
% % %
% % % Listung der Anonymous-Funktion: (Keine vorhanden)
% % % Listung der Callback-Funktion: (Keine vorhanden)
% % %
% % % Syntax für die Verwendung: (nur im Falle einer Funktion)
% % %   startEvaluation()
% % %
% % % Eingaben/ Übergaben: Keine
% % %
% % % Outputs/ Rückgaben: Keine
% % %
% % % Beispiele: (für die Verwendung der Funktion)
% % %   - Aufruf der Funktion ohne Eingaben:
% % %       startEvaluation();
% % %
% % % Header END
% % 
% % function startEvaluation()
% %     % Schritt 1: Verzeichnis des aktuellen Skripts bestimmen
% %     scriptDir = fileparts(mfilename('fullpath')); 
% %     % disp(['Aktuelles Skriptverzeichnis: ', scriptDir]);
% % 
% %     % Schritt 2: Drei Ebenen höher navigieren
% %     baseDir = fullfile(scriptDir, '..', '..', '..'); 
% %     % disp(['Basisverzeichnis (drei Ebenen höher): ', baseDir]);
% % 
% %     % Schritt 3: Verzeichnis zur Konfigurationsdatei hinzufügen
% %     configPath = fullfile(baseDir, 'config');
% %     % disp(['Pfad zur Konfigurationsdatei: ', configPath]);
% % 
% %     % Überprüfen, ob das Verzeichnis existiert
% %     if ~isfolder(configPath)
% %         error('Das Verzeichnis %s existiert nicht.', configPath);
% %     end
% %     addpath(configPath);
% % 
% %     % Schritt 4: Konfigurationsdaten laden
% %     cfg = config();
% %     % disp('Konfigurationsdaten geladen.');
% % 
% %     % Schritt 5: Pfad zum Verzeichnis `functions` hinzufügen
% %     functionsPath = fullfile(baseDir, 'src', 'main', 'functions');
% %     % disp(['Pfad zum Verzeichnis functions: ', functionsPath]);
% % 
% %     % Überprüfen, ob das Verzeichnis existiert
% %     if ~isfolder(functionsPath)
% %         error('Das Verzeichnis %s existiert nicht.', functionsPath);
% %     end
% %     addpath(functionsPath);
% % 
% %     % Debug: Ausgabe des Pfads zur Funktion `fileListenerClient_x`
% %     % disp(['Pfad zur Funktion fileListenerClient_x hinzugefügt: ', functionsPath]);
% % 
% %     % Log-Eintrag erstellen
% %     logEintrag(cfg.logDatei, 'Nachricht', 'Bewertungsprozess wird gestartet...');
% % 
% %     % Schritt 6: Bewertungsprozess starten
% %     fileListenerClient_x();
% % end

% function logEintrag(logDatei, varargin)
%     % LOGEINTRAG Fügt einen Eintrag in eine Protokolldatei hinzu.
%     % Diese Funktion schreibt einen Eintrag in die angegebene Protokolldatei.
% 
%     % Überprüft, ob eine gerade Anzahl an varargin-Parametern übergeben wurde
%     if mod(length(varargin), 2) ~= 0
%         error('Jedes Schlüssel-Wert-Paar muss eine gerade Anzahl von Eingabeparametern haben.');
%     end
% 
%     % Standardwerte für optionale Parameter
%     schreibeAufrufer = true;
%     schreibeZeitstempel = true;
%     nutzeLogDatei = false;
% 
%     % Verarbeitet varargin für optionale Parameter
%     if nargin > 1
%         for i = 1:2:length(varargin)
%             if strcmp(varargin{i}, 'schreibeAufrufer')
%                 schreibeAufrufer = varargin{i + 1};
%             elseif strcmp(varargin{i}, 'schreibeZeitstempel')
%                 schreibeZeitstempel = varargin{i + 1};
%             elseif strcmp(varargin{i}, 'nutzeLogDatei')
%                 nutzeLogDatei = varargin{i + 1};
%             end
%         end
%     end
% 
%     % Verzeichnis der Protokolldatei prüfen und erstellen, falls nicht vorhanden
%     logDir = fileparts(logDatei);
%     if ~exist(logDir, 'dir')
%         mkdir(logDir);
%     end
% 
%     % Öffnet die Logdatei zum Anhängen
%     fid = fopen(logDatei, 'a');
%     if fid == -1
%         error('Protokolldatei konnte nicht geöffnet werden: %s', logDatei);
%     end
% 
%     % Schreibt den Zeitstempel, wenn gewünscht
%     if schreibeZeitstempel
%         fprintf(fid, '[%s] ', datestr(now, 'yyyy-mm-dd HH:MM:SS'));
%     end
% 
%     % Ermittelt und schreibt Aufruferinfo oder Logdatei, wenn gewünscht
%     if nutzeLogDatei
%         fprintf(fid, '[%s] ', logDatei);
%     elseif schreibeAufrufer
%         stack = dbstack;
%         aufruferInfo = 'Unbekannt';
%         pfadName = 'Nicht zutreffend';
%         if numel(stack) > 1
%             aufruferInfo = stack(2).name; % Der direkte Aufrufer ist der zweite Eintrag im Stack
%             pfadName = which(aufruferInfo);
%         else
%             aufruferInfo = 'Workspace oder Command Window';
%         end
%         fprintf(fid, '[%s] [%s] ', aufruferInfo, pfadName);
%     end
% 
%     % Iteriert über die varargin-Argumente in Paaren für zusätzliche Daten
%     for i = 1:2:length(varargin)
%         varName = varargin{i}; % Variablennamen
%         if strcmp(varName, 'schreibeAufrufer') || strcmp(varName, 'schreibeZeitstempel') || strcmp(varName, 'nutzeLogDatei')
%             continue; % Überspringt die speziellen Steuerungsparameter
%         end
%         varValue = varargin{i + 1}; % Variablenwert
% 
%         % Überprüft den Typ des Variablenwerts und formatiert ihn entsprechend
%         if isnumeric(varValue)
%             valueStr = num2str(varValue);
%         elseif ischar(varValue) || isstring(varValue)
%             valueStr = ['"', char(varValue), '"'];
%         else
%             valueStr = 'Komplexer Typ'; % Für nicht direkt unterstützte Typen
%         end
% 
%         % Fügt den Variablennamen und -wert zum Logeintrag hinzu
%         fprintf(fid, '%s=%s; ', varName, valueStr);
%     end
% 
%     % Schließt den Eintrag mit einem Zeilenumbruch und schließt die Datei
%     fprintf(fid, '\n');
%     fclose(fid);
% end



%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % Header START
% % % %
% % % % Zweck: Dieses Skript startet direkt den Bewertungsprozess.
% % % %
% % % % Skriptname: startEvaluation.m
% % % % Funktion: startEvaluation
% % % %
% % % % Erstellt von: Bernd Schmidt
% % % % Erstelldatum: 1. August 2024
% % % %
% % % % Änderungshistorie:
% % % % Datum: 1. August 2024: Erstellt
% % % % Datum: 23. Juli 2024: Hinzufügen von Log-Einträgen für eine detaillierte Protokollierung
% % % %
% % % % Funktionsart: Standalone-Funktion
% % % %               User-Funktion
% % % %
% % % % Verwendete Funktionen:
% % % %   - config(): Lädt die Konfigurationsdaten.
% % % %   - fileListenerClient_x(): Startet den Bewertungsprozess.
% % % %
% % % % Listung der Anonymous-Funktion: (Keine vorhanden)
% % % % Listung der Callback-Funktion: (Keine vorhanden)
% % % %
% % % % Syntax für die Verwendung: (nur im Falle einer Funktion)
% % % %   startEvaluation()
% % % %
% % % %    Inputs/ Übergaben: Keine
% % % %
% % % %    Outputs/ Rückgaben: Keine
% % % %
% % % % Beispiele: (für die Verwendung der Funktion)
% % % %   - Aufruf der Funktion ohne Eingaben:
% % % %       startEvaluation();
% % % %
% % % % Header END
% % % % clear all;clc;close all;
% % % % Code STARTs
% % % function startEvaluation()
% % %     % Schritt 1: Verzeichnis des aktuellen Skripts bestimmen
% % %     scriptDir = fileparts(mfilename('fullpath')); 
% % %     logEintrag('startEvaluation.log', 'Nachricht', sprintf('Aktuelles Skriptverzeichnis: %s', scriptDir));
% % % 
% % %     % Schritt 2: Drei Ebenen höher navigieren
% % %     baseDir = fullfile(scriptDir, '..', '..', '..'); 
% % %     logEintrag('startEvaluation.log', 'Nachricht', sprintf('Basisverzeichnis (drei Ebenen höher): %s', baseDir));
% % % 
% % %     % Schritt 3: Verzeichnis zur Konfigurationsdatei hinzufügen
% % %     configPath = fullfile(baseDir, 'config');
% % %     logEintrag('startEvaluation.log', 'Nachricht', sprintf('Pfad zur Konfigurationsdatei: %s', configPath));
% % % 
% % %     % Überprüfen, ob das Verzeichnis existiert
% % %     if ~isfolder(configPath)
% % %         errorMsg = sprintf('Das Verzeichnis %s existiert nicht.', configPath);
% % %         logEintrag('startEvaluation.log', 'Fehler', errorMsg);
% % %         error(errorMsg);
% % %     end
% % %     addpath(configPath);
% % % 
% % %     % Schritt 4: Konfigurationsdaten laden
% % %     cfg = config();
% % %     logEintrag('startEvaluation.log', 'Nachricht', 'Konfigurationsdaten geladen.');
% % % 
% % %     % Schritt 5: Pfad zum Verzeichnis `functions` hinzufügen
% % %     functionsPath = fullfile(baseDir, 'src', 'main', 'functions');
% % %     logEintrag('startEvaluation.log', 'Nachricht', sprintf('Pfad zum Verzeichnis functions: %s', functionsPath));
% % % 
% % %     % Überprüfen, ob das Verzeichnis existiert
% % %     if ~isfolder(functionsPath)
% % %         errorMsg = sprintf('Das Verzeichnis %s existiert nicht.', functionsPath);
% % %         logEintrag('startEvaluation.log', 'Fehler', errorMsg);
% % %         error(errorMsg);
% % %     end
% % %     addpath(functionsPath);
% % % 
% % %     % Debug: Ausgabe des Pfads zur Funktion `fileListenerClient_x`
% % %     logEintrag('startEvaluation.log', 'Nachricht', sprintf('Pfad zur Funktion fileListenerClient_x hinzugefügt: %s', functionsPath));
% % % 
% % %     % Schritt 6: Bewertungsprozess starten
% % %     logEintrag('startEvaluation.log', 'Nachricht', 'Bewertungsprozess wird gestartet...');
% % %     try
% % %         fileListenerClient_x();
% % %         logEintrag('startEvaluation.log', 'Nachricht', 'Bewertungsprozess erfolgreich abgeschlossen.');
% % %     catch ME
% % %         errorMsg = sprintf('Fehler im Bewertungsprozess: %s', ME.message);
% % %         logEintrag('startEvaluation.log', 'Fehler', errorMsg);
% % %         rethrow(ME);
% % %     end
% % % end

% function startEvaluation()
%     % Schritt 1: Verzeichnis des aktuellen Skripts bestimmen
%     scriptDir = fileparts(mfilename('fullpath')); 
%     fprintf('Aktuelles Skriptverzeichnis: %s\n', scriptDir);
% 
%     % Schritt 2: Drei Ebenen höher navigieren
%     baseDir = fullfile(scriptDir, '..', '..', '..')
%     fprintf('Basisverzeichnis (drei Ebenen höher): %s\n', baseDir);
% 
%     % Schritt 3: Verzeichnis zur Konfigurationsdatei hinzufügen
%     configPath = fullfile(baseDir, 'config');
%     fprintf('Pfad zur Konfigurationsdatei: %s\n', configPath);
% 
%     % Überprüfen, ob das Verzeichnis existiert
%     if ~isfolder(configPath)
%         error('Das Verzeichnis %s existiert nicht.', configPath);
%     end
%     addpath(configPath);
% 
%     % Schritt 4: Konfigurationsdaten laden
%     cfg = config();
%     fprintf('Konfigurationsdaten geladen.\n');
% 
%     % Schritt 5: Pfad zum Verzeichnis `functions` hinzufügen
%     functionsPath = fullfile(baseDir, 'src', 'main', 'functions');
%     fprintf('Pfad zum Verzeichnis functions: %s\n', functionsPath);
% 
%     % Überprüfen, ob das Verzeichnis existiert
%     if ~isfolder(functionsPath)
%         error('Das Verzeichnis %s existiert nicht.', functionsPath);
%     end
%     addpath(functionsPath);
% 
%     % Debug: Ausgabe des Pfads zur Funktion `fileListenerClient_x`
%     fprintf('Pfad zur Funktion fileListenerClient_x hinzugefügt: %s\n', functionsPath);
% 
%     % Schritt 6: Bewertungsprozess starten
%     fprintf('Bewertungsprozess wird gestartet...\n');
%     fileListenerClient_x();
% end







% Code ENDs
