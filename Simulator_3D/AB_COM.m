function AB_COM(t,f,m,p,Rocket)
        to_raw = transpose([ t ; f*1000/(9.80665*m); p ]);
        dlmwrite('raw.csv',to_raw,'-append');
        RAW = readtable('raw.csv');
        T = readtable('log.csv', 'HeaderLines',1);

        t_max = T(end:1);
        
        if (t > t_max + 0.01)
        
            bound = floor(100*t)/100;

            [~, index] = unique(RAW{:,1}); 
            AX = interp1(RAW{:,1}(index), RAW{:,2}(index) , 0.0: 0.01 : bound, 'pchip', 'extrap');  
            AY = interp1(RAW{:,1}(index), RAW{:,3}(index) , 0.0: 0.01 : bound, 'pchip', 'extrap');  
            AZ = interp1(RAW{:,1}(index), RAW{:,4}(index) , 0.0: 0.01 : bound, 'pchip', 'extrap');  
            P = interp1(RAW{:,1}(index), RAW{:,5}(index) , 0.0: 0.01 : bound, 'pchip', 'extrap');  

            to_log = transpose([ 20.0: 0.01 : bound+20 ; AX ; AY ; AZ ; P ]);

            dlmwrite('log.csv',to_log(end),'-append');

            if ( mod(bound*100,5) == 0)
                IN = -1;
                while( IN == -1)
                    IN=readtable(ab_out); % changer le nom
                end
                  Rocket.AB_angle = IN; % rentrer -1 dans IN
            end
        
        end
        
        
end
