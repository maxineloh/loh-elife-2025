function [data] = sexDifferences(data,mal,fem,animalnumber)

    for abc = animalnumber
        if sum(contains(mal,data(abc).animal))
            data(abc).sex = 'm';
        elseif sum(contains(fem,data(abc).animal))
            data(abc).sex = 'f';
        end
    end
end

