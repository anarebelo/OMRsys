function [models, vectorParametersRests, vectorParameters] = read_models()

trebleClef = dlmread('models\trebleClef.csv',';'); %1
bassClef   = dlmread('models\bassClef.csv',';'); %2
altoClef1  = dlmread('models\altoClef.csv',';'); %3
vectorParameters = {trebleClef; bassClef; altoClef1}; 

%Read rests matrix
quarter = dlmread('models\quarter.csv',';');
quaver   = dlmread('models\quaver.csv',';');
semiquaver  = dlmread('models\semiquaver.csv',';');
demisemiquaver  = dlmread('models\demisemiquaver.csv',';');
hemidemisemiquaver  = dlmread('models\hemidemisemiquaver.csv',';'); %8
vectorParametersRests = {quarter; quaver; semiquaver; demisemiquaver;hemidemisemiquaver};

%Read accidentals matrix
flat = dlmread('models\flat.csv',';');
natural   = dlmread('models\natural.csv',';');
sharp  = dlmread('models\sharp.csv',';'); %11
vectorParametersAccidentals = {flat; natural; sharp};

%Read time signature matrix
bartimesignature0  = dlmread('models\0bartimesignature.csv',';'); %12
bartimesignature1  = dlmread('models\1bartimesignature.csv',';');
bartimesignature2  = dlmread('models\2bartimesignature.csv',';');
bartimesignature3  = dlmread('models\3bartimesignature.csv',';'); %15
bartimesignature4  = dlmread('models\4bartimesignature.csv',';');
bartimesignature5  = dlmread('models\5bartimesignature.csv',';');
bartimesignature6  = dlmread('models\6bartimesignature.csv',';');
bartimesignature7  = dlmread('models\7bartimesignature.csv',';');
bartimesignature8  = dlmread('models\8bartimesignature.csv',';'); %20
bartimesignature9  = dlmread('models\9bartimesignature.csv',';'); %21
cbartimesignature  = dlmread('models\cbartimesignature.csv',';');
ctimesignature     = dlmread('models\ctimesignature.csv',';'); %23

vectorParametersTS = {bartimesignature0; bartimesignature1; bartimesignature2; bartimesignature3; bartimesignature4;...
    bartimesignature5; bartimesignature6; bartimesignature7; bartimesignature8; bartimesignature9;...
    cbartimesignature; ctimesignature};

breve  = dlmread('models\breve.csv',';'); %24
semibreve     = dlmread('models\semibreve.csv',';'); %25
vectorParameterssemibreve = {breve; semibreve};

dot     = dlmread('models\dot.csv',';');
vectorParametersdot = {dot};

turn           = dlmread('models\turn.csv',';'); %27
dynamic        = dlmread('models\dynamic.csv',';');
fermata        = dlmread('models\fermata.csv',';');
harmonic       = dlmread('models\harmonic.csv',';'); %30
marcato        = dlmread('models\marcato.csv',';');
mordent        = dlmread('models\mordent.csv',';');
staccatissimo  = dlmread('models\staccatissimo.csv',';'); %33
staccato       = dlmread('models\staccato.csv',';');
stopped        = dlmread('models\stopped.csv',';');
tenuto         = dlmread('models\tenuto.csv',';'); %36
vectorParametersaccent = {turn; dynamic; fermata; harmonic; marcato; mordent; staccatissimo; staccato; stopped; tenuto};

barlines     = dlmread('models\barlines.csv',';'); %37
vectorParametersbarlines = {barlines};

wholehalf     = dlmread('models\wholehalf.csv',';');
vectorParameterswholehalf = {wholehalf};

doublewhole     = dlmread('models\doublewhole.csv',';'); %39
vectorParametersdoublewhole = {doublewhole};

beam1     = dlmread('models\beam1.csv',';');
beam2     = dlmread('models\beam2.csv',';');
beam3     = dlmread('models\beam3.csv',';');
beam4     = dlmread('models\beam4.csv',';'); %43
vectorParametersbeam= {beam1; beam2; beam3; beam4};

note1b     = dlmread('models\note1b.csv',';'); %44
note1bsf   = dlmread('models\note1bsf.csv',';'); %45
note1c     = dlmread('models\note1c.csv',';'); %46
note1csf   = dlmread('models\note1csf.csv',';'); %47
note2b     = dlmread('models\note2b.csv',';'); %48
note2c     = dlmread('models\note2c.csv',';'); %49
note3b     = dlmread('models\note3b.csv',';'); %50
note3c     = dlmread('models\note3c.csv',';'); %51
note4b     = dlmread('models\note4b.csv',';'); %52
note4c     = dlmread('models\note4c.csv',';'); %53
vectorParametersnotes= {note1b; note1bsf; note1c; note1csf; note2b; note2c; note3b; note3c; note4b; note4c};

opennoteb     = dlmread('models\opennoteb.csv',';'); %54
opennotec     = dlmread('models\opennotec.csv',';'); %55
vectorParametersopennotes= {opennoteb;opennotec};

models = [vectorParameters; vectorParametersRests; vectorParametersAccidentals; vectorParametersTS; vectorParameterssemibreve; vectorParametersdot; ...
    vectorParametersaccent; vectorParametersbarlines; vectorParameterswholehalf; vectorParametersdoublewhole; vectorParametersbeam; vectorParametersnotes; ...
    vectorParametersopennotes];