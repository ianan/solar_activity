pro plot_activity_ssar

  ; Load in the sunspot numbers
  ; montly numbers from http://www.sidc.be/silso/DATA/SN_m_tot_V2.0.txt
  infile='SN_m_tot_V2.0.txt'
  restore, file='sun_template.sav'
  ss=read_ascii(infile,template=sun_template)

  ; make a nice plot
  dim=[500,600]

  xr=[2009,2018.6]
  yrm=2400

  ; made from daily_arnum.pro
  ff=file_search('noaa_ar/*_noaa*.dat',count=nf)
  ;  dd=''
  yf=0.
  noaa=0

  for i=0,nf-1 do begin
    restore,ff[i]
    yf=[yf,yrfrc]
    noaa=[noaa,nna]
  endfor

  yf=yf[1:n_elements(yy)-1]
  noaa=noaa[1:n_elements(nn)-1]
  ; just incase there is overlap
  gdd=uniq(yf)
  yf=yf[gdd]
  noaa=noaa[gdd]

  ssc='steel blue'
  nac='indian red';'cadet blue'

  ; histogram type line as xhist bin starts
  phist=plot(yf,smooth(noaa,7),/histogram,xtitle='',ytitle='< Daily NOAA AR >',xrange=xr,yrange=[0,12],ymajor=4,$
    font_name='Helvetica',font_size=13,thick=2,position=[0.15,0.575,0.95,0.925],dimension=dim,/buffer,color=nac)

  ; stairstep type line as decimal_date at bin mids
  pss=plot(ss.decimal_date,ss.month_tot_sun_num,/stairstep,xtitle='Year',ytitle='Sunspot Number',xrange=xr,$
    font_name='Helvetica',font_size=13,thick=2,position=[0.15,0.125,0.95,0.475],/current,yrange=[0,160],color=ssc)

  tt2=text(10,10,'Data from hek and http://www.sidc.be/silso/DATA/SN_m_tot_V2.0.txt',color='black',font_size=5, target=pp,/device)

  ;  phist.save,'activity_ssar_C24.pdf',page_size=[5,6]
  phist.save,'activity_ssar_C24.png',height=504,width=840
  phist.close

  xr=[1996,2018.6]
  ; Do it our a longer time range 2000 to 2017
  ; histogram type line as xhist bin starts
  phist=plot(yf,smooth(noaa,7),/histogram,xtitle='',ytitle='< Daily NOAA AR >',xrange=xr,yrange=[0,16],$
    font_name='Helvetica',font_size=13,thick=2,position=[0.15,0.575,0.95,0.925],dimension=dim,/buffer,ymajor=4,color=nac)


  ; stairstep type line as decimal_date at bin mids
  pss=plot(ss.decimal_date,ss.month_tot_sun_num,/stairstep,xtitle='Year',ytitle='Sunspot Number',xrange=xr,$
    font_name='Helvetica',font_size=13,thick=2,position=[0.15,0.125,0.95,0.475],/current,yrange=[0,250],color=ssc)

  tt2=text(10,10,'Data from hek and http://www.sidc.be/silso/DATA/SN_m_tot_V2.0.txt',color='black',font_size=5, target=pp,/device)


  ;  phist.save,'activity_ssar_C2324.pdf',page_size=[5,6]
  phist.save,'activity_ssar_C2324.png',height=504,width=840
  phist.close
  stop
end