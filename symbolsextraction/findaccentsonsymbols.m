function accentClass = findaccentsonsymbols(accentClass,setnoteheadstem,imgforfinddots,spaceHeight,lineHeight, flag)

if flag == 1
    name   = fieldnames(setnoteheadstem);
    name   = cell2mat(name);
    notes = getfield( setnoteheadstem, {1,1}, name );
    for j=1:size(notes,1)
        notehead = cell2mat(notes(j,1));
        beam = cell2mat(notes(j,3));
        stem = cell2mat(notes(j,2));
        
        if size(beam,1) == 0
            %Stem down
            if abs(notehead(1)-stem(1)) < abs(notehead(2)-stem(2))
                
                %Above noteheads
                a = max(1,notehead(1)-3*spaceHeight);
                b = min(notehead(1)-lineHeight,size(imgforfinddots,1));
                c = max(1,notehead(3)-2*lineHeight);
                d = min(notehead(4)+2*lineHeight,size(imgforfinddots,2));
                %                 xx(a:b,c:d) = 0.5;
                [accentSymbol]=findAccents(imgforfinddots(a:b,c:d),spaceHeight,lineHeight);
                
                if size(accentSymbol,1)~=0
                    for k = 1:size(accentSymbol,1)
                        accentSymbol1 = [max(1,accentSymbol(k,1)+a) min(size(imgforfinddots,1),accentSymbol(k,2)+a) max(1,accentSymbol(k,3)+c) min(size(imgforfinddots,2),accentSymbol(k,4)+c) accentSymbol(k,5) accentSymbol(k,6)]-1;
                        accentClass = [accentClass; accentSymbol1];
                        %                         xx(accentClass(end,1):accentClass(end,2),accentClass(end,3):accentClass(end,4)) = 0.5;
                    end
                else
                    %Search bellow noteheads
                    a = max(1,stem(2));
                    b = min(stem(2) + 3*spaceHeight,size(imgforfinddots,1));
                    c = max(1,notehead(3)-2*lineHeight);
                    d = min(notehead(4)+2*lineHeight,size(imgforfinddots,2));
                    
                    %                     xx(a:b,c:d) = 0.5;
                    [accentSymbol]=findAccents(imgforfinddots(a:b,c:d),spaceHeight,lineHeight);
                    
                    if size(accentSymbol,1)~=0
                        for k = 1:size(accentSymbol,1)
                            accentSymbol1 = [max(1,accentSymbol(k,1)+a) min(size(imgforfinddots,1),accentSymbol(k,2)+a) max(1,accentSymbol(k,3)+c) min(size(imgforfinddots,2),accentSymbol(k,4)+c) accentSymbol(k,5) accentSymbol(k,6)]-1;
                            accentClass = [accentClass; accentSymbol1];
                            %                             xx(accentClass(end,1):accentClass(end,2),accentClass(end,3):accentClass(end,4)) = 0.5;
                        end
                    end
                end
            else
                %Above noteheads
                a = max(1,stem(1)-3*spaceHeight);
                b = min(stem(1),size(imgforfinddots,1));
                c = max(1,notehead(3)-2*lineHeight);
                d = min(notehead(4)+2*lineHeight,size(imgforfinddots,2));
                
                %                 xx(a:b,c:d) = 0.5;
                [accentSymbol]=findAccents(imgforfinddots(a:b,c:d),spaceHeight,lineHeight);
                
                if size(accentSymbol,1)~=0
                    for k = 1:size(accentSymbol,1)
                        accentSymbol1 = [max(1,accentSymbol(k,1)+a) min(size(imgforfinddots,1),accentSymbol(k,2)+a) max(1,accentSymbol(k,3)+c) min(size(imgforfinddots,2),accentSymbol(k,4)+c) accentSymbol(k,5) accentSymbol(k,6)]-1;
                        accentClass = [accentClass; accentSymbol1];
                        %                         xx(accentClass(end,1):accentClass(end,2),accentClass(end,3):accentClass(end,4)) = 0.5;
                    end
                else
                    %Search bellow noteheads
                    a = max(1,notehead(2)+lineHeight);
                    b = min(notehead(2) + 3*spaceHeight,size(imgforfinddots,1));
                    c = max(1,notehead(3)-2*lineHeight);
                    d = min(notehead(4)+2*lineHeight,size(imgforfinddots,2));
                    
                    %                     xx(a:b,c:d) = 0.5;
                    [accentSymbol]=findAccents(imgforfinddots(a:b,c:d),spaceHeight,lineHeight);
                    
                    if size(accentSymbol,1)~=0
                        for k = 1:size(accentSymbol,1)
                            accentSymbol1 = [max(1,accentSymbol(k,1)+a) min(size(imgforfinddots,1),accentSymbol(k,2)+a) max(1,accentSymbol(k,3)+c) min(size(imgforfinddots,2),accentSymbol(k,4)+c) accentSymbol(k,5) accentSymbol(k,6)]-1;
                            accentClass = [accentClass; accentSymbol1];
                            %                             xx(accentClass(end,1):accentClass(end,2),accentClass(end,3):accentClass(end,4)) = 0.5;
                        end
                    end
                end
            end
        else
            %Stem down
            if abs(notehead(1)-stem(1)) < abs(notehead(2)-stem(2))
                
                %Above noteheads
                a = max(1,notehead(1)-3*spaceHeight);
                b = min(notehead(1)-lineHeight,size(imgforfinddots,1));
                c = max(1,notehead(3)-2*lineHeight);
                d = min(notehead(4)+2*lineHeight,size(imgforfinddots,2));
                
                %                 xx(a:b,c:d) = 0.5;
                [accentSymbol]=findAccents(imgforfinddots(a:b,c:d),spaceHeight,lineHeight);
                
                if size(accentSymbol,1)~=0
                    for k = 1:size(accentSymbol,1)
                        accentSymbol1 = [max(1,accentSymbol(k,1)+a) min(size(imgforfinddots,1),accentSymbol(k,2)+a) max(1,accentSymbol(k,3)+c) min(size(imgforfinddots,2),accentSymbol(k,4)+c) accentSymbol(k,5) accentSymbol(k,6)]-1;
                        accentClass = [accentClass; accentSymbol1];
                        %                         xx(accentClass(end,1):accentClass(end,2),accentClass(end,3):accentClass(end,4)) = 0.5;
                    end
                else
                    %Search bellow noteheads
                    a = max(1,stem(2));
                    b = min(stem(2) + 4*spaceHeight,size(imgforfinddots,1));
                    c = max(1,notehead(3)-2*lineHeight);
                    d = min(notehead(4)+2*lineHeight,size(imgforfinddots,2));
                    
                    %                     xx(a:b,c:d) = 0.5;
                    [accentSymbol]=findAccents(imgforfinddots(a:b,c:d),spaceHeight,lineHeight);
                    
                    
                    if size(accentSymbol,1)~=0
                        for k = 1:size(accentSymbol,1)
                            accentSymbol1 = [max(1,accentSymbol(k,1)+a) min(size(imgforfinddots,1),accentSymbol(k,2)+a) max(1,accentSymbol(k,3)+c) min(size(imgforfinddots,2),accentSymbol(k,4)+c) accentSymbol(k,5) accentSymbol(k,6)]-1;
                            accentClass = [accentClass; accentSymbol1];
                            %                             xx(accentClass(end,1):accentClass(end,2),accentClass(end,3):accentClass(end,4)) = 0.5;
                        end
                    end
                end
            else
                %Above noteheads
                a = max(1,stem(1)-4*spaceHeight);
                b = min(stem(1),size(imgforfinddots,1));
                c = max(1,notehead(3)-2*lineHeight);
                d = min(notehead(4)+2*lineHeight,size(imgforfinddots,2));
                
                %                 xx(a:b,c:d) = 0.5;
                [accentSymbol]=findAccents(imgforfinddots(a:b,c:d),spaceHeight,lineHeight);
                
                if size(accentSymbol,1)~=0
                    for k = 1:size(accentSymbol,1)
                        accentSymbol1 = [max(1,accentSymbol(k,1)+a) min(size(imgforfinddots,1),accentSymbol(k,2)+a) max(1,accentSymbol(k,3)+c) min(size(imgforfinddots,2),accentSymbol(k,4)+c) accentSymbol(k,5) accentSymbol(k,6)]-1;
                        accentClass = [accentClass; accentSymbol1];
                        %                         xx(accentClass(end,1):accentClass(end,2),accentClass(end,3):accentClass(end,4)) = 0.5;
                    end
                    
                    
                else
                    %Search bellow noteheads
                    a = max(1,notehead(2)+lineHeight);
                    b = min(notehead(2) + 3*spaceHeight,size(imgforfinddots,1));
                    c = max(1,notehead(3)-2*lineHeight);
                    d = min(notehead(4)+2*lineHeight,size(imgforfinddots,2));
                    
                    %                     xx(a:b,c:d) = 0.5;
                    [accentSymbol]=findAccents(imgforfinddots(a:b,c:d),spaceHeight,lineHeight);
                    
                    if size(accentSymbol,1)~=0
                        for k = 1:size(accentSymbol,1)
                            accentSymbol1 = [max(1,accentSymbol(k,1)+a) min(size(imgforfinddots,1),accentSymbol(k,2)+a) max(1,accentSymbol(k,3)+c) min(size(imgforfinddots,2),accentSymbol(k,4)+c) accentSymbol(k,5) accentSymbol(k,6)]-1;
                            accentClass = [accentClass; accentSymbol1];
                            %                             xx(accentClass(end,1):accentClass(end,2),accentClass(end,3):accentClass(end,4)) = 0.5;
                        end
                    end
                end
            end
        end
    end
else
    for j=1:size(setnoteheadstem,1)
        notehead = setnoteheadstem(j,:);
 
        %Above noteheads
        a = max(1,notehead(1)-3*spaceHeight);
        b = min(notehead(1)-lineHeight,size(imgforfinddots,1));
        c = max(1,notehead(3)-2*lineHeight);
        d = min(notehead(4)+2*lineHeight,size(imgforfinddots,2));
        
        %                 xx(a:b,c:d) = 0.5;
        [accentSymbol]=findAccents(imgforfinddots(a:b,c:d),spaceHeight,lineHeight);
        
        if size(accentSymbol,1)~=0
            for k = 1:size(accentSymbol,1)
                accentSymbol1 = [max(1,accentSymbol(k,1)+a) min(size(imgforfinddots,1),accentSymbol(k,2)+a) max(1,accentSymbol(k,3)+c) min(size(imgforfinddots,2),accentSymbol(k,4)+c) accentSymbol(k,5) accentSymbol(k,6)]-1;
                accentClass = [accentClass; accentSymbol1];
                %                         xx(accentClass(end,1):accentClass(end,2),accentClass(end,3):accentClass(end,4)) = 0.5;
            end
        else
            %Search bellow noteheads
            a = max(1,notehead(1)+lineHeight);
            b = min(notehead(2) + 3*spaceHeight,size(imgforfinddots,1));
            c = max(1,notehead(3)-2*lineHeight);
            d = min(notehead(4)+2*lineHeight,size(imgforfinddots,2));
            
            %                     xx(a:b,c:d) = 0.5;
            [accentSymbol]=findAccents(imgforfinddots(a:b,c:d),spaceHeight,lineHeight);
            
            if size(accentSymbol,1)~=0
                for k = 1:size(accentSymbol,1)
                    accentSymbol1 = [max(1,accentSymbol(k,1)+a) min(size(imgforfinddots,1),accentSymbol(k,2)+a) max(1,accentSymbol(k,3)+c) min(size(imgforfinddots,2),accentSymbol(k,4)+c) accentSymbol(k,5) accentSymbol(k,6)]-1;
                    accentClass = [accentClass; accentSymbol1];
                    %                             xx(accentClass(end,1):accentClass(end,2),accentClass(end,3):accentClass(end,4)) = 0.5;
                end
            end
        end      
    end
end