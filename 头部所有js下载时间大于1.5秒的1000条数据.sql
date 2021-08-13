select
  a.uuid,
  iploc,
  vendor_result,
  head,
  polyfill,
  common_result,
  domainTime,
  connectTime,
  htmlGenerate,
  htmlTransfer,
  requestTime,
  pr2hippyStart,
  initDomTime,
  interactiveAbleTime,
  loadTime
from
  (
    select
      pbparams ['uuid'] as uuid,
      MAX(CASE WHEN item.name like '%vendor_result%' THEN item.time ELSE 0 END) AS vendor_result,
      MAX(CASE WHEN item.name like '%head%' THEN item.time ELSE 0 END) AS head,
      MAX(CASE WHEN item.name like '%polyfill%' THEN item.time ELSE 0 END) AS polyfill,
      MAX(CASE WHEN item.name like '%common_result%' THEN item.time ELSE 0 END) AS common_result
    from
      custom.web_uigs_wapapp_other lateral view explode(jsname) tmp as item
    where
      logdate >= "2021080920"
      and logdate <= "2021080921"
      and pbparams ['jsname'] is not null
      and item.name like '%.js'
      and (item.name like '%vendor_result%' or item.name like '%head%' or item.name like '%polyfill%' or item.name like '%common_result%')
      and item.time != 'NaN'
      and item.time > 1500
      and item.time <= 100000
      group by pbparams ['uuid']
  ) a
  inner join (
    select
      pbparams ['uuid'] as uuid,
      pbparams ['iploc'] as iploc,
      (
        pbparams ['domainLookupEnd'] - pbparams ['domainLookupStart']
      ) as domainTime,
      (
        pbparams ['connectEnd'] - pbparams ['connectStart']
      ) as connectTime,
      (
        pbparams ['responseStart'] - pbparams ['requestStart']
      ) as htmlGenerate,
      (
        pbparams ['responseEnd'] - pbparams ['responseStart']
      ) as htmlTransfer,
      (
        pbparams ['responseEnd'] - pbparams ['requestStart']
      ) as requestTime,
      (
        pbparams ['_pr2hippyStart_'] - pbparams ['navigationStart']
      ) as pr2hippyStart,
      (
        pbparams ['domInteractive'] - pbparams ['responseEnd']
      ) as initDomTime,
      (
        pbparams ['domInteractive'] - pbparams ['navigationStart']
      ) as interactiveAbleTime,
      (
        pbparams ['loadEventEnd'] - pbparams ['navigationStart']
      ) as loadTime
    from
      custom.web_uigs_wapapp_orc
    where
      logdate >= "2021080920"
      and logdate <= "2021080921"
      and pbparams ['type'] = 'page_speed'
      and pbparams ['stype'] = 'searchList_iphone'
      and pbparams ['enable'] = '1'
      and (
        pbparams ['headStartTime'] - pbparams ['navigationStart']
      ) >= 0
      and (
        pbparams ['headStartTime'] - pbparams ['navigationStart']
      ) <= 100000
      and (
        pbparams ['unloadEventEnd'] - pbparams ['unloadEventStart']
      ) >= 0
      and (
        pbparams ['headEndTime'] - pbparams ['headStartTime']
      ) >= 0
      and (
        pbparams ['headEndTime'] - pbparams ['headStartTime']
      ) <= 100000
      and (
        pbparams ['resultStartTime'] - pbparams ['headEndTime']
      ) >= 0
      and (
        pbparams ['resultStartTime'] - pbparams ['headEndTime']
      ) <= 100000
      and (
        pbparams ['redirectEnd'] - pbparams ['redirectStart']
      ) >= 0
      and (
        pbparams ['fetchStart'] - pbparams ['navigationStart']
      ) >= 0
      and (
        pbparams ['domainLookupEnd'] - pbparams ['domainLookupStart']
      ) >= 0
      and (
        pbparams ['connectEnd'] - pbparams ['connectStart']
      ) >= 0
      and (
        pbparams ['responseEnd'] - pbparams ['requestStart']
      ) >= 0
      and (
        pbparams ['domInteractive'] - pbparams ['responseEnd']
      ) >= 0
      and (
        pbparams ['domComplete'] - pbparams ['domInteractive']
      ) >= 0
      and (
        pbparams ['loadEventEnd'] - pbparams ['loadEventStart']
      ) > 0
      and (
        pbparams ['loadEventEnd'] - pbparams ['navigationStart']
      ) >= 0
      and (
        pbparams ['domInteractive'] - pbparams ['navigationStart']
      ) >= 0
      and (
        pbparams ['unloadEventEnd'] - pbparams ['unloadEventStart']
      ) <= 100000
      and (
        pbparams ['redirectEnd'] - pbparams ['redirectStart']
      ) <= 100000
      and (
        pbparams ['fetchStart'] - pbparams ['navigationStart']
      ) <= 100000
      and (
        pbparams ['domainLookupEnd'] - pbparams ['domainLookupStart']
      ) <= 100000
      and (
        pbparams ['connectEnd'] - pbparams ['connectStart']
      ) <= 100000
      and (
        pbparams ['responseEnd'] - pbparams ['requestStart']
      ) <= 100000
      and (
        pbparams ['domInteractive'] - pbparams ['responseEnd']
      ) <= 100000
      and (
        pbparams ['domComplete'] - pbparams ['domInteractive']
      ) <= 100000
      and (
        pbparams ['loadEventEnd'] - pbparams ['loadEventStart']
      ) <= 100000
      and (
        pbparams ['loadEventEnd'] - pbparams ['navigationStart']
      ) <= 100000
      and (
        pbparams ['domInteractive'] - pbparams ['navigationStart']
      ) <= 100000
      and (
        pbparams ['pr2hippy'] is not null
        and pbparams ['pr2hippy'] <= 100000
      )
      and pbparams ['iploc'] like 'CN%'
      and (pbparams ['sgwbtp'] is null)
      and useragent like '%MQQBrowser%'
      and useragent like '%Android%'
      and pbparams ['url_protocol'] = 'https'
  ) b on a.uuid = b.uuid
limit
  1000;
