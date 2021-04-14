USE [WebPMIS]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_RemoveLastChar]    Script Date: 2021/4/13 下午 04:40:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_RemoveLastChar]
(
    @string as nvarchar(max)
)
RETURNS nvarchar(max)
AS
BEGIN
    RETURN REVERSE(STUFF(REVERSE(@string),1,1,''));
END

GO
/****** Object:  UserDefinedFunction [dbo].[SplitString]    Script Date: 2021/4/13 下午 04:40:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SplitString]
(
@SplitStr nvarchar(1000),
@SplitChar nvarchar(5)
)
RETURNS @RtnValue table
(
Data nvarchar(500)
)
AS
BEGIN
Declare @Count int
Set @Count = 1

While (Charindex(@SplitChar,@SplitStr)>0)
Begin
Insert Into @RtnValue (Data)
Select
Data = ltrim(rtrim(Substring(@SplitStr,1,Charindex(@SplitChar,@SplitStr)-1)))

Set @SplitStr = Substring(@SplitStr,Charindex(@SplitChar,@SplitStr)+1,len(@SplitStr))
Set @Count = @Count + 1
End

Insert Into @RtnValue (Data)
Select Data = ltrim(rtrim(@SplitStr))

Return
END


GO
/****** Object:  View [dbo].[EFC_CurrentMember]    Script Date: 2021/4/13 下午 04:40:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[EFC_CurrentMember]
AS
SELECT      dbo.FSe7en_Org_MemberStruct.AccountID, dbo.FSe7en_Org_MemberInfo.DisplayName AS AccountName, dbo.FSe7en_Org_MemberStruct.DeptID, 
                   ISNULL(dbo.FSe7en_Org_DeptStruct.ParentDept, N'') AS ParentDeptID, dbo.FSe7en_Org_DeptInfo.DisplayName AS DeptName, 
                   dbo.FSe7en_Org_MemberStruct.IsMainJob
FROM         dbo.FSe7en_Org_MemberStruct LEFT OUTER JOIN
                   dbo.FSe7en_Org_DeptInfo ON dbo.FSe7en_Org_MemberStruct.DeptID = dbo.FSe7en_Org_DeptInfo.DeptID LEFT OUTER JOIN
                   dbo.FSe7en_Org_DeptStruct ON dbo.FSe7en_Org_DeptStruct.DeptID = dbo.FSe7en_Org_DeptInfo.DeptID LEFT OUTER JOIN
                   dbo.FSe7en_Org_MemberInfo ON dbo.FSe7en_Org_MemberInfo.AccountID = dbo.FSe7en_Org_MemberStruct.AccountID
WHERE      (dbo.FSe7en_Org_MemberStruct.IsMainJob = '1')

GO