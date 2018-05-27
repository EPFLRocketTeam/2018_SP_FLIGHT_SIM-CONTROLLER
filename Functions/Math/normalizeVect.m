function v_unit = normalizeVect(v)
    v_norm = norm(v);
    if v_norm == 0
       v_unit = v*0; 
    else
       v_unit = v/v_norm;
    end
end