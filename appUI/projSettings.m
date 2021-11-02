function projSettings(app,myPanel)
% projSettings - when called, creates all elements for the Project Settings panel

% Create DatasetNameEditFieldLabel
DatasetNameEditFieldLabel = uilabel(myPanel);
DatasetNameEditFieldLabel.HorizontalAlignment = 'right';
DatasetNameEditFieldLabel.FontSize = 18;
DatasetNameEditFieldLabel.Position = [9 518 120 22];
DatasetNameEditFieldLabel.Text = 'Dataset Name';

% Create DatasetNameEditField
DatasetNameEditField = uieditfield(myPanel, 'text');
DatasetNameEditField.FontSize = 18;
DatasetNameEditField.Position = [144 514 334 26];
DatasetNameEditField.Value = getSetting(app,'general','SetName');

% Create SaveButton
SaveButton = uibutton(myPanel, 'push');
SaveButton.FontSize = 18;
SaveButton.Position = [558 509 100 29];
SaveButton.Text = 'Save';
SaveButton.ButtonPushedFcn = @(src,event)changeDatasetName(app,DatasetNameEditField.Value);

% Create TabGroup
TabGroup = uitabgroup(myPanel);
TabGroup.Position = [1 1 679 501];

% Create InputTab
InputTab = uitab(TabGroup);
InputTab.Title = 'Input';

% Create ProcessingOptionsPanel
ProcessingOptionsPanel = uipanel(InputTab);
ProcessingOptionsPanel.Title = 'Processing Options';
ProcessingOptionsPanel.FontWeight = 'bold';
ProcessingOptionsPanel.FontSize = 18;
ProcessingOptionsPanel.Position = [8 10 241 458];

% Create MethodButtonGroup
MethodButtonGroup = uibuttongroup(ProcessingOptionsPanel);
MethodButtonGroup.Title = 'Method ';
MethodButtonGroup.FontWeight = 'bold';
MethodButtonGroup.FontSize = 18;
MethodButtonGroup.Position = [28 273 190 126];
MethodButtonGroup.SelectionChangedFcn = @(src,event)changeSetting(app,'imgProcessing','Method',event.NewValue.Text);

% Create UnconnectedButton
UnconnectedButton = uitogglebutton(MethodButtonGroup);
UnconnectedButton.Text = 'Unconnected';
UnconnectedButton.FontSize = 18;
UnconnectedButton.Position = [17 59 150 29];

% Create ConnectedButton
ConnectedButton = uitogglebutton(MethodButtonGroup);
ConnectedButton.Text = 'Connected';
ConnectedButton.FontSize = 18;
ConnectedButton.Position = [18 18 150 29];
ConnectedButton.Value = true;

% Set Active MethodButton
selMethod = getSetting(app,'imgProcessing','Method');
if(selMethod == "Unconnected")
    UnconnectedButton.Value = true;
    ConnectedButton.Value = false;
elseif (selMethod == "Connected")
    UnconnectedButton.Value = false;
    ConnectedButton.Value = true;
end

% Create BorderMethodButtonGroup
BorderMethodButtonGroup = uibuttongroup(ProcessingOptionsPanel);
BorderMethodButtonGroup.Title = 'Border Method';
BorderMethodButtonGroup.FontWeight = 'bold';
BorderMethodButtonGroup.FontSize = 18;
BorderMethodButtonGroup.Position = [29 122 190 126];
BorderMethodButtonGroup.SelectionChangedFcn = @(src,event)changeSetting(app,'imgProcessing','BorderMethod',event.NewValue.Text);

% Create RemoveButton
RemoveButton = uitogglebutton(BorderMethodButtonGroup);
RemoveButton.Text = 'Remove';
RemoveButton.FontSize = 18;
RemoveButton.Position = [17 59 150 29];

% Create ReduceButton
ReduceButton = uitogglebutton(BorderMethodButtonGroup);
ReduceButton.Text = 'Reduce';
ReduceButton.FontSize = 18;
ReduceButton.Position = [18 18 150 29];

% Set Active BorderMethodButton
selBorderMethod = getSetting(app,'imgProcessing','BorderMethod');
if(selBorderMethod == "Remove")
    RemoveButton.Value = true;
    ReduceButton.Value = false;
elseif (selBorderMethod == "Reduce")
    RemoveButton.Value = false;
    ReduceButton.Value = true;
end

% Create InvertColourButton
InvertColourButton = uibutton(ProcessingOptionsPanel, 'state');
InvertColourButton.Text = 'Invert Colour';
InvertColourButton.FontSize = 18;
InvertColourButton.Position = [47 71 148 29];
InvertColourButton.ValueChangedFcn = @(src,event)changeSetting(app,'imgProcessing','InvertColour',logical(event.Value));
InvertColourButton.Value = logical(getSetting(app,'imgProcessing','InvertColour'));

% Create StatisticsConfigPanel
StatisticsConfigPanel = uipanel(InputTab);
StatisticsConfigPanel.Title = 'Statistics Config';
StatisticsConfigPanel.FontWeight = 'bold';
StatisticsConfigPanel.FontSize = 18;
StatisticsConfigPanel.Position = [262 11 403 457];

% Create RadialBinsEditFieldLabel
RadialBinsEditFieldLabel = uilabel(StatisticsConfigPanel);
RadialBinsEditFieldLabel.HorizontalAlignment = 'center';
RadialBinsEditFieldLabel.FontSize = 18;
RadialBinsEditFieldLabel.Position = [40 397 101 22];
RadialBinsEditFieldLabel.Text = 'Radial Bins';

% Create RadialBinsEditField
RadialBinsEditField = uieditfield(StatisticsConfigPanel, 'numeric');
RadialBinsEditField.FontSize = 18;
RadialBinsEditField.Position = [40 366 101 23];
RadialBinsEditField.ValueChangedFcn = @(src,event)changeSetting(app,'stats','RadialBins',event.Value);
RadialBinsEditField.Value = getSetting(app,'stats','RadialBins');

% Create AnglarBinsEditFieldLabel
AngularBinsEditFieldLabel = uilabel(StatisticsConfigPanel);
AngularBinsEditFieldLabel.HorizontalAlignment = 'center';
AngularBinsEditFieldLabel.FontSize = 18;
AngularBinsEditFieldLabel.Position = [161 397 102 22];
AngularBinsEditFieldLabel.Text = 'Angular Bins';

% Create AnglarBinsEditField
AngularBinsEditField = uieditfield(StatisticsConfigPanel, 'numeric');
AngularBinsEditField.FontSize = 18;
AngularBinsEditField.Position = [161 366 99 23];
AngularBinsEditField.ValueChangedFcn = @(src,event)changeSetting(app,'stats','AngularBins',event.Value);
AngularBinsEditField.Value = getSetting(app,'stats','AngularBins');

% Create PairBinsEditFieldLabel
PairBinsEditFieldLabel = uilabel(StatisticsConfigPanel);
PairBinsEditFieldLabel.HorizontalAlignment = 'center';
PairBinsEditFieldLabel.FontSize = 18;
PairBinsEditFieldLabel.Position = [291 397 79 22];
PairBinsEditFieldLabel.Text = 'Pair Bins';

% Create PairBinsEditField
PairBinsEditField = uieditfield(StatisticsConfigPanel, 'numeric');
PairBinsEditField.FontSize = 18;
PairBinsEditField.Position = [280 366 100 23];
PairBinsEditField.ValueChangedFcn = @(src,event)changeSetting(app,'stats','PairBins',event.Value);
PairBinsEditField.Value = getSetting(app,'stats','PairBins');

% Create MaximumPairPixelsEditFieldLabel
MaximumPairPixelsEditFieldLabel = uilabel(StatisticsConfigPanel);
MaximumPairPixelsEditFieldLabel.HorizontalAlignment = 'center';
MaximumPairPixelsEditFieldLabel.FontSize = 18;
MaximumPairPixelsEditFieldLabel.Position = [72 308 90 42];
MaximumPairPixelsEditFieldLabel.Text = {'Maximum'; 'Pair Pixels'};

% Create MaximumPairPixelsEditField
MaximumPairPixelsEditField = uieditfield(StatisticsConfigPanel, 'numeric');
MaximumPairPixelsEditField.FontSize = 18;
MaximumPairPixelsEditField.Position = [48 281 140 23];
MaximumPairPixelsEditField.ValueChangedFcn = @(src,event)changeSetting(app,'stats','MaxCells',event.Value);
MaximumPairPixelsEditField.Value = getSetting(app,'stats','MaxCells');

% Create PairSamplesEditFieldLabel
PairSamplesEditFieldLabel = uilabel(StatisticsConfigPanel);
PairSamplesEditFieldLabel.HorizontalAlignment = 'center';
PairSamplesEditFieldLabel.FontSize = 18;
PairSamplesEditFieldLabel.Position = [255 308 75 42];
PairSamplesEditFieldLabel.Text = {'Pair'; 'Samples'};

% Create PairSamplesEditField
PairSamplesEditField = uieditfield(StatisticsConfigPanel, 'numeric');
PairSamplesEditField.FontSize = 18;
PairSamplesEditField.Position = [223 281 140 23];
PairSamplesEditField.ValueChangedFcn = @(src,event)changeSetting(app,'stats','PairSamples',event.Value);
PairSamplesEditField.Value = getSetting(app,'stats','PairSamples');

% Create RadiusMethodButtonGroup
RadiusMethodButtonGroup = uibuttongroup(StatisticsConfigPanel);
RadiusMethodButtonGroup.Title = 'Radius Method';
RadiusMethodButtonGroup.FontWeight = 'bold';
RadiusMethodButtonGroup.FontSize = 18;
RadiusMethodButtonGroup.Position = [18 121 177 126];
RadiusMethodButtonGroup.SelectionChangedFcn = @(src,event)changeSetting(app,'stats','RadiusMethod',event.NewValue.Text);

% Create CSRButton
CSRButton = uitogglebutton(RadiusMethodButtonGroup);
CSRButton.Text = 'CSR';
CSRButton.FontSize = 18;
CSRButton.Position = [15 58 150 29];

% Create PushButton
PushButton = uitogglebutton(RadiusMethodButtonGroup);
PushButton.Text = 'Push';
PushButton.FontSize = 18;
PushButton.Position = [15 21 150 29];

% Set Active RadiusMethodButton
radiusMethod = getSetting(app,'stats','RadiusMethod');
if(radiusMethod == "CSR")
    CSRButton.Value = true;
    PushButton.Value = false;
elseif (radiusMethod == "Push")
    CSRButton.Value = false;
    PushButton.Value = true;
end

% Create CentralDataButton
CentralDataButton = uibutton(StatisticsConfigPanel, 'state');
CentralDataButton.Text = 'Central Data';
CentralDataButton.FontSize = 18;
CentralDataButton.Position = [231 183 148 29];
CentralDataButton.ValueChangedFcn = @(src,event)changeSetting(app,'stats','CentreData',logical(event.Value));
CentralDataButton.Value = logical(getSetting(app,'stats','CentreData'));

% Create AnalyseAnnulusButton
AnalyseAnnulusButton = uibutton(StatisticsConfigPanel, 'state');
AnalyseAnnulusButton.Text = 'Analyse Annulus';
AnalyseAnnulusButton.FontSize = 18;
AnalyseAnnulusButton.Position = [230 146 149 29];
AnalyseAnnulusButton.ValueChangedFcn = @(src,event)changeSetting(app,'stats','Annulus',logical(event.Value));
AnalyseAnnulusButton.Value = logical(getSetting(app,'stats','Annulus'));

% Create RadiusMethodProportionLabel
RadiusMethodProportionLabel = uilabel(StatisticsConfigPanel);
RadiusMethodProportionLabel.HorizontalAlignment = 'center';
RadiusMethodProportionLabel.VerticalAlignment = 'top';
RadiusMethodProportionLabel.FontSize = 18;
RadiusMethodProportionLabel.FontWeight = 'bold';
RadiusMethodProportionLabel.Position = [48 70 320 30];
RadiusMethodProportionLabel.Text = 'Radius Method Proportion';

% Create RadiusMethodProportion
RadiusMethodProportion = uislider(StatisticsConfigPanel);
RadiusMethodProportion.Limits = [0 1];
RadiusMethodProportion.MajorTicks = [0 0.2 0.4 0.6 0.8 1];
RadiusMethodProportion.FontSize = 18;
RadiusMethodProportion.FontWeight = 'bold';
RadiusMethodProportion.Position = [32 58 353 3];
RadiusMethodProportion.ValueChangedFcn = @(src,event)changeSetting(app,'stats','RadiusProportion',event.Value);
RadiusMethodProportion.Value = getSetting(app,'stats','RadiusProportion');

% Create OutputTab
OutputTab = uitab(TabGroup);
OutputTab.Title = 'Output';

% Create ExportFilesPanel
ExportFilesPanel = uipanel(OutputTab);
ExportFilesPanel.Title = 'Export Files';
ExportFilesPanel.FontWeight = 'bold';
ExportFilesPanel.FontSize = 18;
ExportFilesPanel.Position = [8 11 206 455];

% Create BinaryImagesButton
BinaryImagesButton = uibutton(ExportFilesPanel, 'state');
BinaryImagesButton.Text = 'Binary Images';
BinaryImagesButton.FontSize = 18;
BinaryImagesButton.Position = [10 348 187 29];
BinaryImagesButton.ValueChangedFcn = @(src,event)changeSetting(app,'exportFiles','SaveBinary',logical(event.Value));
BinaryImagesButton.Value = logical(getSetting(app,'exportFiles','SaveBinary'));

% Create BinaryCSVButton
BinaryCSVButton = uibutton(ExportFilesPanel, 'state');
BinaryCSVButton.Text = 'Binary CSV';
BinaryCSVButton.FontSize = 18;
BinaryCSVButton.Position = [11 308 187 29];
BinaryCSVButton.ValueChangedFcn = @(src,event)changeSetting(app,'exportFiles','SaveBinaryCSV',logical(event.Value));
BinaryCSVButton.Value = logical(getSetting(app,'exportFiles','SaveBinaryCSV'));

% Create BinaryMATButton
BinaryMATButton = uibutton(ExportFilesPanel, 'state');
BinaryMATButton.Text = 'Binary MAT';
BinaryMATButton.FontSize = 18;
BinaryMATButton.Position = [11 266 187 29];
BinaryMATButton.ValueChangedFcn = @(src,event)changeSetting(app,'exportFiles','SaveBinaryMAT',logical(event.Value));
BinaryMATButton.Value = logical(getSetting(app,'exportFiles','SaveBinaryMAT'));

% Create ComparisonImagesButton
ComparisonImagesButton = uibutton(ExportFilesPanel, 'state');
ComparisonImagesButton.Text = 'Comparison Images';
ComparisonImagesButton.FontSize = 18;
ComparisonImagesButton.Position = [11 174 187 29];
ComparisonImagesButton.ValueChangedFcn = @(src,event)changeSetting(app,'exportFiles','SaveComparison',logical(event.Value));
ComparisonImagesButton.Value = logical(getSetting(app,'exportFiles','SaveComparison'));
%%% Button Disabled - feature not currently supported
ComparisonImagesButton.Enable = 'off';

% Create StatisticsCSVButton
StatisticsCSVButton = uibutton(ExportFilesPanel, 'state');
StatisticsCSVButton.Text = 'Statistics CSV';
StatisticsCSVButton.FontSize = 18;
StatisticsCSVButton.Position = [11 58 187 29];
StatisticsCSVButton.ValueChangedFcn = @(src,event)changeSetting(app,'exportFiles','SaveStatsCSV',logical(event.Value));
StatisticsCSVButton.Value = logical(getSetting(app,'exportFiles','SaveStatsCSV'));

% Create StatisticsMATButton
StatisticsMATButton = uibutton(ExportFilesPanel, 'state');
StatisticsMATButton.Text = 'Statistics MAT';
StatisticsMATButton.FontSize = 18;
StatisticsMATButton.Position = [11 19 187 29];
StatisticsMATButton.ValueChangedFcn = @(src,event)changeSetting(app,'exportFiles','SaveStatsMAT',logical(event.Value));
StatisticsMATButton.Value = logical(getSetting(app,'exportFiles','SaveStatsMAT'));

% Create ExportOptionsPanel
ExportOptionsPanel = uipanel(OutputTab);
ExportOptionsPanel.Title = 'Export Options';
ExportOptionsPanel.FontWeight = 'bold';
ExportOptionsPanel.FontSize = 18;
ExportOptionsPanel.Position = [251 11 206 455];

% Create IntensityPlotsButton
IntensityPlotsButton = uibutton(ExportOptionsPanel, 'state');
IntensityPlotsButton.Text = 'Intensity Plots';
IntensityPlotsButton.FontSize = 18;
IntensityPlotsButton.Position = [13 352 187 29];
IntensityPlotsButton.ValueChangedFcn = @(src,event)changeSetting(app,'exportOpt','SaveIntensity',logical(event.Value));
IntensityPlotsButton.Value = logical(getSetting(app,'exportOpt','SaveIntensity'));
%%% Button Disabled - feature not currently supported
IntensityPlotsButton.Enable = 'off';

% Create IntensitywithErrorButton
IntensitywithErrorButton = uibutton(ExportOptionsPanel, 'state');
IntensitywithErrorButton.Text = 'Intensity with Error';
IntensitywithErrorButton.FontSize = 18;
IntensitywithErrorButton.Position = [13 316 187 29];
IntensitywithErrorButton.ValueChangedFcn = @(src,event)changeSetting(app,'exportOpt','SaveError',logical(event.Value));
IntensitywithErrorButton.Value = logical(getSetting(app,'exportOpt','SaveError'));
%%% Button Disabled - feature not currently supported
IntensitywithErrorButton.Enable = 'off';


% Create FourierCoefficientsButton
FourierCoefficientsButton = uibutton(ExportOptionsPanel, 'state');
FourierCoefficientsButton.Text = 'Fourier Coefficients';
FourierCoefficientsButton.FontSize = 18;
FourierCoefficientsButton.Position = [12 219 187 29];
FourierCoefficientsButton.ValueChangedFcn = @(src,event)changeSetting(app,'exportOpt','SaveFourier',logical(event.Value));
FourierCoefficientsButton.Value = logical(getSetting(app,'exportOpt','SaveFourier'));

% Create WaveNumbersButton
WaveNumbersButton = uibutton(ExportOptionsPanel, 'state');
WaveNumbersButton.Text = 'Wave Numbers';
WaveNumbersButton.FontSize = 18;
WaveNumbersButton.Position = [13 183 187 29];
WaveNumbersButton.ValueChangedFcn = @(src,event)changeSetting(app,'exportOpt','SaveWave',logical(event.Value));
WaveNumbersButton.Value = logical(getSetting(app,'exportOpt','SaveWave'));

% Create RadialMetricButton
RadialMetricButton = uibutton(ExportOptionsPanel, 'state');
RadialMetricButton.Text = 'Radial Metric';
RadialMetricButton.FontSize = 18;
RadialMetricButton.Position = [11 109 187 29];
RadialMetricButton.ValueChangedFcn = @(src,event)changeSetting(app,'exportOpt','SaveFR',logical(event.Value));
RadialMetricButton.Value = logical(getSetting(app,'exportOpt','SaveFR'));

% Create AngluarMetricButton
AngluarMetricButton = uibutton(ExportOptionsPanel, 'state');
AngluarMetricButton.Text = 'Angluar Metric';
AngluarMetricButton.FontSize = 18;
AngluarMetricButton.Position = [10 70 187 29];
AngluarMetricButton.ValueChangedFcn = @(src,event)changeSetting(app,'exportOpt','SaveFA',logical(event.Value));
AngluarMetricButton.Value = logical(getSetting(app,'exportOpt','SaveFA'));

% Create PairMetricButton
PairMetricButton = uibutton(ExportOptionsPanel, 'state');
PairMetricButton.Text = 'Pair Metric';
PairMetricButton.FontSize = 18;
PairMetricButton.Position = [10 31 187 29];
PairMetricButton.ValueChangedFcn = @(src,event)changeSetting(app,'exportOpt','SaveFP',logical(event.Value));
PairMetricButton.Value = logical(getSetting(app,'exportOpt','SaveFP'));

% Create OutputImageFormatButtonGroup
OutputImageFormatButtonGroup = uibuttongroup(OutputTab);
OutputImageFormatButtonGroup.Title = 'Output Image Format';
OutputImageFormatButtonGroup.FontSize = 18;
OutputImageFormatButtonGroup.Position = [476 281 181 185];
OutputImageFormatButtonGroup.SelectionChangedFcn = @(src,event)changeSetting(app,'exportOpt','ImageExtensionOut',event.NewValue.Text);

% Create tifButton
tifButton = uitogglebutton(OutputImageFormatButtonGroup);
tifButton.Text = 'tif';
tifButton.FontSize = 18;
tifButton.Position = [11 120 162 29];

% Create bmpButton
bmpButton = uitogglebutton(OutputImageFormatButtonGroup);
bmpButton.Text = 'bmp';
bmpButton.FontSize = 18;
bmpButton.Position = [11 84 161 29];

% Create pngButton
pngButton = uitogglebutton(OutputImageFormatButtonGroup);
pngButton.Text = 'png';
pngButton.FontSize = 18;
pngButton.Position = [12 46 160 29];

% Create jpgButton
jpgButton = uitogglebutton(OutputImageFormatButtonGroup);
jpgButton.Text = 'jpg';
jpgButton.FontSize = 18;
jpgButton.Position = [13 10 160 29];

% Set Active OutputImageFormatButton
imgOutExtn = getSetting(app,'exportOpt','ImageExtensionOut');
    if(imgOutExtn == "tif")
        tifButton.Value = true;
    elseif (imgOutExtn == "bmp")
        bmpButton.Value = true;
    elseif (imgOutExtn == "png")
        pngButton.Value = true;
    elseif (imgOutExtn == "jpg")
        jpgButton.Value = true;
    end
end

