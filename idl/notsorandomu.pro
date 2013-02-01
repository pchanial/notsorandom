; emulate randomu, by reading random values from an external file

function notsorandomu, seed, d1, d2, d3, d4, d5, double=double
    on_error, 2
    case n_params() of
       0 : message, 'Incorrect number of arguments.'
       1 : return, notsorandomn(seed, /uniform, double=double)
       2 : return, notsorandomn(seed, d1, /uniform, double=double)
       3 : return, notsorandomn(seed, d1, d2, /uniform, double=double)
       4 : return, notsorandomn(seed, d1, d2, d3, /uniform, double=double)
       5 : return, notsorandomn(seed, d1, d2, d3, d4, /uniform, double=double)
       6 : return, notsorandomn(seed, d1, d2, d3, d4, d5, /uniform, $
                                double=double)
    endcase
end
