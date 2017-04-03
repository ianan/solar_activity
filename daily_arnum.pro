pro daily_arnum,year=year,rdnar=rdnar

  ; Brute force way to get the daily number of NOAA AR from HEK for a specified year
  ; maybe a better idea to do via rd_nar.pro etc - use the rdnar flag instead
  ; https://hesperia.gsfc.nasa.gov/ssw/gen/idl/fund_lib/yohkoh/
  ;
  ;
  ; 01-Feb-2017 IGH
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`
  ;

  if (n_elements(year) ne 1) then year='2017'
  tws='01-Jan-'+year
  ; More than needed but makes sure we get all the days that year
  nf=367
  days=strarr(nf)
  yrfrc=dblarr(nf)

  for i=0,nf-1 do begin
    days[i]=anytim(anytim(tws)+i*24*60.*60.,/yoh,/trunc,/date)
    temp=anytim(days[i]+' 00:00:00',/utc_ex)
    yeart=temp.year
    yrs=string(yeart,format='(i4)')
    yrsp=string(yeart+1,format='(i4)')
    yrfrc[i]=yeart+$
      (anytim(days[i]+' 00:00:00')-anytim('01-Jan-'+yrs))/(anytim('01-Jan-'+yrsp)-anytim('01-Jan-'+yrs))
  endfor
  nna=intarr(nf)

  ; Double check if working with current year
  caldat,julday(),cmon,cday,cyear

  if (year eq string(cyear,format='(i4)')) then begin
    ;Number of days passed this year?
    nft=floor(julday()-julday(01,01,cyear))
  endif else begin
    ; If not current year can loop over all days
    nft=nf
  endelse

  ; Can't get the data for the future!
  if (long(year) gt cyear) then begin
    print,'Warning future date!'
    stop
  endif

  for i=0,nft-1 do begin
    day=days[i]
    print,i+1, '  --   ',nft,'   ', day

    if keyword_set(rdnar) then begin
;      set_logenv,'DIR_GEN_NAR','/usr/local/sswdb/ydb/nar'
      rd_nar,day+' 00:00',day+' 23:59',ars

      if size(ars,/tname) eq 'STRUCT' then begin
        aii=unique(ars.noaa)
        ; Save number of unique NOAA AR that day
        nna[i]=n_elements(aii)
      endif
    endif else begin

      ars = ssw_her_query(ssw_her_make_query(day+' 00:00',day+' 23:59',/ar,search_array='frm_name=NOAA SWPC Observer'))

      if size(ars,/tname) eq 'STRUCT' then begin
        aii=unique(ars.ar.ar_noaanum)
        ; Save number of unique NOAA AR that day
        nna[i]=n_elements(aii)
      endif
    endelse

    if ((i mod 20) eq 0) then save, file=year+'_noaa_ar.dat',days,yrfrc,nna
  endfor

  save, file=year+'_noaa_ar.dat',days,yrfrc,nna

  stop

end