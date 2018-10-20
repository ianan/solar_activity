pro average_goes15_update,oldfile=oldfile

  ; Load in new GOES monlthy averaged csv files, which you've downloaded separately from
  ; http://satdat.ngdc.noaa.gov/sem/goes/data/new_avg/
  ; work out the hourly average in each channel, add this to the previous list and then
  ; save it all out....
  ;
  ; only works if new csv files exist to load in or the oldfile name actually exists as well
  ;
  ; 01-Feb-2017 IGH
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ;

  if (n_elements(oldfile) ne 1) then oldfile='GOES15_60min_newest.dat'

  ; Load in the new files
  restore,file='gcsv_new.dat'
  ff=file_search('g15_xrs*csv',count=nf)
  for i=0l, nf-1 do begin
    print,'loading.... '+ff[i]
    gdata=read_ascii(ff[i],template=gcsv_new)
    ;    read_ges_xrs_csv,ff[i],gtim,glow,ghigh
    gtim=gdata.time
    glow=gdata.low
    ghigh=gdata.high
    if (i eq 0) then time=gtim else time=[time,gtim]
    if (i eq 0) then low=glow else low=[low,glow]
    if (i eq 0) then high=ghigh else high=[high,ghigh]

  endfor
  ;   Get the avergae for the new files
  nt=n_elements(time)
  tr=[time[0],time[nt-1]]

  nt60=(nt/60)-1

  time60=strarr(nt60)
  low60=fltarr(nt60)
  high60=fltarr(nt60)

  nfin=nt60

  timef=strarr(nt)

  for i=0l, nt-1 do timef[i]=strmid(time[i],2,2)+'/'+strmid(time[i],5,2)+'/'+strmid(time[i],8,2)+' '+strmid(time[i],11,8)
  time=timef

  for i=0l, nfin-1 do begin

    if ((i mod 500) eq 0) then print,i,'/',nfin
    time60[i]=anytim(mean(anytim(time[60*i:60*i+59])),/yoh)

    ddl=low[60*i:60*i+59]
    gd=where(ddl gt 0.,ngd)
    if (ngd gt 0) then ddl=ddl[gd]
    low60[i]=mean(ddl)

    ddh=high[60*i:60*i+59]
    gd=where(ddh gt 0.,ngd)
    if (ngd gt 0) then ddh=ddh[gd]
    high60[i]=mean(ddh)

  endfor
  ;
  tr=anytim([anytim(time60[0])-30*60.,anytim(time60[n_elements(time60)-1])+30*60],/yoh,/trunc)

  ;load in the previous file
  restore,file=oldfile
  ;swap the old out names for new in ones
  timsin=tims
  time60in=time60out
  low60in=low60out
  high60in=high60out
  trin=trout

  trout=[trin[0],tr[1]]
  idnew=where(anytim(time60in) lt anytim(time60[0]),nnew)

  time60out=[time60in[idnew],time60]
  low60out=[low60in[idnew],low60]
  high60out=[high60in[idnew],high60]

  nt=n_elements(time60out)

  tims=fltarr(nt)
  tims[idnew]=timsin[idnew]
  ; Just need to work out time fraction for the new ones
  for i=max(idnew)+1,nt-1 do begin
    tt=anytim(time60out[i],/utc_ext)
    year=tt.year
    years=string(tt.year,format='(i4)')
    secs=anytim(time60out[i])-anytim('01-Jan-'+strmid(years,2,2))
    tims[i]=years+secs/(60.*60.*24.*365.25)
  endfor

  tt=anytim(time60out[nt-1],/utc_ext)

  if (tt.month lt 10) then outname=string(tt.year,format='(i4)')+'0'+string(tt.month,format='(i1)') else $
    outname=string(tt.year,format='(i4)')+string(tt.month,format='(i2)')

  save,file='GOES15_60min_'+outname+'.dat',tims,time60out,low60out,high60out,trout

  stop
end
