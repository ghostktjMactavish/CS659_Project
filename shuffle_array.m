function shuffled = shuffle_array(ca)
    n = numel(ca);
    shuffled = ca(randperm(n));
end

