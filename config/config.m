% Header START
%: Das Skript definiert und lädt die Konfigurationsparameter und -pfade für das gesamte Projekt. Es stellt sicher, dass alle notwendigen Pfade und Parameter korrekt gesetzt sind, um die verschiedenen Funktionen und Prozesse des Projekts zu unterstützen.
%
% Zweck
% Skriptname: config.m
% Funktion: config
%
% Erstellt von: Bernd Schmidt
% Erstelldatum: ‎15. ‎Februar ‎2024
%
% Änderungshistorie:
% Datum: ‎15. ‎Februar ‎2024: Erstellung des Skripts.
% Datum: ‎18. ‎März ‎2024: Änderungen und Optimierungen.
% Datum: ‎19. ‎Juli ‎2024: Header hinzugefügt.
% Datum: ‎23. ‎Juli ‎2024: Fehlerbehandlung und detaillierte Logeinträge hinzugefügt.
%
% Funktionsart: Standalone-Funktion
%               User-Funktion
%
% Verwendete Funktionen: Keine externen Funktionen
% Listung der Helper Funktionen: Keine vorhanden
% Listung der Anonymous-Funktion: Keine vorhanden
% Listung der Callback-Funktion: Keine vorhanden
%
% Syntax für die Verwendung:
%   cfg = config()
%
%    Inputs/ Übergaben: Keine
%
%    Outputs/ Rückgaben:
%    - cfg (struct): Struktur mit allen Konfigurationsparametern und -pfaden.
%
% Beispiele: (für die Verwendung der Funktion)
%   - Aufruf der Funktion und Nutzung der Konfiguration:
%       cfg = config();
%       disp(cfg.wurzelPfad);
%
% Benutzereingaben: Keine
%
% Programmausgaben:
%   - cfg (struct): Struktur mit allen Konfigurationsparametern und -pfaden.
%
% Seiteneffekte:
%   - Keine
%
% Nebeneffekte:
%   - Lesen von Dateien: Keine
%   - Schreiben von Dateien: Keine
%
% Verwendete Variablen und ihre Datentypen sowie Dimensionen:
%   - cfg.wurzelPfad (string): Basisverzeichnis des Projekts.
%   - cfg.basisPfad (string): Basispfad für Netzlaufwerk.
%   - cfg.logPfad (string): Pfad zum Log-Verzeichnis.
%   - cfg.logDatei (string): Pfad zur Log-Datei.
%   - cfg.clientAImagePfad (string): Pfad zu den Bildverzeichnissen des Clients.
%   - cfg.clientABewertungPfad (string): Pfad zu den Bewertungsverzeichnissen des Clients.
%   - cfg.clientASchonBewertetPfad (string): Pfad zu den Verzeichnissen für bereits bewertete Bilder.
%
% Verwendete Parameter und ihre Datentypen sowie Dimensionen: Keine spezifischen zusätzlichen Parameter
%
% Verwendete Umgebungsvariablen (falls vorhanden) System: Keine
%
% Hinweise:
%   - Es wird erwartet, dass die definierten Pfade und Verzeichnisse vorhanden sind oder erstellt werden können.
%
% Siehe auch:
% Built-In Funktionen:
%   - fullfile(): Erstellt einen vollständigen Dateipfad.
%   - mkdir(): Erstellt ein neues Verzeichnis.
%
% Theorie:
%   - Dieses Skript ist ein zentrales Element des Projekts, das die Konfiguration für alle anderen Teile bereitstellt. Es stellt sicher, dass alle Pfade und Parameter korrekt gesetzt sind, um ein reibungsloses Funktionieren des Projekts zu gewährleisten.
%
% Berechnung / Algorithmus:
%   - Definiert den Wurzelpfad des Projekts.
%   - Setzt die Basispfade für Logs, Dateien und Ergebnisse.
%   - Konfiguriert die Pfade für verschiedene Clients und deren Bildverzeichnisse.
%
% Header END

% Code START

function cfg = config()
    try
        % Bestimme das Verzeichnis, in dem sich dieses Skript befindet
        scriptPath = fileparts(mfilename('fullpath'));
        disp(['scriptPath: ', scriptPath]);
        
        % Basisverzeichnis des Projekts
        cfg.wurzelPfad = scriptPath;
        
        % Pfade
        cfg.basisPfad = fullfile(cfg.wurzelPfad, '..', 'temp');
        disp(['cfg.basisPfad: ', cfg.basisPfad]);
        
        cfg.logPfad = fullfile(cfg.basisPfad, 'logs');
        disp(['cfg.logPfad: ', cfg.logPfad]);

        % Sicherstellen, dass das Verzeichnis existiert
        if ~exist(cfg.logPfad, 'dir')
            mkdir(cfg.logPfad);
        end

        cfg.logDatei = fullfile(cfg.logPfad, 'projektlog.txt');
        disp(['cfg.logDatei: ', cfg.logDatei]);

        % Netzwerk Basisverzeichnis
        cfg.netzwerkBasisPfad = '\\PC-WEDEKIND\datenaustausch_Dev2Dev';
        disp(['cfg.netzwerkBasisPfad: ', cfg.netzwerkBasisPfad]);

        cfg.clientAImagePfad = fullfile(cfg.netzwerkBasisPfad, 'BilderAktuelleGeneration');
        disp(['cfg.clientAImagePfad: ', cfg.clientAImagePfad]);
        
        cfg.clientABewertungPfad = fullfile(cfg.basisPfad, 'bewertung');
        disp(['cfg.clientABewertungPfad: ', cfg.clientABewertungPfad]);
        
        cfg.clientASchonBewertetPfad = fullfile(cfg.basisPfad, 'image', 'schonBewertet');
        disp(['cfg.clientASchonBewertetPfad: ', cfg.clientASchonBewertetPfad]);

        % Netzwerk Pfad für Bewertungen
        cfg.netzwerkBewertungPfad = fullfile(cfg.netzwerkBasisPfad, 'ready', 'bewertung_clients');
        disp(['cfg.netzwerkBewertungPfad: ', cfg.netzwerkBewertungPfad]);

        % Log-Erstellung bei erfolgreicher Konfiguration
        logEintrag(cfg.logDatei, 'Nachricht', 'Konfigurationsdaten erfolgreich geladen.');
        
    catch ME
        errorMsg = sprintf('Fehler in config.m: %s', ME.message);
        disp(errorMsg);
        logEintrag(cfg.logDatei, 'Fehler', errorMsg);
    end
end




% % % Header START
% % %
% % % Zweck: Das Skript definiert und lädt die Konfigurationsparameter und -pfade für das gesamte Projekt. Es stellt sicher, dass alle notwendigen Pfade und Parameter korrekt gesetzt sind, um die verschiedenen Funktionen und Prozesse des Projekts zu unterstützen.
% % %
% % % Skriptname: config.m
% % % Funktion: config
% % %
% % % Erstellt von: Bernd Schmidt
% % % Erstelldatum: ‎15. ‎Februar ‎2024
% % %
% % % Änderungshistorie:
% % % Datum: ‎15. ‎Februar ‎2024: Erstellung des Skripts.
% % % Datum: ‎18. ‎März ‎2024: Änderungen und Optimierungen.
% % % Datum: ‎19. ‎Juli ‎2024: Header hinzugefügt.
% % %
% % % Funktionsart: Standalone-Funktion
% % %               User-Funktion
% % %
% % % Verwendete Funktionen: Keine externen Funktionen
% % % Listung der Helper Funktionen: Keine vorhanden
% % % Listung der Anonymous-Funktion: Keine vorhanden
% % % Listung der Callback-Funktion: Keine vorhanden
% % %
% % % Syntax für die Verwendung:
% % %   cfg = config()
% % %
% % %    Inputs/ Übergaben: Keine
% % %
% % %    Outputs/ Rückgaben:
% % %    - cfg (struct): Struktur mit allen Konfigurationsparametern und -pfaden.
% % %
% % % Beispiele: (für die Verwendung der Funktion)
% % %   - Aufruf der Funktion und Nutzung der Konfiguration:
% % %       cfg = config();
% % %       disp(cfg.wurzelPfad);
% % %
% % % Benutzereingaben: Keine
% % %
% % % Programmausgaben:
% % %   - cfg (struct): Struktur mit allen Konfigurationsparametern und -pfaden.
% % %
% % % Seiteneffekte:
% % %   - Keine
% % %
% % % Nebeneffekte:
% % %   - Lesen von Dateien: Keine
% % %   - Schreiben von Dateien: Keine
% % %
% % % Verwendete Variablen und ihre Datentypen sowie Dimensionen:
% % %   - cfg.wurzelPfad (string): Basisverzeichnis des Projekts.
% % %   - cfg.basisPfad (string): Basispfad für Netzlaufwerk.
% % %   - cfg.logPfad (string): Pfad zum Log-Verzeichnis.
% % %   - cfg.logDatei (string): Pfad zur Log-Datei.
% % %   - cfg.filesPfad (string): Pfad für Dateien.
% % %   - cfg.formatschluesselPfad (string): Pfad für Formatschlüssel.
% % %   - cfg.speicherpfad (string): Speicherpfad für Ergebnisse.
% % %   - cfg.figurenLogExcelPfad (string): Pfad zur Figuren-Log-Excel-Datei.
% % %   - cfg.ergebnisseExcelPfad (string): Pfad zur Ergebnisse-Excel-Datei.
% % %   - cfg.elternpaareExcelPfad (string): Pfad zur Elternpaare-Excel-Datei.
% % %   - cfg.mutationExcelPfad (string): Pfad zur Mutationen-Excel-Datei.
% % %   - cfg.plusExcelPfad (string): Pfad zur zusätzlichen Ergebnisse-Excel-Datei.
% % %   - cfg.plusExcelPfadTestTunier (string): Pfad zur Turnier-Ergebnisse-Excel-Datei.
% % %   - cfg.clientAImagePfad, cfg.clientBImagePfad, cfg.clientCImagePfad (string): Pfade zu den Bildverzeichnissen der Clients.
% % %   - cfg.clientASchonBewertetPfad, cfg.clientBSchonBewertetPfad, cfg.clientCSchonBewertetPfad (string): Pfade zu den Verzeichnissen für bereits bewertete Bilder.
% % %   - cfg.clientABewertungPfad, cfg.clientBBewertungPfad, cfg.clientCBewertungPfad (string): Pfade zu den Bewertungsverzeichnissen der Clients.
% % %   - cfg.addPaths (cell array of strings): Zell-Array für Pfade, die zum MATLAB-Suchpfad hinzugefügt werden sollen.
% % %   - cfg.anzahlGenerationen (integer): Anzahl der Generationen im evolutionären Algorithmus.
% % %   - cfg.konvergenzSchwelle (double): Schwellenwert für die Konvergenzprüfung.
% % %   - cfg.startRate (double): Startwert der Mutationsrate.
% % %   - cfg.endRate (double): Endwert der Mutationsrate.
% % %   - cfg.anzahlTurniere (integer): Anzahl der Turniere im Auswahlprozess.
% % %   - cfg.turnierGroesse (integer): Größe der Turniere im Auswahlprozess.
% % %   - cfg.winkelArmRechts, cfg.winkelArmLinks, cfg.winkelBeinRechts, cfg.winkelBeinLinks (integer): Initialisierungswinkel für Strichmännchen.
% % %   - cfg.anzahlFiguren (integer): Anzahl der zu erzeugenden Figuren.
% % %
% % % Verwendete Parameter und ihre Datentypen sowie Dimensionen: Keine spezifischen zusätzlichen Parameter
% % %
% % % Verwendete Umgebungsvariablen (falls vorhanden) System: Keine
% % %
% % % Hinweise:
% % %   - Es wird erwartet, dass die definierten Pfade und Verzeichnisse vorhanden sind oder erstellt werden können.
% % %
% % % Siehe auch:
% % % Built-In Funktionen:
% % %   - fullfile(): Erstellt einen vollständigen Dateipfad.
% % %   - mkdir(): Erstellt ein neues Verzeichnis.
% % %
% % % Theorie:
% % %   - Dieses Skript ist ein zentrales Element des Projekts, das die Konfiguration für alle anderen Teile bereitstellt. Es stellt sicher, dass alle Pfade und Parameter korrekt gesetzt sind, um ein reibungsloses Funktionieren des Projekts zu gewährleisten.
% % %
% % % Berechnung / Algorithmus:
% % %   - Definiert den Wurzelpfad des Projekts.
% % %   - Setzt die Basispfade für Logs, Dateien und Ergebnisse.
% % %   - Konfiguriert die Pfade für verschiedene Clients und deren Bildverzeichnisse.
% % %   - Stellt Parameter für den evolutionären Algorithmus bereit.
% % %   - Initialisiert die Winkelparameter für die Strichmännchen.
% % %   - Fügt alle relevanten Pfade zum MATLAB-Suchpfad hinzu.
% % %
% % % Header END
% % 
% % 
% % % Code STARTs
% % 
% % % % Umgebungsbereinigung
% % % close all; % Schließt alle offenen Figuren
% % % clear;     % Löscht alle Variablen im Workspace
% % % clc;       % Löscht den Command Window Inhalt
% % 
% % % Code 
% % 
% % function cfg = config()
% %     % Bestimme das Verzeichnis, in dem sich dieses Skript befindet
% %     scriptPath = fileparts(mfilename('fullpath'));
% %     disp(['scriptPath: ', scriptPath]);
% % 
% %     % Basisverzeichnis des Projekts
% %     cfg.wurzelPfad = scriptPath;
% % 
% %     % Pfade
% %     cfg.basisPfad = fullfile(cfg.wurzelPfad, '..', 'temp');
% %     disp(['cfg.basisPfad: ', cfg.basisPfad]);
% % 
% %     cfg.logPfad = fullfile(cfg.basisPfad, 'logs');
% %     disp(['cfg.logPfad: ', cfg.logPfad]);
% % 
% %     % Sicherstellen, dass das Verzeichnis existiert
% %     if ~exist(cfg.logPfad, 'dir')
% %         mkdir(cfg.logPfad);
% %     end
% % 
% %     cfg.logDatei = fullfile(cfg.logPfad, 'projektlog.txt');
% %     disp(['cfg.logDatei: ', cfg.logDatei]);
% % 
% %     cfg.clientAImagePfad = '\\PC-WEDEKIND\datenaustausch_Dev2Dev\BilderAktuelleGeneration';
% %     disp(['cfg.clientAImagePfad: ', cfg.clientAImagePfad]);
% % 
% %     cfg.clientABewertungPfad = fullfile(cfg.basisPfad, 'bewertung');
% %     disp(['cfg.clientABewertungPfad: ', cfg.clientABewertungPfad]);
% % 
% %     cfg.clientASchonBewertetPfad = fullfile(cfg.basisPfad, 'image', 'schonBewertet');
% %     disp(['cfg.clientASchonBewertetPfad: ', cfg.clientASchonBewertetPfad]);
% % 
% %   end

% function cfg = config()
%     % Bestimme das Verzeichnis, in dem sich dieses Skript befindet
%     scriptPath = fileparts(mfilename('fullpath'));
%     disp(['scriptPath: ', scriptPath]);
% 
%     % Basisverzeichnis des Projekts
%     cfg.wurzelPfad = scriptPath;
% 
%     % Pfade
%     cfg.basisPfad = fullfile(cfg.wurzelPfad, '..', 'temp');
%     disp(['cfg.basisPfad: ', cfg.basisPfad]);
% 
%     cfg.logPfad = fullfile(cfg.basisPfad, 'logs', 'projektlog.txt');
%     disp(['cfg.logPfad: ', cfg.logPfad]);
% 
%     % Korrektur: Hinzufügen des Feldes logDatei
%     cfg.logDatei = cfg.logPfad;
%     disp(['cfg.logDatei: ', cfg.logDatei]);
% 
%     cfg.clientAImagePfad = '\\PC-WEDEKIND\datenaustausch_Dev2Dev\BilderAktuelleGeneration';
%     disp(['cfg.clientAImagePfad: ', cfg.clientAImagePfad]);
% 
%     cfg.clientABewertungPfad = fullfile(cfg.basisPfad, 'bewertung');
%     disp(['cfg.clientABewertungPfad: ', cfg.clientABewertungPfad]);
% 
%     cfg.clientASchonBewertetPfad = fullfile(cfg.basisPfad, 'image', 'schonBewertet');
%     disp(['cfg.clientASchonBewertetPfad: ', cfg.clientASchonBewertetPfad]);
% 
%     % Weitere Konfigurationsparameter
%     % ...
% end



% function cfg = config()
%     % Bestimme das Verzeichnis, in dem sich dieses Skript befindet
%     scriptPath = fileparts(mfilename('fullpath'));
% 
%     % Basisverzeichnis des Projekts
%     cfg.wurzelPfad = scriptPath;
% 
%     % Pfade
%     cfg.basisPfad = fullfile(cfg.wurzelPfad, '..', 'temp');
%     cfg.logPfad = fullfile(cfg.basisPfad, 'logs', 'projektlog.txt');
%     cfg.clientAImagePfad = '\\PC-WEDEKIND\datenaustausch_Dev2Dev\BilderAktuelleGeneration';
%     cfg.clientABewertungPfad = fullfile(cfg.basisPfad, 'bewertung');
%     cfg.clientASchonBewertetPfad = fullfile(cfg.basisPfad, 'image', 'schonBewertet');
% 
%     % Pfad zum Verzeichnis `functions` hinzufügen
%     addpath(fullfile(cfg.wurzelPfad, 'src', 'main', 'functions'));
% 
%     % Weitere Konfigurationsparameter
%     % ... (weitere Konfigurationsparameter hier einfügen)
% end


% function cfg = config()   
%     % Definieren des Wurzelpfades
%     % cfg.wurzelPfad = 'C:\Users\HTW_U\OneDrive\Dokumente\MATLAB\EigMatPrg\EGA_Proportionen';
%     cfg.wurzelPfad = 'D:\MALAB\EigMatPrg\EGA_Proportionen';
% 
%     % Zusammensetzung des Basispfades aus Wurzelpfad und 'NetzDrive\'
%     % (Falls benötigt, ansonsten weglassen oder entsprechend anpassen)
%     % cfg.basisPfad = fullfile(cfg.wurzelPfad, 'NetzDrive\');
% 
%     % Konfigurationspfade definieren
%     cfg.logPfad = fullfile(cfg.wurzelPfad, 'logs'); % Log-Pfad direkt unter dem Wurzelpfad
%     cfg.logDatei = fullfile(cfg.logPfad, 'projektlog.txt'); % Vollständiger Pfad zur Protokolldatei
%     cfg.filesPfad = cfg.wurzelPfad; % Beispiel, wenn filesPfad dem Wurzelpfad entspricht
%     cfg.formatschluesselPfad = fullfile(cfg.wurzelPfad, 'src', 'Formatschlussel');
%     cfg.speicherpfad = cfg.wurzelPfad; % Kann direkt als Wurzelpfad verwendet werden
% 
%     % Pfade für Excel-Dateien
%     cfg.figurenLogExcelPfad = fullfile(cfg.speicherpfad, 'FigurenLog.xlsx');
%     cfg.ergebnisseExcelPfad = fullfile(cfg.speicherpfad, 'testCrossoverResults.xlsx');
%     cfg.elternpaareExcelPfad = fullfile(cfg.speicherpfad, 'testWinner2Parents.xlsx');
%     cfg.mutationExcelPfad = fullfile(cfg.speicherpfad, 'mutationResults.xlsx');
%     cfg.plusExcelPfad = fullfile(cfg.speicherpfad, 'testCrossoverResultPlus.xlsx');
%     cfg.plusExcelPfadTestTunier = fullfile(cfg.speicherpfad, 'testTurnierWinner.xlsx');
% 
%     % Spezifische Bildpfade für die Clients
%     cfg.clientAImagePfad = fullfile(cfg.wurzelPfad, 'src', 'clientA', 'image');
%     cfg.clientBImagePfad = fullfile(cfg.wurzelPfad, 'src', 'clientB', 'image');
%     cfg.clientCImagePfad = fullfile(cfg.wurzelPfad, 'src', 'clientC', 'image');
% 
%     % Pfad für das Verzeichnis "schonBewertet" und Bewertungen für Client A
%     cfg.clientASchonBewertetPfad = fullfile(cfg.clientAImagePfad, 'schonBewertet');
%     cfg.clientABewertungPfad = fullfile(cfg.wurzelPfad, 'src', 'clientA', 'bewertung');
% 
%     % Pfad für das Verzeichnis "schonBewertet" und Bewertungen für Client B
%     cfg.clientBSchonBewertetPfad = fullfile(cfg.clientBImagePfad, 'schonBewertet');
%     cfg.clientBBewertungPfad = fullfile(cfg.wurzelPfad, 'src', 'clientB', 'bewertung');
% 
%     % Pfad für das Verzeichnis "schonBewertet" und Bewertungen für Client C
%     cfg.clientCSchonBewertetPfad = fullfile(cfg.clientCImagePfad, 'schonBewertet');
%     cfg.clientCBewertungPfad = fullfile(cfg.wurzelPfad, 'src', 'clientC', 'bewertung');
% 
%     % Konfiguration für den evolutionären Algorithmus
%     % Anzahl der zu erzeugenden Figuren
%     cfg.anzahlFiguren = 5;
%     cfg.anzahlGenerationen = 4;
%     cfg.konvergenzSchwelle = 0.01;
%     cfg.startRate = 0.8;
%     cfg.endRate = 0.5;
%     cfg.anzahlTurniere = 30;
%     cfg.turnierGroesse = 4;
% 
%     % Initialisierungswinkel für Strichmännchen
%     cfg.winkelArmRechts = 330;
%     cfg.winkelArmLinks = 210;
%     cfg.winkelBeinRechts = 315;
%     cfg.winkelBeinLinks = 225;
% 
%     % Initialisierung von cfg.addPaths als leeres Zell-Array
%     cfg.addPaths = {};
% 
%     % Hinzufügen von Basispfaden zu cfg.addPaths
%     cfg.addPaths = [cfg.addPaths, {fullfile(cfg.wurzelPfad)}];
% 
%     % Dynamische Erzeugung der Client-Pfade und Hinzufügen zu cfg.addPaths
%     clients = {'A', 'B', 'C'};
%     for i = 1:length(clients)
%         clientPath = fullfile(cfg.wurzelPfad, 'src', ['client' clients{i}]);
%         cfg.addPaths = [cfg.addPaths, {clientPath}]; % Hinzufügen als Zelle
% 
%         % Für das Image-Verzeichnis
%         clientImagePath = fullfile(clientPath, 'image');
%         cfg.(['client' clients{i} 'ImagePfad']) = clientImagePath;
%         cfg.addPaths = [cfg.addPaths, {clientImagePath}]; % Hinzufügen als Zelle
%     end
% end

% Code ENDs


%%%%%%%%%%%%%%%%%%% % Header START
% %
% % Zweck: Das Skript definiert und lädt die Konfigurationsparameter und -pfade für das gesamte Projekt. Es stellt sicher, dass alle notwendigen Pfade und Parameter korrekt gesetzt sind, um die verschiedenen Funktionen und Prozesse des Projekts zu unterstützen.
% %
% % Skriptname: config.m
% % Funktion: config
% %
% % Erstellt von: Bernd Schmidt
% % Erstelldatum: ‎15. ‎Februar ‎2024, 
% %
% % Änderungshistorie:
% % Datum: ‎15. ‎Februar ‎2024, : Erstellung des Skripts.
% % Datum: ‎18. ‎März ‎2024 : 
% % Datum: ‎‎19. ‎Juli ‎2024 : Header hinzugefügt
% %
% % Funktionsart: Standalone-Funktion
% %               User-Funktion
% %
% % Verwendete Funktionen: Keine externen Funktionen
% % Listung der Helper Funktionen: Keine vorhanden
% % Listung der Anonymous-Funktion: Keine vorhanden
% % Listung der Callback-Funktion: Keine vorhanden
% %
% % Syntax für die Verwendung:
% %   cfg = config()
% %
% %    Inputs/ Übergaben: Keine
% %
% %    Outputs/ Rückgaben:
% %    - cfg (struct): Struktur mit allen Konfigurationsparametern und -pfaden.
% %
% % Beispiele: (für die Verwendung der Funktion)
% %   - Aufruf der Funktion und Nutzung der Konfiguration:
% %       cfg = config();
% %       disp(cfg.wurzelPfad);
% %
% % Benutzereingaben: Keine
% %
% % Programmausgaben:
% %   - cfg (struct): Struktur mit allen Konfigurationsparametern und -pfaden.
% %
% % Seiteneffekte:
% %   - Keine
% %
% % Nebeneffekte:
% %   - Lesen von Dateien: Keine
% %   - Schreiben von Dateien: Keine
% %
% % Verwendete Variablen und ihre Datentypen sowie Dimensionen:
% %   - cfg.wurzelPfad (string): Basisverzeichnis des Projekts.
% %   - cfg.basisPfad (string): Basispfad für Netzlaufwerk.
% %   - cfg.logPfad (string): Pfad zum Log-Verzeichnis.
% %   - cfg.logDatei (string): Pfad zur Log-Datei.
% %   - cfg.filesPfad (string): Pfad für Dateien.
% %   - cfg.formatschluesselPfad (string): Pfad für Formatschlüssel.
% %   - cfg.speicherpfad (string): Speicherpfad für Ergebnisse.
% %   - cfg.figurenLogExcelPfad (string): Pfad zur Figuren-Log-Excel-Datei.
% %   - cfg.ergebnisseExcelPfad (string): Pfad zur Ergebnisse-Excel-Datei.
% %   - cfg.elternpaareExcelPfad (string): Pfad zur Elternpaare-Excel-Datei.
% %   - cfg.mutationExcelPfad (string): Pfad zur Mutationen-Excel-Datei.
% %   - cfg.plusExcelPfad (string): Pfad zur zusätzlichen Ergebnisse-Excel-Datei.
% %   - cfg.plusExcelPfadTestTunier (string): Pfad zur Turnier-Ergebnisse-Excel-Datei.
% %   - cfg.clientAImagePfad, cfg.clientBImagePfad, cfg.clientCImagePfad (string): Pfade zu den Bildverzeichnissen der Clients.
% %   - cfg.clientASchonBewertetPfad, cfg.clientBSchonBewertetPfad, cfg.clientCSchonBewertetPfad (string): Pfade zu den Verzeichnissen für bereits bewertete Bilder.
% %   - cfg.clientABewertungPfad, cfg.clientBBewertungPfad, cfg.clientCBewertungPfad (string): Pfade zu den Bewertungsverzeichnissen der Clients.
% %   - cfg.addPaths (cell array of strings): Zell-Array für Pfade, die zum MATLAB-Suchpfad hinzugefügt werden sollen.
% %   - cfg.anzahlGenerationen (integer): Anzahl der Generationen im evolutionären Algorithmus.
% %   - cfg.konvergenzSchwelle (double): Schwellenwert für die Konvergenzprüfung.
% %   - cfg.startRate (double): Startwert der Mutationsrate.
% %   - cfg.endRate (double): Endwert der Mutationsrate.
% %   - cfg.anzahlTurniere (integer): Anzahl der Turniere im Auswahlprozess.
% %   - cfg.turnierGroesse (integer): Größe der Turniere im Auswahlprozess.
% %   - cfg.winkelArmRechts, cfg.winkelArmLinks, cfg.winkelBeinRechts, cfg.winkelBeinLinks (integer): Initialisierungswinkel für Strichmännchen.
% %
% % Verwendete Parameter und ihre Datentypen sowie Dimensionen: Keine spezifischen zusätzlichen Parameter
% %
% % Verwendete Umgebungsvariablen (falls vorhanden) System: Keine
% %
% % Hinweise:
% %   - Es wird erwartet, dass die definierten Pfade und Verzeichnisse vorhanden sind oder erstellt werden können.
% %
% % Siehe auch:
% % Built-In Funktionen:
% %   - fullfile(): Erstellt einen vollständigen Dateipfad.
% %   - mkdir(): Erstellt ein neues Verzeichnis.
% %
% % Theorie:
% %   - Dieses Skript ist ein zentrales Element des Projekts, das die Konfiguration für alle anderen Teile bereitstellt. Es stellt sicher, dass alle Pfade und Parameter korrekt gesetzt sind, um ein reibungsloses Funktionieren des Projekts zu gewährleisten.
% %
% % Berechnung / Algorithmus:
% %   - Definiert den Wurzelpfad des Projekts.
% %   - Setzt die Basispfade für Logs, Dateien und Ergebnisse.
% %   - Konfiguriert die Pfade für verschiedene Clients und deren Bildverzeichnisse.
% %   - Stellt Parameter für den evolutionären Algorithmus bereit.
% %   - Initialisiert die Winkelparameter für die Strichmännchen.
% %   - Fügt alle relevanten Pfade zum MATLAB-Suchpfad hinzu.
% %
% % Header END
% 
% 
% % Code STARTs
% 
% % % Umgebungsbereinigung
% % close all; % Schließt alle offenen Figuren
% % clear;     % Löscht alle Variablen im Workspace
% % clc;       % Löscht den Command Window Inhalt
% 
% % Code 
% function cfg = config()   
%     % Definieren des Wurzelpfades
%     % cfg.wurzelPfad = 'C:\Users\HTW_U\OneDrive\Dokumente\MATLAB\EigMatPrg\EGA_Proportionen';
%     cfg.wurzelPfad = 'D:\MALAB\EigMatPrg\EGA_Proportionen';
% 
%     % Zusammensetzung des Basispfades aus Wurzelpfad und 'NetzDrive\'
%     % (Falls benötigt, ansonsten weglassen oder entsprechend anpassen)
%     % cfg.basisPfad = fullfile(cfg.wurzelPfad, 'NetzDrive\');
% 
%     % Konfigurationspfade definieren
%     cfg.logPfad = fullfile(cfg.wurzelPfad, 'logs'); % Log-Pfad direkt unter dem Wurzelpfad
%     cfg.logDatei = fullfile(cfg.logPfad, 'projektlog.txt'); % Vollständiger Pfad zur Protokolldatei
%     cfg.filesPfad = cfg.wurzelPfad; % Beispiel, wenn filesPfad dem Wurzelpfad entspricht
%     cfg.formatschluesselPfad = fullfile(cfg.wurzelPfad, 'src', 'Formatschlussel');
%     cfg.speicherpfad = cfg.wurzelPfad; % Kann direkt als Wurzelpfad verwendet werden
% 
%     % Pfade für Excel-Dateien
%     cfg.figurenLogExcelPfad = fullfile(cfg.speicherpfad, 'FigurenLog.xlsx');
%     cfg.ergebnisseExcelPfad = fullfile(cfg.speicherpfad, 'testCrossoverResults.xlsx');
%     cfg.elternpaareExcelPfad = fullfile(cfg.speicherpfad, 'testWinner2Parents.xlsx');
%     cfg.mutationExcelPfad = fullfile(cfg.speicherpfad, 'mutationResults.xlsx');
%     cfg.plusExcelPfad = fullfile(cfg.speicherpfad, 'testCrossoverResultPlus.xlsx');
%     cfg.plusExcelPfadTestTunier = fullfile(cfg.speicherpfad, 'testTurnierWinner.xlsx');
% 
%     % Spezifische Bildpfade für die Clients
%     cfg.clientAImagePfad = fullfile(cfg.wurzelPfad, 'src', 'clientA', 'image');
%     cfg.clientBImagePfad = fullfile(cfg.wurzelPfad, 'src', 'clientB', 'image');
%     cfg.clientCImagePfad = fullfile(cfg.wurzelPfad, 'src', 'clientC', 'image');
% 
%     % Pfad für das Verzeichnis "schonBewertet" und Bewertungen für Client A
%     cfg.clientASchonBewertetPfad = fullfile(cfg.clientAImagePfad, 'schonBewertet');
%     cfg.clientABewertungPfad = fullfile(cfg.wurzelPfad, 'src', 'clientA', 'bewertung');
% 
%     % Pfad für das Verzeichnis "schonBewertet" und Bewertungen für Client B
%     cfg.clientBSchonBewertetPfad = fullfile(cfg.clientBImagePfad, 'schonBewertet');
%     cfg.clientBBewertungPfad = fullfile(cfg.wurzelPfad, 'src', 'clientB', 'bewertung');
% 
%     % Pfad für das Verzeichnis "schonBewertet" und Bewertungen für Client C
%     cfg.clientCSchonBewertetPfad = fullfile(cfg.clientCImagePfad, 'schonBewertet');
%     cfg.clientCBewertungPfad = fullfile(cfg.wurzelPfad, 'src', 'clientC', 'bewertung');
% 
%     % Konfiguration für den evolutionären Algorithmus
%     % Anzahl der zu erzeugenden Figuren
%     cfg.anzahlFiguren = 5;
%     cfg.anzahlGenerationen = 4;
%     cfg.konvergenzSchwelle = 0.01;
%     cfg.startRate = 0.8;
%     cfg.endRate = 0.5;
%     cfg.anzahlTurniere = 30;
%     cfg.turnierGroesse = 4;
% 
%     % Initialisierungswinkel für Strichmännchen
%     cfg.winkelArmRechts = 330;
%     cfg.winkelArmLinks = 210;
%     cfg.winkelBeinRechts = 315;
%     cfg.winkelBeinLinks = 225;
% 
%     % Initialisierung von cfg.addPaths als leeres Zell-Array
%     cfg.addPaths = {};
% 
%     % Hinzufügen von Basispfaden zu cfg.addPaths
%     cfg.addPaths = [cfg.addPaths, {fullfile(cfg.wurzelPfad)}];
% 
%     % Dynamische Erzeugung der Client-Pfade und Hinzufügen zu cfg.addPaths
%     clients = {'A', 'B', 'C'};
%     for i = 1:length(clients)
%         clientPath = fullfile(cfg.wurzelPfad, 'src', ['client' clients{i}]);
%         cfg.addPaths = [cfg.addPaths, {clientPath}]; % Hinzufügen als Zelle
% 
%         % Für das Image-Verzeichnis
%         clientImagePath = fullfile(clientPath, 'image');
%         cfg.(['client' clients{i} 'ImagePfad']) = clientImagePath;
%         cfg.addPaths = [cfg.addPaths, {clientImagePath}]; % Hinzufügen als Zelle
%     end
% end
% 
% % Code ENDs






% % Header START
% %
% % Zweck: Das Skript definiert und lädt die Konfigurationsparameter und -pfade für das gesamte Projekt. Es stellt sicher, dass alle notwendigen Pfade und Parameter korrekt gesetzt sind, um die verschiedenen Funktionen und Prozesse des Projekts zu unterstützen.
% %
% % Skriptname: config.m
% % Funktion: config
% %
% % Erstellt von: Bernd Schmidt
% % Erstelldatum: ‎15. ‎Februar ‎2024, 
% %
% % Änderungshistorie:
% % Datum: ‎15. ‎Februar ‎2024, : Erstellung des Skripts.
% % Datum: ‎18. ‎März ‎2024 : 
% % Datum: ‎‎19. ‎Juli ‎2024 : Header hinzugefügt
% %
% % Funktionsart: Standalone-Funktion
% %               User-Funktion
% %
% % Verwendete Funktionen: Keine externen Funktionen
% % Listung der Helper Funktionen: Keine vorhanden
% % Listung der Anonymous-Funktion: Keine vorhanden
% % Listung der Callback-Funktion: Keine vorhanden
% %
% % Syntax für die Verwendung:
% %   cfg = config()
% %
% %    Inputs/ Übergaben: Keine
% %
% %    Outputs/ Rückgaben:
% %    - cfg (struct): Struktur mit allen Konfigurationsparametern und -pfaden.
% %
% % Beispiele: (für die Verwendung der Funktion)
% %   - Aufruf der Funktion und Nutzung der Konfiguration:
% %       cfg = config();
% %       disp(cfg.wurzelPfad);
% %
% % Benutzereingaben: Keine
% %
% % Programmausgaben:
% %   - cfg (struct): Struktur mit allen Konfigurationsparametern und -pfaden.
% %
% % Seiteneffekte:
% %   - Keine
% %
% % Nebeneffekte:
% %   - Lesen von Dateien: Keine
% %   - Schreiben von Dateien: Keine
% %
% % Verwendete Variablen und ihre Datentypen sowie Dimensionen:
% %   - cfg.wurzelPfad (string): Basisverzeichnis des Projekts.
% %   - cfg.basisPfad (string): Basispfad für Netzlaufwerk.
% %   - cfg.logPfad (string): Pfad zum Log-Verzeichnis.
% %   - cfg.logDatei (string): Pfad zur Log-Datei.
% %   - cfg.filesPfad (string): Pfad für Dateien.
% %   - cfg.formatschluesselPfad (string): Pfad für Formatschlüssel.
% %   - cfg.speicherpfad (string): Speicherpfad für Ergebnisse.
% %   - cfg.figurenLogExcelPfad (string): Pfad zur Figuren-Log-Excel-Datei.
% %   - cfg.ergebnisseExcelPfad (string): Pfad zur Ergebnisse-Excel-Datei.
% %   - cfg.elternpaareExcelPfad (string): Pfad zur Elternpaare-Excel-Datei.
% %   - cfg.mutationExcelPfad (string): Pfad zur Mutationen-Excel-Datei.
% %   - cfg.plusExcelPfad (string): Pfad zur zusätzlichen Ergebnisse-Excel-Datei.
% %   - cfg.plusExcelPfadTestTunier (string): Pfad zur Turnier-Ergebnisse-Excel-Datei.
% %   - cfg.clientAImagePfad, cfg.clientBImagePfad, cfg.clientCImagePfad (string): Pfade zu den Bildverzeichnissen der Clients.
% %   - cfg.clientASchonBewertetPfad, cfg.clientBSchonBewertetPfad, cfg.clientCSchonBewertetPfad (string): Pfade zu den Verzeichnissen für bereits bewertete Bilder.
% %   - cfg.clientABewertungPfad, cfg.clientBBewertungPfad, cfg.clientCBewertungPfad (string): Pfade zu den Bewertungsverzeichnissen der Clients.
% %   - cfg.addPaths (cell array of strings): Zell-Array für Pfade, die zum MATLAB-Suchpfad hinzugefügt werden sollen.
% %   - cfg.anzahlGenerationen (integer): Anzahl der Generationen im evolutionären Algorithmus.
% %   - cfg.konvergenzSchwelle (double): Schwellenwert für die Konvergenzprüfung.
% %   - cfg.startRate (double): Startwert der Mutationsrate.
% %   - cfg.endRate (double): Endwert der Mutationsrate.
% %   - cfg.anzahlTurniere (integer): Anzahl der Turniere im Auswahlprozess.
% %   - cfg.turnierGroesse (integer): Größe der Turniere im Auswahlprozess.
% %   - cfg.winkelArmRechts, cfg.winkelArmLinks, cfg.winkelBeinRechts, cfg.winkelBeinLinks (integer): Initialisierungswinkel für Strichmännchen.
% %
% % Verwendete Parameter und ihre Datentypen sowie Dimensionen: Keine spezifischen zusätzlichen Parameter
% %
% % Verwendete Umgebungsvariablen (falls vorhanden) System: Keine
% %
% % Hinweise:
% %   - Es wird erwartet, dass die definierten Pfade und Verzeichnisse vorhanden sind oder erstellt werden können.
% %
% % Siehe auch:
% % Built-In Funktionen:
% %   - fullfile(): Erstellt einen vollständigen Dateipfad.
% %   - mkdir(): Erstellt ein neues Verzeichnis.
% %
% % Theorie:
% %   - Dieses Skript ist ein zentrales Element des Projekts, das die Konfiguration für alle anderen Teile bereitstellt. Es stellt sicher, dass alle Pfade und Parameter korrekt gesetzt sind, um ein reibungsloses Funktionieren des Projekts zu gewährleisten.
% %
% % Berechnung / Algorithmus:
% %   - Definiert den Wurzelpfad des Projekts.
% %   - Setzt die Basispfade für Logs, Dateien und Ergebnisse.
% %   - Konfiguriert die Pfade für verschiedene Clients und deren Bildverzeichnisse.
% %   - Stellt Parameter für den evolutionären Algorithmus bereit.
% %   - Initialisiert die Winkelparameter für die Strichmännchen.
% %   - Fügt alle relevanten Pfade zum MATLAB-Suchpfad hinzu.
% %
% % Header END
% 
% 
% % Code STARTs
% 
% % % Umgebungsbereinigung
% % close all; % Schließt alle offenen Figuren
% % clear;     % Löscht alle Variablen im Workspace
% % clc;       % Löscht den Command Window Inhalt
% 
% % Code 
% function cfg = config()   
%     % Definieren des Wurzelpfades
%     % cfg.wurzelPfad = 'C:\Users\HTW_U\OneDrive\Dokumente\MATLAB\EigMatPrg\proportionen\';
%         cfg.wurzelPfad = 'C:\Users\HTW_U\OneDrive\Dokumente\MATLAB\EigMatPrg\EGA_Proportionen\src';
% 
%     % Zusammensetzung des Basispfades aus Wurzelpfad und 'NetzDrive\'
%     cfg.basisPfad = fullfile(cfg.wurzelPfad, 'NetzDrive\');
% 
%     % Konfigurationspfade definieren
%     cfg.logPfad = fullfile(cfg.wurzelPfad, 'logs'); % Log-Pfad direkt unter dem Wurzelpfad
%     cfg.logDatei = fullfile(cfg.logPfad, 'projektlog.txt'); % Vollständiger Pfad zur Protokolldatei
%     cfg.filesPfad = cfg.basisPfad; % Beispiel, wenn filesPfad dem basisPfad entspricht
%     cfg.formatschluesselPfad = fullfile(cfg.basisPfad, 'Formatschlussel')
%     cfg.speicherpfad = cfg.basisPfad; % Kann direkt als Basispfad verwendet werden
% 
%     % Pfade für Excel-Dateien
%     cfg.figurenLogExcelPfad = fullfile(cfg.speicherpfad, 'FigurenLog.xlsx');
%     cfg.ergebnisseExcelPfad = fullfile(cfg.basisPfad, 'testCrossoverResults.xlsx');
%     cfg.elternpaareExcelPfad = fullfile(cfg.basisPfad, 'testWinner2Parents.xlsx');
%     cfg.mutationExcelPfad = fullfile(cfg.basisPfad, 'mutationResults.xlsx');
%     cfg.plusExcelPfad = fullfile(cfg.basisPfad, 'testCrossoverResultPlus.xlsx');
%     cfg.plusExcelPfadTestTunier = fullfile(cfg.basisPfad, 'testTurnierWinner.xlsx');
% 
%     % Spezifische Bildpfade für die Clients
%     cfg.clientAImagePfad = fullfile(cfg.speicherpfad, 'clientA', 'image');
%     cfg.clientBImagePfad = fullfile(cfg.speicherpfad, 'clientB', 'image');
%     cfg.clientCImagePfad = fullfile(cfg.speicherpfad, 'clientC', 'image');
% 
%     % Pfad für das Verzeichnis "schonBewertet" und Bewertungen für Client A
%     cfg.clientASchonBewertetPfad = fullfile(cfg.clientAImagePfad, 'schonBewertet');
%     cfg.clientABewertungPfad = fullfile(cfg.speicherpfad, 'clientA', 'bewertung\');
% 
%     % Pfad für das Verzeichnis "schonBewertet" und Bewertungen für Client B
%     cfg.clientBSchonBewertetPfad = fullfile(cfg.clientBImagePfad, 'schonBewertet');
%     cfg.clientBBewertungPfad = fullfile(cfg.speicherpfad, 'clientB', 'bewertung\');
% 
%     % Pfad für das Verzeichnis "schonBewertet" und Bewertungen für Client C
%     cfg.clientCSchonBewertetPfad = fullfile(cfg.clientCImagePfad, 'schonBewertet');
%     cfg.clientCBewertungPfad = fullfile(cfg.speicherpfad, 'clientC', 'bewertung\');
% 
%     % Konfiguration für den evolutionären Algorithmus
%     cfg.anzahlGenerationen = 4;
%     cfg.konvergenzSchwelle = 0.01;
%     cfg.startRate = 0.8;
%     cfg.endRate = 0.5;
%     cfg.anzahlTurniere = 30;
%     cfg.turnierGroesse = 4;
% 
%     % Initialisierungswinkel für Strichmännchen
%     cfg.winkelArmRechts = 330;
%     cfg.winkelArmLinks = 210;
%     cfg.winkelBeinRechts = 315;
%     cfg.winkelBeinLinks = 225;
% 
%     % Initialisierung von cfg.addPaths als leeres Zell-Array
%     cfg.addPaths = {};
% 
%     % Hinzufügen von Basispfaden zu cfg.addPaths
%     cfg.addPaths = [cfg.addPaths, {fullfile(cfg.wurzelPfad)}];
% 
%     % Dynamische Erzeugung der Client-Pfade und Hinzufügen zu cfg.addPaths
%     clients = {'A', 'B', 'C'};
%     for i = 1:length(clients)
%         clientPath = fullfile(cfg.basisPfad, ['client' clients{i}]);
%         cfg.addPaths = [cfg.addPaths, {clientPath}]; % Hinzufügen als Zelle
% 
%         % Für das Image-Verzeichnis
%         clientImagePath = fullfile(clientPath, 'image\');
%         cfg.(['client' clients{i} 'ImagePfad']) = clientImagePath;
%         cfg.addPaths = [cfg.addPaths, {clientImagePath}]; % Hinzufügen als Zelle
%     end
% end
% 
% % Code ENDs






















% % % % Header START
% % % %
% % % % Zweck: Des Skript oder der Funktion
% % % %
% % % % Skriptname: config.m
% % % % Funktion: FUNCTION_NAME_PLACEHOLDER
% % % %
% % % % Erstellt von: Bernd Schmidt
% % % % Erstelldatum: 19. July 2024
% % % %
% % % % Änderungshistorie:
% % % % Datum: 19. July 2024: Erstellung des Skripts.
% % % %
% % % % Funktionsart: Skript ODER Standalone-Funktion ODER Third-Party Funktion oder Wrapper-Funktion
% % % %               User-Funktion
% % % % Verwendete Funktionen:
% % % % Listung der Helper Funktionen (falls vorhanden)
% % % % Listung der Anonymous-Funktion (falls vorhanden)
% % % % Listung der Callback-Funktion (falls vorhanden) 
% % % % 
% % % % Syntax für die Verwendung:(nur im Falle einer Funktion)
% % % %  
% % % %    Inputs/ Uebergaben:
% % % %
% % % %    Outputs/ Rueckgaben
% % % %
% % % % Beispiele: (für die Verwendung der Funktion)
% % % %
% % % %
% % % % Benutzereingaben: (falls vorhanden)
% % % % Beispiele:
% % % %
% % % % Programmausgaben: (falls vorhanden)
% % % % Beispiele:
% % % %
% % % % Seiteneffekte:(falls vorhanden z.B. erzeugen von globalen Variablen mit
% % % %                Einfluss auf den Rest des Programms)
% % % % Nebeneffekte: (falls vorhanden z.B. schreiben oder lesen von Dateien)
% % % %
% % % % Verwendete Variablen und ihre Datentypen sowie Dimensionen:
% % % %
% % % % Verwendete Parameter und ihre Datentypen sowie Dimensionen:
% % % %
% % % % Verwendete Umgebungsvariablen (falls vorhanden) System:
% % % %
% % % % Hinweise:
% % % %
% % % % Siehe auch:
% % % % Built-In Funktionen: 
% % % % 
% % % % Theorie:
% % % % Berchnung / Algorithmus:
% % % %
% % % % Header END
% % % 
% % % 
% % % % Code STARTs
% % % 
% % % % Umgebungsbereinigung
% % % close all; % Schließt alle offenen Figuren
% % % clear;     % Löscht alle Variablen im Workspace
% % % clc;       % Löscht den Command Window Inhalt
% % % 
% % % % Code 
% % % function cfg = config()   
% % % % C:\Users\bernd\Documents\MALAB\EigMatPrg\proportionen
% % %     % Definieren des Wurzelpfades
% % %     % wurzelPfad = 'C:\Users\bernd\Documents\MALAB\EigMatPrg\proportionen\';
% % %       cfg.wurzelPfad = 'C:\Users\HTW_U\OneDrive\Dokumente\MATLAB\EigMatPrg\proportionen\';
% % %     % D:\MALAB\EigMatPrg\proportionen
% % % 
% % %     % Zusammensetzung des Basispfades aus Wurzelpfad und 'NetzDrive\'
% % %     cfg.basisPfad = fullfile(cfg.wurzelPfad, 'NetzDrive\');
% % % 
% % % 
% % %     % Konfigurationspfade definieren
% % %     cfg.logPfad = fullfile(cfg.wurzelPfad, 'log'); % Log-Pfad direkt unter dem Wurzelpfad
% % %     cfg.logDatei = fullfile(cfg.logPfad, 'programmLog.txt'); % Vollständiger Pfad zur Protokolldatei
% % %         % Definieren des filesPfad
% % %     cfg.filesPfad = cfg.basisPfad; % Beispiel, wenn filesPfad dem basisPfad entspricht
% % %     % Weitere Pfade basierend auf dem Basispfad definieren
% % %     cfg.formatschluesselPfad = fullfile(cfg.basisPfad, 'Formatschlussel');
% % %     cfg.speicherpfad = cfg.basisPfad; % Kann direkt als Basispfad verwendet werden
% % % 
% % % 
% % % cfg.figurenLogExcelPfad = fullfile(cfg.speicherpfad, 'FigurenLog.xlsx');
% % %     % Spezifische Bildpfade für die Clients
% % %     cfg.clientAImagePfad = fullfile(cfg.speicherpfad, 'clientA', 'image');
% % %     cfg.clientBImagePfad = fullfile(cfg.speicherpfad, 'clientB', 'image');
% % %     cfg.clientCImagePfad = fullfile(cfg.speicherpfad, 'clientC', 'image');
% % % 
% % %     % Konfiguration für den evolutionären Algorithmus
% % %     cfg.anzahlGenerationen = 4;
% % %     cfg.konvergenzSchwelle = 0.01;
% % %     cfg.startRate = 0.8;
% % %     cfg.endRate = 0.5;
% % %     cfg.anzahlTurniere = 30;
% % %     cfg.turnierGroesse = 4;
% % % 
% % %     % Initialisierungswinkel für Strichmännchen
% % %     cfg.winkelArmRechts = 330;
% % %     cfg.winkelArmLinks = 210;
% % %     cfg.winkelBeinRechts = 315;
% % %     cfg.winkelBeinLinks = 225;
% % % 
% % %     % Pfad für das Verzeichnis "schonBewertet" für Client A
% % %     cfg.clientASchonBewertetPfad = fullfile(cfg.clientAImagePfad, 'schonBewertet');
% % %     % Pfad für Bewertungen
% % %     cfg.clientABewertungPfad = fullfile(cfg.speicherpfad, 'clientA', 'bewertung\');
% % % 
% % %     % Pfad für das Verzeichnis "schonBewertet" für Client B
% % %     cfg.clientBSchonBewertetPfad = fullfile(cfg.clientBImagePfad, 'schonBewertet');
% % %     % Pfad für Bewertungen
% % %     % cfg.clientBBewertungPfad = fullfile(cfg.clientBImagePfad, '..', 'bewertung')
% % %       cfg.clientBBewertungPfad = fullfile(cfg.speicherpfad, 'clientB', 'bewertung\');
% % % 
% % %     % 
% % %      % Pfad für das Verzeichnis "schonBewertet" für Client C
% % %     cfg.clientCSchonBewertetPfad = fullfile(cfg.clientCImagePfad, 'schonBewertet');
% % %     % Pfad für Bewertungen
% % %     % cfg.clientCBewertungPfad = fullfile(cfg.clientCImagePfad, '..', 'bewertung')
% % %     %%%csvFolderPath = 'D:\MALAB\EigMatPrg\proportionen\NetzDrive\clientA\bewertung\'
% % %       cfg.clientCBewertungPfad = fullfile(cfg.speicherpfad, 'clientC', 'bewertung\');
% % % 
% % % 
% % %     % Beispiel für die Definition weiterer Pfade
% % %     cfg.elternpaareExcelPfad = fullfile(cfg.basisPfad, 'testWinner2Parents.xlsx');
% % %     cfg.mutationExcelPfad = fullfile(cfg.basisPfad, 'mutationResults.xlsx');
% % %     cfg.ergebnisseExcelPfad = fullfile(cfg.basisPfad, 'testCrossoverResults.xlsx');
% % %     cfg.plusExcelPfad = fullfile(cfg.basisPfad, 'testCrossoverResultPlus.xlsx');
% % %     cfg.plusExcelPfadTestTunier = fullfile(cfg.basisPfad, 'testTurnierWinner.xlsx');
% % % 
% % % 
% % % 
% % %  % Initialisierung von cfg.addPaths als leeres Zell-Array
% % %     cfg.addPaths = {};
% % % 
% % %     % Hinzufügen von Basispfaden zu cfg.addPaths
% % %     % cfg.addPaths = [cfg.addPaths, {fullfile('C:\Users\bernd\Documents\MALAB\EigMatPrg\proportionen')}];
% % %     %  cfg.addPaths = [cfg.addPaths, {fullfile('C:\Users\HTW_U\OneDrive\Dokumente\MATLAB\EigMatPrg\proportionen')}];
% % %     cfg.addPaths = [cfg.addPaths, {fullfile(cfg.wurzelPfad)}];
% % % 
% % % 
% % % 
% % %     % D:\MALAB\EigMatPrg\proportionen
% % %     % C:\Users\bernd\Documents\MALAB\EigMatPrg\proportionen
% % %     % Dynamische Erzeugung der Client-Pfade und Hinzufügen zu cfg.addPaths
% % %     clients = {'A', 'B', 'C'};
% % %     for i = 1:length(clients)
% % % % D:\MALAB\EigMatPrg\proportionen\NetzDrive\
% % %         % C:\Users\bernd\Documents\MALAB\EigMatPrg\proportionen\NetzDrive
% % %         % clientPath = fullfile('C:\Users\bernd\Documents\MALAB\EigMatPrg\proportionen\NetzDrive\', ['client' clients{i}]);
% % %         % clientPath = fullfile('C:\Users\HTW_U\OneDrive\Dokumente\MATLAB\EigMatPrg\proportionen\NetzDrive\', ['client' clients{i}]);
% % %         clientPath = fullfile(cfg.basisPfad, ['client' clients{i}]);
% % %         cfg.addPaths = [cfg.addPaths, {clientPath}]; % Hinzufügen als Zelle
% % % 
% % %         % Für das Image-Verzeichnis
% % %         clientImagePath = fullfile(clientPath, 'image\');
% % %         cfg.(['client' clients{i} 'ImagePfad']) = clientImagePath;
% % %         cfg.addPaths = [cfg.addPaths, {clientImagePath}]; % Hinzufügen als Zelle
% % %     end
% % % end
% % % 
% % % % Code ENDs
