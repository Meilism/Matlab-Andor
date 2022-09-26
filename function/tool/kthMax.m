function Max = kthMax(A,k)
    if k>length(A(:))
        error('Index exceeds number of array elements')
    end
    M = maxk(A(:),k);
    Max = M(k);
end