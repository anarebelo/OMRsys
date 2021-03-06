function setOfSymbols = main(musicalScores,spaceHeight,lineHeight,dataY,dataX,numberLines,initialpositions,data_staffinfo_sets,count,r,symbolBeams,...
    BeamsClass,accidentalClass,setOfSymbols,degree,models,minStem,MaxdistancesBetweenElements,maxWidthClave,heigthKeySignatures,vectorParametersRests,...
    toleranceStaff,numberSpaces,vectorParameters,orderID, number, val_blackpixels,val_NoteHeads1,val_NoteHeads2,val_NoteHeads3,val_WidthHeightDiag,...
    val_verifyNoteHeadStem1,val_verifyNoteHeadStem2,val_sideFlag,minWidthClave,val_findAccidentals1,val_findAccidentals2,val_findAccidentals3,...
    val_findAccidentals4,val_opennotehead,val_whitepixels)



if orderID == 1
    setOfSymbols = firstmain(musicalScores,spaceHeight,lineHeight,dataY,dataX,numberLines,initialpositions,data_staffinfo_sets,count,r,symbolBeams,...
    BeamsClass,accidentalClass,setOfSymbols,degree,models,minStem,MaxdistancesBetweenElements,maxWidthClave,heigthKeySignatures,vectorParametersRests,...
    toleranceStaff,numberSpaces,vectorParameters,orderID, val_blackpixels,val_NoteHeads1,val_NoteHeads2,val_NoteHeads3,val_WidthHeightDiag,...
    val_verifyNoteHeadStem1,val_verifyNoteHeadStem2,val_sideFlag,minWidthClave,val_findAccidentals1,val_findAccidentals2,val_findAccidentals3,...
    val_findAccidentals4,val_opennotehead,val_whitepixels);
    
else
    setOfSymbols = secondmain(musicalScores,spaceHeight,lineHeight,dataY,dataX,numberLines,initialpositions,data_staffinfo_sets,count,r,symbolBeams,...
    BeamsClass,accidentalClass,setOfSymbols,degree,models,minStem,MaxdistancesBetweenElements,maxWidthClave,vectorParametersRests,...
    toleranceStaff,numberSpaces,val_blackpixels,val_NoteHeads1,val_NoteHeads2,val_NoteHeads3,val_WidthHeightDiag,orderID,...
    val_verifyNoteHeadStem1,val_verifyNoteHeadStem2,val_sideFlag,minWidthClave,val_findAccidentals1,val_findAccidentals2,val_findAccidentals3,...
    val_findAccidentals4,val_opennotehead,val_whitepixels,number);
end