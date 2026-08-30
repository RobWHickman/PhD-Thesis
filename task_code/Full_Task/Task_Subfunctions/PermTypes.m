function Vec   = PermTypes(NTrials, type1, type2)

    A = ones(1,NTrials/2); B = type2*A; A = type1*A; X = [A, B];
    Vec = X(randperm(length(X)));

end