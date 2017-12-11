# Lobbying Analysis

## Purpose

## Data

We downloaded the data from the [Lobbying Register](http://lobbying.ie). The script `returns.rb` downloaded the returns and the outputted files were concatenated together. The data has been cleaned and loaded into a relational database (SQLite3). There were some errors in the data, due mainly to strange inputs in the user inputted fields. To open the data: `sqlite3 lobbying.db`.

### Tables

<table>
    <thead>
        <tr>
            <th>Table</th><th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>dpos</td><td>Names and roles of the DPOs mentioned as being lobbied in the reports</td>
        </tr>
    <tr>
        <td>dpos lobbied</td><td>Essentially a join table connecting the DPOs and the reports in which they were mentioned</td>
    </tr>
    <tr>
        <td>organisations</td><td>Information on on lobbying organisations downloaded from lobbying.ie</td>
    </tr>
    <tr>
        <td>reports</td><td>The reports information from the data API</td>
    </tr>
    </tbody>
<table>

### People

Of key interest are the people being lobbied, the so-called DPOs. These have been extracted from the returns and a separate table in the database has been created for them. In some cases, there were many versions of the same name. The names were therefore normalised before deduplicating. A normalised version of the name is stored in the database for reference purposes. Sometimes people change jobs. The Role in the DPOs table is thus the first one encountered in the reports table, later changes are not reflected there.


## Some queries

### Lobbying by organisations and sector

```sql
SELECT organisations.Name AS Lobbyist, organisations.'Main activities of the organisation', 
COUNT(reports.Id) as Reports 
FROM organisations 
JOIN reports ON reports.'Lobbyist Name' = organisations.Name 
GROUP BY Lobbyist ORDER BY Reports DESC LIMIT 10;
```

### Climate Change Lobbying by organisation and sector

```sql
SELECT reports.'Lobbyist Name' AS Lobbyist, 
  organisations.'Main activities of the organisation' AS 'Sector', 
  COUNT(reports.Id) AS Num
  FROM reports 
  JOIN organisations ON reports.'Lobbyist Name' = organisations.Name 
  WHERE (UPPER(reports.'Specific Details') LIKE '%CARBON%' OR  UPPER(reports.'Specific Details') LIKE '%CLIMATE%'
  OR UPPER(reports.'Subject Matter') LIke '%CARBON%' OR UPPER(reports.'Subject Matter') LIke '%CLIMATE%')
  GROUP BY Lobbyist
  ORDER BY Num DESC;
 ```

### Face-time in Climate change Lobbying

```sql
SELECT reports.'Lobbyist Name' AS Lobbyist, 
  organisations.'Main activities of the organisation' AS 'Sector', 
  COUNT(reports.Id) AS Num
  FROM reports 
  JOIN organisations ON reports.'Lobbyist Name' = organisations.Name 
  WHERE (UPPER(reports.'Specific Details') LIKE '%CARBON%' OR  UPPER(reports.'Specific Details') LIKE '%CLIMATE%'
  OR UPPER(reports.'Subject Matter') LIke '%CARBON%' OR UPPER(reports.'Subject Matter') LIke '%CLIMATE%')
  AND UPPER(reports."Lobbying Activities") LIKE '%MEETING%'
  GROUP BY Lobbyist
  ORDER BY Num DESC;
 ```

 ### Some examples of Climate Change Lobbying

 ```sql
SELECT reports.'Lobbyist Name' AS Lobbyist, 
reports.'Specific Details', reports.'DPOs Lobbied', 
reports.'Lobbying Activities', reports.Period
FROM "reports"
WHERE reports.'Specific Details' LIKE '%carbon%' OR  reports.'Specific Details' LIKE '%climate%'
ORDER BY "Lobbyist Name"
```
