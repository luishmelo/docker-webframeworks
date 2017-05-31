DECLARE @Language VARCHAR(30) = ##Language:string##
DECLARE @Framework VARCHAR(30) = ##Framework:string##

DECLARE @LanguageTagId INT = (SELECT Id FROM Tags WHERE TagName = @Language)
DECLARE @FrameworkTagId INT =  (SELECT Id FROM Tags WHERE TagName = @Framework)

CREATE TABLE #PostIds (Id INT)
CREATE TABLE #PostsAndUpVotes (Id INT, AnswerScore INT)

INSERT INTO #PostIds
SELECT
  Posts.Id
  From 
    Posts
  WHERE    
  Posts.AcceptedAnswerId > 0 -- Must contains a valid accepted answer (aka green tick)
  AND Posts.PostTypeId = 1 -- PostType with Id = 1 is the "Question" type
  AND
    (
      EXISTS(
        SELECT * FROM PostTags 
        WHERE 
          PostTags.PostId = Posts.Id 
          AND PostTags.TagId = @LanguageTagId
      )
      AND
      EXISTS(
        SELECT * FROM PostTags 
        WHERE 
          PostTags.PostId = Posts.Id 
          AND PostTags.TagId = @FrameworkTagId
      )
    )

INSERT INTO #PostsAndUpVotes
SELECT 
  TOP 100
  Posts.Id AS [Post Link],
  Answer.Score as [Answer Score]
  FROM Posts INNER JOIN #PostIds ON Posts.Id = #PostIds.Id
  INNER JOIN Posts Answer ON Answer.Id = Posts.AcceptedAnswerId
  WHERE
    ( -- Valid Question
      Posts.ClosedDate IS NULL
      AND Posts.DeletionDate IS NULL
    )
  ORDER BY
    [Answer Score] DESC
    
SELECT 
  Posts.Id AS [Post Link],
  Posts.Title as [Post Title],
  Posts.ViewCount as [Post Views],
  #PostsAndUpVotes.AnswerScore as [Answer Score]
  FROM Posts INNER JOIN #PostsAndUpVotes ON Posts.Id = #PostsAndUpVotes.Id
