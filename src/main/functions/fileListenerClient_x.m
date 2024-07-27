% Header START
%
% Zweck: Dieses Skript überwacht einen bestimmten Ordner auf PNG-Bilder,
% kopiert sie zur weiteren Verarbeitung in ein temporäres Verzeichnis,
% lädt sie zur Bewertung in eine GUI und protokolliert die Bewertungen.
%
% Skriptname: fileListenerClient_x.m
% Funktion: fileListenerClient_x
%
% Erstellt von: Bernd Schmidt
% Erstelldatum: 1. Februar 2024
%
% Änderungshistorie:
% Datum: 1. Februar 2024: Erstellt
% Datum: 28. Februar 2024: Änderungen und Optimierungen
% Datum: 23. Juli 2024: Code umgeschrieben, so dass Funktion auf verteilten Systemen erfüllt ist
% Datum: 23. Juli 2024: Hinzufügen von Fehlerbehandlung und detaillierten Log-Einträgen
% Datum: 23. Juli 2024: Änderung, um Bilder nur zu kopieren, anstatt sie zu verschieben
% Datum: 23. Juli 2024: Änderung, um Bilder nach Bewertung zu verschieben
%
% Funktionsart: Standalone-Funktion
%               User-Funktion
%
% Verwendete Funktionen:
%   - config(): Lädt die Konfigurationsdaten.
%   - logEintrag(logDatei, Nachricht): Protokolliert Nachrichten in der Protokolldatei.
%   - createGUI(folderPath, imageName, logDatei): Erstellt eine GUI zur Bildbewertung.
%   - bewertungCallback(~, ~, folderPath, imageName, feedback, logDatei, fig): Callback-Funktion für die Bewertungsschaltflächen.
%   - writeFeedback(imageName, feedback, logDatei): Schreibt die Bewertung in eine CSV-Datei und verschiebt das Bild.
%
% Syntax für die Verwendung: (nur im Falle einer Funktion)
%   fileListenerClient_x()
%
% Eingaben/ Übergaben: Keine
%
% Outputs/ Rückgaben: Keine
%
% Beispiele: (für die Verwendung der Funktion)
%   - Aufruf der Funktion ohne Eingaben:
%       fileListenerClient_x();
%
% Benutzereingaben: (falls vorhanden)
%   - Interaktive Eingaben über die GUI zur Bewertung der Bilder.
%
% Programmausgaben: (falls vorhanden)
%   - Protokollierte Nachrichten in der Log-Datei.
%
% Seiteneffekte: (falls vorhanden)
%   - Globaler Scope für currentFileIndex.
%
% Nebeneffekte: (falls vorhanden)
%   - Lesen der PNG-Bilder aus dem überwachten Ordner.
%   - Schreiben der Bewertungsdaten in eine CSV-Datei.
%   - Verschieben der bewerteten Bilder in einen anderen Ordner.
%
% Verwendete Variablen und ihre Datentypen sowie Dimensionen:
%   - cfg (struct): Konfigurationsdaten.
%   - logDatei (string): Pfad zur Protokolldatei.
%   - folderPath (string): Pfad zum Bildordner.
%   - files (struct): Informationen über die Dateien im Bildordner.
%   - currentFile (string): Name der aktuellen Bilddatei.
%   - fig (figure handle): Handle der GUI-Figur.
%   - ax (axes handle): Handle der Achsen in der GUI-Figur.
%   - imageName (string): Name der Bilddatei.
%   - feedback (string): Bewertung des Bildes.
%   - csvFolderPath (string): Pfad zum Ordner für die Bewertungsdateien.
%   - csvFileName (string): Name der CSV-Datei.
%   - feedbackTable (table): Tabelle mit den Bewertungsdaten.
%   - sourcePath (string): Quellpfad des Bildes.
%   - destPath (string): Zielpfad des Bildes.
%
% Verwendete Parameter und ihre Datentypen sowie Dimensionen:
%   - Keine spezifischen Parameter, aber Umgebungsvariablen (COMPUTERNAME, USERNAME) werden verwendet.
%
% Hinweise:
%   - Die Funktion verwendet eine Konfigurationsdatei, um Pfade und Einstellungen zu laden.
%   - Es wird erwartet, dass die Konfigurationsdatei gültige Pfade enthält.
%
% Siehe auch:
% Built-In Funktionen:
%   - getenv(): Ruft Umgebungsvariablen ab.
%   - imread(): Liest ein Bild in MATLAB ein.
%   - figure(): Erstellt eine neue GUI-Figur.
%   - uicontrol(): Erstellt UI-Steuerelemente in der GUI.
%   - writetable(): Schreibt eine Tabelle in eine CSV-Datei.
%   - copyfile(): Kopiert eine Datei.
%   - movefile(): Verschiebt eine Datei.
%   - dir(): Listet Dateien in einem Verzeichnis auf.
%   - fullfile(): Erstellt einen vollständigen Dateipfad.
%
% Theorie:
%   - Das Skript implementiert eine einfache Überwachung eines Ordners und eine Benutzeroberfläche zur Bildbewertung.
%
% Berechnung / Algorithmus:
%   - Die Bilder im angegebenen Ordner werden aufgelistet.
%   - Für jedes Bild wird eine GUI zur Bewertung erstellt.
%   - Die Bewertungen werden protokolliert und in einer CSV-Datei gespeichert.
%   - Bewertete Bilder werden in einen anderen Ordner verschoben.
%
% Header END

% Code START

function fileListenerClient_x()
    try
        % Konfigurationsdaten laden
        cfg = config();
        
        % Pfad zur Protokolldatei aus der Konfiguration verwenden
        logDatei = cfg.logDatei;
        folderPath = cfg.clientAImagePfad; 

        files = dir(fullfile(folderPath, '*.png'));

        if isempty(files)
            logEintrag(logDatei, 'Nachricht', 'Keine Bilder gefunden', 'Details', 'Im angegebenen Ordner wurden keine Bilder gefunden.');
            return;
        end

        % Kopieren der Bilder in temp_images zur weiteren Verarbeitung
        tempImagePath = fullfile(cfg.basisPfad, 'temp_images');
        if ~exist(tempImagePath, 'dir')
            mkdir(tempImagePath);
        end
        
        for idx = 1:length(files)
            currentFile = files(idx).name;
            sourceFilePath = fullfile(folderPath, currentFile);
            tempFilePath = fullfile(tempImagePath, currentFile);
            copyfile(sourceFilePath, tempFilePath);
            logEintrag(logDatei, 'Nachricht', 'Bild kopiert', 'Details', sprintf('Bild %s nach %s kopiert', sourceFilePath, tempFilePath));
            
            createGUI(tempImagePath, currentFile, logDatei);
            waitforbuttonpress; % Bleibt unverändert, basierend auf deiner Anweisung
        end
    catch ME
        errorMsg = sprintf('Fehler in fileListenerClient_x.m: %s', ME.message);
        disp(errorMsg);
        logEintrag(logDatei, 'Fehler', errorMsg);
    end
end


function createGUI(folderPath, imageName, logDatei)
    try
        % Rechner- und Benutzernamen abrufen
        computerName = getenv('COMPUTERNAME');
        userName = getenv('USERNAME');

        img = imread(fullfile(folderPath, imageName));
        % Fenstertitel mit Rechnername, Benutzername und "CL_A" setzen
        fig = figure('Name', sprintf('Bildbewertung - %s - %s - CL_A', computerName, userName), 'NumberTitle', 'off', 'WindowState', 'maximized');
        ax = axes('Parent', fig, 'Position', [0.1, 0.3, 0.8, 0.6]);
        imshow(img, 'Parent', ax);

        % Protokollieren, dass das Bild geladen und angezeigt wird, inklusive Rechner- und Benutzernamen
        logMessage = sprintf('Bild %s geladen und zur Bewertung angezeigt von %s auf %s.', imageName, userName, computerName);
        logEintrag(logDatei, 'Nachricht', logMessage);

        % Buttons für die Bewertung
        uicontrol('Parent', fig, 'Style', 'pushbutton', 'String', 'Ästhetisch', 'Position', [100, 50, 100, 30], 'Callback', {@bewertungCallback, folderPath, imageName, 'ästhetisch', logDatei, fig});
        logMessage = sprintf('Bewertungsbutton "Ästhetisch" erstellt von %s auf %s.', userName, computerName);
        logEintrag(logDatei, 'Nachricht', logMessage);

        uicontrol('Parent', fig, 'Style', 'pushbutton', 'String', 'Unästhetisch', 'Position', [210, 50, 100, 30], 'Callback', {@bewertungCallback, folderPath, imageName, 'unästhetisch', logDatei, fig});
        logMessage = sprintf('Bewertungsbutton "Unästhetisch" erstellt von %s auf %s.', userName, computerName);
        logEintrag(logDatei, 'Nachricht', logMessage);
        
    catch ME
        errorMsg = sprintf('Fehler in createGUI.m: %s', ME.message);
        disp(errorMsg);
        logEintrag(logDatei, 'Fehler', errorMsg);
    end
end

function bewertungCallback(~, ~, folderPath, imageName, feedback, logDatei, fig)
    try
        % Callback-Funktion für die Bewertungsschaltflächen.
        writeFeedback(imageName, feedback, logDatei);
        % Protokollieren des Schließens des Bewertungsfensters
        logMessage = sprintf('Bewertungsfenster für %s wird geschlossen.', imageName);
        logEintrag(logDatei, 'Nachricht', logMessage);
        close(fig); % Schließt die GUI nach der Bewertung
        
    catch ME
        errorMsg = sprintf('Fehler in bewertungCallback.m: %s', ME.message);
        disp(errorMsg);
        logEintrag(logDatei, 'Fehler', errorMsg);
    end
end

function writeFeedback(imageName, feedback, logDatei)
    try
        cfg = config(); % Konfiguration laden
        computerName = getenv('COMPUTERNAME'); % Für Windows
        userName = getenv('USERNAME'); % Für Windows
        feedbackNum = strcmp(feedback, 'ästhetisch'); % Konvertiert das Feedback in einen numerischen Wert
        
        % Lokaler Speicherpfad
        csvFolderPathLocal = cfg.clientABewertungPfad;
        csvFileNameLocal = sprintf('BeWe_%s_%s_%s.csv', computerName, userName, 'Instanz_A'); % Dateiname für Client A
        csvFilePathLocal = fullfile(csvFolderPathLocal, csvFileNameLocal); % Vollständiger Pfad zur CSV-Datei

        % Netzwerk Speicherpfad
        csvFolderPathNetwork = cfg.netzwerkBewertungPfad;
        csvFileNameNetwork = sprintf('BeWe_%s_%s_%s.csv', computerName, userName, 'Instanz_A'); % Dateiname für Client A
        csvFilePathNetwork = fullfile(csvFolderPathNetwork, csvFileNameNetwork); % Vollständiger Pfad zur CSV-Datei

        % Erstellt das lokale Verzeichnis, falls nicht vorhanden
        if ~exist(csvFolderPathLocal, 'dir')
            mkdir(csvFolderPathLocal);
        end

        % Erstellt das Netzwerkverzeichnis, falls nicht vorhanden
        if ~exist(csvFolderPathNetwork, 'dir')
            mkdir(csvFolderPathNetwork);
        end

        imageName = erase(imageName, '.png'); % Entfernen der Dateiendung '.png'

        % Erstellt eine Tabelle für das Feedback
        feedbackTable = table({imageName}, {'Instanz_A'}, {computerName}, {userName}, feedbackNum, ...
                              'VariableNames', {'Bildname', 'Instanz', 'Rechner', 'Benutzer', 'Bewertung'});

        % Schreibt das Feedback in die lokale CSV-Datei
        if exist(csvFilePathLocal, 'file')
            writetable(feedbackTable, csvFilePathLocal, 'WriteMode', 'append', 'Delimiter', ',', 'WriteVariableNames', false);
        else
            writetable(feedbackTable, csvFilePathLocal, 'Delimiter', ',');
        end

        % Schreibt das Feedback in die Netzwerk-CSV-Datei
        if exist(csvFilePathNetwork, 'file')
            writetable(feedbackTable, csvFilePathNetwork, 'WriteMode', 'append', 'Delimiter', ',', 'WriteVariableNames', false);
        else
            writetable(feedbackTable, csvFilePathNetwork, 'Delimiter', ',');
        end

        % Protokollieren des geschriebenen Feedbacks und des Dateipfades
        logMessage = sprintf('Feedback für %s: %s von %s auf %s.', imageName, feedback, userName, computerName);
        logEintrag(logDatei, 'Nachricht', logMessage);

        % Verwenden des Bild- und schonBewertet-Pfades aus der Konfiguration
        sourcePath = fullfile(cfg.clientAImagePfad, [imageName, '.png']);
        destPath = fullfile(cfg.clientASchonBewertetPfad, [imageName, '.png']);
        copyfile(sourcePath, destPath); % Ändern von movefile zu copyfile
        logMessage = sprintf('Bild %s nach %s kopiert.', sourcePath, destPath);
        logEintrag(logDatei, 'Nachricht', logMessage);

    catch ME
        errorMsg = sprintf('Fehler in writeFeedback.m: %s', ME.message);
        disp(errorMsg);
        logEintrag(logDatei, 'Fehler', errorMsg);
    end
end




% Code ENDs





%%%%%%%%%%%%%%%%%%%%%%
% % % % Header START
% % % %
% % % % Zweck: Dieses Skript überwacht einen bestimmten Ordner auf PNG-Bilder, lädt sie zur Bewertung in eine GUI und protokolliert die Bewertungen.
% % % %
% % % % Skriptname: fileListenerClient_x.m
% % % % Funktion: fileListenerClient_x
% % % %
% % % % Erstellt von: Bernd Schmidt
% % % % Erstelldatum: 1. ‎Februar ‎2024
% % % %
% % % % Änderungshistorie:
% % % % Datum: 1. ‎Februar ‎2024: Erstellt
% % % % Datum: 28. ‎Februar ‎2024: 
% % % % Datum: 18. Juli 2024: Header hinzugefügt.
% % % % Datum: 23. Juli 2024: Code umgeschrieben, so dass Funktion auf verteilten Systemen erfüllt ist.
% % % % Datum: 23. Juli 2024: Fehlerbehandlung und detaillierte Logeinträge hinzugefügt.
% % % %
% % % % Funktionsart: Standalone-Funktion
% % % %               User-Funktion
% % % %
% % % % Verwendete Funktionen:
% % % % Listung der Helper Funktionen:
% % % %   - config(): Lädt die Konfigurationsdaten.
% % % %   - logEintrag(logDatei, Nachricht): Protokolliert Nachrichten in der Protokolldatei.
% % % %   - createGUI(folderPath, imageName, logDatei): Erstellt eine GUI zur Bildbewertung.
% % % %   - bewertungCallback(~, ~, folderPath, imageName, feedback, logDatei, fig): Callback-Funktion für die Bewertungsschaltflächen.
% % % %   - writeFeedback(imageName, feedback, logDatei): Schreibt die Bewertung in eine CSV-Datei und verschiebt das Bild.
% % % %
% % % % Listung der Anonymous-Funktion: Keine vorhanden
% % % % Listung der Callback-Funktion:
% % % %   - bewertungCallback: Wird aufgerufen, wenn ein Bewertungsbutton in der GUI gedrückt wird.
% % % %
% % % % Syntax für die Verwendung: (nur im Falle einer Funktion)
% % % %   fileListenerClient_x()
% % % %
% % % %    Inputs/ Übergaben: Keine
% % % %
% % % %    Outputs/ Rückgaben: Keine
% % % %
% % % % Beispiele: (für die Verwendung der Funktion)
% % % %   - Aufruf der Funktion ohne Eingaben:
% % % %       fileListenerClient_x();
% % % %
% % % % Benutzereingaben: (falls vorhanden)
% % % %   - Interaktive Eingaben über die GUI zur Bewertung der Bilder.
% % % %
% % % % Programmausgaben: (falls vorhanden)
% % % %   - Protokollierte Nachrichten in der Log-Datei.
% % % %
% % % % Seiteneffekte: (falls vorhanden z.B. erzeugen von globalen Variablen mit Einfluss auf den Rest des Programms)
% % % %   - Globaler Scope für currentFileIndex.
% % % %
% % % % Nebeneffekte: (falls vorhanden z.B. schreiben oder lesen von Dateien)
% % % %   - Lesen der PNG-Bilder aus dem überwachten Ordner.
% % % %   - Schreiben der Bewertungsdaten in eine CSV-Datei.
% % % %   - Verschieben der bewerteten Bilder in einen anderen Ordner.
% % % %
% % % % Verwendete Variablen und ihre Datentypen sowie Dimensionen:
% % % %   - cfg (struct): Konfigurationsdaten.
% % % %   - logDatei (string): Pfad zur Protokolldatei.
% % % %   - folderPath (string): Pfad zum Bildordner.
% % % %   - files (struct): Informationen über die Dateien im Bildordner.
% % % %   - currentFile (string): Name der aktuellen Bilddatei.
% % % %   - fig (figure handle): Handle der GUI-Figur.
% % % %   - ax (axes handle): Handle der Achsen in der GUI-Figur.
% % % %   - imageName (string): Name der Bilddatei.
% % % %   - feedback (string): Bewertung des Bildes.
% % % %   - csvFolderPath (string): Pfad zum Ordner für die Bewertungsdateien.
% % % %   - csvFileName (string): Name der CSV-Datei.
% % % %   - feedbackTable (table): Tabelle mit den Bewertungsdaten.
% % % %   - sourcePath (string): Quellpfad des Bildes.
% % % %   - destPath (string): Zielpfad des Bildes.
% % % %
% % % % Verwendete Parameter und ihre Datentypen sowie Dimensionen:
% % % %   - Keine spezifischen Parameter, aber Umgebungsvariablen (COMPUTERNAME, USERNAME) werden verwendet.
% % % %
% % % % Hinweise:
% % % %   - Die Funktion verwendet eine Konfigurationsdatei, um Pfade und Einstellungen zu laden.
% % % %   - Es wird erwartet, dass die Konfigurationsdatei gültige Pfade enthält.
% % % %
% % % % Siehe auch:
% % % % Built-In Funktionen:
% % % %   - getenv(): Ruft Umgebungsvariablen ab.
% % % %   - imread(): Liest ein Bild in MATLAB ein.
% % % %   - figure(): Erstellt eine neue GUI-Figur.
% % % %   - uicontrol(): Erstellt UI-Steuerelemente in der GUI.
% % % %   - writetable(): Schreibt eine Tabelle in eine CSV-Datei.
% % % %   - movefile(): Verschiebt eine Datei.
% % % %   - dir(): Listet Dateien in einem Verzeichnis auf.
% % % %   - fullfile(): Erstellt einen vollständigen Dateipfad.
% % % %
% % % % Theorie:
% % % %   - Das Skript implementiert eine einfache Überwachung eines Ordners und eine Benutzeroberfläche zur Bildbewertung.
% % % %
% % % % Berechnung / Algorithmus:
% % % %   - Die Bilder im angegebenen Ordner werden aufgelistet.
% % % %   - Für jedes Bild wird eine GUI zur Bewertung erstellt.
% % % %   - Die Bewertungen werden protokolliert und in einer CSV-Datei gespeichert.
% % % %   - Bewertete Bilder werden in einen anderen Ordner verschoben.
% % % %
% % % % Header END
% % % 
% % % % Code START
% % % 
% % % function fileListenerClient_x()
% % %     try
% % %         % Konfigurationsdaten laden
% % %         cfg = config();
% % % 
% % %         % Pfad zur Protokolldatei aus der Konfiguration verwenden
% % %         logDatei = cfg.logDatei;
% % %         folderPath = cfg.clientAImagePfad; 
% % % 
% % %         files = dir(fullfile(folderPath, '*.png'));
% % % 
% % %         if isempty(files)
% % %             logEintrag(logDatei, 'Nachricht', 'Keine Bilder gefunden', 'Details', 'Im angegebenen Ordner wurden keine Bilder gefunden.');
% % %             return;
% % %         end
% % % 
% % %         for idx = 1:length(files)
% % %             currentFile = files(idx).name;
% % %             createGUI(folderPath, currentFile, logDatei);
% % %             waitforbuttonpress; % Bleibt unverändert, basierend auf deiner Anweisung
% % %         end
% % %     catch ME
% % %         errorMsg = sprintf('Fehler in fileListenerClient_x.m: %s', ME.message);
% % %         disp(errorMsg);
% % %         logEintrag(logDatei, 'Fehler', errorMsg);
% % %     end
% % % end
% % % 
% % % 
% % % function createGUI(folderPath, imageName, logDatei)
% % %     try
% % %         % Rechner- und Benutzernamen abrufen
% % %         computerName = getenv('COMPUTERNAME');
% % %         userName = getenv('USERNAME');
% % % 
% % %         img = imread(fullfile(folderPath, imageName));
% % %         % Fenstertitel mit Rechnername, Benutzername und "CL_A" setzen
% % %         fig = figure('Name', sprintf('Bildbewertung - %s - %s - CL_A', computerName, userName), 'NumberTitle', 'off', 'WindowState', 'maximized');
% % %         ax = axes('Parent', fig, 'Position', [0.1, 0.3, 0.8, 0.6]);
% % %         imshow(img, 'Parent', ax);
% % % 
% % %         % Protokollieren, dass das Bild geladen und angezeigt wird, inklusive Rechner- und Benutzernamen
% % %         logMessage = sprintf('Bild %s geladen und zur Bewertung angezeigt von %s auf %s.', imageName, userName, computerName);
% % %         logEintrag(logDatei, 'Nachricht', logMessage);
% % % 
% % %         % Buttons für die Bewertung
% % %         uicontrol('Parent', fig, 'Style', 'pushbutton', 'String', 'Ästhetisch', 'Position', [100, 50, 100, 30], 'Callback', {@bewertungCallback, folderPath, imageName, 'ästhetisch', logDatei, fig});
% % %         logMessage = sprintf('Bewertungsbutton "Ästhetisch" erstellt von %s auf %s.', userName, computerName);
% % %         logEintrag(logDatei, 'Nachricht', logMessage);
% % % 
% % %         uicontrol('Parent', fig, 'Style', 'pushbutton', 'String', 'Unästhetisch', 'Position', [210, 50, 100, 30], 'Callback', {@bewertungCallback, folderPath, imageName, 'unästhetisch', logDatei, fig});
% % %         logMessage = sprintf('Bewertungsbutton "Unästhetisch" erstellt von %s auf %s.', userName, computerName);
% % %         logEintrag(logDatei, 'Nachricht', logMessage);
% % % 
% % %     catch ME
% % %         errorMsg = sprintf('Fehler in createGUI.m: %s', ME.message);
% % %         disp(errorMsg);
% % %         logEintrag(logDatei, 'Fehler', errorMsg);
% % %     end
% % % end
% % % 
% % % function bewertungCallback(~, ~, folderPath, imageName, feedback, logDatei, fig)
% % %     try
% % %         % Callback-Funktion für die Bewertungsschaltflächen.
% % %         writeFeedback(imageName, feedback, logDatei);
% % %         % Protokollieren des Schließens des Bewertungsfensters
% % %         logMessage = sprintf('Bewertungsfenster für %s wird geschlossen.', imageName);
% % %         logEintrag(logDatei, 'Nachricht', logMessage);
% % %         close(fig); % Schließt die GUI nach der Bewertung
% % % 
% % %     catch ME
% % %         errorMsg = sprintf('Fehler in bewertungCallback.m: %s', ME.message);
% % %         disp(errorMsg);
% % %         logEintrag(logDatei, 'Fehler', errorMsg);
% % %     end
% % % end
% % % 
% % % function writeFeedback(imageName, feedback, logDatei)
% % %     try
% % %         cfg = config(); % Konfiguration laden
% % %         global currentFileIndex; % Stellt sicher, dass currentFileIndex im globalen Scope definiert ist
% % %         computerName = getenv('COMPUTERNAME'); % Für Windows
% % %         userName = getenv('USERNAME'); % Für Windows
% % %         feedbackNum = strcmp(feedback, 'ästhetisch'); % Konvertiert das Feedback in einen numerischen Wert
% % %         csvFolderPath = cfg.clientABewertungPfad; 
% % %         csvFileName = sprintf('BeWe_%s_%s.csv', computerName, 'Instanz_A'); % Dateiname für Client A
% % %         csvFilePath = fullfile(csvFolderPath, csvFileName); % Vollständiger Pfad zur CSV-Datei
% % % 
% % %         if ~exist(csvFolderPath, 'dir')
% % %             mkdir(csvFolderPath); % Erstellt den Ordner, falls nicht vorhanden
% % %         end
% % % 
% % %         imageName = erase(imageName, '.png'); % Entfernen der Dateiendung '.png'
% % % 
% % %         % Erstellt eine Tabelle für das Feedback
% % %         feedbackTable = table({imageName}, {'Instanz_A'}, {computerName}, {userName}, feedbackNum, ...
% % %                               'VariableNames', {'Bildname', 'Instanz', 'Rechner', 'Benutzer', 'Bewertung'});
% % % 
% % %         % Schreibt das Feedback in die CSV-Datei
% % %         if exist(csvFilePath, 'file')
% % %             writetable(feedbackTable, csvFilePath, 'WriteMode', 'append', 'Delimiter', ',', 'WriteVariableNames', false);
% % %         else
% % %             writetable(feedbackTable, csvFilePath, 'Delimiter', ',');
% % %         end
% % % 
% % %         % Protokollieren des geschriebenen Feedbacks und des Dateipfades
% % %         logMessage = sprintf('Feedback für %s: %s von %s auf %s mit currentFileIndex %d.', imageName, feedback, userName, computerName, currentFileIndex);
% % %         logEintrag(logDatei, 'Nachricht', logMessage);
% % % 
% % %         % Verwenden des Bild- und schonBewertet-Pfades aus der Konfiguration
% % %         sourcePath = fullfile(cfg.clientAImagePfad, [imageName, '.png']);
% % %         destPath = fullfile(cfg.clientASchonBewertetPfad, [imageName, '.png']);
% % %         movefile(sourcePath, destPath);                                                                                       
% % %         logMessage = sprintf('Bild %s nach %s verschoben.', sourcePath, destPath);
% % %         logEintrag(logDatei, 'Nachricht', logMessage);
% % % 
% % %     catch ME
% % %         errorMsg = sprintf('Fehler in writeFeedback.m: %s', ME.message);
% % %         disp(errorMsg);
% % %         logEintrag(logDatei, 'Fehler', errorMsg);
% % %     end
% % % end





%%%%%%%%%%%%%%%%%%%%%%%%
% % % Header START
% % %
% % % Zweck: Dieses Skript überwacht einen bestimmten Ordner auf PNG-Bilder,
% % % lädt sie zur Bewertung in eine GUI und protokolliert die Bewertungen.
% % %
% % % Skriptname: fileListenerClient_x.m
% % % Funktion: fileListenerClient_x
% % %
% % % Erstellt von: Bernd Schmidt
% % % Erstelldatum: 1. Februar 2024
% % %
% % % Änderungshistorie:
% % % Datum: 1. Februar 2024: Erstellt
% % % Datum: 28. Februar 2024: 
% % % Datum: 18. Juli 2024: Header hinzugefügt.
% % % Datum: 23. Juli 2024: Code umgeschrieben, so dass Funktion auf
% % %                       verteileten Systemen erfüllt ist.
% % %
% % % Funktionsart: Standalone-Funktion
% % %               User-Funktion
% % %
% % % Verwendete Funktionen:
% % % Listung der Helper Funktionen:
% % %   - config(): Lädt die Konfigurationsdaten.
% % %   - logEintrag(logDatei, Nachricht): Protokolliert Nachrichten in der Protokolldatei.
% % %   - createGUI(folderPath, imageName, logDatei): Erstellt eine GUI zur Bildbewertung.
% % %   - bewertungCallback(~, ~, folderPath, imageName, feedback, logDatei, fig): Callback-Funktion für die Bewertungsschaltflächen.
% % %   - writeFeedback(imageName, feedback, logDatei): Schreibt die Bewertung in eine CSV-Datei und verschiebt das Bild.
% % %
% % % Listung der Anonymous-Funktion: (Keine vorhanden)
% % % Listung der Callback-Funktion:
% % %   - bewertungCallback: Wird aufgerufen, wenn ein Bewertungsbutton in der GUI gedrückt wird.
% % %
% % % Syntax für die Verwendung: (nur im Falle einer Funktion)
% % %   fileListenerClient_x()
% % %
% % %    Inputs/ Übergaben: Keine
% % %
% % %    Outputs/ Rückgaben: Keine
% % %
% % % Beispiele: (für die Verwendung der Funktion)
% % %   - Aufruf der Funktion ohne Eingaben:
% % %       fileListenerClient_x();
% % %
% % % Benutzereingaben: (falls vorhanden)
% % %   - Interaktive Eingaben über die GUI zur Bewertung der Bilder.
% % %
% % % Programmausgaben: (falls vorhanden)
% % %   - Protokollierte Nachrichten in der Log-Datei.
% % %
% % % Seiteneffekte: (falls vorhanden z.B. erzeugen von globalen Variablen mit
% % %                Einfluss auf den Rest des Programms)
% % %   - Globaler Scope für currentFileIndex.
% % %
% % % Nebeneffekte: (falls vorhanden z.B. schreiben oder lesen von Dateien)
% % %   - Lesen der PNG-Bilder aus dem überwachten Ordner.
% % %   - Schreiben der Bewertungsdaten in eine CSV-Datei.
% % %   - Verschieben der bewerteten Bilder in einen anderen Ordner.
% % %
% % % Verwendete Variablen und ihre Datentypen sowie Dimensionen:
% % %   - cfg (struct): Konfigurationsdaten.
% % %   - logDatei (string): Pfad zur Protokolldatei.
% % %   - folderPath (string): Pfad zum Bildordner.
% % %   - files (struct): Informationen über die Dateien im Bildordner.
% % %   - currentFile (string): Name der aktuellen Bilddatei.
% % %   - fig (figure handle): Handle der GUI-Figur.
% % %   - ax (axes handle): Handle der Achsen in der GUI-Figur.
% % %   - imageName (string): Name der Bilddatei.
% % %   - feedback (string): Bewertung des Bildes.
% % %   - csvFolderPath (string): Pfad zum Ordner für die Bewertungsdateien.
% % %   - csvFileName (string): Name der CSV-Datei.
% % %   - feedbackTable (table): Tabelle mit den Bewertungsdaten.
% % %   - sourcePath (string): Quellpfad des Bildes.
% % %   - destPath (string): Zielpfad des Bildes.
% % %
% % % Verwendete Parameter und ihre Datentypen sowie Dimensionen:
% % %   - Keine spezifischen Parameter, aber Umgebungsvariablen (COMPUTERNAME, USERNAME) werden verwendet.
% % %
% % % Hinweise:
% % %   - Die Funktion verwendet eine Konfigurationsdatei, um Pfade und Einstellungen zu laden.
% % %   - Es wird erwartet, dass die Konfigurationsdatei gültige Pfade enthält.
% % %
% % % Siehe auch:
% % % Built-In Funktionen:
% % %   - getenv(): Ruft Umgebungsvariablen ab.
% % %   - imread(): Liest ein Bild in MATLAB ein.
% % %   - figure(): Erstellt eine neue GUI-Figur.
% % %   - uicontrol(): Erstellt UI-Steuerelemente in der GUI.
% % %   - writetable(): Schreibt eine Tabelle in eine CSV-Datei.
% % %   - movefile(): Verschiebt eine Datei.
% % %   - dir(): Listet Dateien in einem Verzeichnis auf.
% % %   - fullfile(): Erstellt einen vollständigen Dateipfad.
% % %
% % % Theorie:
% % %   - Das Skript implementiert eine einfache Überwachung eines Ordners und eine Benutzeroberfläche zur Bildbewertung.
% % %
% % % Berechnung / Algorithmus:
% % %   - Die Bilder im angegebenen Ordner werden aufgelistet.
% % %   - Für jedes Bild wird eine GUI zur Bewertung erstellt.
% % %   - Die Bewertungen werden protokolliert und in einer CSV-Datei gespeichert.
% % %   - Bewertete Bilder werden in einen anderen Ordner verschoben.
% % %
% % % Header END
% % 
% % % Code STARTsfunction fileListenerClient_x()
% %     % Konfigurationsdaten laden
% %     cfg = config();
% % 
% %     % Pfad zur Protokolldatei aus der Konfiguration verwenden
% %     logDatei = cfg.logDatei;
% %     folderPath = cfg.clientAImagePfad; 
% % 
% %     files = dir(fullfile(folderPath, '*.png'));
% % 
% %     if isempty(files)
% %         logEintrag(logDatei, 'Nachricht', 'Keine Bilder gefunden', 'Details', 'Im angegebenen Ordner wurden keine Bilder gefunden.');
% %         return;
% %     end
% % 
% %     for idx = 1:length(files)
% %         currentFile = files(idx).name;
% %         createGUI(folderPath, currentFile, logDatei);
% %         waitforbuttonpress; % Bleibt unverändert, basierend auf deiner Anweisung
% %     end
% % 
% % 
% % function createGUI(folderPath, imageName, logDatei)
% %     % Rechner- und Benutzernamen abrufen
% %     computerName = getenv('COMPUTERNAME');
% %     userName = getenv('USERNAME');
% % 
% %     img = imread(fullfile(folderPath, imageName));
% %     % Fenstertitel mit Rechnername, Benutzername und "CL_A" setzen
% %     fig = figure('Name', sprintf('Bildbewertung - %s - %s - CL_A', computerName, userName), 'NumberTitle', 'off', 'WindowState', 'maximized');
% %     ax = axes('Parent', fig, 'Position', [0.1, 0.3, 0.8, 0.6]);
% %     imshow(img, 'Parent', ax);
% % 
% %     % Protokollieren, dass das Bild geladen und angezeigt wird, inklusive Rechner- und Benutzernamen
% %     logMessage = sprintf('Bild %s geladen und zur Bewertung angezeigt von %s auf %s.', imageName, userName, computerName);
% %     logEintrag(logDatei, 'Nachricht', logMessage);
% % 
% %     % Buttons für die Bewertung
% %     uicontrol('Parent', fig, 'Style', 'pushbutton', 'String', 'Ästhetisch', 'Position', [100, 50, 100, 30], 'Callback', {@bewertungCallback, folderPath, imageName, 'ästhetisch', logDatei, fig});
% %     logMessage = sprintf('Bewertungsbutton "Ästhetisch" erstellt von %s auf %s.', userName, computerName);
% %     logEintrag(logDatei, 'Nachricht', logMessage);
% % 
% %     uicontrol('Parent', fig, 'Style', 'pushbutton', 'String', 'Unästhetisch', 'Position', [210, 50, 100, 30], 'Callback', {@bewertungCallback, folderPath, imageName, 'unästhetisch', logDatei, fig});
% %     logMessage = sprintf('Bewertungsbutton "Unästhetisch" erstellt von %s auf %s.', userName, computerName);
% %     logEintrag(logDatei, 'Nachricht', logMessage);
% % end
% % 
% % function bewertungCallback(~, ~, folderPath, imageName, feedback, logDatei, fig)
% %     % Callback-Funktion für die Bewertungsschaltflächen.
% %     writeFeedback(imageName, feedback, logDatei);
% %     % Protokollieren des Schließens des Bewertungsfensters
% %     logMessage = sprintf('Bewertungsfenster für %s wird geschlossen.', imageName);
% %     logEintrag(logDatei, 'Nachricht', logMessage);
% %     close(fig); % Schließt die GUI nach der Bewertung
% % end
% % 
% % function writeFeedback(imageName, feedback, logDatei)
% %     cfg = config(); % Konfiguration laden
% %     global currentFileIndex; % Stellt sicher, dass currentFileIndex im globalen Scope definiert ist
% %     computerName = getenv('COMPUTERNAME'); % Für Windows
% %     userName = getenv('USERNAME'); % Für Windows
% %     feedbackNum = strcmp(feedback, 'ästhetisch'); % Konvertiert das Feedback in einen numerischen Wert
% %     csvFolderPath = cfg.clientABewertungPfad; 
% %     csvFileName = fullfile(csvFolderPath, sprintf('bewertungBeWe_%s_Instanz_A.csv', computerName)); % Dateiname für Client A
% % 
% %     if ~exist(csvFolderPath, 'dir')
% %         mkdir(csvFolderPath); % Erstellt den Ordner, falls nicht vorhanden
% %     end
% % 
% %     imageName = erase(imageName, '.png'); % Entfernen der Dateiendung '.png'
% % 
% %     % Erstellt eine Tabelle für das Feedback
% %     feedbackTable = table({imageName}, {'Instanz_A'}, {computerName}, {userName}, feedbackNum, ...
% %                           'VariableNames', {'Bildname', 'Instanz', 'Rechner', 'Benutzer', 'Bewertung'});
% % 
% %     % Schreibt das Feedback in die CSV-Datei
% %     if exist(csvFileName, 'file')
% %         writetable(feedbackTable, csvFileName, 'WriteMode', 'append', 'Delimiter', ',', 'WriteVariableNames', false);
% %     else
% %         writetable(feedbackTable, csvFileName, 'Delimiter', ',');
% %     end
% % 
% %     % Protokollieren des geschriebenen Feedbacks und des Dateipfades
% %     logMessage = sprintf('Feedback für %s: %s von %s auf %s mit currentFileIndex %d.', imageName, feedback, userName, computerName, currentFileIndex);
% %     logEintrag(logDatei, 'Nachricht', logMessage);
% % 
% %     % Verwenden des Bild- und schonBewertet-Pfades aus der Konfiguration
% %     sourcePath = fullfile(cfg.clientAImagePfad, [imageName, '.png']);
% %     destPath = fullfile(cfg.clientASchonBewertetPfad, [imageName, '.png']);
% %     movefile(sourcePath, destPath);                                                                                       
% %     logMessage = sprintf('Bild %s nach %s verschoben.', sourcePath, destPath);
% %     logEintrag(logDatei, 'Nachricht', logMessage);
% % end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function fileListenerClient_x()
%     % Konfigurationsdaten laden
%     cfg = config();
% 
%     % Pfad zur Protokolldatei aus der Konfiguration verwenden
%     logDatei = cfg.logDatei;
%     % folderPath = fullfile(cfg.filesPfad, 'clientA', 'image\');
%     folderPath = cfg.clientAImagePfad; 
% 
%     files = dir(fullfile(folderPath, '*.png'));
% 
%     if isempty(files)
%         logEintrag(logDatei, 'Nachricht', 'Keine Bilder gefunden', 'Details', 'Im angegebenen Ordner wurden keine Bilder gefunden.');
%         return;
%     end
% 
%     for idx = 1:length(files)
%         currentFile = files(idx).name;
%         createGUI(folderPath, currentFile, logDatei);
%         waitforbuttonpress; % Bleibt unverändert, basierend auf deiner Anweisung
%     end
% end
% 
% 
% function createGUI(folderPath, imageName, logDatei)
%     % Rechner- und Benutzernamen abrufen
%     computerName = getenv('COMPUTERNAME');
%     userName = getenv('USERNAME');
% 
%     img = imread(fullfile(folderPath, imageName));
%     % Fenstertitel mit Rechnername, Benutzername und "CL_A" setzen
%     fig = figure('Name', sprintf('Bildbewertung - %s - %s - CL_A', computerName, userName), 'NumberTitle', 'off', 'WindowState', 'maximized');
%     ax = axes('Parent', fig, 'Position', [0.1, 0.3, 0.8, 0.6]);
%     imshow(img, 'Parent', ax);
% 
%     % Protokollieren, dass das Bild geladen und angezeigt wird, inklusive Rechner- und Benutzernamen
%     logMessage = sprintf('Bild %s geladen und zur Bewertung angezeigt von %s auf %s.', imageName, userName, computerName);
%     logEintrag(logDatei, 'Nachricht', logMessage);
% 
%     % Buttons für die Bewertung
%     uicontrol('Parent', fig, 'Style', 'pushbutton', 'String', 'Ästhetisch', 'Position', [100, 50, 100, 30], 'Callback', {@bewertungCallback, folderPath, imageName, 'ästhetisch', logDatei, fig});
%     logMessage = sprintf('Bewertungsbutton "Ästhetisch" erstellt von %s auf %s.', userName, computerName);
%     logEintrag(logDatei, 'Nachricht', logMessage);
% 
%     uicontrol('Parent', fig, 'Style', 'pushbutton', 'String', 'Unästhetisch', 'Position', [210, 50, 100, 30], 'Callback', {@bewertungCallback, folderPath, imageName, 'unästhetisch', logDatei, fig});
%     logMessage = sprintf('Bewertungsbutton "Unästhetisch" erstellt von %s auf %s.', userName, computerName);
%     logEintrag(logDatei, 'Nachricht', logMessage);
% end
% 
% function bewertungCallback(~, ~, folderPath, imageName, feedback, logDatei, fig)
%     % Callback-Funktion für die Bewertungsschaltflächen.
%     writeFeedback(imageName, feedback, logDatei);
%     % Protokollieren des Schließens des Bewertungsfensters
%     logMessage = sprintf('Bewertungsfenster für %s wird geschlossen.', imageName);
%     logEintrag(logDatei, 'Nachricht', logMessage);
%     close(fig); % Schließt die GUI nach der Bewertung
% end
% 
% function writeFeedback(imageName, feedback, logDatei)
%     cfg = config(); % Konfiguration laden
%     global currentFileIndex; % Stellt sicher, dass currentFileIndex im globalen Scope definiert ist
%     computerName = getenv('COMPUTERNAME'); % Für Windows
%     userName = getenv('USERNAME'); % Für Windows
%     feedbackNum = strcmp(feedback, 'ästhetisch'); % Konvertiert das Feedback in einen numerischen Wert
%     % csvFolderPath = 'D:\MALAB\EigMatPrg\proportionen\NetzDrive\clientA\bewertung\'; % Pfad für Client A
%     csvFolderPath = cfg.clientABewertungPfad; 
%     csvFileName = sprintf('%sBeWe_%s_%s.csv', csvFolderPath, computerName, 'Instanz_A'); % Dateiname für Client A
% 
%     if ~exist(csvFolderPath, 'dir')
%         mkdir(csvFolderPath); % Erstellt den Ordner, falls nicht vorhanden
%     end
% 
%     imageName = erase(imageName, '.png'); % Entfernen der Dateiendung '.png'
% 
%     % Erstellt eine Tabelle für das Feedback
%     feedbackTable = table({imageName}, {'Instanz_A'}, {computerName}, {userName}, feedbackNum, ...
%                           'VariableNames', {'Bildname', 'Instanz', 'Rechner', 'Benutzer', 'Bewertung'});
% 
%     % Schreibt das Feedback in die CSV-Datei
%     if exist(csvFileName, 'file')
%         writetable(feedbackTable, csvFileName, 'WriteMode', 'append', 'Delimiter', ',', 'WriteVariableNames', false);
%     else
%         writetable(feedbackTable, csvFileName, 'Delimiter', ',');
%     end
% 
%     % Protokollieren des geschriebenen Feedbacks und des Dateipfades
%     logMessage = sprintf('Feedback für %s: %s von %s auf %s mit currentFileIndex %d.', imageName, feedback, userName, computerName, currentFileIndex);
%     logEintrag(logDatei, 'Nachricht', logMessage);
% 
%     % Verwenden des Bild- und schonBewertet-Pfades aus der Konfiguration
%     sourcePath = fullfile(cfg.clientAImagePfad, [imageName, '.png']);
%     destPath = fullfile(cfg.clientASchonBewertetPfad, [imageName, '.png']);
%     movefile(sourcePath, destPath);                                                                                       
%     logMessage = sprintf('Bild %s nach %s verschoben.', sourcePath, destPath);
%     logEintrag(logDatei, 'Nachricht', logMessage);
% end

% Code ENDs



%%%%%%%%%%%%%%%%%%%
% % Header START
% %
% % Zweck: Dieses Skript überwacht einen bestimmten Ordner auf PNG-Bilder,
% % lädt sie zur Bewertung in eine GUI und protokolliert die Bewertungen.
% %
% % Skriptname: fileListenerClient_x.m
% % Funktion: fileListenerClient_x
% %
% % Erstellt von: Bernd Schmidt
% % Erstelldatum: 1. ‎Februar ‎2024
% %
% % Änderungshistorie:
% % Datum: 1. ‎Februar ‎2024: Erstellt
% % Datum: 28. ‎Februar ‎2024: 
% % Datum: 18. Juli 2024: Header hinzugefügt.
% % Datum: 23. Juli 2024: Code umgeschrieben, so dass Funktion auf
% %                       verteileten Sytemen erfüllt ist.
% %
% % Funktionsart: Standalone-Funktion
% %               User-Funktion
% %
% % Verwendete Funktionen:
% % Listung der Helper Funktionen:
% %   - config(): Lädt die Konfigurationsdaten.
% %   - logEintrag(logDatei, Nachricht): Protokolliert Nachrichten in der Protokolldatei.
% %   - createGUI(folderPath, imageName, logDatei): Erstellt eine GUI zur Bildbewertung.
% %   - bewertungCallback(~, ~, folderPath, imageName, feedback, logDatei, fig): Callback-Funktion für die Bewertungsschaltflächen.
% %   - writeFeedback(imageName, feedback, logDatei): Schreibt die Bewertung in eine CSV-Datei und verschiebt das Bild.
% %
% % Listung der Anonymous-Funktion: (Keine vorhanden)
% % Listung der Callback-Funktion:
% %   - bewertungCallback: Wird aufgerufen, wenn ein Bewertungsbutton in der GUI gedrückt wird.
% %
% % Syntax für die Verwendung: (nur im Falle einer Funktion)
% %   fileListenerClient_x()
% %
% %    Inputs/ Übergaben: Keine
% %
% %    Outputs/ Rückgaben: Keine
% %
% % Beispiele: (für die Verwendung der Funktion)
% %   - Aufruf der Funktion ohne Eingaben:
% %       fileListenerClient_x();
% %
% % Benutzereingaben: (falls vorhanden)
% %   - Interaktive Eingaben über die GUI zur Bewertung der Bilder.
% %
% % Programmausgaben: (falls vorhanden)
% %   - Protokollierte Nachrichten in der Log-Datei.
% %
% % Seiteneffekte: (falls vorhanden z.B. erzeugen von globalen Variablen mit
% %                Einfluss auf den Rest des Programms)
% %   - Globaler Scope für currentFileIndex.
% %
% % Nebeneffekte: (falls vorhanden z.B. schreiben oder lesen von Dateien)
% %   - Lesen der PNG-Bilder aus dem überwachten Ordner.
% %   - Schreiben der Bewertungsdaten in eine CSV-Datei.
% %   - Verschieben der bewerteten Bilder in einen anderen Ordner.
% %
% % Verwendete Variablen und ihre Datentypen sowie Dimensionen:
% %   - cfg (struct): Konfigurationsdaten.
% %   - logDatei (string): Pfad zur Protokolldatei.
% %   - folderPath (string): Pfad zum Bildordner.
% %   - files (struct): Informationen über die Dateien im Bildordner.
% %   - currentFile (string): Name der aktuellen Bilddatei.
% %   - fig (figure handle): Handle der GUI-Figur.
% %   - ax (axes handle): Handle der Achsen in der GUI-Figur.
% %   - imageName (string): Name der Bilddatei.
% %   - feedback (string): Bewertung des Bildes.
% %   - csvFolderPath (string): Pfad zum Ordner für die Bewertungsdateien.
% %   - csvFileName (string): Name der CSV-Datei.
% %   - feedbackTable (table): Tabelle mit den Bewertungsdaten.
% %   - sourcePath (string): Quellpfad des Bildes.
% %   - destPath (string): Zielpfad des Bildes.
% %
% % Verwendete Parameter und ihre Datentypen sowie Dimensionen:
% %   - Keine spezifischen Parameter, aber Umgebungsvariablen (COMPUTERNAME, USERNAME) werden verwendet.
% %
% % Hinweise:
% %   - Die Funktion verwendet eine Konfigurationsdatei, um Pfade und Einstellungen zu laden.
% %   - Es wird erwartet, dass die Konfigurationsdatei gültige Pfade enthält.
% %
% % Siehe auch:
% % Built-In Funktionen:
% %   - getenv(): Ruft Umgebungsvariablen ab.
% %   - imread(): Liest ein Bild in MATLAB ein.
% %   - figure(): Erstellt eine neue GUI-Figur.
% %   - uicontrol(): Erstellt UI-Steuerelemente in der GUI.
% %   - writetable(): Schreibt eine Tabelle in eine CSV-Datei.
% %   - movefile(): Verschiebt eine Datei.
% %   - dir(): Listet Dateien in einem Verzeichnis auf.
% %   - fullfile(): Erstellt einen vollständigen Dateipfad.
% %
% % Theorie:
% %   - Das Skript implementiert eine einfache Überwachung eines Ordners und eine Benutzeroberfläche zur Bildbewertung.
% %
% % Berechnung / Algorithmus:
% %   - Die Bilder im angegebenen Ordner werden aufgelistet.
% %   - Für jedes Bild wird eine GUI zur Bewertung erstellt.
% %   - Die Bewertungen werden protokolliert und in einer CSV-Datei gespeichert.
% %   - Bewertete Bilder werden in einen anderen Ordner verschoben.
% %
% % Header END
% 
% 
% % Code STARTs
% 
% % Umgebungsbereinigung
% % close all; % Schließt alle offenen Figuren
% % clear;     % Löscht alle Variablen im Workspace
% % clc;       % Löscht den Command Window Inhalt
% 
% % Code 
% function fileListenerClient_x()
%     % Konfigurationsdaten laden
%     cfg = config();
% 
%     % Pfad zur Protokolldatei aus der Konfiguration verwenden
%     logDatei = cfg.logDatei;
%     % folderPath = fullfile(cfg.filesPfad, 'clientA', 'image\');
%     folderPath = cfg.clientAImagePfad; 
% 
%     files = dir(fullfile(folderPath, '*.png'));
% 
%     if isempty(files)
%         logEintrag(logDatei, 'Nachricht', 'Keine Bilder gefunden', 'Details', 'Im angegebenen Ordner wurden keine Bilder gefunden.');
%         return;
%     end
% 
%     for idx = 1:length(files)
%         currentFile = files(idx).name;
%         createGUI(folderPath, currentFile, logDatei);
%         waitforbuttonpress; % Bleibt unverändert, basierend auf deiner Anweisung
%     end
% end
% 
% 
% function createGUI(folderPath, imageName, logDatei)
%     % Rechner- und Benutzernamen abrufen
%     computerName = getenv('COMPUTERNAME');
%     userName = getenv('USERNAME');
% 
%     img = imread(fullfile(folderPath, imageName));
%     % Fenstertitel mit Rechnername, Benutzername und "CL_A" setzen
%     fig = figure('Name', sprintf('Bildbewertung - %s - %s - CL_A', computerName, userName), 'NumberTitle', 'off', 'WindowState', 'maximized');
%     ax = axes('Parent', fig, 'Position', [0.1, 0.3, 0.8, 0.6]);
%     imshow(img, 'Parent', ax);
% 
%     % Protokollieren, dass das Bild geladen und angezeigt wird, inklusive Rechner- und Benutzernamen
%     logMessage = sprintf('Bild %s geladen und zur Bewertung angezeigt von %s auf %s.', imageName, userName, computerName);
%     logEintrag(logDatei, 'Nachricht', logMessage);
% 
%     % Buttons für die Bewertung
%     uicontrol('Parent', fig, 'Style', 'pushbutton', 'String', 'Ästhetisch', 'Position', [100, 50, 100, 30], 'Callback', {@bewertungCallback, folderPath, imageName, 'ästhetisch', logDatei, fig});
%     logMessage = sprintf('Bewertungsbutton "Ästhetisch" erstellt von %s auf %s.', userName, computerName);
%     logEintrag(logDatei, 'Nachricht', logMessage);
% 
%     uicontrol('Parent', fig, 'Style', 'pushbutton', 'String', 'Unästhetisch', 'Position', [210, 50, 100, 30], 'Callback', {@bewertungCallback, folderPath, imageName, 'unästhetisch', logDatei, fig});
%     logMessage = sprintf('Bewertungsbutton "Unästhetisch" erstellt von %s auf %s.', userName, computerName);
%     logEintrag(logDatei, 'Nachricht', logMessage);
% end
% 
% function bewertungCallback(~, ~, folderPath, imageName, feedback, logDatei, fig)
%     % Callback-Funktion für die Bewertungsschaltflächen.
%     writeFeedback(imageName, feedback, logDatei);
%     % Protokollieren des Schließens des Bewertungsfensters
%     logMessage = sprintf('Bewertungsfenster für %s wird geschlossen.', imageName);
%     logEintrag(logDatei, 'Nachricht', logMessage);
%     close(fig); % Schließt die GUI nach der Bewertung
% end
% 
% function writeFeedback(imageName, feedback, logDatei)
%     cfg = config(); % Konfiguration laden
%     global currentFileIndex; % Stellt sicher, dass currentFileIndex im globalen Scope definiert ist
%     computerName = getenv('COMPUTERNAME'); % Für Windows
%     userName = getenv('USERNAME'); % Für Windows
%     feedbackNum = strcmp(feedback, 'ästhetisch'); % Konvertiert das Feedback in einen numerischen Wert
%     % csvFolderPath = 'D:\MALAB\EigMatPrg\proportionen\NetzDrive\clientA\bewertung\'; % Pfad für Client A
%     csvFolderPath = cfg.clientABewertungPfad; 
%     csvFileName = sprintf('%sBeWe_%s_%s.csv', csvFolderPath, computerName, 'Instanz_A'); % Dateiname für Client A
% 
%     if ~exist(csvFolderPath, 'dir')
%         mkdir(csvFolderPath); % Erstellt den Ordner, falls nicht vorhanden
%     end
% 
%     imageName = erase(imageName, '.png'); % Entfernen der Dateiendung '.png'
% 
%     % Erstellt eine Tabelle für das Feedback
%     feedbackTable = table({imageName}, {'Instanz_A'}, {computerName}, {userName}, feedbackNum, ...
%                           'VariableNames', {'Bildname', 'Instanz', 'Rechner', 'Benutzer', 'Bewertung'});
% 
%     % Schreibt das Feedback in die CSV-Datei
%     if exist(csvFileName, 'file')
%         writetable(feedbackTable, csvFileName, 'WriteMode', 'append', 'Delimiter', ',', 'WriteVariableNames', false);
%     else
%         writetable(feedbackTable, csvFileName, 'Delimiter', ',');
%     end
% 
%     % Protokollieren des geschriebenen Feedbacks und des Dateipfades
%     logMessage = sprintf('Feedback für %s: %s von %s auf %s mit currentFileIndex %d.', imageName, feedback, userName, computerName, currentFileIndex);
%     logEintrag(logDatei, 'Nachricht', logMessage);
% 
%     % Verwenden des Bild- und schonBewertet-Pfades aus der Konfiguration
%     sourcePath = fullfile(cfg.clientAImagePfad, [imageName, '.png']);
%     destPath = fullfile(cfg.clientASchonBewertetPfad, [imageName, '.png']);
%     movefile(sourcePath, destPath);                                                                                       
%     logMessage = sprintf('Bild %s nach %s verschoben.', sourcePath, destPath);
%     logEintrag(logDatei, 'Nachricht', logMessage);
% end
% 
% % Code ENDs


% % % Header START
% % %
% % % Zweck: Dieses Skript überwacht einen bestimmten Ordner auf PNG-Bilder,
% % % lädt sie zur Bewertung in eine GUI und protokolliert die Bewertungen.
% % %
% % % Skriptname: fileListener2A.m
% % % Funktion: fileListener2A
% % %
% % % Erstellt von: Bernd Schmidt
% % % Erstelldatum: 1. ‎Februar ‎2024
% % %
% % % Änderungshistorie:
% % % Datum: 1. ‎Februar ‎2024: Erstellt
% % % Datum: 28. ‎Februar ‎2024: 
% % % Datum: 18. Juli 2024: Header hinzugefügt.
% % %
% % %
% % % Funktionsart: Standalone-Funktion
% % %               User-Funktion
% % %
% % % Verwendete Funktionen:
% % % Listung der Helper Funktionen:
% % %   - config(): Lädt die Konfigurationsdaten.
% % %   - logEintrag(logDatei, Nachricht): Protokolliert Nachrichten in der Protokolldatei.
% % %   - createGUI(folderPath, imageName, logDatei): Erstellt eine GUI zur Bildbewertung.
% % %   - bewertungCallback(~, ~, folderPath, imageName, feedback, logDatei, fig): Callback-Funktion für die Bewertungsschaltflächen.
% % %   - writeFeedback(imageName, feedback, logDatei): Schreibt die Bewertung in eine CSV-Datei und verschiebt das Bild.
% % %
% % % Listung der Anonymous-Funktion: (Keine vorhanden)
% % % Listung der Callback-Funktion:
% % %   - bewertungCallback: Wird aufgerufen, wenn ein Bewertungsbutton in der GUI gedrückt wird.
% % %
% % % Syntax für die Verwendung: (nur im Falle einer Funktion)
% % %   fileListener2A()
% % %
% % %    Inputs/ Übergaben: Keine
% % %
% % %    Outputs/ Rückgaben: Keine
% % %
% % % Beispiele: (für die Verwendung der Funktion)
% % %   - Aufruf der Funktion ohne Eingaben:
% % %       fileListener2A();
% % %
% % % Benutzereingaben: (falls vorhanden)
% % %   - Interaktive Eingaben über die GUI zur Bewertung der Bilder.
% % %
% % % Programmausgaben: (falls vorhanden)
% % %   - Protokollierte Nachrichten in der Log-Datei.
% % %
% % % Seiteneffekte: (falls vorhanden z.B. erzeugen von globalen Variablen mit
% % %                Einfluss auf den Rest des Programms)
% % %   - Globaler Scope für currentFileIndex.
% % %
% % % Nebeneffekte: (falls vorhanden z.B. schreiben oder lesen von Dateien)
% % %   - Lesen der PNG-Bilder aus dem überwachten Ordner.
% % %   - Schreiben der Bewertungsdaten in eine CSV-Datei.
% % %   - Verschieben der bewerteten Bilder in einen anderen Ordner.
% % %
% % % Verwendete Variablen und ihre Datentypen sowie Dimensionen:
% % %   - cfg (struct): Konfigurationsdaten.
% % %   - logDatei (string): Pfad zur Protokolldatei.
% % %   - folderPath (string): Pfad zum Bildordner.
% % %   - files (struct): Informationen über die Dateien im Bildordner.
% % %   - currentFile (string): Name der aktuellen Bilddatei.
% % %   - fig (figure handle): Handle der GUI-Figur.
% % %   - ax (axes handle): Handle der Achsen in der GUI-Figur.
% % %   - imageName (string): Name der Bilddatei.
% % %   - feedback (string): Bewertung des Bildes.
% % %   - csvFolderPath (string): Pfad zum Ordner für die Bewertungsdateien.
% % %   - csvFileName (string): Name der CSV-Datei.
% % %   - feedbackTable (table): Tabelle mit den Bewertungsdaten.
% % %   - sourcePath (string): Quellpfad des Bildes.
% % %   - destPath (string): Zielpfad des Bildes.
% % %
% % % Verwendete Parameter und ihre Datentypen sowie Dimensionen:
% % %   - Keine spezifischen Parameter, aber Umgebungsvariablen (COMPUTERNAME, USERNAME) werden verwendet.
% % %
% % % Hinweise:
% % %   - Die Funktion verwendet eine Konfigurationsdatei, um Pfade und Einstellungen zu laden.
% % %   - Es wird erwartet, dass die Konfigurationsdatei gültige Pfade enthält.
% % %
% % % Siehe auch:
% % % Built-In Funktionen:
% % %   - getenv(): Ruft Umgebungsvariablen ab.
% % %   - imread(): Liest ein Bild in MATLAB ein.
% % %   - figure(): Erstellt eine neue GUI-Figur.
% % %   - uicontrol(): Erstellt UI-Steuerelemente in der GUI.
% % %   - writetable(): Schreibt eine Tabelle in eine CSV-Datei.
% % %   - movefile(): Verschiebt eine Datei.
% % %   - dir(): Listet Dateien in einem Verzeichnis auf.
% % %   - fullfile(): Erstellt einen vollständigen Dateipfad.
% % %
% % % Theorie:
% % %   - Das Skript implementiert eine einfache Überwachung eines Ordners und eine Benutzeroberfläche zur Bildbewertung.
% % %
% % % Berechnung / Algorithmus:
% % %   - Die Bilder im angegebenen Ordner werden aufgelistet.
% % %   - Für jedes Bild wird eine GUI zur Bewertung erstellt.
% % %   - Die Bewertungen werden protokolliert und in einer CSV-Datei gespeichert.
% % %   - Bewertete Bilder werden in einen anderen Ordner verschoben.
% % %
% % % Header END
% % 
% % 
% % % Code STARTs
% % 
% % % Umgebungsbereinigung
% % % close all; % Schließt alle offenen Figuren
% % % clear;     % Löscht alle Variablen im Workspace
% % % clc;       % Löscht den Command Window Inhalt
% % 
% % % Code 
% % function fileListener2A()
% %     % Konfigurationsdaten laden
% %     cfg = config();
% % 
% %     % Pfad zur Protokolldatei aus der Konfiguration verwenden
% %     logDatei = cfg.logDatei;
% %     % folderPath = fullfile(cfg.filesPfad, 'clientA', 'image\');
% %     folderPath = cfg.clientAImagePfad; 
% % 
% %     files = dir(fullfile(folderPath, '*.png'));
% % 
% %     if isempty(files)
% %         logEintrag(logDatei, 'Keine Bilder gefunden', 'Im angegebenen Ordner wurden keine Bilder gefunden.');
% %         return;
% %     end
% % 
% %     for idx = 1:length(files)
% %         currentFile = files(idx).name;
% %         createGUI(folderPath, currentFile, logDatei);
% %         waitforbuttonpress; % Bleibt unverändert, basierend auf deiner Anweisung
% %     end
% % end
% % 
% % 
% % function createGUI(folderPath, imageName, logDatei)
% %     % Rechner- und Benutzernamen abrufen
% %     computerName = getenv('COMPUTERNAME');
% %     userName = getenv('USERNAME');
% % 
% %     img = imread(fullfile(folderPath, imageName));
% %     % Fenstertitel mit Rechnername, Benutzername und "CL_A" setzen
% %     fig = figure('Name', sprintf('Bildbewertung - %s - %s - CL_A', computerName, userName), 'NumberTitle', 'off', 'WindowState', 'maximized');
% %     ax = axes('Parent', fig, 'Position', [0.1, 0.3, 0.8, 0.6]);
% %     imshow(img, 'Parent', ax);
% % 
% %     % Protokollieren, dass das Bild geladen und angezeigt wird, inklusive Rechner- und Benutzernamen
% %     logEintrag(logDatei, sprintf('Bild %s geladen und zur Bewertung angezeigt von %s auf %s.', imageName, userName, computerName));
% % 
% %     % Buttons für die Bewertung
% %     uicontrol('Parent', fig, 'Style', 'pushbutton', 'String', 'Ästhetisch', 'Position', [100, 50, 100, 30], 'Callback', {@bewertungCallback, folderPath, imageName, 'ästhetisch', logDatei, fig});
% %     logEintrag(logDatei, sprintf('Bewertungsbutton "Ästhetisch" erstellt von %s auf %s.', userName, computerName));
% % 
% %     uicontrol('Parent', fig, 'Style', 'pushbutton', 'String', 'Unästhetisch', 'Position', [210, 50, 100, 30], 'Callback', {@bewertungCallback, folderPath, imageName, 'unästhetisch', logDatei, fig});
% %     logEintrag(logDatei, sprintf('Bewertungsbutton "Unästhetisch" erstellt von %s auf %s.', userName, computerName));
% % end
% % 
% % 
% % 
% % 
% % function bewertungCallback(~, ~, folderPath, imageName, feedback, logDatei, fig)
% %     % Callback-Funktion für die Bewertungsschaltflächen.
% %     writeFeedback(imageName, feedback, logDatei);
% %     % Protokollieren des Schließens des Bewertungsfensters
% %     logEintrag(logDatei, sprintf('Bewertungsfenster für %s wird geschlossen.', imageName));
% %     close(fig); % Schließt die GUI nach der Bewertung
% % end
% % 
% % 
% % 
% % function writeFeedback(imageName, feedback, logDatei)
% %     cfg = config(); % Konfiguration laden
% %     global currentFileIndex; % Stellt sicher, dass currentFileIndex im globalen Scope definiert ist
% %     computerName = getenv('COMPUTERNAME'); % Für Windows
% %     userName = getenv('USERNAME'); % Für Windows
% %     feedbackNum = strcmp(feedback, 'ästhetisch'); % Konvertiert das Feedback in einen numerischen Wert
% %     % csvFolderPath = 'D:\MALAB\EigMatPrg\proportionen\NetzDrive\clientA\bewertung\'; % Pfad für Client A
% %     csvFolderPath =     cfg.clientABewertungPfad; 
% %     csvFileName = sprintf('%sBeWe_%s_%s.csv', csvFolderPath, computerName, 'Instanz_A'); % Dateiname für Client A
% % 
% %     if ~exist(csvFolderPath, 'dir')
% %         mkdir(csvFolderPath); % Erstellt den Ordner, falls nicht vorhanden
% %     end
% % 
% %     imageName = erase(imageName, '.png'); % Entfernen der Dateiendung '.png'
% % 
% %     % Erstellt eine Tabelle für das Feedback
% %     feedbackTable = table({imageName}, {'Instanz_A'}, {computerName}, {userName}, feedbackNum, ...
% %                           'VariableNames', {'Bildname', 'Instanz', 'Rechner', 'Benutzer', 'Bewertung'});
% % 
% %     % Schreibt das Feedback in die CSV-Datei
% %     if exist(csvFileName, 'file')
% %         writetable(feedbackTable, csvFileName, 'WriteMode', 'append', 'Delimiter', ',', 'WriteVariableNames', false);
% %     else
% %         writetable(feedbackTable, csvFileName, 'Delimiter', ',');
% %     end
% % 
% %     % Protokollieren des geschriebenen Feedbacks und des Dateipfades
% %     logEintrag(logDatei, sprintf('Feedback für %s: %s von %s auf %s mit currentFileIndex %d.', imageName, feedback, userName, computerName, currentFileIndex));
% % 
% %     % Verwenden des Bild- und schonBewertet-Pfades aus der Konfiguration
% %     sourcePath = fullfile(cfg.clientAImagePfad, [imageName, '.png']);
% %     destPath = fullfile(cfg.clientASchonBewertetPfad, [imageName, '.png']);
% %     movefile(sourcePath, destPath);                                                                                       
% %     logEintrag(logDatei, sprintf('Bild %s nach %s verschoben.', sourcePath, destPath));
% % end
% % 
% % % Code ENDs
