WITH RECURSIVE FolderSizes AS (
    SELECT 
        NodeID,
        NodeName,
        SizeBytes
    FROM FileSystem
    WHERE NodeID NOT IN (SELECT DISTINCT ParentID FROM FileSystem WHERE ParentID IS NOT NULL)
    
    UNION ALL
    SELECT 
        f.NodeID,
        f.NodeName,
        COALESCE(SUM(fs.SizeBytes), 0) AS SizeBytes
    FROM FileSystem f
    JOIN FolderSizes fs ON f.ParentID = fs.NodeID
    WHERE f.ParentID IS NOT NULL
    GROUP BY f.NodeID, f.NodeName
)
SELECT NodeID, NodeName, SizeBytes
FROM FolderSizes;
