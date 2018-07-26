function [histog] = ObtainHistograms(result, divisions)

    a = histogram(result,0:1:40);
    norma = norm(a.Values);
    histog = a.Values/norm(a.Values);
    %hist(:,jj) = a.Values/norm(a.Values);
    [r, c]= size(result);%r-rows,c-columns,p-planes


    if divisions > 1
        for rows=0:1
            for cols=0:1
                div_1=result((r/2)*rows+1:r/2*(rows+1),(c/2)*cols+1:c/2*(cols+1));
                hist_1 = histogram(div_1,0:1:40);
                histog = [histog hist_1.Values/norma];
            end
        end    
    end

    if divisions > 2
        for rows=0:3
            for cols=0:3
                div_2=result((r/4)*rows+1:r/4*(rows+1),(c/4)*cols+1:c/4*(cols+1));
                hist_2 = histogram(div_2,0:1:40);
                histog = [histog hist_2.Values/norma];
            end
        end       
    end
    
    if divisions > 3
        %%Second Division
        for rows=0:7
            for cols=0:7
                div_3=result((r/8)*rows+1:r/8*(rows+1),(c/8)*cols+1:c/8*(cols+1));
                hist_3 = histogram(div_3,0:1:40);
                histog = [histog hist_3.Values/norma];
            end
        end
    end

end
