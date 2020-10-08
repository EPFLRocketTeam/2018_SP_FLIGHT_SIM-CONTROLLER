function CAN_COM(t,f,m,p)
        to_output = transpose([ t ; f*1000/(9.80665*m); p ]);
        dlmwrite('test.csv',to_output,'-append');
end
