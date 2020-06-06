function [] = writeModelChanges(modelChanges,fileName,date)
%writeModelChanges  Write model rxn and met change structure(s) to file(s).
%
% USAGE:
%
%   writeModelChanges(modelChanges, fileName, date);
%
% INPUT:
%
%   modelChanges   A structure generated by the docModelChanges function
%                  that contains information on changed model reaction-
%                  and/or metabolite-related fields. See docModelChanges
%                  for more detail on what this structure contains.
%
%   fileName       Name of file to write to. If modelChanges contains
%                  changes to both reactions and metabolites, two files
%                  will be written and their filenames will be appended
%                  with "_rxns" and "_mets", respectively. If an extension
%                  is not provided, ".tsv" will be used.
%
%   date           (Opt, default TRUE) print out the date in the first
%                  line of output file, or not if FALSE.
%


% handle input arguments
if nargin < 3
    date = true;
end

% need to identify extension in case filename is to be appended
extension = char(regexp(fileName,'\.\w{2,4}$','match'));
if isempty(extension)
    extension = '.tsv';
else
    fileName = regexprep(fileName,strcat(extension,'$'),'');
end

% prepare output filenames
if isempty(modelChanges.rxns)
    fileNameMet = strcat(fileName,extension);
elseif isempty(modelChanges.mets)
    fileNameRxn = strcat(fileName,extension);
else
    fileNameMet = strcat(fileName,'_mets',extension);
    fileNameRxn = strcat(fileName,'_rxns',extension);
end

if ~isempty(modelChanges.rxns)
    % organize reaction change information into an array format
    rxnChg = modelChanges.rxns;
    rxnChgArray = [fieldnames(rxnChg)';
                  [rxnChg.rxns, rxnChg.eqnOrig, rxnChg.eqnNew,...
                  num2cell([rxnChg.lbOrig, rxnChg.lbNew, ...
                  rxnChg.ubOrig, rxnChg.ubNew]), rxnChg.grRuleOrig, ...
                  rxnChg.grRuleNew, rxnChg.notes]];

    % write to file
    writecell2file(rxnChgArray,fileNameRxn,true,'\t','%s\t%s\t%s\t%f\t%f\t%f\t%f\t%s\t%s\t%s\n',date);
end

if ~isempty(modelChanges.mets)
    % organize metabolite change information into an array format
    metChg = modelChanges.mets;
    metChgArray = [fieldnames(metChg)';
                  [metChg.mets, metChg.nameOrig, metChg.nameNew,...
                  metChg.formulaOrig, metChg.formulaNew, ...
                  num2cell([metChg.chargeOrig, metChg.chargeNew]), ...
                  metChg.notes]];

    % write to file
    writecell2file(metChgArray,fileNameMet,true,'\t','%s\t%s\t%s\t%s\t%s\t%d\t%d\t%s\n',date);
end

