
% A2 E-stop Button

classdef app1 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure     matlab.ui.Figure
        ESTOPButton  matlab.ui.control.Button
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: ESTOPButton
        function ESTOPButtonPushed(app, event)
        EstopFlag = 1; % Set EstopFlag global bool variable to 1 when E-STOP button pressed in gui
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [1 1 0];
            app.UIFigure.Position = [100 100 140 150];
            app.UIFigure.Name = 'MATLAB App';

            % Create ESTOPButton
            app.ESTOPButton = uibutton(app.UIFigure, 'push');
            app.ESTOPButton.ButtonPushedFcn = createCallbackFcn(app, @ESTOPButtonPushed, true);
            app.ESTOPButton.BackgroundColor = [1 0 0];
            app.ESTOPButton.FontWeight = 'bold';
            app.ESTOPButton.Position = [21 65 100 22];
            app.ESTOPButton.Text = 'E-STOP';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app1

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end

