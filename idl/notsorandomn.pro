; emulate randomn, by reading random values from an external file

function notsorandomn, seed, d1, d2, d3, d4, d5, d6, uniform=uniform, normal=normal, double=double
    common common_myrandom, datan, posn, datau, posu
    on_error, 2
    
    idl_dir = '/home/chanial/software/share/notsorandom/'
    
    if not keyword_set(uniform) then normal = 1
    
    if n_params() eq 0 then begin
       message, 'Incorrect number of arguments.'
    endif
    if n_params() ge 2 and n_elements(d1) eq 0 then begin
       message, 'Variable is undefined: D1.'
    endif
    if n_params() ge 3 and n_elements(d2) eq 0 then begin
       message, 'Variable is undefined: D2.'
    endif
    if n_params() ge 4 and n_elements(d3) eq 0 then begin
       message, 'Variable is undefined: D3.'
    endif
    if n_params() ge 5 and n_elements(d4) eq 0 then begin
       message, 'Variable is undefined: D4.'
    endif
    if n_params() ge 6 and n_elements(d5) eq 0 then begin
       message, 'Variable is undefined: D5.'
    endif

    on_error, 0

    case n_params() of
       1 : dims = [1]
       2 : dims = [d1]
       3 : dims = [d1, d2]
       4 : dims = [d1, d2, d3]
       5 : dims = [d1, d2, d3, d4]
       6 : dims = [d1, d2, d3, d4, d5]
    endcase

    n = 1l
    for idim=0, n_elements(dims) - 1 do begin
       n = n * dims[idim]
    endfor
    
    if keyword_set(normal) then begin
       if n_elements(datan) eq 0 then begin
          datan = ptr_new(readfits(idl_dir + 'randomn.fits', /silent))
          posn = 0
       endif
       data = datan
       pos = posn
    endif else begin
       if n_elements(datau) eq 0 then begin
          datau = ptr_new(readfits(idl_dir + 'randomu.fits', /silent))
          posu = 0
       endif
       data = datau
       pos = posu
    endelse
    
    maxsize = n_elements(*data)
    output = make_array(n, double=double, /nozero)
    
    ; copy data in chunks of maxsize
    for k = 0, ceil(float(n) / maxsize) - 1 do begin
        a = k * maxsize
        z = min([(k + 1) * maxsize, n]) - 1
        avail = min([maxsize - pos, z - a + 1])
        if avail gt 0 then begin
            output[a:a+avail-1] = (*data)[pos:pos+avail-1]
        endif
        pos = pos + avail
        if avail lt z - a + 1 then begin
            output[a+avail:z] = (*data)[0:z-a-avail]
            pos = z - a + 1 - avail
        endif
    endfor

    if keyword_set(normal) then begin
       posn = pos
    endif else begin
       posu = pos
    endelse
    
    if n_params() eq 1 then begin
        output = output[0]
    endif else begin
       output = reform(output, dims, /overwrite)
    endelse

    return, output

end
