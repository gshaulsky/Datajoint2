function h=jvAddJPETH(h)
% jvAddJPETH addpanel function
% 
% Example:
% h=jvAddPETH(h)
%
% -------------------------------------------------------------------------
% Author: Malcolm Lidierth 11/07
% Copyright � The Author & King's College London 2007-
% -------------------------------------------------------------------------


Height=0.09;
Top=0.75;

h=jvAddPanel(h, 'Title', 'Details',...
    'dimension', 0.6);



h=jvElement(h{end},'Component', 'javax.swing.JComboBox',...
    'Position',[0.1 Top 0.8 Height],...
    'DisplayList', {'0.1' '0.2' '0.5' '1.0' '2.0'},...
    'Label', 'Duration(s)',...
    'ToolTipText', 'Duraion of average (s)');

h=jvElement(h{end},'Component', 'javax.swing.JComboBox',...
    'Position',[0.1 Top-(2*Height) 0.8 Height],...
    'DisplayList', {'0.001' '0.002' '0.005' '0.01' '0.02'},...
    'Label', 'Bin Width(s)',...
    'ToolTipText', 'PETH Bin Width (s)');

h=jvElement(h{end},'Component', 'javax.swing.JComboBox',...
    'Position',[0.1 Top-(4*Height) 0.8 Height],...
    'DisplayList', {'0' '10' '20' '50'},...
    'ReturnValues', {0 10 20 50},...
    'Label', 'PreTime(%)',...
    'ToolTipText', 'Pre-trigger time');

c=methods('jpeth');
idx=strfind(c, 'get');
for k=1:length(idx)
    if isempty(idx{k})
        c{k}=[];
    else
        switch c{k}
            case {'getMatrix' 'getXcorr' 'getBinWidth' 'getCoincidence' 'getMode' 'getLabel'}
                c{k}=[];
            otherwise
                str=c{k};
                c{k}=str(4:end);
        end
    end
end
idx=1;
for k=1:length(c)
    if ~isempty(c{k})
        c1{idx}=c{k}; %#ok<AGROW>
        idx=idx+1;
    end
end

h=jvElement(h{end},'Component', 'javax.swing.JComboBox',...
    'Position',[0.1 Top-(6*Height) 0.8 Height],...
    'DisplayList', c1,...
    'ReturnValues', c1,...
    'Label', 'Mode',...
    'ToolTipText', 'Analysis Mode');


h=jvElement(h{end},'Component', 'javax.swing.JCheckBox',...
    'Position',[0.03 Top-(8*Height) 0.48 Height],...
    'Label', 'Symmetric',...
    'ToolTipText', 'Use triggers falling within a sweep');


h=jvElement(h{end},'Component', 'javax.swing.JComboBox',...
    'Position',[0.55 Top-(8*Height) 0.4 Height],...
    'DisplayList', {'None' '3' '5' '7' '9'},...
    'Label', 'Filter Width',...
    'ToolTipText', 'Filter Width');

return
end

