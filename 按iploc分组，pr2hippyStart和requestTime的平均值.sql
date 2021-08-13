select
  iploc,
  count(1) as pv,
  round(avg(pr2hippyStart), 2) as pr2hippyStart,
  round(avg(htmlGenerate), 2) as htmlGenerate,
  round(avg(htmlTransfer), 2) as htmlTransfer,
  round(avg(requestTime), 2) as requestTime,
  round(avg(domainTime), 2) as dnsTime,
  round(avg(connectTime), 2) as connectTime
from
  (
    select
      pbparams ['iploc'] as iploc,
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
        pbparams ['domainLookupEnd'] - pbparams ['domainLookupStart']
      ) as domainTime,
      (
        pbparams ['connectEnd'] - pbparams ['connectStart']
      ) as connectTime
    from
      custom.wapsearch_speed
    where
      logdate >= '2021080900'
      and logdate <= '2021080923'
      and pbparams ['type'] = 'page_speed'
      and pbparams ['stype'] = 'searchList_iphone'
      and pbparams ['enable'] = '1'
      and isprivate = '0'
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
      and pbparams ['firstScreenTime'] >= 0
      and pbparams ['firstStartTime'] >= 0
      and pbparams ['firstEndTime'] >= 0
      and pbparams ['secondEndTime'] >= 0
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
      and pbparams ['firstScreenTime'] <= 100000
      and pbparams ['firstStartTime'] <= 100000
      and pbparams ['firstEndTime'] <= 100000
      and pbparams ['secondEndTime'] <= 100000
      and (
        pbparams ['pr2hippy'] is not null
        and pbparams ['pr2hippy'] <= 100000
      )
      and pbparams ['iploc'] like 'CN%'
      and (pbparams ['sgwbtp'] is null)
      and useragent like '%MQQBrowser%'
      and useragent like '%Android%'
      and pbparams ['url_protocol'] = 'https'
  ) a
group by
  iploc
HAVING
  count(1) > 10000
order by
  pr2hippyStart desc;

