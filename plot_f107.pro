pro plot_f107

  ; Load in the solar radio flux f10.7cm data from:
  ; http://www.spaceweather.gc.ca/solarflux/sx-5-en.php
  ; and then plot it
  ;
  ;
  ; 15-Mar-2017 IGH
  ;~~~~~~~~~~~~~~~~~~~~~~~~~
  
  restore,file='radfluxtemp.dat'
  restore,file='mradfluxtemp.dat'

  
  rr=read_ascii('fluxtable.txt',template=radtemp)
  rrm=read_ascii('solflux_monthly_average.txt',template=mradtemp)
  
  ; middle of the month as fraction of years
  yrfrc=rrm.year+(rrm.mon-0.5)/12.
  plot,yrfrc,rrm.FLUX_adj,yrange=[50,275],ystyle=17
  
  stop
end