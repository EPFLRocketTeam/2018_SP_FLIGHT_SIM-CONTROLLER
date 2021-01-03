function CAN_COM(t,x,f,m,p,T,obj)
    if 1==0
        to_output = transpose([ t ; x ;f*1000/(9.80665*m); p;T ]);
        dlmwrite('test.csv',to_output,'-append');
    else
        if t>0.3

        end
        to_raw = transpose([ t ; x ;f*1000/(9.80665*m); p;T ]);
        dlmwrite('raw.csv',to_raw,'-append');
        RAW = readtable('raw.csv');

        TN = readtable('log.csv', 'HeaderLines',1);
        t1=t(end);
        if t1==0
            t_max = 1;
            dlmwrite('log.csv',transpose([ t ; x ;f*1000/(9.80665*m); p;T ]),'-append');

        else
            
            t_max = TN{end,1};
        end
        
        if (t1 > t_max + 0.01)
        
            bound = floor(100*t1)/100;

            [~, index] = unique(RAW{:,1}); 
            X = interp1(RAW{:,1}(index), RAW{:,2}(index) , 0.0: 0.01 : bound, 'pchip', 'extrap');  
            Y = interp1(RAW{:,1}(index), RAW{:,3}(index) , 0.0: 0.01 : bound, 'pchip', 'extrap');  
            Z = interp1(RAW{:,1}(index), RAW{:,4}(index) , 0.0: 0.01 : bound, 'pchip', 'extrap');  
            AX = interp1(RAW{:,1}(index), RAW{:,5}(index) , 0.0: 0.01 : bound, 'pchip', 'extrap');  
            AY = interp1(RAW{:,1}(index), RAW{:,6}(index) , 0.0: 0.01 : bound, 'pchip', 'extrap');  
            AZ = interp1(RAW{:,1}(index), RAW{:,7}(index) , 0.0: 0.01 : bound, 'pchip', 'extrap'); 
            P = interp1(RAW{:,1}(index), RAW{:,8}(index) , 0.0: 0.01 : bound, 'pchip', 'extrap');  
            T = interp1(RAW{:,1}(index), RAW{:,9}(index) , 0.0: 0.01 : bound, 'pchip', 'extrap');  

            to_log = [ 0: 0.01 : bound;X;Y;Z; AX ; AY ; AZ ; P ;T];
            number = round((bound-t_max)*100)
            for in = 1:number
                alph=round(number-in);
                to_log(end-9*(alph)-8:end-9*alph);
                dlmwrite('log.csv',to_log(end-9*(alph)-8:end-9*alph),'-append');
            end
            %dlmwrite('log.csv',to_log(end-8:end),'-append');


            if ( mod(bound*100,5) == 0 || (number+mod(bound*100,5) >=5) )
                IN = -1
                while( IN == -1)
                    IN=readtable('angle.csv');% changer le nom
                    IN = IN{1,1}
                end
                  dlmwrite('angle.csv',[-1;-1;-1;-1]);

                  obj.Rocket.ab_n = 7;
                  obj.Rocket.ab_phi = IN; % rentrer -1 dans IN
            end
            
        end
    end

end
