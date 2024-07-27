function logEintrag(logDatei, varargin)
    % LOGEINTRAG Fügt einen Eintrag in eine Protokolldatei hinzu.
    % Diese Funktion schreibt einen Eintrag in die angegebene Protokolldatei.

    % Überprüft, ob eine gerade Anzahl an varargin-Parametern übergeben wurde
    if mod(length(varargin), 2) ~= 0
        error('Jedes Schlüssel-Wert-Paar muss eine gerade Anzahl von Eingabeparametern haben.');
    end

    % Standardwerte für optionale Parameter
    schreibeAufrufer = true;
    schreibeZeitstempel = true;
    nutzeLogDatei = false;

    % Verarbeitet varargin für optionale Parameter
    if nargin > 1
        for i = 1:2:length(varargin)
            if strcmp(varargin{i}, 'schreibeAufrufer')
                schreibeAufrufer = varargin{i + 1};
            elseif strcmp(varargin{i}, 'schreibeZeitstempel')
                schreibeZeitstempel = varargin{i + 1};
            elseif strcmp(varargin{i}, 'nutzeLogDatei')
                nutzeLogDatei = varargin{i + 1};
            end
        end
    end

    % Verzeichnis der Protokolldatei prüfen und erstellen, falls nicht vorhanden
    logDir = fileparts(logDatei);
    if ~exist(logDir, 'dir')
        mkdir(logDir);
    end

    % Öffnet die Logdatei zum Anhängen
    fid = fopen(logDatei, 'a');
    if fid == -1
        error('Protokolldatei konnte nicht geöffnet werden: %s', logDatei);
    end

    % Schreibt den Zeitstempel, wenn gewünscht
    if schreibeZeitstempel
        fprintf(fid, '[%s] ', datestr(now, 'yyyy-mm-dd HH:MM:SS'));
    end

    % Ermittelt und schreibt Aufruferinfo oder Logdatei, wenn gewünscht
    if nutzeLogDatei
        fprintf(fid, '[%s] ', logDatei);
    elseif schreibeAufrufer
        stack = dbstack;
        aufruferInfo = 'Unbekannt';
        pfadName = 'Nicht zutreffend';
        if numel(stack) > 1
            aufruferInfo = stack(2).name; % Der direkte Aufrufer ist der zweite Eintrag im Stack
            pfadName = which(aufruferInfo);
        else
            aufruferInfo = 'Workspace oder Command Window';
        end
        fprintf(fid, '[%s] [%s] ', aufruferInfo, pfadName);
    end

    % Iteriert über die varargin-Argumente in Paaren für zusätzliche Daten
    for i = 1:2:length(varargin)
        varName = varargin{i}; % Variablennamen
        if strcmp(varName, 'schreibeAufrufer') || strcmp(varName, 'schreibeZeitstempel') || strcmp(varName, 'nutzeLogDatei')
            continue; % Überspringt die speziellen Steuerungsparameter
        end
        varValue = varargin{i + 1}; % Variablenwert

        % Überprüft den Typ des Variablenwerts und formatiert ihn entsprechend
        if isnumeric(varValue)
            valueStr = num2str(varValue);
        elseif ischar(varValue) || isstring(varValue)
            valueStr = ['"', char(varValue), '"'];
        else
            valueStr = 'Komplexer Typ'; % Für nicht direkt unterstützte Typen
        end

        % Fügt den Variablennamen und -wert zum Logeintrag hinzu
        fprintf(fid, '%s=%s; ', varName, valueStr);
    end

    % Schließt den Eintrag mit einem Zeilenumbruch und schließt die Datei
    fprintf(fid, '\n');
    fclose(fid);
end


% % function logEintrag(logDatei, varargin)
% %     % LOGEINTRAG Fügt einen Eintrag in eine Protokolldatei hinzu.
% %     %
% %     % Diese Funktion schreibt einen Eintrag in die angegebene Protokolldatei. Sie kann
% %     % optional den Namen des Aufrufers und einen Zeitstempel einfügen. Zusätzliche
% %     % Informationen können über Schlüssel-Wert-Paare übergeben werden.
% %     %
% %     % Syntax:
% %     %   logEintrag(logDatei)
% %     %   logEintrag(logDatei, 'schreibeAufrufer', true/false, 'schreibeZeitstempel', true/false, 'nutzeLogDatei', true/false, ...)
% %     %
% %     % Eingabeparameter:
% %     %   logDatei (string): Pfad und Dateiname der Protokolldatei.
% %     %   varargin (Schlüssel-Wert-Paare): Optionale Parameter und Werte, die protokolliert werden sollen.
% %     %       'schreibeAufrufer' (logical): Gibt an, ob der Name des Aufrufers protokolliert werden soll.
% %     %                                    Standardwert ist true.
% %     %       'schreibeZeitstempel' (logical): Gibt an, ob ein Zeitstempel protokolliert werden soll.
% %     %                                        Standardwert ist true.
% %     %       'nutzeLogDatei' (logical): Gibt an, ob der Name der Logdatei statt des Aufrufers protokolliert werden soll.
% %     %                                  Standardwert ist false.
% %     %       Zusätzliche Schlüssel-Wert-Paare können übergeben werden, um spezifische Informationen
% %     %       zu protokollieren. Schlüssel sollten als Strings und Werte können als Strings, Zahlen
% %     %       oder andere unterstützte Formate übergeben werden.
% %     %
% %     % Ausgaben:
% %     %   Keine expliziten Ausgaben. Die Funktion schreibt Daten in die Protokolldatei.
% %     %
% %     % Beispiele:
% %     %   logEintrag('meinLog.txt', 'Operation', 'Start der Verarbeitung');
% %     %   logEintrag('meinLog.txt', 'schreibeAufrufer', false, 'Fehler', 'Datei nicht gefunden', 'Dateiname', 'daten.csv');
% %     %   logEintrag('meinLog.txt', 'nutzeLogDatei', true, 'Fehler', 'Datei nicht gefunden', 'Dateiname', 'daten.csv');
% %     %
% %     % Hinweise:
% %     %   - Die Funktion erstellt die Protokolldatei automatisch, falls diese nicht
% %     %     existiert.
% %     %   - Bei Problemen mit dem Dateizugriff wird eine Fehlermeldung ausgegeben.
% %     %   - Diese Funktion ist besonders nützlich für die Fehlersuche, das Monitoring
% %     %     von Programmabläufen und die Dokumentation von wichtigen Ereignissen
% %     %     während der Ausführung von Skripten und Funktionen.
% %     %
% %     % Autor: Ihr Name
% %     % Datum: aktuelles Datum
% %     %
% %     % Siehe auch: fopen, fprintf, fclose, datestr
% % 
% %     % Überprüft, ob eine gerade Anzahl an varargin-Parametern übergeben wurde
% %     if mod(length(varargin), 2) ~= 0
% %         error('Jedes Schlüssel-Wert-Paar muss eine gerade Anzahl von Eingabeparametern haben.');
% %     end
% % 
% %     % Standardwerte für optionale Parameter
% %     schreibeAufrufer = true;
% %     schreibeZeitstempel = true;
% %     nutzeLogDatei = false;
% % 
% %     % Verarbeitet varargin für optionale Parameter
% %     if nargin > 1
% %         for i = 1:2:length(varargin)
% %             if strcmp(varargin{i}, 'schreibeAufrufer')
% %                 schreibeAufrufer = varargin{i + 1};
% %             elseif strcmp(varargin{i}, 'schreibeZeitstempel')
% %                 schreibeZeitstempel = varargin{i + 1};
% %             elseif strcmp(varargin{i}, 'nutzeLogDatei')
% %                 nutzeLogDatei = varargin{i + 1};
% %             end
% %         end
% %     end
% % 
% %     % Öffnet die Logdatei zum Anhängen
% %     fid = fopen(logDatei, 'a');
% %     if fid == -1
% %         error('Protokolldatei konnte nicht geöffnet werden.');
% %     end
% % 
% %     % Schreibt den Zeitstempel, wenn gewünscht
% %     if schreibeZeitstempel
% %         fprintf(fid, '[%s] ', datestr(now, 'yyyy-mm-dd HH:MM:SS'));
% %     end
% % 
% %     % Ermittelt und schreibt Aufruferinfo oder Logdatei, wenn gewünscht
% %     if nutzeLogDatei
% %         fprintf(fid, '[%s] ', logDatei);
% %     elseif schreibeAufrufer
% %         stack = dbstack;
% %         aufruferInfo = 'Unbekannt';
% %         pfadName = 'Nicht zutreffend';
% %         if numel(stack) > 1
% %             aufruferInfo = stack(2).name; % Der direkte Aufrufer ist der zweite Eintrag im Stack
% %             pfadName = which(aufruferInfo);
% %         else
% %             aufruferInfo = 'Workspace oder Command Window';
% %         end
% %         fprintf(fid, '[%s] [%s] ', aufruferInfo, pfadName);
% %     end
% % 
% %     % Iteriert über die varargin-Argumente in Paaren für zusätzliche Daten
% %     for i = 1:2:length(varargin)
% %         varName = varargin{i}; % Variablennamen
% %         if strcmp(varName, 'schreibeAufrufer') || strcmp(varName, 'schreibeZeitstempel') || strcmp(varName, 'nutzeLogDatei')
% %             continue; % Überspringt die speziellen Steuerungsparameter
% %         end
% %         varValue = varargin{i + 1}; % Variablenwert
% % 
% %         % Überprüft den Typ des Variablenwerts und formatiert ihn entsprechend
% %         if isnumeric(varValue)
% %             valueStr = num2str(varValue);
% %         elseif ischar(varValue) || isstring(varValue)
% %             valueStr = ['"', char(varValue), '"'];
% %         else
% %             valueStr = 'Komplexer Typ'; % Für nicht direkt unterstützte Typen
% %         end
% % 
% %         % Fügt den Variablennamen und -wert zum Logeintrag hinzu
% %         fprintf(fid, '%s=%s; ', varName, valueStr);
% %     end
% % 
% %     % Schließt den Eintrag mit einem Zeilenumbruch und schließt die Datei
% %     fprintf(fid, '\n');
% %     fclose(fid);
% % end


% function logEintrag(logDatei, varargin)
%     % LOGEINTRAG Fügt einen Eintrag in eine Protokolldatei hinzu.
%     %
%     % Diese Funktion schreibt einen Eintrag in die angegebene Protokolldatei. Sie kann
%     % optional den Namen des Aufrufers und einen Zeitstempel einfügen. Zusätzliche
%     % Informationen können über Schlüssel-Wert-Paare übergeben werden.
%     %
%     % Syntax:
%     %   logEintrag(logDatei)
%     %   logEintrag(logDatei, 'schreibeAufrufer', true/false, 'schreibeZeitstempel', true/false, 'nutzeLogDatei', true/false, ...)
%     %
%     % Eingabeparameter:
%     %   logDatei (string): Pfad und Dateiname der Protokolldatei.
%     %   varargin (Schlüssel-Wert-Paare): Optionale Parameter und Werte, die protokolliert werden sollen.
%     %       'schreibeAufrufer' (logical): Gibt an, ob der Name des Aufrufers protokolliert werden soll.
%     %                                    Standardwert ist true.
%     %       'schreibeZeitstempel' (logical): Gibt an, ob ein Zeitstempel protokolliert werden soll.
%     %                                        Standardwert ist true.
%     %       'nutzeLogDatei' (logical): Gibt an, ob der Name der Logdatei statt des Aufrufers protokolliert werden soll.
%     %                                  Standardwert ist false.
%     %       Zusätzliche Schlüssel-Wert-Paare können übergeben werden, um spezifische Informationen
%     %       zu protokollieren. Schlüssel sollten als Strings und Werte können als Strings, Zahlen
%     %       oder andere unterstützte Formate übergeben werden.
%     %
%     % Ausgaben:
%     %   Keine expliziten Ausgaben. Die Funktion schreibt Daten in die Protokolldatei.
%     %
%     % Beispiele:
%     %   logEintrag('meinLog.txt', 'Operation', 'Start der Verarbeitung');
%     %   logEintrag('meinLog.txt', 'schreibeAufrufer', false, 'Fehler', 'Datei nicht gefunden', 'Dateiname', 'daten.csv');
%     %   logEintrag('meinLog.txt', 'nutzeLogDatei', true, 'Fehler', 'Datei nicht gefunden', 'Dateiname', 'daten.csv');
%     %
%     % Hinweise:
%     %   - Die Funktion erstellt die Protokolldatei automatisch, falls diese nicht
%     %     existiert.
%     %   - Bei Problemen mit dem Dateizugriff wird eine Fehlermeldung ausgegeben.
%     %   - Diese Funktion ist besonders nützlich für die Fehlersuche, das Monitoring
%     %     von Programmabläufen und die Dokumentation von wichtigen Ereignissen
%     %     während der Ausführung von Skripten und Funktionen.
%     %
%     % Autor: Ihr Name
%     % Datum: aktuelles Datum
%     %
%     % Siehe auch: fopen, fprintf, fclose, datestr
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
%     % Öffnet die Logdatei zum Anhängen
%     fid = fopen(logDatei, 'a');
%     if fid == -1
%         error('Protokolldatei konnte nicht geöffnet werden.');
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
%         if i+1 <= length(varargin)
%             varValue = varargin{i + 1}; % Variablenwert
% 
%             % Überprüft den Typ des Variablenwerts und formatiert ihn entsprechend
%             if isnumeric(varValue)
%                 valueStr = num2str(varValue);
%             elseif ischar(varValue) || isstring(varValue)
%                 valueStr = ['"', char(varValue), '"'];
%             else
%                 valueStr = 'Komplexer Typ'; % Für nicht direkt unterstützte Typen
%             end
% 
%             % Fügt den Variablennamen und -wert zum Logeintrag hinzu
%             fprintf(fid, '%s=%s; ', varName, valueStr);
%         end
%     end
% 
%     % Schließt den Eintrag mit einem Zeilenumbruch und schließt die Datei
%     fprintf(fid, '\n');
%     fclose(fid);
% end


% function logEintrag(logDatei, varargin)
%     % LOGEINTRAG Fügt einen Eintrag in eine Protokolldatei hinzu.
%     %
%     % Diese Funktion schreibt einen Eintrag in die angegebene Protokolldatei. Sie kann
%     % optional den Namen des Aufrufers und einen Zeitstempel einfügen. Zusätzliche
%     % Informationen können über Schlüssel-Wert-Paare übergeben werden.
%     %
%     % Syntax:
%     %   logEintrag(logDatei)
%     %   logEintrag(logDatei, 'schreibeAufrufer', true/false, 'schreibeZeitstempel', true/false, ...)
%     %
%     % Eingabeparameter:
%     %   logDatei (string): Pfad und Dateiname der Protokolldatei.
%     %   varargin (Schlüssel-Wert-Paare): Optionale Parameter und Werte, die protokolliert werden sollen.
%     %       'schreibeAufrufer' (logical): Gibt an, ob der Name des Aufrufers protokolliert werden soll.
%     %                                    Standardwert ist true.
%     %       'schreibeZeitstempel' (logical): Gibt an, ob ein Zeitstempel protokolliert werden soll.
%     %                                        Standardwert ist true.
%     %       Zusätzliche Schlüssel-Wert-Paare können übergeben werden, um spezifische Informationen
%     %       zu protokollieren. Schlüssel sollten als Strings und Werte können als Strings, Zahlen
%     %       oder andere unterstützte Formate übergeben werden.
%     %
%     % Ausgaben:
%     %   Keine expliziten Ausgaben. Die Funktion schreibt Daten in die Protokolldatei.
%     %
%     % Beispiele:
%     %   logEintrag('meinLog.txt', 'Operation', 'Start der Verarbeitung');
%     %   logEintrag('meinLog.txt', 'schreibeAufrufer', false, 'Fehler', 'Datei nicht gefunden', 'Dateiname', 'daten.csv');
%     %
%     % Hinweise:
%     %   - Die Funktion erstellt die Protokolldatei automatisch, falls diese nicht
%     %     existiert.
%     %   - Bei Problemen mit dem Dateizugriff wird eine Fehlermeldung ausgegeben.
%     %   - Diese Funktion ist besonders nützlich für die Fehlersuche, das Monitoring
%     %     von Programmabläufen und die Dokumentation von wichtigen Ereignissen
%     %     während der Ausführung von Skripten und Funktionen.
%     %
%     % Autor: Ihr Name
%     % Datum: aktuelles Datum
%     %
%     % Siehe auch: fopen, fprintf, fclose, datestr
% 
%     % Standardwerte für optionale Parameter
%     schreibeAufrufer = true;
%     schreibeZeitstempel = true;
% 
%     % Verarbeitet varargin für optionale Parameter
%     if nargin > 1
%         for i = 1:2:length(varargin)
%             if strcmp(varargin{i}, 'schreibeAufrufer')
%                 schreibeAufrufer = varargin{i + 1};
%             elseif strcmp(varargin{i}, 'schreibeZeitstempel')
%                 schreibeZeitstempel = varargin{i + 1};
%             end
%         end
%     end
% 
%     % Öffnet die Logdatei zum Anhängen
%     fid = fopen(logDatei, 'a');
%     if fid == -1
%         error('Protokolldatei konnte nicht geöffnet werden.');
%     end
% 
%     % Schreibt den Zeitstempel, wenn gewünscht
%     if schreibeZeitstempel
%         fprintf(fid, '[%s] ', datestr(now, 'yyyy-mm-dd HH:MM:SS'));
%     end
% 
%     % Ermittelt und schreibt Aufruferinfo, wenn gewünscht
%     if schreibeAufrufer
%         stack = dbstack
%         % stack.file
%         % stack.name
%         % stack.line
%         aufruferInfo = 'Unbekannt';
%         pfadName = 'Nicht zutreffend';
%         if numel(stack) > 1
%             aufruferInfo = stack(2).name % Der direkte Aufrufer ist der zweite Eintrag im Stack
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
%         if strcmp(varName, 'schreibeAufrufer') || strcmp(varName, 'schreibeZeitstempel')
%             continue; % Überspringt die speziellen Steuerungsparameter
%         end
%         if i+1 <= length(varargin)
%             varValue = varargin{i + 1}; % Variablenwert
% 
%             % Überprüft den Typ des Variablenwerts und formatiert ihn entsprechend
%             if isnumeric(varValue)
%                 valueStr = num2str(varValue);
%             elseif ischar(varValue) || isstring(varValue)
%                 valueStr = ['"', char(varValue), '"'];
%             else
%                 valueStr = 'Komplexer Typ'; % Für nicht direkt unterstützte Typen
%             end
% 
%             % Fügt den Variablennamen und -wert zum Logeintrag hinzu
%             fprintf(fid, '%s=%s; ', varName, valueStr);
%         end
%     end
% 
%     % Schließt den Eintrag mit einem Zeilenumbruch und schließt die Datei
%     fprintf(fid, '\n');
%     fclose(fid);
% end

% % function logEintrag(logDatei, varargin)
% % % LOGEINTRAG Fügt einen Eintrag in eine Protokolldatei hinzu.
% % %
% % % Diese Funktion schreibt einen Eintrag in die angegebene Protokolldatei. Sie kann
% % % optional den Namen des Aufrufers und einen Zeitstempel einfügen. Zusätzliche
% % % Informationen können über Schlüssel-Wert-Paare übergeben werden.
% % %
% % % Syntax:
% % %   logEintrag(logDatei)
% % %   logEintrag(logDatei, 'schreibeAufrufer', true/false, 'schreibeZeitstempel', true/false, ...)
% % %
% % % Eingabeparameter:
% % %   logDatei (string): Pfad und Dateiname der Protokolldatei.
% % %   varargin (Schlüssel-Wert-Paare): Optionale Parameter und Werte, die protokolliert werden sollen.
% % %       'schreibeAufrufer' (logical): Gibt an, ob der Name des Aufrufers protokolliert werden soll.
% % %                                    Standardwert ist true.
% % %       'schreibeZeitstempel' (logical): Gibt an, ob ein Zeitstempel protokolliert werden soll.
% % %                                        Standardwert ist true.
% % %       Zusätzliche Schlüssel-Wert-Paare können übergeben werden, um spezifische Informationen
% % %       zu protokollieren. Schlüssel sollten als Strings und Werte können als Strings, Zahlen
% % %       oder andere unterstützte Formate übergeben werden.
% % %
% % % Ausgaben:
% % %   Keine expliziten Ausgaben. Die Funktion schreibt Daten in die Protokolldatei.
% % %
% % % Beispiele:
% % %   logEintrag('meinLog.txt', 'Operation', 'Start der Verarbeitung');
% % %   logEintrag('meinLog.txt', 'schreibeAufrufer', false, 'Fehler', 'Datei nicht gefunden', 'Dateiname', 'daten.csv');
% % %
% % % Hinweise:
% % %   - Die Funktion erstellt die Protokolldatei automatisch, falls diese nicht
% % %     existiert.
% % %   - Bei Problemen mit dem Dateizugriff wird eine Fehlermeldung ausgegeben.
% % %   - Diese Funktion ist besonders nützlich für die Fehlersuche, das Monitoring
% % %     von Programmabläufen und die Dokumentation von wichtigen Ereignissen
% % %     während der Ausführung von Skripten und Funktionen.
% % %
% % % Autor: Ihr Name
% % % Datum: aktuelles Datum
% % %
% % % Siehe auch: fopen, fprintf, fclose, datestr
% % 
% %     % Standardwerte für optionale Parameter
% %     schreibeAufrufer = true;
% %     schreibeZeitstempel = true;
% % 
% %     % Verarbeitet varargin für optionale Parameter
% %     if nargin > 1
% %         for i = 1:2:length(varargin)
% %             if strcmp(varargin{i}, 'schreibeAufrufer')
% %                 schreibeAufrufer = varargin{i + 1};
% %             elseif strcmp(varargin{i}, 'schreibeZeitstempel')
% %                 schreibeZeitstempel = varargin{i + 1};
% %             end
% %         end
% %     end
% % 
% %     % Öffnet die Logdatei zum Anhängen
% %     fid = fopen(logDatei, 'a');
% %     if fid == -1
% %         error('Protokolldatei konnte nicht geöffnet werden.');
% %     end
% % 
% %     % Schreibt den Zeitstempel, wenn gewünscht
% %     if schreibeZeitstempel
% %         fprintf(fid, '[%s] ', datestr(now, 'yyyy-mm-dd HH:MM:SS'));
% %     end
% % 
% %     % Ermittelt und schreibt Aufruferinfo, wenn gewünscht
% %     if schreibeAufrufer
% %         stack = dbstack;
% %         aufruferInfo = 'Unbekannt';
% %         pfadName = 'Nicht zutreffend';
% %         if numel(stack) > 1
% %             aufruferInfo = stack(2).name; % Der direkte Aufrufer ist der zweite Eintrag im Stack
% %             pfadName = which(aufruferInfo);
% %         else
% %             aufruferInfo = 'Workspace oder Command Window';
% %         end
% %         fprintf(fid, '[%s] [%s] ', aufruferInfo, pfadName);
% %     end
% % 
% %     % Iteriert über die varargin-Argumente in Paaren für zusätzliche Daten
% %     for i = 1:2:length(varargin)
% %         varName = varargin{i}; % Variablennamen
% %         if strcmp(varName, 'schreibeAufrufer') || strcmp(varName, 'schreibeZeitstempel')
% %             continue; % Überspringt die speziellen Steuerungsparameter
% %         end
% %         if i+1 <= length(varargin)
% %             varValue = varargin{i + 1}; % Variablenwert
% % 
% %             % Überprüft den Typ des Variablenwerts und formatiert ihn entsprechend
% %             if isnumeric(varValue)
% %                 valueStr = num2str(varValue);
% %             elseif ischar(varValue) || isstring(varValue)
% %                 valueStr = ['"', char(varValue), '"'];
% %             else
% %                 valueStr = 'Komplexer Typ'; % Für nicht direkt unterstützte Typen
% %             end
% % 
% %             % Fügt den Variablennamen und -wert zum Logeintrag hinzu
% %             fprintf(fid, '%s=%s; ', varName, valueStr);
% %         end
% %     end
% % 
% %     % Schließt den Eintrag mit einem Zeilenumbruch und schließt die Datei
% %     fprintf(fid, '\n');
% %     fclose(fid);
% % end

% function logEintrag(logDatei, varargin)
% 
% % LOGEINTRAG Fügt einen Eintrag in eine Protokolldatei hinzu.
% %
% % Diese Funktion schreibt einen Eintrag in die angegebene Protokolldatei. Sie kann
% % optional den Namen des Aufrufers und einen Zeitstempel einfügen. Zusätzliche
% % Informationen können über Schlüssel-Wert-Paare übergeben werden.
% %
% % Syntax:
% %   logEintrag(logDatei)
% %   logEintrag(logDatei, 'schreibeAufrufer', true/false, 'schreibeZeitstempel', true/false, ...)
% %
% % Eingabeparameter:
% %   logDatei (string): Pfad und Dateiname der Protokolldatei.
% %   varargin (Schlüssel-Wert-Paare): Optionale Parameter und Werte, die protokolliert werden sollen.
% %       'schreibeAufrufer' (logical): Gibt an, ob der Name des Aufrufers protokolliert werden soll.
% %                                    Standardwert ist true.
% %       'schreibeZeitstempel' (logical): Gibt an, ob ein Zeitstempel protokolliert werden soll.
% %                                        Standardwert ist true.
% %       Zusätzliche Schlüssel-Wert-Paare können übergeben werden, um spezifische Informationen
% %       zu protokollieren. Schlüssel sollten als Strings und Werte können als Strings, Zahlen
% %       oder andere unterstützte Formate übergeben werden.
% %
% % Ausgaben:
% %   Keine expliziten Ausgaben. Die Funktion schreibt Daten in die Protokolldatei.
% %
% % Beispiele:
% %   logEintrag('meinLog.txt', 'Operation', 'Start der Verarbeitung');
% %   logEintrag('meinLog.txt', 'schreibeAufrufer', false, 'Fehler', 'Datei nicht gefunden', 'Dateiname', 'daten.csv');
% %
% % Hinweise:
% %   - Die Funktion erstellt die Protokolldatei automatisch, falls diese nicht
% %     existiert.
% %   - Bei Problemen mit dem Dateizugriff wird eine Fehlermeldung ausgegeben.
% %   - Diese Funktion ist besonders nützlich für die Fehlersuche, das Monitoring
% %     von Programmabläufen und die Dokumentation von wichtigen Ereignissen
% %     während der Ausführung von Skripten und Funktionen.
% %
% % Autor: Ihr Name
% % Datum: aktuelles Datum
% %
% % Siehe auch: fopen, fprintf, fclose, datestr
% 
% 
%     % Standardwerte für optionale Parameter
%     schreibeAufrufer = true;
%     schreibeZeitstempel = true;
% 
%     % Verarbeitet varargin für optionale Parameter
%     if nargin > 1
%         for i = 1:2:length(varargin)
%             if strcmp(varargin{i}, 'schreibeAufrufer')
%                 schreibeAufrufer = varargin{i + 1};
%             elseif strcmp(varargin{i}, 'schreibeZeitstempel')
%                 schreibeZeitstempel = varargin{i + 1};
%             end
%         end
%     end
% 
%     % Öffnet die Logdatei zum Anhängen
%     fid = fopen(logDatei, 'a');
%     if fid == -1
%         error('Protokolldatei konnte nicht geöffnet werden.');
%     end
% 
%     % Schreibt den Zeitstempel, wenn gewünscht
%     if schreibeZeitstempel
%         fprintf(fid, '[%s] ', datestr(now, 'yyyy-mm-dd HH:MM:SS'));
%     end
% 
%     % Ermittelt und schreibt Aufruferinfo, wenn gewünscht
%     if schreibeAufrufer
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
%         if strcmp(varName, 'schreibeAufrufer') || strcmp(varName, 'schreibeZeitstempel')
%             continue; % Überspringt die speziellen Steuerungsparameter
%         end
%         if i+1 <= length(varargin)
%             varValue = varargin{i + 1}; % Variablenwert
% 
%             % Überprüft den Typ des Variablenwerts und formatiert ihn entsprechend
%             if isnumeric(varValue)
%                 valueStr = num2str(varValue);
%             elseif ischar(varValue) || isstring(varValue)
%                 valueStr = ['"', char(varValue), '"'];
%             else
%                 valueStr = 'Komplexer Typ'; % Für nicht direkt unterstützte Typen
%             end
% 
%             % Fügt den Variablennamen und -wert zum Logeintrag hinzu
%             fprintf(fid, '%s=%s; ', varName, valueStr);
%         end
%     end
% 
%     % Schließt den Eintrag mit einem Zeilenumbruch und schließt die Datei
%     fprintf(fid, '\n');
%     fclose(fid);
% end
% 
% 
% 
% 
% 