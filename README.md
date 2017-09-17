SK-CSIRT Incident: <http://www.nbu.gov.sk/skcsirt-sa-20170909-pypi/>

PyPI Google BigQuery Tables: <https://bigquery.cloud.google.com/dataset/the-psf:pypi> 

SQL query used for mal-pacakges:

    SELECT
      timestamp,
      file.project AS package,
      country_code,
      file.version AS version
    FROM ( (TABLE_DATE_RANGE([the-psf:pypi.downloads], TIMESTAMP('2016-01-22'), TIMESTAMP('2017-09-15'))) )
    WHERE
      file.project IN ( 'acqusition',
        'apidev-coop',
        'bzip',
        'crypt',
        'django-server',
        'pwd',
        'setup-tools',
        'telnet',
        'urlib3',
        'urllib')


SQL query used to ignore mirror-to-mirror traffic:L

    SELECT
      timestamp,
      file.project AS package,
      country_code,
      file.version AS version
    FROM ( (TABLE_DATE_RANGE([the-psf:pypi.downloads], TIMESTAMP('2016-01-22'), TIMESTAMP('2017-09-15'))) )
    WHERE
      file.project IN ( 'acqusition',
        'apidev-coop',
        'bzip',
        'crypt',
        'django-server',
        'pwd',
        'setup-tools',
        'telnet',
        'urlib3',
        'urllib')
    AND details.installer.name NOT IN ('bandersnatch')

SQL query used for good dopplegangers:

    SELECT
      DATE(timestamp) AS dl_day,
      file.project AS package,
      COUNT(DATE(timestamp)) AS dl_count
    FROM ( (TABLE_DATE_RANGE([the-psf:pypi.downloads], TIMESTAMP('2017-04-01'), TIMESTAMP('2017-09-15'))) )
    WHERE
      file.project IN ( 'acquisition',
        'apidev-coop_cms',
        'bz2file',
        'crypto',
        'django-server-guardian-api',
        'pwdhash',
        'setuptools',
        'telnetsrvlib',
        'urllib3' )
    GROUP BY package, dl_day
