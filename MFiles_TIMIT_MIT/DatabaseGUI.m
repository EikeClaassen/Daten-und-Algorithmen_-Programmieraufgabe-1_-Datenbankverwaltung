classdef DatabaseGUI < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Handles
        DatabaseObj
        currentAudio
    end
    
    
    methods
        
        function obj =  DatabaseGUI(databaseObj)
            obj.DatabaseObj = databaseObj;
            obj.initializeGUI
            obj.updateGUI
        end
        
        
        function initializeGUI(obj)
            % Create and then hide the UI as it is being constructed.
            hFigure = figure('Tag','TIMIT_MIT_DatabaseGUI',...
                         'Visible','off',...
                         'MenuBar','none',...
                         'Resize','off',...
                         'NumberTitle','off',...
                         'Name','Search Audio Data',...
                         'Position',[400 400 786 512]);
            % Centering the Gui
            movegui(hFigure,'center');
            % Construct the components.
            hDirectory = uicontrol('Style','edit',...
                                'Position',[50 450 250 30],...
                                'String',obj.DatabaseObj.DefaultDirectory,...
                                'Tooltipstring','directory to search for the TIMIT MIT database',...
                                'FontName','Trebuchet',...
                                'FontSize',13,...
                                'Callback',@(hObject,callbackdata,handles)obj.directoryCallback);

            hDirInfo = uicontrol('Style','text',...
                                 'Position',[350 445 350 30],...
                                 'String','database not loaded, edit directory',...
                                 'Tooltipstring','information whether the database was found or not',...
                                 'FontName','Trebuchet',...
                                 'Visible','on',...
                                 'FontSize',13);

            hGenderText = uicontrol('Style','text',...
                                    'Position',[40 405 95 30],...
                                    'String','Gender',...
                                    'FontName','Trebuchet',...
                                    'FontSize',13);

            hGender = uicontrol('Style','popupmenu',...
                                'Position',[45 385 95 30],...
                                'Tooltipstring','search for sex...',...
                                'FontName','Trebuchet',...
                                'FontSize',13,...
                                'String',{'','Male','Female'});

            hPersonText = uicontrol('Style','text',...
                                    'Position',[155 405 85 30],...
                                    'String','Person',...
                                    'FontName','Trebuchet',...
                                    'FontSize',13);

            hPerson = uicontrol('Style','popupmenu',...
                                'Position',[150 385 85 30],...
                                'Tooltipstring','search for a person',...
                                'FontName','Trebuchet',...
                                'FontSize',13,...
                                'String',{'','cpm0','vmh0','arc0','aem0','adc0','alk0',...
                                            'aeb0','alr0','bgt0','tlg0','bma1','apb0',...
                                            'add0','blv0','bcg0','bcg1'});

            hSentenceIDText = uicontrol('Style','text',...
                                       'Position',[260 410 90 30],...
                                       'String','SentenceID',...
                                       'FontName','Trebuchet',...
                                       'FontSize',13);

            hSentenceID = uicontrol('Style','edit',...
                                    'FontName','Trebuchet',...
                                    'FontSize',13,...
                                    'Tooltipstring','search for a sentence',...
                                    'Position',[245 390 90 30]);

            hWordsText = uicontrol('Style','text',...
                                   'Position',[365 410 150 30],...
                                   'String','Words',...
                                   'FontName','Trebuchet',...
                                   'FontSize',13);

            hWords = uicontrol('Style','edit',...
                               'FontName','Trebuchet',...
                               'FontSize',13,...
                               'Tooltipstring','search for words',...
                               'Position',[360 390 150 30]);

            hPhonemsText = uicontrol('Style','text',...
                                     'Position',[535 410 150 30],...
                                     'String','Phonems',...
                                     'FontName','Trebuchet',...
                                     'FontSize',13);

            hPhonems = uicontrol('Style','edit',...
                                 'FontName','Trebuchet',...
                                 'FontSize',13,...
                                 'Tooltipstring','search for phonems',...
                                 'Position',[535 390 150 30]);

            hSearch = uicontrol('Style','pushbutton',...
                                'FontName','Trebuchet',...
                                'Enable','off',...
                                'FontSize',13,...
                                'FontWeight','bold',...
                                'Position',[600 320 100 35],...
                                'String','Search',...
                                'Tooltipstring','start your search',...
                                'Callback',@(hObject,callbackdata,handles)obj.searchCallback);
                            
              hSTFT = uicontrol('Style','pushbutton',...
                                'FontName','Trebuchet',...
                                'Enable','off',...
                                'FontSize',13,...
                                'FontWeight','bold',...
                                'Position',[600 280 100 35],...
                                'String','STFT',...
                                'Tooltipstring','Short-Time-Fourier-Transform of the selected .wav-file',...
                                'Callback',@(hObject,callbackdata,handles)obj.STFTCallback);
                            
            hConsole = uicontrol('Style','pushbutton',...
                                'FontName','Trebuchet',...
                                'Enable','off',...
                                'FontSize',13,...
                                'FontWeight','bold',...
                                'Position',[600 240 100 35],...
                                'String','CWresults',...
                                'Tooltipstring','save results in Command-Window-variable ''results''',...
                                'Callback',@(hObject,callbackdata,handles)obj.consoleCallback);

            hResults = uicontrol('Style','listbox',...
                                 'FontName','Trebuchet',...
                                 'FontSize',13,...
                                 'Enable','off',...
                                 'Position',[50 45 350 300],...
                                 'String','',...
                                 'Tooltipstring','results of your search',...
                                 'Callback',@(hObject,callbackdata,handles)obj.resultsCallback);

            hPlay = uicontrol('Style','togglebutton',...
                              'FontName','Trebuchet',...
                              'Enable','off',...
                              'FontSize',13,...
                              'FontWeight','bold',...
                              'Position',[450 50 100 35],...
                              'String','Play',...
                              'Tooltipstring','play the chosen .wav-file',...
                              'Callback',@(hObject,callbackdata,handles)obj.playCallback);

            hStop = uicontrol('Style','pushbutton',...
                              'FontName','Trebuchet',...
                              'Enable','off',...
                              'FontSize',13,...
                              'FontWeight','bold',...
                              'Position',[600 50 100 35],...
                              'String','Stop',...
                              'Tooltipstring','stop playing',...
                              'Callback',@(hObject,callbackdata,handles)obj.stopCallback);
            align([hGenderText hPersonText hSentenceIDText hWordsText hPhonemsText],'distribute','middle');            
            align([hGender hPerson hSentenceID hWords hPhonems],'distribute','bottom');

            obj.Handles = struct('hFigure',hFigure,...
                             'hDirectory',hDirectory,...
                             'hDirInfo',hDirInfo,...
                             'hGender',hGender,...
                             'hPerson',hPerson,...
                             'hSentenceID',hSentenceID,...
                             'hWords',hWords,...
                             'hPhonems',hPhonems,...
                             'hSearch',hSearch,...
                             'hFFT',hSTFT,...
                             'hConsole',hConsole,...
                             'hResults',hResults,...
                             'hPlay',hPlay,...
                             'hStop',hStop);
        end
        
        
        function updateGUI(obj)       
            if ~isempty(obj.DatabaseObj.Database)
                obj.Handles.hDirInfo.String = 'Database successfully loaded';
                obj.Handles.hSearch.Enable = 'on';
            end
            obj.Handles.hFigure.Visible = 'on';
        end
        
        
        function directoryCallback(obj)
            obj.DatabaseObj.loadDatabase(obj.Handles.hDirectory.String);
        end
        
        
        function searchCallback(obj)
            gender = obj.Handles.hGender.String(obj.Handles.hGender.Value);
            switch gender{1}
                case 'Male'
                    gender = 'm';
                case 'Female'
                    gender = 'f';
            end
            person = obj.Handles.hPerson.String(obj.Handles.hPerson.Value);
            sentenceID = obj.Handles.hSentenceID.String;
            words = obj.Handles.hWords.String;
            phonems = obj.Handles.hPhonems.String;
            obj.DatabaseObj.searchDatabase(gender, person{1}, sentenceID, words, phonems)
        end
        
        
        function resultsCallback(obj)
            selectedDirectory = obj.Handles.hResults.String(obj.Handles.hResults.Value);
            obj.currentAudio = AudioPlayer(selectedDirectory{1});
        end
        
        
        function playCallback(obj)
            if  obj.Handles.hPlay.Value
                set(obj.currentAudio.Player,'StopFcn',@(hObject,eventdata,handels)obj.stopCallback);
                resume(obj.currentAudio.Player)
                obj.Handles.hPlay.String = 'Pause';
            else
                set(obj.currentAudio.Player,'StopFcn',@(hObject,eventdata,handles)disp(''));
                pause(obj.currentAudio.Player)
                obj.Handles.hPlay.String = 'Resume';
            end
        end
        
        
        function stopCallback(obj)
            stop(obj.currentAudio.Player)
            obj.Handles.hPlay.String = 'Play';
            obj.Handles.hPlay.Value = 0;
        end
        
        
        function STFTCallback(obj)
            header = strcat('Kurzzeit-Fourier-Transformation von dir: ',obj.Handles.hResults.String(obj.Handles.hResults.Value));
            [mFrames, vTimeFrame] = Windowing(obj.currentAudio.Data, obj.currentAudio.Fs, 0.030, 0.005);
            vAnalysisWindow= hann(size(mFrames,2),'periodic');
            [ mSTFT, vFreq ] = STFT( mFrames, obj.currentAudio.Fs, vAnalysisWindow);
            hfig = figure('Tag','FFT_Window_Plot',...
                          'Visible','off',...
                          'Resize','off',...
                          'NumberTitle','off',...
                          'Name','STFT Signal',...
                          'Position',[400 400 640 448]);
            imagesc(vTimeFrame, vFreq, 10*log10(max(abs(mSTFT).^2,10^(-15))))
            axis xy
            xlabel 'Zeit in s'
            ylabel 'Frequenz in Hz'
            title (header)
            movegui(hfig,'center')
            hfig.Visible = 'on';
        end
        
        
        function consoleCallback(obj)
            assignin('base','results',obj.DatabaseObj.Results);
            evalin('base','results');
        end
        
    end
end