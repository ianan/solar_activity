pro plot_goes15_update

  ; Plot the hourly averaged GOES15 flux using the data file from
  ; average_goes15_update.pro
  ;
  ; GOES15 Data is originally from
  ; https://satdat.ngdc.noaa.gov/sem/goes/data/new_avg/
  ;
  ; 01-Feb-2017 IGH
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ;

  restore,file='GOES15_60min_newest.dat'
  nt=n_elements(time60out)
  tt=anytim(time60out[nt-1],/utc_ext)

  if (tt.month lt 10) then outname=string(tt.year,format='(i4)')+'0'+string(tt.month,format='(i1)') else $
    outname=string(tt.year,format='(i4)')+string(tt.month,format='(i2)')

  id=where(tims gt 2012.5 and tims lt 2013 and low60out lt 4e-8)
  low60out[id]=0.
  high60out[id]=0.

  id=where(tims gt 2014.0 and tims lt 2014.5 and low60out lt 1e-7)
  low60out[id]=0.
  high60out[id]=0.

  id=where(tims gt 2015.0  and low60out lt 1e-8)
  low60out[id]=0.
  high60out[id]=0.

  xr=[2010.5,2019]
  yr=[8e-10,3d-4]

  ; Plot the low channel flux

  pp=plot(tims,low60out,xrange=xr,yrange=yr,xlog=0,ylog=1,thick=1,$
    /nodata,/buffer,dimension=[700,400])
  pp.xtitle='Year'
  pp.ytitle=' Flux <hourly> Wm$^{-2}$'
  pp.ytickformat='exp1'
  pp.title='GOES15 1.0-8.0 $\AA$'

    ppa=plot(xr,[1e-8,1e-8],color='grey',line=1,/overplot)
  ppb=plot(xr,[1e-7,1e-7],color='grey',line=1,/overplot)
  ppc=plot(xr,[1e-6,1e-6],color='grey',line=1,/overplot)
  ppm=plot(xr,[1e-5,1e-5],color='grey',line=1,/overplot)
  ppx=plot(xr,[1e-4,1e-4],color='grey',line=1,/overplot)

  ppm1=plot(tims,low60out,/overplot,color='crimson',thick=0.8)

  tta=text(xr[0]+.01,1.05e-8,'A',target=pp,/data,color='grey')
  ttb=text(xr[0]+.01,1.05e-7,'B',target=pp,/data,color='grey')
  ttc=text(xr[0]+.01,1.05e-6,'C',target=pp,/data,color='grey')
  ttm=text(xr[0]+.01,1.05e-5,'M',target=pp,/data,color='grey')
  ttx=text(xr[0]+.01,1.05e-4,'X',target=pp,/data,color='grey')


  tt2=text(10,10,'Data from: https://satdat.ngdc.noaa.gov/sem/goes/data/new_avg/',color='black',font_size=5, target=pp,/device)

  dim=pp.window.dimensions
  height=4
  width=7
  ;  pp.save,'GOES15_low_hrly_'+outname+'.png',height=720,width=1200
  pp.save,'GOES15_low_hrly_newest.png',height=720,width=1200
  pp.close

  ; low the high channel flux

  pp=plot(tims,high60out,xrange=xr,yrange=yr,xlog=0,ylog=1,thick=1,$
    /nodata,/buffer,dimension=[700,400])
  pp.xtitle='Year'
  pp.ytitle=' Flux <hourly> Wm$^{-2}$'
  pp.ytickformat='exp1'
  pp.title='GOES15 0.5-4.0 $\AA$'

  ppa=plot(xr,[1e-8,1e-8],color='grey',line=1,/overplot)
  ppb=plot(xr,[1e-7,1e-7],color='grey',line=1,/overplot)
  ppc=plot(xr,[1e-6,1e-6],color='grey',line=1,/overplot)
  ppm=plot(xr,[1e-5,1e-5],color='grey',line=1,/overplot)
  ppx=plot(xr,[1e-4,1e-4],color='grey',line=1,/overplot)

  ;ppm1=plot(tims,low60out,/overplot,color='crimson')
  ppm2=plot(tims,high60out,/overplot,color='royal blue',thick=0.8)
  tt2=text(10,10,'Data from: https://satdat.ngdc.noaa.gov/sem/goes/data/new_avg/',color='black',font_size=5, target=pp,/device)

  dim=pp.window.dimensions
  height=4
  width=7

  ;  pp.save,'GOES15_high_hrly_'+outname+'.png',height=720,width=1200
  pp.save,'GOES15_high_hrly_newest.png',height=720,width=1200

  pp.close


  stop
end
