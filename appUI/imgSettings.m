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

% Create SampleEditFieldLabel
SampleEditFieldLabel = uilabel(SampleImageOptionsPanel);
SampleEditFieldLabel.HorizontalAlignment = 'right';
SampleEditFieldLabel.FontSize = 18;
SampleEditFieldLabel.Position = [142 382 66 22];
SampleEditFieldLabel.Text = 'Sample';

% Create SampleEditField
SampleEditField = uieditfield(SampleImageOptionsPanel, 'numeric');
SampleEditField.HorizontalAlignment = 'left';
SampleEditField.FontSize = 18;
SampleEditField.Position = [223 381 52 23];
SampleEditField.Value = imgIndex;
SampleEditField.Editable = 'off';

% Create MagnificationxEditFieldLabel
MagnificationxEditFieldLabel = uilabel(SampleImageOptionsPanel);
MagnificationxEditFieldLabel.HorizontalAlignment = 'right';
MagnificationxEditFieldLabel.FontSize = 18;
MagnificationxEditFieldLabel.Position = [94 309 116 22];
MagnificationxEditFieldLabel.Text = 'Magnification';

% Create MagnificationxEditField
MagnificationxEditField = uieditfield(SampleImageOptionsPanel, 'numeric');
MagnificationxEditField.HorizontalAlignment = 'left';
MagnificationxEditField.FontSize = 18;
MagnificationxEditField.Position = [223 309 100 23];
MagnificationxEditField.Value = getImage(app, imgIndex).zoom;
MagnificationxEditField.ValueChangedFcn = @(src,event)changeImage(app,imgIndex,'zoom',event.Value);

% Create TimeButtonGroup
TimeButtonGroup = uibuttongroup(SampleImageOptionsPanel);
TimeButtonGroup.AutoResizeChildren = 'off';
TimeButtonGroup.Title = 'Time';
TimeButtonGroup.FontSize = 18;
TimeButtonGroup.Position = [82 156 256 106];

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

% Create UpButton
UpButton = uibutton(myPanel, 'push');
UpButton.FontSize = 20;
UpButton.Position = [10 509 37 32];
UpButton.Text = '▲';
UpButton.ButtonPushedFcn = @(src,event)moveImgUp(app,imgIndex);

% Create DownButton
DownButton = uibutton(myPanel, 'push');
DownButton.FontSize = 20;
DownButton.Position = [53 509 37 32];
DownButton.Text = '▼';
DownButton.ButtonPushedFcn = @(src,event)moveImgDown(app,imgIndex);

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
