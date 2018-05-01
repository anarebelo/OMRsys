function symbolBar=findBars(newSymbol1,MaxdistancesBetweenElements)
kk=1;
symbolBar=[];
p=[];

if size(newSymbol1,1)>1
    flag=-1;
    for l=1:size(newSymbol1,1)-1
        value=newSymbol1(l+1,1)-newSymbol1(l,2);
        if value>0
            if flag==2 & size(p,2)~=0
                symbolBar(kk,:)=[newSymbol1(p(1),1) newSymbol1(p(end),2) min(newSymbol1(p(1),3),newSymbol1(p(end),3)) max(newSymbol1(p(1),4),newSymbol1(p(end),4))];
                kk=kk+1;
                p=[];
                flag=-1;
            else
                if value<=MaxdistancesBetweenElements & newSymbol1(l+1,3)>=newSymbol1(l,3) & newSymbol1(l+1,3)<=newSymbol1(l,4)
                    p=[p l l+1];
                    flag=0;
                else
                    if size(p,2)~=0
                        symbolBar(kk,:)=[newSymbol1(p(1),1) newSymbol1(p(end),2) min(newSymbol1(p(1),3),newSymbol1(p(end),3)) max(newSymbol1(p(1),4),newSymbol1(p(end),4))];
                        kk=kk+1;
                        p=[];
                        flag=1;
                    else
                        symbolBar(kk,:)=newSymbol1(l,1:4);
                        kk=kk+1;
                        flag=1;
                    end
                end
                if l==size(newSymbol1,1)-1 && flag==1
                    symbolBar(kk,:)=newSymbol1(size(newSymbol1,1),1:4);
                elseif l==size(newSymbol1,1)-1 && flag==0
                    p=[p size(newSymbol1,1)];
                    symbolBar(kk,:)=[newSymbol1(p(1),1) newSymbol1(p(end),2) min(newSymbol1(p(1),3),newSymbol1(p(end),3)) max(newSymbol1(p(1),4),newSymbol1(p(end),4))];
                end
            end
        else
            if newSymbol1(l+1,1)>newSymbol1(l,1) & newSymbol1(l+1,1)<newSymbol1(l,2) & newSymbol1(l+1,3)>=newSymbol1(l,3) & newSymbol1(l+1,3)<=newSymbol1(l,4)
                p=[p l l+1];
                flag=0;
            else
                if size(p,2)~=0
                    symbolBar(kk,:)=[newSymbol1(p(1),1) newSymbol1(p(end),2) min(newSymbol1(p(1),3),newSymbol1(p(end),3)) max(newSymbol1(p(1),4),newSymbol1(p(end),4))];
                    kk=kk+1;
                    p=[];
                    flag=1;
                else
                    symbolBar(kk,:)=newSymbol1(l,1:4);
                    kk=kk+1;
                    flag=1;
                end
            end
            if l==size(newSymbol1,1)-1 && flag==1
                symbolBar(kk,:)=newSymbol1(size(newSymbol1,1),1:4);
            elseif l==size(newSymbol1,1)-1 && flag==0
                p=[p size(newSymbol1,1)];
                symbolBar(kk,:)=[newSymbol1(p(1),1) newSymbol1(p(end),2) min(newSymbol1(p(1),3),newSymbol1(p(end),3)) max(newSymbol1(p(1),4),newSymbol1(p(end),4))];
            end
            flag=2;
        end
    end
elseif size(newSymbol1,1)~=0 & size(newSymbol1,1)==1
    symbolBar=newSymbol1(1,1:4);
end