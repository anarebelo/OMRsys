function result =  rowpositionbeam(beam,NewnoteHead,spaceHeight,lineHeight)

result = 0;
value = beam(1) - NewnoteHead(2);
value1 = NewnoteHead(1) - beam(2);
if value > 0 &  value > spaceHeight/2-lineHeight & value < 12 * spaceHeight
    result = 1;
elseif value1 > 0 & value1 > spaceHeight/2-lineHeight &  value1 < 12 * spaceHeight
    result = 1;
end

return