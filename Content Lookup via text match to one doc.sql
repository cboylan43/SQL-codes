Use adppctu2012
SELECT     PageID, ParentID, LanguageID, Display, Title, [Content]
FROM         Pages
WHERE     ([Content] =(
	SELECT     [Content]
	FROM         Pages
	WHERE     (PageID = 19680)))