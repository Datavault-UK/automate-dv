SELECT
  datetime '2020-01-01' AS load_dts,
  'a' AS entity_id,
  '1a' AS val,

UNION ALL

SELECT  '2020-01-02', 'a', '2a' UNION ALL
SELECT  '2020-01-04', 'a', '4a' UNION ALL
SELECT  '2020-01-01', 'b', '1b' UNION ALL
SELECT  '2020-01-03', 'b', '3b' UNION ALL
SELECT  '2020-01-05', 'b', '5b'
