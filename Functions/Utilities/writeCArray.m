function cArray = writeCArray(matArray)

    cArray = ['{ '];
    for i = 1:(length(matArray)-1)
        cArray = [cArray num2str(matArray(i)) ', '];
    end
    cArray = [cArray num2str(matArray(end)) ' }'];
end