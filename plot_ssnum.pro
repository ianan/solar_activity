pro plot_ssnum

  ; Load in the sunspot numbers
  ; montly numbers from http://www.sidc.be/silso/DATA/SN_m_tot_V2.0.txt
  infile='SN_m_tot_V2.0.txt'
  restore, file='sun_template.sav'
  ss=read_ascii(infile,template=sun_template)
  
  ; make a nice plot
  dim=[500,350]

  xr=[1996,2019.5]
  yrm=2400
  
  ssc='cornflower';'medium blue'
  
  
  ; stairstep type line as decimal_date at bin mids
  ;  pss=plot(ss.decimal_date,ss.month_tot_sun_num,/stairstep,xtitle='Year',ytitle='Sunspot Number',xrange=xr,$
  ;    font_name='Helvetica',font_size=14,thick=2,position=[0.15,0.15,0.95,0.95],dimension=dim,/buffer,yrange=[0,249],color=ssc)
    pss=barplot(ss.decimal_date,ss.month_tot_sun_num,xtitle='Year',ytitle='Sunspot Number',xrange=xr,$
    font_name='Helvetica',font_size=14,thick=1,position=[0.15,0.15,0.95,0.95],dimension=dim,/buffer,yrange=[0,249],color=ssc)

  ax = pss.axes
  ax[2].hide = 1 
  ax[3].hide = 1  
    
  hgt=720
;  pss.save,'activity_ssnum.png',height=hgt,width=hgt*dim[0]/dim[1]
  pss.save,'activity_ssnum.pdf',page_size=dim/100.

  pss.close

stop
end