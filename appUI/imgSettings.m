function imgSettings(app,myPanel,imgIndex)
% projSettings - when called, create the elements for specific Image Settings panel

% Create TabGroup
TabGroup = uitabgroup(myPanel);
TabGroup.AutoResizeChildren = 'off';
TabGroup.Position = [0 1 679 501];

% Create ImageTab
ImageTab = uitab(TabGroup);
ImageTab.AutoResizeChildren = 'off';
ImageTab.Title = 'Image';

% Create SampleImageOptionsPanel
SampleImageOptionsPanel = uipanel(ImageTab);
SampleImageOptionsPanel.AutoResizeChildren = 'off';
SampleImageOptionsPanel.Title = 'Sample Image Options';
SampleImageOptionsPanel.FontWeight = 'bold';
SampleImageOptionsPanel.FontSize = 18;
SampleImageOptionsPanel.Position = [8 10 416 458];

% Create NameEditFieldLabel
NameEditFieldLabel = uilabel(SampleImageOptionsPanel);
NameEditFieldLabel.HorizontalAlignment = 'right';
NameEditFieldLabel.FontSize = 18;
NameEditFieldLabel.Position = [46 386 53 22];
NameEditFieldLabel.Text = 'Name';

% Create NameEditField
NameEditField = uieditfield(SampleImageOptionsPanel, 'text');
NameEditField.FontSize = 18;
NameEditField.Position = [114 382 256 26];
% Set initial value to current Image Name
NameEditField.Value = char(getImage(app, imgIndex).imgName);
% When field is changed, save new Image Name
NameEditField.ValueChangedFcn = @(src,event)changeImage(app,imgIndex,'imgName',string(event.Value));

% Create SampleEditFieldLabel
SampleEditFieldLabel = uilabel(SampleImageOptionsPanel);
SampleEditFieldLabel.HorizontalAlignment = 'right';
SampleEditFieldLabel.FontSize = 18;
SampleEditFieldLabel.Position = [117 329 66 22];
SampleEditFieldLabel.Text = 'Sample';

% Create SampleEditField
SampleEditField = uieditfield(SampleImageOptionsPanel, 'numeric');
SampleEditField.HorizontalAlignment = 'left';
SampleEditField.FontSize = 18;
SampleEditField.Position = [198 328 100 23];
SampleEditField.Value = getImage(app, imgIndex).sample;
SampleEditField.ValueChangedFcn = @(src,event)changeImage(app,imgIndex,'sample',event.Value);

% Create MagnificationxEditFieldLabel
MagnificationxEditFieldLabel = uilabel(SampleImageOptionsPanel);
MagnificationxEditFieldLabel.HorizontalAlignment = 'right';
MagnificationxEditFieldLabel.FontSize = 18;
MagnificationxEditFieldLabel.Position = [83 118 125 22];
MagnificationxEditFieldLabel.Text = 'Magnification x';

% Create MagnificationxEditField
MagnificationxEditField = uieditfield(SampleImageOptionsPanel, 'numeric');
MagnificationxEditField.HorizontalAlignment = 'left';
MagnificationxEditField.FontSize = 18;
MagnificationxEditField.Position = [207 117 116 23];
MagnificationxEditField.Value = getImage(app, imgIndex).zoom;
MagnificationxEditField.ValueChangedFcn = @(src,event)changeImage(app,imgIndex,'zoom',event.Value);

% Create TimeButtonGroup
TimeButtonGroup = uibuttongroup(SampleImageOptionsPanel);
TimeButtonGroup.AutoResizeChildren = 'off';
TimeButtonGroup.Title = 'Time';
TimeButtonGroup.FontSize = 18;
TimeButtonGroup.Position = [80 176 256 106];

% Create HoursButton
HoursButton = uiradiobutton(TimeButtonGroup);
HoursButton.Text = 'Hours';
HoursButton.FontSize = 18;
HoursButton.Position = [11 53 70 22];
HoursButton.Value = true;

% Create DaysButton
DaysButton = uiradiobutton(TimeButtonGroup);
DaysButton.Text = 'Days';
DaysButton.FontSize = 18;
DaysButton.Position = [11 18 63 22];

% Create HoursTimeField
HoursTimeField = uieditfield(TimeButtonGroup, 'numeric');
HoursTimeField.FontSize = 18;
HoursTimeField.Position = [143 52 100 23];
HoursTimeField.Value = getImage(app, imgIndex).timeHrs;
HoursTimeField.ValueChangedFcn = @(src,event)changeImage(app,imgIndex,'timeHrs',event.Value);

% Create DaysTimeField
DaysTimeField = uieditfield(TimeButtonGroup, 'numeric');
DaysTimeField.FontSize = 18;
DaysTimeField.Position = [143 18 100 23];
DaysTimeField.Value = getImage(app, imgIndex).timeDays;
DaysTimeField.ValueChangedFcn = @(src,event)changeImage(app,imgIndex,'timeDays',event.Value);

% Add a Callback Function to the TimeButtonGroup
TimeButtonGroup.SelectionChangedFcn = @(src,event)swapTime(app,imgIndex,HoursTimeField,DaysTimeField,event.NewValue.Text);

% Create FileEditFieldLabel
FileEditFieldLabel = uilabel(SampleImageOptionsPanel);
FileEditFieldLabel.HorizontalAlignment = 'right';
FileEditFieldLabel.FontSize = 18;
FileEditFieldLabel.Position = [65 72 34 22];
FileEditFieldLabel.Text = 'File';

% Create FileEditField
FileEditField = uieditfield(SampleImageOptionsPanel, 'text');
FileEditField.Editable = 'off';
FileEditField.FontSize = 18;
FileEditField.Position = [114 68 256 26];
FileEditField.Value = char(getImage(app, imgIndex).fileName);

% Create AddFileButton
AddFileButton = uibutton(SampleImageOptionsPanel, 'push');
AddFileButton.FontSize = 18;
AddFileButton.Position = [168 30 100 29];
AddFileButton.Text = 'Add File';
AddFileButton.ButtonPushedFcn = @(src,event)changeFile(app,imgIndex,FileEditField);


% Create SaveButton
SaveButton = uibutton(myPanel, 'push');
SaveButton.FontSize = 18;
SaveButton.Position = [558 509 100 29];
SaveButton.Text = 'Save';
SaveButton.ButtonPushedFcn = @(src,event)refreshTree(app);

end

function swapTime(app,imgIndex,HoursTimeField,DaysTimeField,toEnable)
    changeImage(app,imgIndex,'time',toEnable);
    % What are we changing to?
    if(toEnable == "Hours")
        % Enable the new box
        HoursTimeField.Enable = 'on';
        % Disable the old one
        DaysTimeField.Enable = 'off';
    elseif(toEnable == "Days")
        DaysTimeField.Enable = 'on';
        HoursTimeField.Enable = 'off';
    end
end

function changeFile(app,imgIndex,FileEditField)
    % Load the file picker, save the output values
    [newFile, newPath] = uigetfile('.tif');

    % If they gave a new file, the values should be returned
    if (newPath ~= 0)
           % Save the output values back in the Data table
        changeImage(app,imgIndex,'fileName',newFile);
        changeImage(app,imgIndex,'filePath',newPath);
    end

    % Update the File text box to show the new file's name
    FileEditField.Value = char(getImage(app, imgIndex).fileName);
end
