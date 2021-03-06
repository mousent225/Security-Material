USE [master]
GO
/****** Object:  Database [Portal]    Script Date: 22/06/2018 5:10:23 PM ******/
CREATE DATABASE [Portal]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TEST_PORTAL', FILENAME = N'E:\Portal\Portal.mdf' , SIZE = 3977216KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'TEST_PORTAL_log', FILENAME = N'E:\Portal\Portal_log.ldf' , SIZE = 14212608KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Portal] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Portal].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Portal] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Portal] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Portal] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Portal] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Portal] SET ARITHABORT OFF 
GO
ALTER DATABASE [Portal] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Portal] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Portal] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Portal] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Portal] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Portal] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Portal] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Portal] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Portal] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Portal] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Portal] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Portal] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Portal] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Portal] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Portal] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Portal] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Portal] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Portal] SET RECOVERY FULL 
GO
ALTER DATABASE [Portal] SET  MULTI_USER 
GO
ALTER DATABASE [Portal] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Portal] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Portal] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Portal] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [Portal] SET DELAYED_DURABILITY = DISABLED 
GO
USE [Portal]
GO
/****** Object:  User [security]    Script Date: 22/06/2018 5:10:23 PM ******/
CREATE USER [security] FOR LOGIN [security] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [hyoportal]    Script Date: 22/06/2018 5:10:23 PM ******/
CREATE USER [hyoportal] FOR LOGIN [hyoportal] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_denydatareader] ADD MEMBER [security]
GO
/****** Object:  Schema [EApproval]    Script Date: 22/06/2018 5:10:23 PM ******/
CREATE SCHEMA [EApproval]
GO
/****** Object:  Schema [GATE]    Script Date: 22/06/2018 5:10:23 PM ******/
CREATE SCHEMA [GATE]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_INT2IP]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		TRAN CONG THO
-- Create date: 2014/11/25
-- Description:	CONVERT INT TO IPADDRESS
-- =============================================
CREATE FUNCTION [dbo].[FN_INT2IP] 
(
	-- Add the parameters for the function here
	@IPADDRESS int
)
RETURNS VARCHAR(20)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result VARCHAR(20)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = ( SELECT  CAST(ROUND( (cast(cast(@IPADDRESS as binary(4)) as bigint) / 16777216 ), 0, 1) AS varchar(4)) + '.' +
		CAST((ROUND( (cast(cast(@IPADDRESS as binary(4)) as bigint) / 65536 ), 0, 1) % 256) AS varchar(4)) + '.' +
		CAST((ROUND( (cast(cast(@IPADDRESS as binary(4)) as bigint) / 256 ), 0, 1) % 256) AS varchar(4)) + '.' + 
		CAST((cast(cast(@IPADDRESS as binary(4)) as bigint) % 256 ) AS varchar(4)))

	-- Return the result of the function
	RETURN @Result

END


GO
/****** Object:  UserDefinedFunction [dbo].[FN_IP2INT]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 03/12/2014
-- Description:	REVERT IP TO INT
-- =============================================
CREATE FUNCTION [dbo].[FN_IP2INT]
(
	-- Add the parameters for the function here
	@IP AS varchar(15)
)
RETURNS BIGINT
AS
BEGIN
	RETURN (CONVERT(bigint, PARSENAME(@IP,1)) +

	CONVERT(bigint, PARSENAME(@IP,2)) * 256 +

	CONVERT(bigint, PARSENAME(@IP,3)) * 65536 +

	CONVERT(bigint, PARSENAME(@IP,4)) * 16777216)
END


GO
/****** Object:  UserDefinedFunction [dbo].[FN_SplitString]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_SplitString]     
(    
    -- Add the parameters for the function here    
    @myString nvarchar(max),    
    @deliminator varchar(10)    
)    
RETURNS     
@ReturnTable TABLE     
(    
    -- Add the column definitions for the TABLE variable here    
    [id] [int] IDENTITY(1,1) NOT NULL,    
    [SplitItem] [nvarchar](MAX) COLLATE Korean_Wansung_CI_AS NULL  
)    
AS    
BEGIN    
 Declare @iSpaces INT    
 Declare @part nvarchar(MAX)    
     
 --initialize spaces    
 Select @iSpaces = charindex(@deliminator,@myString,0)    
 While @iSpaces > 0    
     
 BEGIN    
  Select @part = substring(@myString,0,charindex(@deliminator,@myString,0))    
   Insert Into @ReturnTable(SplitItem)    
   Select @part    
   Select @myString = substring(@mystring,charindex(@deliminator,@myString,0)+ len(@deliminator),len (@myString) - len(@part))     
   Select @iSpaces = charindex(@deliminator,@myString,0)    
 END    
     
    If len(@myString) > 0    
    Insert Into @ReturnTable    
    Select @myString    
        
    RETURN     
END

GO
/****** Object:  UserDefinedFunction [dbo].[parseJSON]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[parseJSON]( @JSON NVARCHAR(MAX))
	RETURNS @hierarchy TABLE
	  (
	   element_id INT IDENTITY(1, 1) NOT NULL, /* internal surrogate primary key gives the order of parsing and the list order */
	   sequenceNo [int] NULL, /* the place in the sequence for the element */
	   parent_ID INT,/* if the element has a parent then it is in this column. The document is the ultimate parent, so you can get the structure from recursing from the document */
	   Object_ID INT,/* each list or object has an object id. This ties all elements to a parent. Lists are treated as objects here */
	   NAME NVARCHAR(2000),/* the name of the object */
	   StringValue NVARCHAR(MAX) NOT NULL,/*the string representation of the value of the element. */
	   ValueType VARCHAR(10) NOT null /* the declared type of the value represented as a string in StringValue*/
	  )
	AS
	BEGIN
	  DECLARE
	    @FirstObject INT, --the index of the first open bracket found in the JSON string
	    @OpenDelimiter INT,--the index of the next open bracket found in the JSON string
	    @NextOpenDelimiter INT,--the index of subsequent open bracket found in the JSON string
	    @NextCloseDelimiter INT,--the index of subsequent close bracket found in the JSON string
	    @Type NVARCHAR(10),--whether it denotes an object or an array
	    @NextCloseDelimiterChar CHAR(1),--either a '}' or a ']'
	    @Contents NVARCHAR(MAX), --the unparsed contents of the bracketed expression
	    @Start INT, --index of the start of the token that you are parsing
	    @end INT,--index of the end of the token that you are parsing
	    @param INT,--the parameter at the end of the next Object/Array token
	    @EndOfName INT,--the index of the start of the parameter at end of Object/Array token
	    @token NVARCHAR(200),--either a string or object
	    @value NVARCHAR(MAX), -- the value as a string
	    @SequenceNo int, -- the sequence number within a list
	    @name NVARCHAR(200), --the name as a string
	    @parent_ID INT,--the next parent ID to allocate
	    @lenJSON INT,--the current length of the JSON String
	    @characters NCHAR(36),--used to convert hex to decimal
	    @result BIGINT,--the value of the hex symbol being parsed
	    @index SMALLINT,--used for parsing the hex value
	    @Escape INT --the index of the next escape character
	    
	  DECLARE @Strings TABLE /* in this temporary table we keep all strings, even the names of the elements, since they are 'escaped' in a different way, and may contain, unescaped, brackets denoting objects or lists. These are replaced in the JSON string by tokens representing the string */
	    (
	     String_ID INT IDENTITY(1, 1),
	     StringValue NVARCHAR(MAX)
	    )
	  SELECT--initialise the characters to convert hex to ascii
	    @characters='0123456789abcdefghijklmnopqrstuvwxyz',
	    @SequenceNo=0, --set the sequence no. to something sensible.
	  /* firstly we process all strings. This is done because [{} and ] aren't escaped in strings, which complicates an iterative parse. */
	    @parent_ID=0;
	  WHILE 1=1 --forever until there is nothing more to do
	    BEGIN
	      SELECT
	        @start=PATINDEX('%[^a-zA-Z]["]%', @json collate SQL_Latin1_General_CP850_Bin);--next delimited string
	      IF @start=0 BREAK --no more so drop through the WHILE loop
	      IF SUBSTRING(@json, @start+1, 1)='"' 
	        BEGIN --Delimited Name
	          SET @start=@Start+1;
	          SET @end=PATINDEX('%[^\]["]%', RIGHT(@json, LEN(@json+'|')-@start) collate SQL_Latin1_General_CP850_Bin);
	        END
	      IF @end=0 --no end delimiter to last string
	        BREAK --no more
	      SELECT @token=SUBSTRING(@json, @start+1, @end-1)
	      --now put in the escaped control characters
	      SELECT @token=REPLACE(@token, FROMString, TOString)
	      FROM
	        (SELECT
	          '\"' AS FromString, '"' AS ToString
	         UNION ALL SELECT '\\', '\'
	         UNION ALL SELECT '\/', '/'
	         UNION ALL SELECT '\b', CHAR(08)
	         UNION ALL SELECT '\f', CHAR(12)
	         UNION ALL SELECT '\n', CHAR(10)
	         UNION ALL SELECT '\r', CHAR(13)
	         UNION ALL SELECT '\t', CHAR(09)
	        ) substitutions
	      SELECT @result=0, @escape=1
	  --Begin to take out any hex escape codes
	      WHILE @escape>0
	        BEGIN
	          SELECT @index=0,
	          --find the next hex escape sequence
	          @escape=PATINDEX('%\x[0-9a-f][0-9a-f][0-9a-f][0-9a-f]%', @token collate SQL_Latin1_General_CP850_Bin)
	          IF @escape>0 --if there is one
	            BEGIN
	              WHILE @index<4 --there are always four digits to a \x sequence   
	                BEGIN
	                  SELECT --determine its value
	                    @result=@result+POWER(16, @index)
	                    *(CHARINDEX(SUBSTRING(@token, @escape+2+3-@index, 1),
	                                @characters)-1), @index=@index+1 ;
	         
	                END
	                -- and replace the hex sequence by its unicode value
	              SELECT @token=STUFF(@token, @escape, 6, NCHAR(@result))
	            END
	        END
	      --now store the string away 
	      INSERT INTO @Strings (StringValue) SELECT @token
	      -- and replace the string with a token
	      SELECT @JSON=STUFF(@json, @start, @end+1,
	                    '@string'+CONVERT(NVARCHAR(5), @@identity))
	    END
	  -- all strings are now removed. Now we find the first leaf.  
	  WHILE 1=1  --forever until there is nothing more to do
	  BEGIN
	 
	  SELECT @parent_ID=@parent_ID+1
	  --find the first object or list by looking for the open bracket
	  SELECT @FirstObject=PATINDEX('%[{[[]%', @json collate SQL_Latin1_General_CP850_Bin)--object or array
	  IF @FirstObject = 0 BREAK
	  IF (SUBSTRING(@json, @FirstObject, 1)='{') 
	    SELECT @NextCloseDelimiterChar='}', @type='object'
	  ELSE 
	    SELECT @NextCloseDelimiterChar=']', @type='array'
	  SELECT @OpenDelimiter=@firstObject
	  WHILE 1=1 --find the innermost object or list...
	    BEGIN
	      SELECT
	        @lenJSON=LEN(@JSON+'|')-1
	  --find the matching close-delimiter proceeding after the open-delimiter
	      SELECT
	        @NextCloseDelimiter=CHARINDEX(@NextCloseDelimiterChar, @json,
	                                      @OpenDelimiter+1)
	  --is there an intervening open-delimiter of either type
	      SELECT @NextOpenDelimiter=PATINDEX('%[{[[]%',
	             RIGHT(@json, @lenJSON-@OpenDelimiter)collate SQL_Latin1_General_CP850_Bin)--object
	      IF @NextOpenDelimiter=0 
	        BREAK
	      SELECT @NextOpenDelimiter=@NextOpenDelimiter+@OpenDelimiter
	      IF @NextCloseDelimiter<@NextOpenDelimiter 
	        BREAK
	      IF SUBSTRING(@json, @NextOpenDelimiter, 1)='{' 
	        SELECT @NextCloseDelimiterChar='}', @type='object'
	      ELSE 
	        SELECT @NextCloseDelimiterChar=']', @type='array'
	      SELECT @OpenDelimiter=@NextOpenDelimiter
	    END
	  ---and parse out the list or name/value pairs
	  SELECT
	    @contents=SUBSTRING(@json, @OpenDelimiter+1,
	                        @NextCloseDelimiter-@OpenDelimiter-1)
	  SELECT
	    @JSON=STUFF(@json, @OpenDelimiter,
	                @NextCloseDelimiter-@OpenDelimiter+1,
	                '@'+@type+CONVERT(NVARCHAR(5), @parent_ID))
	  WHILE (PATINDEX('%[A-Za-z0-9@+.e]%', @contents collate SQL_Latin1_General_CP850_Bin))<>0 
	    BEGIN
	      IF @Type='Object' --it will be a 0-n list containing a string followed by a string, number,boolean, or null
	        BEGIN
	          SELECT
	            @SequenceNo=0,@end=CHARINDEX(':', ' '+@contents)--if there is anything, it will be a string-based name.
	          SELECT  @start=PATINDEX('%[^A-Za-z@][@]%', ' '+@contents collate SQL_Latin1_General_CP850_Bin)--AAAAAAAA
	          SELECT @token=SUBSTRING(' '+@contents, @start+1, @End-@Start-1),
	            @endofname=PATINDEX('%[0-9]%', @token collate SQL_Latin1_General_CP850_Bin),
	            @param=RIGHT(@token, LEN(@token)-@endofname+1)
	          SELECT
	            @token=LEFT(@token, @endofname-1),
	            @Contents=RIGHT(' '+@contents, LEN(' '+@contents+'|')-@end-1)
	          SELECT  @name=stringvalue FROM @strings
	            WHERE string_id=@param --fetch the name
	        END
	      ELSE 
	        SELECT @Name=null,@SequenceNo=@SequenceNo+1 
	      SELECT
	        @end=CHARINDEX(',', @contents)-- a string-token, object-token, list-token, number,boolean, or null
	      IF @end=0 
	        SELECT  @end=PATINDEX('%[A-Za-z0-9@+.e][^A-Za-z0-9@+.e]%', @Contents+' ' collate SQL_Latin1_General_CP850_Bin)
	          +1
	       SELECT
	        @start=PATINDEX('%[^A-Za-z0-9@+.e][A-Za-z0-9@+.e]%', ' '+@contents collate SQL_Latin1_General_CP850_Bin)
	      --select @start,@end, LEN(@contents+'|'), @contents  
	      SELECT
	        @Value=RTRIM(SUBSTRING(@contents, @start, @End-@Start)),
	        @Contents=RIGHT(@contents+' ', LEN(@contents+'|')-@end)
	      IF SUBSTRING(@value, 1, 7)='@object' 
	        INSERT INTO @hierarchy
	          (NAME, SequenceNo, parent_ID, StringValue, Object_ID, ValueType)
	          SELECT @name, @SequenceNo, @parent_ID, SUBSTRING(@value, 8, 5),
	            SUBSTRING(@value, 8, 5), 'object' 
	      ELSE 
	        IF SUBSTRING(@value, 1, 6)='@array' 
	          INSERT INTO @hierarchy
	            (NAME, SequenceNo, parent_ID, StringValue, Object_ID, ValueType)
	            SELECT @name, @SequenceNo, @parent_ID, SUBSTRING(@value, 7, 5),
	              SUBSTRING(@value, 7, 5), 'array' 
	        ELSE 
	          IF SUBSTRING(@value, 1, 7)='@string' 
	            INSERT INTO @hierarchy
	              (NAME, SequenceNo, parent_ID, StringValue, ValueType)
	              SELECT @name, @SequenceNo, @parent_ID, stringvalue, 'string'
	              FROM @strings
	              WHERE string_id=SUBSTRING(@value, 8, 5)
	          ELSE 
	            IF @value IN ('true', 'false') 
	              INSERT INTO @hierarchy
	                (NAME, SequenceNo, parent_ID, StringValue, ValueType)
	                SELECT @name, @SequenceNo, @parent_ID, @value, 'boolean'
	            ELSE
	              IF @value='null' 
	                INSERT INTO @hierarchy
	                  (NAME, SequenceNo, parent_ID, StringValue, ValueType)
	                  SELECT @name, @SequenceNo, @parent_ID, @value, 'null'
	              ELSE
	                IF PATINDEX('%[^0-9]%', @value collate SQL_Latin1_General_CP850_Bin)>0 
	                  INSERT INTO @hierarchy
	                    (NAME, SequenceNo, parent_ID, StringValue, ValueType)
	                    SELECT @name, @SequenceNo, @parent_ID, @value, 'real'
	                ELSE
	                  INSERT INTO @hierarchy
	                    (NAME, SequenceNo, parent_ID, StringValue, ValueType)
	                    SELECT @name, @SequenceNo, @parent_ID, @value, 'int'
	      if @Contents=' ' Select @SequenceNo=0
	    END
	  END
	INSERT INTO @hierarchy (NAME, SequenceNo, parent_ID, StringValue, Object_ID, ValueType)
	  SELECT '-',1, NULL, '', @parent_id-1, @type
	--
	   RETURN
	END

GO
/****** Object:  Table [dbo].[Attachment]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Attachment](
	[AttachId] [int] IDENTITY(1,1) NOT NULL,
	[ModuleId] [uniqueidentifier] NOT NULL,
	[MasterId] [int] NOT NULL,
	[FileName] [nvarchar](500) NOT NULL,
	[FilePath] [nvarchar](500) NULL,
	[FileType] [varchar](50) NULL,
	[FileSize] [int] NULL,
 CONSTRAINT [PK_Attachment] PRIMARY KEY CLUSTERED 
(
	[AttachId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CmsFormTemplate]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CmsFormTemplate](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Subject] [nvarchar](200) NOT NULL,
	[Descript] [ntext] NULL,
	[Category] [uniqueidentifier] NOT NULL,
	[Writer] [varchar](20) NULL,
	[WriteDate] [datetime] NULL,
	[IsSubmit] [bit] NULL,
	[ConfirmDate] [datetime] NULL,
	[IsApprove] [bit] NULL,
	[ApproveUid] [varchar](20) NULL,
	[ApproveDate] [datetime] NULL,
	[Reason] [nvarchar](500) NULL,
	[IsAcive] [bit] NOT NULL,
	[IsAttachFile] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUid] [varchar](20) NOT NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUid] [varchar](20) NULL,
	[DeleteDate] [datetime] NULL,
	[DeleteUid] [varchar](20) NULL,
	[IsDelete] [bit] NULL,
	[Pin] [bit] NOT NULL CONSTRAINT [DF_CmsFormTemplate_Pin]  DEFAULT ((0)),
 CONSTRAINT [PK_FormTemplate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CmsPostAction]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CmsPostAction](
	[ActionId] [int] IDENTITY(1,1) NOT NULL,
	[ModuleId] [uniqueidentifier] NOT NULL,
	[MasterId] [int] NOT NULL,
	[CategoryId] [uniqueidentifier] NOT NULL,
	[UserId] [varchar](20) NOT NULL,
	[ActionDate] [datetime] NOT NULL,
	[IsAttachFile] [bit] NULL,
 CONSTRAINT [PK_CmsPostAction] PRIMARY KEY CLUSTERED 
(
	[ActionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CmsPosts]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CmsPosts](
	[PostId] [int] IDENTITY(1,1) NOT NULL,
	[Subject] [nvarchar](1000) NOT NULL,
	[Category] [uniqueidentifier] NOT NULL,
	[ApplyToPlant] [nvarchar](500) NULL,
	[IsActive] [bit] NULL,
	[Content] [ntext] NULL,
	[Kind] [uniqueidentifier] NULL,
	[ReplyToId] [int] NULL,
	[CreateUid] [varchar](20) NOT NULL,
	[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_CmsPosts_CreateDate]  DEFAULT (getdate()),
	[UpdateUid] [varchar](20) NULL,
	[UpdateDate] [datetime] NULL,
	[DeleteUid] [varchar](20) NULL,
	[DeleteDate] [datetime] NULL,
	[IsDelete] [bit] NOT NULL CONSTRAINT [DF_CmsPosts_IsDelete]  DEFAULT ((0)),
	[IsAttachFile] [bit] NOT NULL CONSTRAINT [DF_CmsPosts_IsAttachFile]  DEFAULT ((0)),
 CONSTRAINT [PK_CmsPosts] PRIMARY KEY CLUSTERED 
(
	[PostId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[HrDeptMaster]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HrDeptMaster](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](10) NULL,
	[EnName] [varchar](255) NOT NULL,
	[KoName] [nvarchar](255) NULL,
	[IsDelete] [bit] NOT NULL,
	[Parent] [int] NULL,
	[ParentCode] [varchar](10) NULL,
 CONSTRAINT [PK_HrDeptMaster] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[HrDeptMasterFull]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HrDeptMasterFull](
	[Id] [int] NOT NULL,
	[Code] [varchar](10) NULL,
	[EnName] [nvarchar](200) NULL,
	[KoName] [nvarchar](200) NULL,
	[Organization] [int] NULL,
	[Plant] [int] NULL,
	[Dept] [int] NULL,
	[Sect] [int] NULL,
	[OrganizationName] [nvarchar](200) NULL,
	[PlantName] [nvarchar](200) NULL,
	[DeptName] [nvarchar](200) NULL,
	[SectName] [nvarchar](200) NULL,
	[Level] [int] NULL,
	[CostCenter] [nchar](50) NULL,
 CONSTRAINT [PK_Hr_Dept_Master_Full] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[HrEmpMaster]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HrEmpMaster](
	[EmpId] [varchar](20) NOT NULL,
	[Code] [varchar](20) NOT NULL,
	[LocalName] [nvarchar](255) NULL,
	[KoName] [nvarchar](255) NULL,
	[EnName] [nvarchar](255) NULL,
	[Email] [varchar](255) NULL,
	[Sex] [varchar](1) NULL,
	[Nation] [varchar](2) NULL,
	[PositionId] [varchar](5) NULL,
	[Status] [bit] NOT NULL,
	[DeptCode] [int] NOT NULL,
	[Img] [image] NULL,
	[WorkGroup] [nvarchar](50) NULL,
	[Temp] [varchar](10) NULL,
	[FactoryId] [int] NULL,
	[Password] [nvarchar](500) NULL,
	[uStatus] [uniqueidentifier] NOT NULL,
	[UpdateDate] [datetime] NULL,
	[InterfaceDate] [datetime] NULL,
	[ActiveDate] [datetime] NULL,
	[Costcenter] [varchar](9) NULL,
	[JobTitleId] [varchar](5) NULL,
	[JoinDate] [varchar](8) NULL,
	[UserType] [uniqueidentifier] NULL,
 CONSTRAINT [PK_HR_Emp_Master] PRIMARY KEY CLUSTERED 
(
	[EmpId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SubSystem]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SubSystem](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Url] [nvarchar](250) NULL,
	[Status] [bit] NOT NULL,
	[CreateUid] [nvarchar](20) NOT NULL,
	[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_SubSystem_CreateDate]  DEFAULT (getdate()),
	[UpdateUid] [varchar](50) NULL,
	[UpdateDate] [datetime] NULL,
	[DeleteUid] [varchar](50) NULL,
	[DeleteDate] [datetime] NULL,
	[IsDelete] [bit] NULL,
 CONSTRAINT [PK_T_SYS_SUBSYSTEM] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SysAuthorization]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SysAuthorization](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Action] [varchar](255) NOT NULL,
	[Controller] [varchar](255) NOT NULL,
	[IsAllowed] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUid] [varchar](20) NOT NULL,
	[ModifyDate] [datetime] NULL,
	[ModifyUid] [varchar](20) NULL,
	[Owner] [varchar](20) NOT NULL,
 CONSTRAINT [PK_SysAuthorization] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SysCategory]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SysCategory](
	[ID] [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [DF__SYS_Category__ID__48CFD27E]  DEFAULT (newid()),
	[Name] [nvarchar](500) NOT NULL,
	[Remark] [nvarchar](1000) NULL,
	[CreateUid] [varchar](20) NOT NULL CONSTRAINT [DF_SysCategory_CreateUid]  DEFAULT ('vn55160524'),
	[CreateDate] [datetime] NOT NULL CONSTRAINT [DF__SYS_Categ__Creat__49C3F6B7]  DEFAULT (getdate()),
	[UpdateUid] [varchar](20) NULL,
	[UpdateDate] [datetime] NULL CONSTRAINT [DF__SYS_Categ__Modif__4AB81AF0]  DEFAULT (getdate()),
	[Deleted] [bit] NOT NULL CONSTRAINT [DF__SYS_Categ__Delet__4BAC3F29]  DEFAULT ((0)),
	[DeleteDate] [datetime] NULL,
	[DeleteUid] [varchar](20) NULL,
 CONSTRAINT [Key1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SysCategoryValue]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SysCategoryValue](
	[ID] [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [DF__SYS_Category__ID__4E88ABD4]  DEFAULT (newid()),
	[Name] [nvarchar](500) NOT NULL,
	[Dictionary] [uniqueidentifier] NULL,
	[Sequence] [tinyint] NULL CONSTRAINT [DF__SYS_Categ__Seque__4F7CD00D]  DEFAULT ((0)),
	[Actived] [bit] NOT NULL CONSTRAINT [DF__SYS_Categ__Activ__5070F446]  DEFAULT ((1)),
	[Category] [uniqueidentifier] NOT NULL,
	[ParentID] [uniqueidentifier] NULL,
	[Remark] [nvarchar](1000) NULL,
	[CreateUid] [varchar](20) NOT NULL CONSTRAINT [DF_SysCategoryValue_CreateUid]  DEFAULT ('1000083'),
	[CreateDate] [datetime] NOT NULL CONSTRAINT [DF__SYS_Categ__Creat__5165187F]  DEFAULT (getdate()),
	[UpdateUid] [varchar](20) NULL,
	[UpdateDate] [datetime] NULL CONSTRAINT [DF__SYS_Categ__Modif__52593CB8]  DEFAULT (getdate()),
	[DeleteUid] [varchar](20) NULL,
	[IsDelete] [bit] NULL CONSTRAINT [DF__SYS_Categ__Delet__534D60F1]  DEFAULT ((0)),
	[DeleteDate] [datetime] NULL,
	[SubCode] [varchar](50) NULL,
 CONSTRAINT [Key2] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SysDocument]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SysDocument](
	[ID] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[Name] [nvarchar](500) NOT NULL,
	[Path] [nvarchar](1000) NULL,
	[ParentID] [uniqueidentifier] NULL,
	[Sequence] [tinyint] NOT NULL,
	[DocNo] [varchar](100) NULL,
	[Actived] [bit] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUID] [uniqueidentifier] NULL,
	[ModifyDate] [datetime] NULL,
	[ModifyUID] [uniqueidentifier] NULL,
	[Deleted] [bit] NULL,
	[DeleteDate] [datetime] NULL,
	[DeleteUID] [uniqueidentifier] NULL,
	[Authorized] [varchar](max) NULL,
 CONSTRAINT [Key6] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SysLogHistory]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SysLogHistory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [varchar](50) NOT NULL,
	[IpAddress] [int] NULL,
	[LogTime] [datetime] NULL,
	[OperatingSystem] [nvarchar](255) NULL,
	[PcName] [nvarchar](255) NULL,
	[PcBrowser] [nvarchar](255) NULL,
	[ControllerName] [nvarchar](255) NULL,
	[ActionName] [nvarchar](255) NULL,
 CONSTRAINT [PK_SysLogHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SysMenu]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SysMenu](
	[ID] [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [DF__SYS_Menu__ID__6477ECF3]  DEFAULT (newid()),
	[SystemId] [int] NULL,
	[Icon] [varchar](50) NULL,
	[Name] [nvarchar](500) NOT NULL,
	[ParentID] [uniqueidentifier] NULL,
	[Sequence] [tinyint] NULL CONSTRAINT [DF__SYS_Menu__Sequen__656C112C]  DEFAULT ((0)),
	[Actived] [bit] NOT NULL CONSTRAINT [DF__SYS_Menu__Active__66603565]  DEFAULT ((1)),
	[Controller] [varchar](255) NULL,
	[Action] [varchar](255) NULL,
	[Param] [nvarchar](500) NULL,
	[CreateDate] [datetime] NULL CONSTRAINT [DF__SYS_Menu__Create__6754599E]  DEFAULT (getdate()),
	[CreateUID] [uniqueidentifier] NULL,
	[ModifyDate] [datetime] NULL CONSTRAINT [DF__SYS_Menu__Modify__68487DD7]  DEFAULT (getdate()),
	[ModifyUID] [uniqueidentifier] NULL,
 CONSTRAINT [Key7] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SysNotices]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SysNotices](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Subject] [nvarchar](200) NOT NULL,
	[Descript] [ntext] NULL,
	[Writer] [varchar](20) NULL,
	[WriteDate] [datetime] NULL,
	[IsSubmit] [bit] NULL,
	[ConfirmDate] [datetime] NULL,
	[IsApprove] [bit] NULL,
	[ApproveUid] [varchar](20) NULL,
	[ApproveDate] [datetime] NULL,
	[Reason] [nvarchar](500) NULL,
	[IsAcive] [bit] NOT NULL,
	[IsAttachFile] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUid] [varchar](20) NOT NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUid] [varchar](20) NULL,
	[DeleteDate] [datetime] NULL,
	[DeleteUid] [varchar](20) NULL,
	[IsDelete] [bit] NULL,
 CONSTRAINT [PK_Notices] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SysRole]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SysRole](
	[RoleId] [varchar](5) NOT NULL,
	[RoleName] [nvarchar](100) NOT NULL,
	[SystemId] [int] NULL,
	[Description] [nvarchar](200) NULL,
	[Status] [bit] NOT NULL,
	[CreateDate] [date] NOT NULL CONSTRAINT [DF_SysRole_CreateDate]  DEFAULT (getdate()),
	[CreateUser] [nvarchar](20) NOT NULL,
	[UpdateDate] [date] NULL,
	[UpdateUser] [nvarchar](20) NULL,
	[DeleteDate] [date] NULL,
	[DeleteUser] [nvarchar](20) NULL,
	[IsDelete] [bit] NULL,
 CONSTRAINT [PK_SysRole] PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SysRoleMapping]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SysRoleMapping](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [varchar](5) NOT NULL,
	[MenuId] [int] NULL,
	[ControllerId] [varchar](200) NOT NULL,
	[ActionId] [varchar](200) NOT NULL,
	[ActionName] [varchar](500) NOT NULL,
	[IsAllow] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_SysRoleMapping_CreateDate]  DEFAULT (getdate()),
	[CreateUid] [varchar](20) NOT NULL,
 CONSTRAINT [PK_SysRoleMapping] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SysUser]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SysUser](
	[LoginID] [varchar](20) NOT NULL,
	[Name] [nvarchar](500) NOT NULL,
	[Email] [varchar](500) NULL,
	[Mobile] [varchar](20) NULL,
	[Password] [nvarchar](500) NOT NULL,
	[IMG] [nvarchar](500) NULL,
	[Actived] [bit] NOT NULL CONSTRAINT [DF__SYS_User__Active__2B3F6F97]  DEFAULT ((1)),
	[CreateUid] [varchar](20) NOT NULL,
	[CreateDate] [datetime] NOT NULL CONSTRAINT [DF__SYS_User__Create__2C3393D0]  DEFAULT (getdate()),
	[UpdateUid] [varchar](20) NULL,
	[UpdateDate] [datetime] NULL CONSTRAINT [DF__SYS_User__Modify__2D27B809]  DEFAULT (getdate()),
	[DeleteUid] [varchar](20) NULL,
	[Deleted] [bit] NULL CONSTRAINT [DF__SYS_User__Delete__2E1BDC42]  DEFAULT ((0)),
	[DeleteDate] [datetime] NULL,
 CONSTRAINT [Key8] PRIMARY KEY CLUSTERED 
(
	[LoginID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SysUserMapping]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SysUserMapping](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [varchar](20) NOT NULL,
	[RoleId] [varchar](5) NOT NULL,
	[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_SysUserMapping_CreateDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_SysUserMapping] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [EApproval].[ApplicationConfig]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [EApproval].[ApplicationConfig](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Code] [varchar](20) NOT NULL,
	[Active] [bit] NOT NULL CONSTRAINT [DF_ApplicationConfig_Active]  DEFAULT ((1)),
	[DeptId] [int] NULL,
	[Description] [nvarchar](500) NULL,
	[ApprovalKind] [uniqueidentifier] NULL,
	[ApprovalLineDefault] [nvarchar](2000) NULL,
	[ApprovalLineJson] [nvarchar](4000) NULL,
	[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_ApplicationConfig_CreateDate]  DEFAULT (getdate()),
	[CreateUid] [varchar](20) NOT NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUId] [varchar](20) NULL,
	[DeleteDate] [datetime] NULL,
	[DeleteUid] [varchar](20) NULL,
 CONSTRAINT [PK_ApplicationConfig] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [EApproval].[ApplicationMaster]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [EApproval].[ApplicationMaster](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationId] [int] NOT NULL,
	[Subject] [nvarchar](200) NOT NULL,
	[Code] [varchar](40) NOT NULL,
	[Applicant] [varchar](20) NOT NULL,
	[RequestDate] [datetime] NOT NULL CONSTRAINT [DF_ApplicationMaster_RequestDate]  DEFAULT (getdate()),
	[CostCenter] [varchar](20) NULL,
	[DeptId] [int] NOT NULL,
	[System] [varchar](200) NULL,
	[ApprovalKind] [uniqueidentifier] NOT NULL,
	[ApprovalLine] [nvarchar](2000) NOT NULL,
	[ApprovalLineJson] [nvarchar](4000) NOT NULL,
	[ApprovalStatus] [uniqueidentifier] NOT NULL,
	[NextApprover] [varchar](20) NULL,
	[ConfirmDate] [datetime] NULL,
	[Description] [nvarchar](500) NULL,
	[Opinion] [nvarchar](500) NULL,
	[ContactPerson] [nvarchar](200) NULL,
	[Content] [ntext] NULL,
	[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_ApplicationMaster_CreateDate]  DEFAULT (getdate()),
	[CreateUid] [varchar](20) NOT NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUId] [varchar](20) NULL,
	[DeleteDate] [datetime] NULL,
	[DeleteUid] [varchar](20) NULL,
 CONSTRAINT [PK__Applican__3214EC0723C20E80] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [EApproval].[Approval]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [EApproval].[Approval](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationId] [int] NOT NULL,
	[MasterId] [int] NOT NULL,
	[EmpId] [varchar](20) NOT NULL,
	[ApproverType] [uniqueidentifier] NULL,
	[IsView] [bit] NULL,
	[IsApprove] [bit] NULL,
	[DateApprove] [datetime] NULL,
	[Seq] [tinyint] NOT NULL,
	[Comment] [nvarchar](200) NULL,
 CONSTRAINT [PK__Approve__3214EC07A7639942] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [EApproval].[ApprovalHistory]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [EApproval].[ApprovalHistory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ApprovalLine] [nvarchar](2000) NOT NULL,
	[ApprovalLineJson] [nvarchar](4000) NOT NULL,
	[ApplicationId] [int] NOT NULL,
	[MasterId] [int] NOT NULL,
	[CreateUid] [varchar](20) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ApprovalHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [EApproval].[CCTVPolicy]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [EApproval].[CCTVPolicy](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MasterId] [int] NOT NULL,
	[EmpId] [varchar](20) NULL,
	[Ip] [int] NULL,
	[AssetNo] [varchar](10) NULL,
	[Policy] [int] NULL,
 CONSTRAINT [PK_ComputerPolicy] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [EApproval].[EmailAddress]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [EApproval].[EmailAddress](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MasterId] [int] NOT NULL,
	[EmpId] [varchar](20) NOT NULL,
	[DeptId] [int] NOT NULL,
	[Request] [uniqueidentifier] NOT NULL,
	[Reason] [nvarchar](500) NULL,
	[TimesPerMonth] [int] NOT NULL,
 CONSTRAINT [PK_EmailAddress] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [EApproval].[InformationSystem]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [EApproval].[InformationSystem](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MasterId] [int] NOT NULL,
	[System] [uniqueidentifier] NOT NULL,
	[Seriousness] [uniqueidentifier] NOT NULL,
	[Explanation] [ntext] NULL,
	[EmpId] [varchar](20) NULL,
	[NumDays] [int] NULL,
	[Solution] [ntext] NULL,
 CONSTRAINT [PK_InformationSystem] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [EApproval].[InstallNetwork]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [EApproval].[InstallNetwork](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MasterId] [int] NOT NULL,
	[ItemName] [nvarchar](200) NULL,
	[Qty] [int] NULL,
	[Desciption] [nvarchar](300) NULL,
	[SurveyDate] [datetime] NULL,
	[RequestToVendorDate] [datetime] NULL,
	[ReceivedQuotationDate] [datetime] NULL,
	[RequestToDeptDate] [datetime] NULL,
	[ApprDate] [datetime] NULL,
	[ApprEmpId] [varchar](20) NULL,
	[PartnerSurveyDate] [datetime] NULL,
	[PartnerSendQuotationDate] [datetime] NULL,
	[StartedDate] [datetime] NULL,
	[FinishedDate] [datetime] NULL,
	[Amount] [float] NULL,
	[Description] [nvarchar](500) NULL,
	[Remark] [nvarchar](500) NULL,
 CONSTRAINT [PK_InstallNetwork] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [EApproval].[ItEquipment]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [EApproval].[ItEquipment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MasterId] [int] NOT NULL,
	[ItemName] [varchar](100) NULL,
	[Qty] [int] NULL,
	[OS] [varchar](100) NULL,
	[Version] [nvarchar](200) NULL,
	[Remark] [nvarchar](200) NULL,
 CONSTRAINT [PK_ItEquipment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [EApproval].[NetClientPolicy]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [EApproval].[NetClientPolicy](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MasterId] [int] NOT NULL,
	[IsAllowance] [bit] NOT NULL,
	[FromDate] [datetime] NOT NULL,
	[ToDate] [datetime] NULL,
	[Ip] [int] NULL,
	[AssetNo] [varchar](10) NULL,
	[Reason] [nvarchar](max) NULL,
 CONSTRAINT [PK_Table_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [EApproval].[PhoneService]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [EApproval].[PhoneService](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MasterId] [int] NOT NULL,
	[ItemName] [nvarchar](200) NULL,
	[EmpId] [varchar](20) NULL,
	[IntNo] [varchar](1) NULL,
	[Remark] [nvarchar](200) NULL,
 CONSTRAINT [PK_PhoneService] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [EApproval].[SystemRole]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [EApproval].[SystemRole](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MasterId] [int] NOT NULL,
	[EmpId] [varchar](20) NOT NULL,
	[DeptId] [int] NOT NULL,
	[Module] [uniqueidentifier] NULL,
	[EmpIdSameRole] [varchar](20) NULL,
	[Remark] [nvarchar](200) NULL,
 CONSTRAINT [PK_SystemRole] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [GATE].[ContainerDetail]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [GATE].[ContainerDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MasterId] [int] NOT NULL,
	[VendorId] [int] NOT NULL,
	[ContainerNum] [varchar](20) NOT NULL,
	[FromDate] [date] NOT NULL,
	[ToDate] [date] NOT NULL,
	[IsImport] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_ContainerDetail_CreateDate]  DEFAULT (getdate()),
	[CreateUid] [varchar](20) NOT NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUId] [varchar](20) NULL,
	[DeleteDate] [datetime] NULL,
	[DeleteUid] [varchar](20) NULL,
 CONSTRAINT [PK_ContainerDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [GATE].[ContainerTrackingDaily]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [GATE].[ContainerTrackingDaily](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ContainerId] [int] NOT NULL,
	[VehicleId] [int] NOT NULL,
	[WorkDate] [date] NOT NULL,
	[ScanTime] [varchar](5) NOT NULL,
	[IsCheckIn] [bit] NOT NULL,
	[GateId] [uniqueidentifier] NULL,
	[Remark] [nvarchar](500) NULL,
	[CreateUid] [nvarchar](20) NOT NULL,
	[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_ContainerTrackingDaily_CreateDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_ContainerTrackingDaily] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [GATE].[ForgetCard]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [GATE].[ForgetCard](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpId] [varchar](20) NOT NULL,
	[WorkDate] [date] NULL,
	[TimeIn] [varchar](5) NULL CONSTRAINT [forgetcard_forgetdate_df]  DEFAULT (getdate()),
	[TimeOut] [varchar](5) NULL,
	[TemporaryCard] [varchar](20) NULL,
	[GateId] [uniqueidentifier] NOT NULL,
	[SecurityName] [nvarchar](200) NOT NULL,
	[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_ForgetCard_CreateDate]  DEFAULT (getdate()),
	[UpdateDate] [datetime] NULL,
	[DeleteDate] [datetime] NULL,
	[ReasonDelete] [nvarchar](1000) NULL,
	[SecurityDelete] [nvarchar](200) NULL,
	[Reason] [uniqueidentifier] NULL,
	[ReasonOthers] [nvarchar](500) NULL,
 CONSTRAINT [PK__ForgetCa__3214EC079C679112] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [GATE].[Guard]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [GATE].[Guard](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[GuardId] [varchar](20) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Password] [nvarchar](500) NOT NULL,
	[Gate] [uniqueidentifier] NOT NULL,
	[Vendor] [uniqueidentifier] NOT NULL,
	[Remark] [nvarchar](500) NULL,
	[IsActive] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_Guard_CreateDate]  DEFAULT (getdate()),
	[CreateUid] [varchar](20) NOT NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUId] [varchar](20) NULL,
	[DeleteDate] [datetime] NULL,
	[DeleteUid] [varchar](20) NULL,
 CONSTRAINT [PK_Guard] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [GATE].[PassingGoodsDetail]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [GATE].[PassingGoodsDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MasterId] [int] NOT NULL,
	[ItemName] [nvarchar](200) NOT NULL,
	[Serial] [varchar](50) NULL,
	[Description] [nvarchar](500) NULL,
	[Quantity] [int] NOT NULL,
	[ItemLocation] [nvarchar](100) NULL,
	[ReImport] [bit] NULL,
	[ReImportDate] [date] NULL,
	[ImportDate] [datetime] NULL,
	[ImportUid] [varchar](20) NULL,
	[IsAttachment] [bit] NULL,
	[Remark] [nvarchar](500) NULL,
 CONSTRAINT [PK_PassingGoodsDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [GATE].[PassingGoodsMaster]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [GATE].[PassingGoodsMaster](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](20) NOT NULL,
	[Applicant] [varchar](20) NOT NULL,
	[DeptId] [int] NOT NULL,
	[ApplicationDate] [datetime] NOT NULL,
	[ReImport] [bit] NULL,
	[ReImportDate] [date] NULL,
	[Reason] [nvarchar](500) NULL,
	[FinishDate] [datetime] NULL,
	[FinishApplication] [bit] NULL,
	[FinishReason] [nvarchar](500) NULL,
	[ApprovalKind] [uniqueidentifier] NULL,
	[ApprovalLine] [nvarchar](2000) NULL,
	[ApprovalLineJson] [nvarchar](4000) NULL,
	[ApprovalStatus] [uniqueidentifier] NULL,
	[NextApprover] [varchar](20) NULL,
	[ConfirmDate] [datetime] NULL,
	[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_PassingGoodsMaster_CreateDate]  DEFAULT (getdate()),
	[CreateUid] [varchar](20) NOT NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUId] [varchar](20) NULL,
	[DeleteDate] [datetime] NULL,
	[DeleteUid] [varchar](20) NULL,
	[IsView] [bit] NULL CONSTRAINT [DF_PassingGoodsMaster_IsView]  DEFAULT ((0)),
	[Temp] [bit] NULL CONSTRAINT [DF_PassingGoodsMaster_Temp]  DEFAULT ((0)),
	[ExportDate] [datetime] NULL,
	[ExportUid] [varchar](20) NULL,
 CONSTRAINT [PK_PassingGoodsMaster] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [GATE].[SamepleSignature]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [GATE].[SamepleSignature](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpId] [varchar](20) NOT NULL,
	[CreateUid] [varchar](20) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[DeleteUid] [varchar](20) NULL,
	[DeleteDate] [datetime] NULL,
 CONSTRAINT [PK_SamepleSignature] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [GATE].[VehicleCheckingDaily]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [GATE].[VehicleCheckingDaily](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[VehicleId] [int] NOT NULL,
	[WorkDate] [date] NOT NULL,
	[ScanTime] [varchar](5) NULL,
	[IsCheckIn] [bit] NULL,
	[GateId] [uniqueidentifier] NULL,
	[Remark] [nvarchar](500) NULL,
	[ChangeDriver] [nvarchar](200) NULL,
	[VehicleCard] [varchar](20) NULL,
	[CreateUid] [nvarchar](20) NOT NULL,
	[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_VehicleCheckingDaily_CreateDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_VehicleCheckingDaily] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [GATE].[Vendor]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [GATE].[Vendor](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TaxCode] [varchar](15) NOT NULL,
	[CompanyName] [nvarchar](100) NOT NULL,
	[Address] [nvarchar](300) NOT NULL,
	[DeptId] [int] NULL,
	[PersonInCharge] [varchar](20) NULL,
	[ContactPerson] [nvarchar](70) NULL,
	[PhoneNumber] [varchar](15) NULL,
	[Email] [varchar](70) NULL,
	[IsActive] [bit] NULL,
	[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_Vendor_CreateDate]  DEFAULT (getdate()),
	[CreateUid] [varchar](20) NOT NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUId] [varchar](20) NULL,
	[DeleteDate] [datetime] NULL,
	[DeleteUid] [varchar](20) NULL,
	[TermsOfUse] [bit] NOT NULL CONSTRAINT [DF_Vendor_TermsOfUse]  DEFAULT ((0)),
	[VendorType] [uniqueidentifier] NULL,
 CONSTRAINT [PK_Vendor] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [GATE].[Violation]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [GATE].[Violation](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](20) NOT NULL,
	[VisitorId] [int] NULL,
	[EmpId] [varchar](20) NULL,
	[DeptId] [int] NULL,
	[Violatedate] [date] NOT NULL,
	[ViolateType] [uniqueidentifier] NOT NULL,
	[ReasonDetail] [ntext] NULL,
	[IsBlackList] [bit] NOT NULL CONSTRAINT [DF_Violation_IsBlackList]  DEFAULT ((0)),
	[PersonInCharge] [varchar](20) NULL,
	[IsAttachment] [bit] NOT NULL CONSTRAINT [DF_Violation_IsAttachment]  DEFAULT ((0)),
	[ApprovalKind] [uniqueidentifier] NULL,
	[ApprovalLine] [nvarchar](2000) NULL,
	[ApprovalLineJson] [nvarchar](4000) NULL,
	[ApprovalStatus] [uniqueidentifier] NULL,
	[NextApprover] [varchar](20) NULL,
	[ConfirmDate] [datetime] NULL,
	[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_Violation_CreateDate]  DEFAULT (getdate()),
	[CreateUid] [varchar](20) NOT NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUId] [varchar](20) NULL,
	[DeleteDate] [datetime] NULL,
	[DeleteUid] [varchar](20) NULL,
 CONSTRAINT [PK_Violation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [GATE].[VisitorApplicationDetailPerson]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [GATE].[VisitorApplicationDetailPerson](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationMaster] [int] NOT NULL,
	[Image] [varchar](200) NULL,
	[FullName] [nvarchar](200) NOT NULL,
	[IdentityCard] [varchar](15) NOT NULL,
	[PhoneNumber] [varchar](15) NULL,
	[FromDate] [date] NOT NULL,
	[ToDate] [date] NOT NULL,
	[IsWorkHourOfficial] [bit] NULL,
	[VisitorCard] [varchar](15) NULL,
	[IssuedDate] [datetime] NULL,
	[IssuedUid] [varchar](15) NULL,
	[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_VisitorApplicationDetailPerson_CreateDate]  DEFAULT (getdate()),
	[CreateUid] [varchar](20) NOT NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUId] [varchar](20) NULL,
	[DeleteDate] [datetime] NULL,
	[DeleteUid] [varchar](20) NULL,
 CONSTRAINT [PK_VisitorApplicationDetailPerson] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [GATE].[VisitorApplicationDetailVehicle]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [GATE].[VisitorApplicationDetailVehicle](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationMaster] [int] NOT NULL,
	[FromDate] [date] NOT NULL,
	[ToDate] [date] NOT NULL,
	[DriverPlate] [varchar](20) NOT NULL,
	[DriverName] [nvarchar](500) NULL,
	[PhoneDriver] [varchar](20) NULL,
	[VehicleType] [uniqueidentifier] NOT NULL,
	[VehicleCard] [varchar](15) NULL,
	[IssuedDate] [datetime] NULL,
	[IssuedUid] [varchar](15) NULL,
	[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_VisitorApplicationDetailVehicle_CreateDate]  DEFAULT (getdate()),
	[CreateUid] [varchar](20) NOT NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUId] [varchar](20) NULL,
	[DeleteDate] [datetime] NULL,
	[DeleteUid] [varchar](20) NULL,
 CONSTRAINT [PK_VisitorApplicationDetailVehicle] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [GATE].[VisitorApplicationMaster]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [GATE].[VisitorApplicationMaster](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](20) NOT NULL,
	[ApplicationType] [int] NOT NULL,
	[DeptId] [int] NOT NULL,
	[Applicant] [varchar](20) NOT NULL,
	[PhoneNumber] [varchar](20) NULL,
	[HandPhoneNumber] [varchar](20) NULL,
	[Vendor] [int] NULL,
	[Purpose] [uniqueidentifier] NULL,
	[FromDate] [datetime] NOT NULL,
	[ToDate] [datetime] NOT NULL,
	[Gate] [varchar](1000) NOT NULL,
	[Location] [varchar](300) NULL,
	[LocationOther] [nvarchar](200) NULL,
	[Remark] [nvarchar](500) NULL,
	[ApprovalKind] [uniqueidentifier] NULL,
	[ApprovalLine] [nvarchar](2000) NULL,
	[ApprovalLineJson] [nvarchar](4000) NULL,
	[ApprovalStatus] [uniqueidentifier] NULL,
	[NextApprover] [varchar](20) NULL,
	[ConfirmDate] [datetime] NULL,
	[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_VisitorApplicationMaster_CreateDate]  DEFAULT (getdate()),
	[CreateUid] [varchar](20) NOT NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUId] [varchar](20) NULL,
	[DeleteDate] [datetime] NULL,
	[DeleteUid] [varchar](20) NULL,
	[Temp] [bit] NOT NULL,
	[IsSendMail] [bit] NULL,
 CONSTRAINT [PK_VisitorApplicationMaster] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [GATE].[VisitorWorkingDaily]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [GATE].[VisitorWorkingDaily](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationType] [int] NULL,
	[VisitorId] [int] NOT NULL,
	[WorkDate] [date] NOT NULL,
	[ScanTime] [varchar](5) NULL,
	[IsCheckIn] [bit] NULL,
	[GateId] [uniqueidentifier] NULL,
	[Remark] [nvarchar](500) NULL,
	[VisitorCard] [varchar](20) NULL,
	[CreateUid] [nvarchar](20) NOT NULL,
	[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_VisitorWorkingDaily_CreateDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_[Gate]].VisitorWorkingDaily] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IDX_CODE]    Script Date: 22/06/2018 5:10:23 PM ******/
CREATE NONCLUSTERED INDEX [IDX_CODE] ON [dbo].[HrEmpMaster]
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IDX_CODE_LocalName_DeptCode_Costcenter]    Script Date: 22/06/2018 5:10:23 PM ******/
CREATE NONCLUSTERED INDEX [IDX_CODE_LocalName_DeptCode_Costcenter] ON [dbo].[HrEmpMaster]
(
	[Code] ASC
)
INCLUDE ( 	[LocalName],
	[DeptCode],
	[Costcenter]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SysAuthorization] ADD  CONSTRAINT [DF__SYS_Autho__IsAll__440B1D61]  DEFAULT ((1)) FOR [IsAllowed]
GO
ALTER TABLE [dbo].[SysAuthorization] ADD  CONSTRAINT [DF__SYS_Autho__Creat__44FF419A]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[SysAuthorization] ADD  CONSTRAINT [DF__SYS_Autho__Modif__45F365D3]  DEFAULT (getdate()) FOR [ModifyDate]
GO
ALTER TABLE [dbo].[SysDocument] ADD  CONSTRAINT [DF__SYS_Document__ID__1B0907CE]  DEFAULT (newid()) FOR [ID]
GO
ALTER TABLE [dbo].[SysDocument] ADD  CONSTRAINT [DF__SYS_Docum__Seque__1BFD2C07]  DEFAULT ((0)) FOR [Sequence]
GO
ALTER TABLE [dbo].[SysDocument] ADD  CONSTRAINT [DF__SYS_Docum__Activ__1CF15040]  DEFAULT ((1)) FOR [Actived]
GO
ALTER TABLE [dbo].[SysDocument] ADD  CONSTRAINT [DF__SYS_Docum__Creat__1DE57479]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[SysDocument] ADD  CONSTRAINT [DF__SYS_Docum__Modif__1ED998B2]  DEFAULT (getdate()) FOR [ModifyDate]
GO
ALTER TABLE [dbo].[SysDocument] ADD  CONSTRAINT [DF__SYS_Docum__Delet__1FCDBCEB]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [GATE].[SamepleSignature] ADD  CONSTRAINT [DF_SamepleSignature_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[Attachment]  WITH CHECK ADD  CONSTRAINT [FK_ModuleId_SysCategoryValue_ID] FOREIGN KEY([ModuleId])
REFERENCES [dbo].[SysCategoryValue] ([ID])
GO
ALTER TABLE [dbo].[Attachment] CHECK CONSTRAINT [FK_ModuleId_SysCategoryValue_ID]
GO
ALTER TABLE [dbo].[CmsFormTemplate]  WITH CHECK ADD  CONSTRAINT [FK_ApproveUid_EmpId] FOREIGN KEY([ApproveUid])
REFERENCES [dbo].[HrEmpMaster] ([EmpId])
GO
ALTER TABLE [dbo].[CmsFormTemplate] CHECK CONSTRAINT [FK_ApproveUid_EmpId]
GO
ALTER TABLE [dbo].[CmsFormTemplate]  WITH CHECK ADD  CONSTRAINT [FK_CreateUid_EmpId] FOREIGN KEY([CreateUid])
REFERENCES [dbo].[HrEmpMaster] ([EmpId])
GO
ALTER TABLE [dbo].[CmsFormTemplate] CHECK CONSTRAINT [FK_CreateUid_EmpId]
GO
ALTER TABLE [dbo].[CmsFormTemplate]  WITH CHECK ADD  CONSTRAINT [FK_DeleteUid_EmpId] FOREIGN KEY([DeleteUid])
REFERENCES [dbo].[HrEmpMaster] ([EmpId])
GO
ALTER TABLE [dbo].[CmsFormTemplate] CHECK CONSTRAINT [FK_DeleteUid_EmpId]
GO
ALTER TABLE [dbo].[CmsFormTemplate]  WITH CHECK ADD  CONSTRAINT [FK_UpdateUid_EmpId] FOREIGN KEY([UpdateUid])
REFERENCES [dbo].[HrEmpMaster] ([EmpId])
GO
ALTER TABLE [dbo].[CmsFormTemplate] CHECK CONSTRAINT [FK_UpdateUid_EmpId]
GO
ALTER TABLE [dbo].[CmsPostAction]  WITH CHECK ADD  CONSTRAINT [FK_CategoryId_ID] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[SysCategoryValue] ([ID])
GO
ALTER TABLE [dbo].[CmsPostAction] CHECK CONSTRAINT [FK_CategoryId_ID]
GO
ALTER TABLE [dbo].[CmsPostAction]  WITH CHECK ADD  CONSTRAINT [FK_ModuleId_ID] FOREIGN KEY([ModuleId])
REFERENCES [dbo].[SysCategoryValue] ([ID])
GO
ALTER TABLE [dbo].[CmsPostAction] CHECK CONSTRAINT [FK_ModuleId_ID]
GO
ALTER TABLE [dbo].[CmsPosts]  WITH CHECK ADD  CONSTRAINT [FK_CmsPosts_HrEmpMaster] FOREIGN KEY([DeleteUid])
REFERENCES [dbo].[HrEmpMaster] ([EmpId])
GO
ALTER TABLE [dbo].[CmsPosts] CHECK CONSTRAINT [FK_CmsPosts_HrEmpMaster]
GO
ALTER TABLE [dbo].[CmsPosts]  WITH CHECK ADD  CONSTRAINT [FK_CmsPosts_HrEmpMaster1] FOREIGN KEY([CreateUid])
REFERENCES [dbo].[HrEmpMaster] ([EmpId])
GO
ALTER TABLE [dbo].[CmsPosts] CHECK CONSTRAINT [FK_CmsPosts_HrEmpMaster1]
GO
ALTER TABLE [dbo].[CmsPosts]  WITH CHECK ADD  CONSTRAINT [FK_CmsPosts_HrEmpMaster2] FOREIGN KEY([UpdateUid])
REFERENCES [dbo].[HrEmpMaster] ([EmpId])
GO
ALTER TABLE [dbo].[CmsPosts] CHECK CONSTRAINT [FK_CmsPosts_HrEmpMaster2]
GO
ALTER TABLE [dbo].[CmsPosts]  WITH CHECK ADD  CONSTRAINT [FK_ReplyToId_PostId] FOREIGN KEY([ReplyToId])
REFERENCES [dbo].[CmsPosts] ([PostId])
GO
ALTER TABLE [dbo].[CmsPosts] CHECK CONSTRAINT [FK_ReplyToId_PostId]
GO
ALTER TABLE [dbo].[HrDeptMaster]  WITH CHECK ADD  CONSTRAINT [FK_HrDeptMaster_HrDeptMaster] FOREIGN KEY([Parent])
REFERENCES [dbo].[HrDeptMaster] ([Id])
GO
ALTER TABLE [dbo].[HrDeptMaster] CHECK CONSTRAINT [FK_HrDeptMaster_HrDeptMaster]
GO
ALTER TABLE [dbo].[SysCategory]  WITH CHECK ADD  CONSTRAINT [FK_CreateUid_HrEmpMaster] FOREIGN KEY([CreateUid])
REFERENCES [dbo].[HrEmpMaster] ([EmpId])
GO
ALTER TABLE [dbo].[SysCategory] CHECK CONSTRAINT [FK_CreateUid_HrEmpMaster]
GO
ALTER TABLE [dbo].[SysCategory]  WITH CHECK ADD  CONSTRAINT [FK_SysCategory_DeleteUid_HrEmpMaster_EmpId] FOREIGN KEY([DeleteUid])
REFERENCES [dbo].[HrEmpMaster] ([EmpId])
GO
ALTER TABLE [dbo].[SysCategory] CHECK CONSTRAINT [FK_SysCategory_DeleteUid_HrEmpMaster_EmpId]
GO
ALTER TABLE [dbo].[SysCategory]  WITH CHECK ADD  CONSTRAINT [FK_SysCategory_UpdateUid_HrEmpMaster_EmpId] FOREIGN KEY([UpdateUid])
REFERENCES [dbo].[HrEmpMaster] ([EmpId])
GO
ALTER TABLE [dbo].[SysCategory] CHECK CONSTRAINT [FK_SysCategory_UpdateUid_HrEmpMaster_EmpId]
GO
ALTER TABLE [dbo].[SysCategoryValue]  WITH CHECK ADD  CONSTRAINT [FK_Category_SysCategory_ID] FOREIGN KEY([Category])
REFERENCES [dbo].[SysCategory] ([ID])
GO
ALTER TABLE [dbo].[SysCategoryValue] CHECK CONSTRAINT [FK_Category_SysCategory_ID]
GO
ALTER TABLE [dbo].[SysCategoryValue]  WITH CHECK ADD  CONSTRAINT [FK_CreateUid_HrEmpMaster_EmpId] FOREIGN KEY([CreateUid])
REFERENCES [dbo].[HrEmpMaster] ([EmpId])
GO
ALTER TABLE [dbo].[SysCategoryValue] CHECK CONSTRAINT [FK_CreateUid_HrEmpMaster_EmpId]
GO
ALTER TABLE [dbo].[SysCategoryValue]  WITH CHECK ADD  CONSTRAINT [FK_DeleteUid_HrEmpMaster_EmpId] FOREIGN KEY([DeleteUid])
REFERENCES [dbo].[HrEmpMaster] ([EmpId])
GO
ALTER TABLE [dbo].[SysCategoryValue] CHECK CONSTRAINT [FK_DeleteUid_HrEmpMaster_EmpId]
GO
ALTER TABLE [dbo].[SysCategoryValue]  WITH CHECK ADD  CONSTRAINT [FK_ParentID_ID] FOREIGN KEY([ParentID])
REFERENCES [dbo].[SysCategoryValue] ([ID])
GO
ALTER TABLE [dbo].[SysCategoryValue] CHECK CONSTRAINT [FK_ParentID_ID]
GO
ALTER TABLE [dbo].[SysCategoryValue]  WITH CHECK ADD  CONSTRAINT [FK_UpdateUid_HrEmpMaster_EmpId] FOREIGN KEY([UpdateUid])
REFERENCES [dbo].[HrEmpMaster] ([EmpId])
GO
ALTER TABLE [dbo].[SysCategoryValue] CHECK CONSTRAINT [FK_UpdateUid_HrEmpMaster_EmpId]
GO
ALTER TABLE [dbo].[SysRole]  WITH CHECK ADD  CONSTRAINT [FK_SysRole_SubSystem] FOREIGN KEY([SystemId])
REFERENCES [dbo].[SubSystem] ([Id])
GO
ALTER TABLE [dbo].[SysRole] CHECK CONSTRAINT [FK_SysRole_SubSystem]
GO
ALTER TABLE [dbo].[SysRoleMapping]  WITH CHECK ADD  CONSTRAINT [FK_SysRoleMapping_SysRole] FOREIGN KEY([RoleId])
REFERENCES [dbo].[SysRole] ([RoleId])
GO
ALTER TABLE [dbo].[SysRoleMapping] CHECK CONSTRAINT [FK_SysRoleMapping_SysRole]
GO
ALTER TABLE [dbo].[SysUserMapping]  WITH CHECK ADD  CONSTRAINT [FK_SysUserMapping_HrEmpMaster] FOREIGN KEY([UserId])
REFERENCES [dbo].[HrEmpMaster] ([EmpId])
GO
ALTER TABLE [dbo].[SysUserMapping] CHECK CONSTRAINT [FK_SysUserMapping_HrEmpMaster]
GO
ALTER TABLE [dbo].[SysUserMapping]  WITH CHECK ADD  CONSTRAINT [FK_SysUserMapping_SysRole] FOREIGN KEY([RoleId])
REFERENCES [dbo].[SysRole] ([RoleId])
GO
ALTER TABLE [dbo].[SysUserMapping] CHECK CONSTRAINT [FK_SysUserMapping_SysRole]
GO
ALTER TABLE [EApproval].[ApplicationConfig]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationConfig_HrDeptMaster] FOREIGN KEY([DeptId])
REFERENCES [dbo].[HrDeptMaster] ([Id])
GO
ALTER TABLE [EApproval].[ApplicationConfig] CHECK CONSTRAINT [FK_ApplicationConfig_HrDeptMaster]
GO
ALTER TABLE [EApproval].[ApplicationConfig]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationConfig_HrEmpMaster] FOREIGN KEY([CreateUid])
REFERENCES [dbo].[HrEmpMaster] ([EmpId])
GO
ALTER TABLE [EApproval].[ApplicationConfig] CHECK CONSTRAINT [FK_ApplicationConfig_HrEmpMaster]
GO
ALTER TABLE [EApproval].[ApplicationConfig]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationConfig_HrEmpMaster1] FOREIGN KEY([UpdateUId])
REFERENCES [dbo].[HrEmpMaster] ([EmpId])
GO
ALTER TABLE [EApproval].[ApplicationConfig] CHECK CONSTRAINT [FK_ApplicationConfig_HrEmpMaster1]
GO
ALTER TABLE [EApproval].[ApplicationMaster]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationMaster_ApplicationConfig] FOREIGN KEY([ApplicationId])
REFERENCES [EApproval].[ApplicationConfig] ([Id])
GO
ALTER TABLE [EApproval].[ApplicationMaster] CHECK CONSTRAINT [FK_ApplicationMaster_ApplicationConfig]
GO
ALTER TABLE [EApproval].[ApplicationMaster]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationMaster_HrDeptMaster] FOREIGN KEY([DeptId])
REFERENCES [dbo].[HrDeptMaster] ([Id])
GO
ALTER TABLE [EApproval].[ApplicationMaster] CHECK CONSTRAINT [FK_ApplicationMaster_HrDeptMaster]
GO
ALTER TABLE [EApproval].[CCTVPolicy]  WITH CHECK ADD  CONSTRAINT [FK_ComputerPolicy_ApplicationMaster] FOREIGN KEY([MasterId])
REFERENCES [EApproval].[ApplicationMaster] ([Id])
GO
ALTER TABLE [EApproval].[CCTVPolicy] CHECK CONSTRAINT [FK_ComputerPolicy_ApplicationMaster]
GO
ALTER TABLE [EApproval].[EmailAddress]  WITH CHECK ADD  CONSTRAINT [FK_EmailAddress_ApplicationMaster] FOREIGN KEY([MasterId])
REFERENCES [EApproval].[ApplicationMaster] ([Id])
GO
ALTER TABLE [EApproval].[EmailAddress] CHECK CONSTRAINT [FK_EmailAddress_ApplicationMaster]
GO
ALTER TABLE [EApproval].[InformationSystem]  WITH CHECK ADD  CONSTRAINT [FK_InformationSystem_ApplicationMaster] FOREIGN KEY([MasterId])
REFERENCES [EApproval].[ApplicationMaster] ([Id])
GO
ALTER TABLE [EApproval].[InformationSystem] CHECK CONSTRAINT [FK_InformationSystem_ApplicationMaster]
GO
ALTER TABLE [EApproval].[InstallNetwork]  WITH CHECK ADD  CONSTRAINT [FK_InstallNetwork_ApplicationMaster] FOREIGN KEY([MasterId])
REFERENCES [EApproval].[ApplicationMaster] ([Id])
GO
ALTER TABLE [EApproval].[InstallNetwork] CHECK CONSTRAINT [FK_InstallNetwork_ApplicationMaster]
GO
ALTER TABLE [EApproval].[ItEquipment]  WITH CHECK ADD  CONSTRAINT [FK_ItEquipment_ApplicationMaster] FOREIGN KEY([MasterId])
REFERENCES [EApproval].[ApplicationMaster] ([Id])
GO
ALTER TABLE [EApproval].[ItEquipment] CHECK CONSTRAINT [FK_ItEquipment_ApplicationMaster]
GO
ALTER TABLE [EApproval].[NetClientPolicy]  WITH CHECK ADD  CONSTRAINT [FK_NetClientPolicy_ApplicationMaster] FOREIGN KEY([MasterId])
REFERENCES [EApproval].[ApplicationMaster] ([Id])
GO
ALTER TABLE [EApproval].[NetClientPolicy] CHECK CONSTRAINT [FK_NetClientPolicy_ApplicationMaster]
GO
ALTER TABLE [EApproval].[PhoneService]  WITH CHECK ADD  CONSTRAINT [FK_PhoneService_ApplicationMaster] FOREIGN KEY([MasterId])
REFERENCES [EApproval].[ApplicationMaster] ([Id])
GO
ALTER TABLE [EApproval].[PhoneService] CHECK CONSTRAINT [FK_PhoneService_ApplicationMaster]
GO
ALTER TABLE [EApproval].[SystemRole]  WITH CHECK ADD  CONSTRAINT [FK_SystemRole_ApplicationMaster] FOREIGN KEY([MasterId])
REFERENCES [EApproval].[ApplicationMaster] ([Id])
GO
ALTER TABLE [EApproval].[SystemRole] CHECK CONSTRAINT [FK_SystemRole_ApplicationMaster]
GO
ALTER TABLE [GATE].[PassingGoodsDetail]  WITH CHECK ADD  CONSTRAINT [FK_PassingGoodsDetail_PassingGoodsMaster] FOREIGN KEY([MasterId])
REFERENCES [GATE].[PassingGoodsMaster] ([Id])
GO
ALTER TABLE [GATE].[PassingGoodsDetail] CHECK CONSTRAINT [FK_PassingGoodsDetail_PassingGoodsMaster]
GO
ALTER TABLE [GATE].[VehicleCheckingDaily]  WITH CHECK ADD  CONSTRAINT [FK_VehicleCheckingDaily_VisitorApplicationDetailVehicle] FOREIGN KEY([VehicleId])
REFERENCES [GATE].[VisitorApplicationDetailVehicle] ([Id])
GO
ALTER TABLE [GATE].[VehicleCheckingDaily] CHECK CONSTRAINT [FK_VehicleCheckingDaily_VisitorApplicationDetailVehicle]
GO
ALTER TABLE [GATE].[VisitorApplicationDetailPerson]  WITH CHECK ADD  CONSTRAINT [FK_VisitorApplicationDetailPerson_VisitorApplicationMaster1] FOREIGN KEY([ApplicationMaster])
REFERENCES [GATE].[VisitorApplicationMaster] ([Id])
GO
ALTER TABLE [GATE].[VisitorApplicationDetailPerson] CHECK CONSTRAINT [FK_VisitorApplicationDetailPerson_VisitorApplicationMaster1]
GO
/****** Object:  StoredProcedure [dbo].[POST_HISTORY]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[POST_HISTORY]
	@DEPTID INT = 0
AS
BEGIN
	SELECT c.UserId, e.EnName
	FROM CmsPostAction C
	INNER JOIN HrEmpMaster E ON C.UserId = E.Code
	RETURN
END

GO
/****** Object:  StoredProcedure [dbo].[SP_CMS_FORMTEMPLATE_GET]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 29-11-2016
-- Description:	LẤY LÊN DANH SÁCH FORMTEMPLATE
-- =============================================
CREATE PROCEDURE [dbo].[SP_CMS_FORMTEMPLATE_GET]
	-- Add the parameters for the stored procedure here
	@SUBJECT NVARCHAR(100) = null,--'querry',
	@USERID VARCHAR(20) = NULL,
	@CREATOR VARCHAR(20) = NULL,
	@CATEGORY VARCHAR(36) = null,--'C4FF5A2F-CD32-4785-9499-A26E5148D58D',
	@ID INT = 1190,
	@DATEFROM DATE = NULL,
	@DATETO DATE = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	--00F2EC64-CC9B-4FCA-AB4C-B37961EFAD53	Approved
	--9a96d85b-8189-46ba-84cd-3389fdc501b7  REJECT
	--C4FF5A2F-CD32-4785-9499-A26E5148D58D	Proccess
	--9C817780-2079-4417-B87B-B7E537BBAE8A	Temporary
	--EAF964F0-F557-40C7-AD06-F0B4A6571A4F	My Posts

	SET NOCOUNT ON;

	DECLARE @ROLE VARCHAR(5) = (SELECT TOP 1 RoleId FROM SysUserMapping WHERE UserId = @CREATOR)

	--CẬP NHẬT LẠI THAO TÁC NGƯỜI DÙNG
	IF @ID <> 0
	BEGIN
		IF EXISTS (SELECT 1 FROM CmsFormTemplate WHERE Id = @ID AND ISNULL(IsApprove, 0) = 1)
			INSERT CmsPostAction(ModuleId, MasterId, CategoryId, ActionDate, UserId)
			VALUES( '720DFEB8-A8FC-4ADB-BC81-33A9BAF633A0', @ID, '95A464F6-6D97-4F9C-B6F3-2D840A5A884C', GETDATE(), @CREATOR)	
	END
	
	IF (@CATEGORY = '00F2EC64-CC9B-4FCA-AB4C-B37961EFAD53')
		GOTO APPROVED
	ELSE IF @CATEGORY = '9a96d85b-8189-46ba-84cd-3389fdc501b7'
		GOTO REJECT
	ELSE IF @CATEGORY = 'C4FF5A2F-CD32-4785-9499-A26E5148D58D'
		GOTO PROCCESS
	ELSE IF @CATEGORY = '9C817780-2079-4417-B87B-B7E537BBAE8A'
		GOTO TEMPORARY
	ELSE IF @CATEGORY = 'EAF964F0-F557-40C7-AD06-F0B4A6571A4F'
		GOTO MYPOSTS
	ELSE
	BEGIN
		IF @CATEGORY = '4BA7FBD4-276D-437B-861E-DA64D3722F3F' SET @CATEGORY = NULL;--LẤY HẾT TẤT CẢ

		WITH CATEGORY(ID, NAME, PARENTID, PARENTNAME, LEVEL) AS(
			SELECT ID, Name, ParentID, CONVERT(NVARCHAR(500),''), 0
			FROM SysCategoryValue
			WHERE ((@CATEGORY IS NULL AND ParentID IS NULL) OR ID = @CATEGORY) AND Category = '054E0F62-4EFE-41E1-A18D-5C28A6531539'
			UNION ALL
			SELECT B.ID, B.Name, B.ParentID, A.NAME, A.LEVEL + 1
			FROM CATEGORY A, SysCategoryValue B
			WHERE A.ID = B.ParentID --AND ISNULL(B.Actived, 0) = 1 AND ISNULL(B.IsDelete, 0) = 0
		), 
		EMPMASTER AS (
			SELECT EmpId, Code, LocalName, DeptCode FROM HrEmpMaster-- WHERE @CREATOR IS NULL OR (@CREATOR IS NOT NULL AND EmpId = @CREATOR)
		),
		FORM_COUNT AS (
			SELECT CATEGORY, COUNT(Id) NUM FROM CmsFormTemplate
			GROUP BY CATEGORY
		),
		POSTACTION AS (
			SELECT MasterId, COUNT(MasterId) NUM FROM CmsPostAction
			WHERE ModuleId = '720DFEB8-A8FC-4ADB-BC81-33A9BAF633A0' AND CategoryId = '95A464F6-6D97-4F9C-B6F3-2D840A5A884C'
			GROUP BY MasterId
		)

		SELECT F.Id, F.Category, C.NAME CategoryName
			, CASE WHEN @ID != 0 THEN F.Subject ELSE '[' + C.NAME + '] ' +  F.Subject END Subject
			, E.LocalName
			, F.CreateUid, F.CreateDate, F.UpdateDate
			, ISNULL(A.LocalName, '') APRROVENAME, IsAttachFile
			, CASE WHEN @ID != 0 THEN F.Descript ELSE '' END Descript
			, F.IsAcive, F.IsSubmit, F.Reason, F.ApproveDate, F.ConfirmDate, f.IsApprove
			, ISNULL(G.NUM, 0) NUM_READ
			, CASE WHEN ISNULL(IsSubmit, 0) = 0 THEN 'Temporary' WHEN IsSubmit = 1 AND IsApprove IS NULL THEN 'Progressing' WHEN IsApprove = 1 THEN 'Approved' WHEN IsApprove = 0 THEN 'Reject' END STATUS
		FROM CmsFormTemplate F
		INNER JOIN EMPMASTER E ON F.CreateUid = E.EmpId
		LEFT JOIN EMPMASTER A ON F.ApproveUid = A.EmpId
		INNER JOIN CATEGORY C ON F.Category = C.ID
		INNER JOIN FORM_COUNT D ON F.Category = D.Category
		LEFT JOIN POSTACTION G ON F.Id = G.MasterId
		--LEFT JOIN HrDeptMasterFull H ON E.DeptCode = H.Id
		WHERE 1=1	
			AND ((@ID != 0 AND F.Id = @ID) 
				OR (@ID = 0 	
					AND ((1=1
						AND ((@ROLE <> 'AD01' AND F.IsApprove = 1) OR @ROLE = 'AD01'))
						OR (@CREATOR IS NOT NULL AND F.CreateUid = @CREATOR AND ISNULL(IsDelete, 0) = 0)	--lấy thêm những cái mà người đang đăng nhập tạo											
					)			
					AND ISNULL(IsDelete, 0) = 0
						
					AND (@SUBJECT IS NULL OR (@SUBJECT IS NOT NULL AND F.Subject LIKE '%' + @SUBJECT + '%'))
					AND (@DATEFROM IS NULL OR (@DATEFROM IS NOT NULL AND DATEDIFF(DAY, @DATEFROM, CreateDate) >=0 ))
					AND (@DATETO IS NULL OR (@DATETO IS NOT NULL AND DATEDIFF(DAY, CreateDate, @DATETO) >=0))
					AND IsApprove = 1 
				)
			)
			--AND (@ID != 0 OR (@ID = 0 AND IsApprove = 1))
			
		ORDER BY F.CreateDate DESC, F.Subject DESC
		RETURN;
	END
	--[SP_CMS_FORMTEMPLATE_GET]

	--------------------------------------------------------------------------------------------------------
	--LẤY RA NHỮNG CÁI NÀO ĐÃ BỊ TỪ CHỐI
	REJECT:
	BEGIN
		
		WITH CATEGORY(ID, NAME, PARENTID, PARENTNAME, LEVEL) AS(
			SELECT ID, Name, ParentID, CONVERT(NVARCHAR(500),''), 0
			FROM SysCategoryValue
			WHERE ParentID IS NULL AND Category = '054E0F62-4EFE-41E1-A18D-5C28A6531539'
			UNION ALL
			SELECT B.ID, B.Name, B.ParentID, A.NAME, A.LEVEL + 1
			FROM CATEGORY A, SysCategoryValue B
			WHERE A.ID = B.ParentID --AND ISNULL(B.Actived, 0) = 1 AND ISNULL(B.IsDelete, 0) = 0
		), 
		EMPMASTER AS (
			SELECT EmpId, Code, LocalName FROM HrEmpMaster
		),
		FORM_COUNT AS (
			SELECT CATEGORY, COUNT(Id) NUM FROM CmsFormTemplate
			GROUP BY CATEGORY
		),
		POSTACTION AS (
			SELECT MasterId, COUNT(MasterId) NUM FROM CmsPostAction
			WHERE ModuleId = '720DFEB8-A8FC-4ADB-BC81-33A9BAF633A0' AND CategoryId = '95A464F6-6D97-4F9C-B6F3-2D840A5A884C'
			GROUP BY MasterId
		)

		SELECT F.Id, F.Category, C.NAME CategoryName
			, CASE WHEN @ID != 0 THEN F.Subject ELSE '[' + C.NAME + '] ' +  F.Subject END Subject
			, E.LocalName, F.CreateUid, F.CreateDate, F.UpdateDate
			, ISNULL(A.LocalName, '') APRROVENAME, IsAttachFile
			, CASE WHEN @ID != 0 THEN F.Descript ELSE '' END Descript
			, F.IsAcive, F.IsSubmit, F.Reason, F.ApproveDate, F.ConfirmDate, f.IsApprove
			, ISNULL(G.NUM, 0) NUM_READ
			, CASE WHEN ISNULL(IsSubmit, 0) = 0 THEN 'Temporary' WHEN IsSubmit = 1 AND ISNULL(IsApprove, 0) = 0 THEN 'Progressing' WHEN IsApprove = 1 THEN 'Approved' WHEN IsApprove = 0 THEN 'Reject' END STATUS
		FROM CmsFormTemplate F
		INNER JOIN EMPMASTER E ON F.CreateUid = E.EmpId
		LEFT JOIN EMPMASTER A ON F.ApproveUid = A.EmpId
		LEFT JOIN CATEGORY C ON F.Category = C.ID
		INNER JOIN FORM_COUNT D ON F.Category = D.Category
		LEFT JOIN POSTACTION G ON F.Id = G.MasterId
		WHERE 1=1
			AND (@SUBJECT IS NULL OR (@SUBJECT IS NOT NULL AND F.Subject LIKE '%' + @SUBJECT + '%'))				
			AND ((@ID != 0 AND F.Id = @ID) OR @ID = 0)	
			AND ISNULL(IsDelete, 0) = 0
			AND ((@ROLE <> 'AD01' AND F.CreateUid = @CREATOR) OR @ROLE = 'AD01')
			AND F.IsApprove = 0
			AND (@DATEFROM IS NULL OR (@DATEFROM IS NOT NULL AND DATEDIFF(DAY, @DATEFROM, CreateDate) >=0 ))
			AND (@DATETO IS NULL OR (@DATETO IS NOT NULL AND DATEDIFF(DAY, CreateDate, @DATETO) >=0))
		ORDER BY F.CreateDate DESC, F.Subject DESC
		RETURN;
	END

	--------------------------------------------------------------------------------------------------------
	--LẤY RA NHỮNG CÁI NÀO ĐÃ ĐƯỢC DUYỆT
	APPROVED:
	BEGIN
		
		WITH CATEGORY(ID, NAME, PARENTID, PARENTNAME, LEVEL) AS(
			SELECT ID, Name, ParentID, CONVERT(NVARCHAR(500),''), 0
			FROM SysCategoryValue
			WHERE ParentID IS NULL AND Category = '054E0F62-4EFE-41E1-A18D-5C28A6531539'
			UNION ALL
			SELECT B.ID, B.Name, B.ParentID, A.NAME, A.LEVEL + 1
			FROM CATEGORY A, SysCategoryValue B
			WHERE A.ID = B.ParentID --AND ISNULL(B.Actived, 0) = 1 AND ISNULL(B.IsDelete, 0) = 0
		), 
		EMPMASTER AS (
			SELECT EmpId, Code, LocalName FROM HrEmpMaster
		),
		FORM_COUNT AS (
			SELECT CATEGORY, COUNT(Id) NUM FROM CmsFormTemplate
			GROUP BY CATEGORY
		),
		POSTACTION AS (
			SELECT MasterId, COUNT(MasterId) NUM FROM CmsPostAction
			WHERE ModuleId = '720DFEB8-A8FC-4ADB-BC81-33A9BAF633A0' AND CategoryId = '95A464F6-6D97-4F9C-B6F3-2D840A5A884C'
			GROUP BY MasterId
		)

		SELECT F.Id, F.Category, C.NAME CategoryName
			, CASE WHEN @ID != 0 THEN F.Subject ELSE '[' + C.NAME + '] ' +  F.Subject END Subject
			, E.LocalName, F.CreateUid, F.CreateDate, F.UpdateDate
			--, CONVERT(VARCHAR(10), F.CreateDate, 102) + ' ' + CONVERT(VARCHAR(8), F.CreateDate, 108) CreateDateC
			, ISNULL(A.LocalName, '') APRROVENAME, IsAttachFile
			, CASE WHEN @ID != 0 THEN F.Descript ELSE '' END Descript
			--, ISNULL(A.LocalName + '|' + CONVERT(VARCHAR(10), F.ApproveDate, 102), '|') ApproveDateC
			, F.IsAcive, F.IsSubmit, F.Reason, F.ApproveDate, F.ConfirmDate, f.IsApprove
			--, CONVERT(VARCHAR(10), F.ConfirmDate, 102) + ' ' + CONVERT(VARCHAR(8), F.ConfirmDate, 108) ConfirmDateC
			--, F.Subject + '|' + C.NAME + ': ' + CONVERT(VARCHAR(5), D.NUM) +' Posts' + '|' + E.LocalName + '|' + CONVERT(VARCHAR(10), F.CreateDate, 102) + ' ' + CONVERT(VARCHAR(8), F.CreateDate, 108) SubjectC
			, ISNULL(G.NUM, 0) NUM_READ
			, CASE WHEN ISNULL(IsSubmit, 0) = 0 THEN 'Temporary' WHEN IsSubmit = 1 AND ISNULL(IsApprove, 0) = 0 THEN 'Progressing' WHEN IsApprove = 1 THEN 'Approved' WHEN IsApprove = 0 THEN 'Reject' END STATUS
		FROM CmsFormTemplate F
		INNER JOIN EMPMASTER E ON F.CreateUid = E.EmpId
		LEFT JOIN EMPMASTER A ON F.ApproveUid = A.EmpId
		LEFT JOIN CATEGORY C ON F.Category = C.ID
		INNER JOIN FORM_COUNT D ON F.Category = D.Category
		LEFT JOIN POSTACTION G ON F.Id = G.MasterId
		WHERE 1=1
			AND (@SUBJECT IS NULL OR (@SUBJECT IS NOT NULL AND F.Subject LIKE '%' + @SUBJECT + '%'))				
			AND ((@ID != 0 AND F.Id = @ID) OR @ID = 0)	
			AND ISNULL(IsDelete, 0) = 0
			AND ((@ROLE <> 'AD01' AND F.CreateUid = @CREATOR) OR @ROLE = 'AD01')
			AND ISNULL(F.IsApprove, 0) = 1
			AND (@DATEFROM IS NULL OR (@DATEFROM IS NOT NULL AND DATEDIFF(DAY, @DATEFROM, CreateDate) >=0 ))
			AND (@DATETO IS NULL OR (@DATETO IS NOT NULL AND DATEDIFF(DAY, CreateDate, @DATETO) >=0))
		ORDER BY F.CreateDate DESC, F.Subject DESC
		RETURN;
	END

	--------------------------------------------------------------------------------------------------------
	--LẤY RA NHỮNG CÁI NÀO ĐÃ SUBMIT
	PROCCESS:
	BEGIN

		WITH CATEGORY(ID, NAME, PARENTID, PARENTNAME, LEVEL) AS(
			SELECT ID, Name, ParentID, CONVERT(NVARCHAR(500),''), 0
			FROM SysCategoryValue
			WHERE ParentID IS NULL AND Category = '054E0F62-4EFE-41E1-A18D-5C28A6531539'
			UNION ALL
			SELECT B.ID, B.Name, B.ParentID, A.NAME, A.LEVEL + 1
			FROM CATEGORY A, SysCategoryValue B
			WHERE A.ID = B.ParentID --AND ISNULL(B.Actived, 0) = 1 AND ISNULL(B.IsDelete, 0) = 0
		), 
		EMPMASTER AS (
			SELECT EmpId, Code, LocalName FROM HrEmpMaster
		),
		FORM_COUNT AS (
			SELECT CATEGORY, COUNT(Id) NUM FROM CmsFormTemplate
			GROUP BY CATEGORY
		),
		POSTACTION AS (
			SELECT MasterId, COUNT(MasterId) NUM FROM CmsPostAction
			WHERE ModuleId = '720DFEB8-A8FC-4ADB-BC81-33A9BAF633A0' AND CategoryId = '95A464F6-6D97-4F9C-B6F3-2D840A5A884C'
			GROUP BY MasterId
		)

		SELECT F.Id, F.Category, C.NAME CategoryName
			, CASE WHEN @ID != 0 THEN F.Subject ELSE '[' + C.NAME + '] ' +  F.Subject END Subject
			, E.LocalName, F.CreateUid, F.CreateDate, F.UpdateDate
			--, CONVERT(VARCHAR(10), F.CreateDate, 102) + ' ' + CONVERT(VARCHAR(8), F.CreateDate, 108) CreateDateC
			, ISNULL(A.LocalName, '') APRROVENAME, IsAttachFile
			, CASE WHEN @ID != 0 THEN F.Descript ELSE '' END Descript
			--, ISNULL(A.LocalName + '|' + CONVERT(VARCHAR(10), F.ApproveDate, 102), '|') ApproveDateC
			, F.IsAcive, F.IsSubmit, F.Reason, F.ApproveDate, F.ConfirmDate, f.IsApprove
			--, CONVERT(VARCHAR(10), F.ConfirmDate, 102) + ' ' + CONVERT(VARCHAR(8), F.ConfirmDate, 108) ConfirmDateC
			--, F.Subject + '|' + C.NAME + ': ' + CONVERT(VARCHAR(5), D.NUM) +' Posts' + '|' + E.LocalName + '|' + CONVERT(VARCHAR(10), F.CreateDate, 102) + ' ' + CONVERT(VARCHAR(8), F.CreateDate, 108) SubjectC
			, ISNULL(G.NUM, 0) NUM_READ
			, CASE WHEN ISNULL(IsSubmit, 0) = 0 THEN 'Temporary' WHEN IsSubmit = 1 AND ISNULL(IsApprove, 0) = 0 THEN 'Progressing' WHEN IsApprove = 1 THEN 'Approved' WHEN IsApprove = 0 THEN 'Reject' END STATUS
		FROM CmsFormTemplate F
		INNER JOIN EMPMASTER E ON F.CreateUid = E.EmpId
		LEFT JOIN EMPMASTER A ON F.ApproveUid = A.EmpId
		LEFT JOIN CATEGORY C ON F.Category = C.ID
		INNER JOIN FORM_COUNT D ON F.Category = D.Category
		LEFT JOIN POSTACTION G ON F.Id = G.MasterId
		WHERE 1=1
			AND (@SUBJECT IS NULL OR (@SUBJECT IS NOT NULL AND F.Subject LIKE '%' + @SUBJECT + '%'))				
			AND ((@ID != 0 AND F.Id = @ID) OR @ID = 0)	
			AND ISNULL(IsDelete, 0) = 0
			AND ((@ROLE <> 'AD01' AND F.CreateUid = @CREATOR) OR @ROLE = 'AD01')
			AND F.IsApprove IS NULL AND F.IsSubmit = 1
			AND (@DATEFROM IS NULL OR (@DATEFROM IS NOT NULL AND DATEDIFF(DAY, @DATEFROM, CreateDate) >=0 ))
			AND (@DATETO IS NULL OR (@DATETO IS NOT NULL AND DATEDIFF(DAY, CreateDate, @DATETO) >=0))
		ORDER BY F.CreateDate DESC, F.Subject DESC
		RETURN;
	END
	--SP_CMS_FORMTEMPLATE_GET
	--------------------------------------------------------------------------------------------------------
	--LẤY RA NHỮNG CÁI NÀO ĐÃ ĐƯỢC SUBMIT MÀ CHƯA CÓ ĐƯỢC DUYỆT
	TEMPORARY:
	BEGIN		
		WITH CATEGORY(ID, NAME, PARENTID, PARENTNAME, LEVEL) AS(
			SELECT ID, Name, ParentID, CONVERT(NVARCHAR(500),''), 0
			FROM SysCategoryValue
			WHERE ParentID IS NULL AND Category = '054E0F62-4EFE-41E1-A18D-5C28A6531539'
			UNION ALL
			SELECT B.ID, B.Name, B.ParentID, A.NAME, A.LEVEL + 1
			FROM CATEGORY A, SysCategoryValue B
			WHERE A.ID = B.ParentID --AND ISNULL(B.Actived, 0) = 1 AND ISNULL(B.IsDelete, 0) = 0
		), 
		EMPMASTER AS (
			SELECT EmpId, Code, LocalName FROM HrEmpMaster
		),
		FORM_COUNT AS (
			SELECT CATEGORY, COUNT(Id) NUM FROM CmsFormTemplate
			GROUP BY CATEGORY
		),
		POSTACTION AS (
			SELECT MasterId, COUNT(MasterId) NUM FROM CmsPostAction
			WHERE ModuleId = '720DFEB8-A8FC-4ADB-BC81-33A9BAF633A0' AND CategoryId = '95A464F6-6D97-4F9C-B6F3-2D840A5A884C'
			GROUP BY MasterId
		)

		SELECT F.Id, F.Category, C.NAME CategoryName
			, CASE WHEN @ID != 0 THEN F.Subject ELSE '[' + C.NAME + '] ' +  F.Subject END Subject
			, E.LocalName, F.CreateUid, F.CreateDate, F.UpdateDate
			--, CONVERT(VARCHAR(10), F.CreateDate, 102) + ' ' + CONVERT(VARCHAR(8), F.CreateDate, 108) CreateDateC
			, ISNULL(A.LocalName, '') APRROVENAME, IsAttachFile
			, CASE WHEN @ID != 0 THEN F.Descript ELSE '' END Descript
			--, ISNULL(A.LocalName + '|' + CONVERT(VARCHAR(10), F.ApproveDate, 102), '|') ApproveDateC
			, F.IsAcive, F.IsSubmit, F.Reason, F.ApproveDate, F.ConfirmDate, f.IsApprove
			--, CONVERT(VARCHAR(10), F.ConfirmDate, 102) + ' ' + CONVERT(VARCHAR(8), F.ConfirmDate, 108) ConfirmDateC
			--, F.Subject + '|' + C.NAME + ': ' + CONVERT(VARCHAR(5), D.NUM) +' Posts' + '|' + E.LocalName + '|' + CONVERT(VARCHAR(10), F.CreateDate, 102) + ' ' + CONVERT(VARCHAR(8), F.CreateDate, 108) SubjectC
			, ISNULL(G.NUM, 0) NUM_READ
			, CASE WHEN ISNULL(IsSubmit, 0) = 0 THEN 'Temporary' WHEN IsSubmit = 1 AND ISNULL(IsApprove, 0) = 0 THEN 'Progressing' WHEN IsApprove = 1 THEN 'Approved' WHEN IsApprove = 0 THEN 'Reject' END STATUS
		FROM CmsFormTemplate F
		INNER JOIN EMPMASTER E ON F.CreateUid = E.EmpId
		LEFT JOIN EMPMASTER A ON F.ApproveUid = A.EmpId
		LEFT JOIN CATEGORY C ON F.Category = C.ID
		INNER JOIN FORM_COUNT D ON F.Category = D.Category
		LEFT JOIN POSTACTION G ON F.Id = G.MasterId
		WHERE 1=1
			AND (@SUBJECT IS NULL OR (@SUBJECT IS NOT NULL AND F.Subject LIKE '%' + @SUBJECT + '%'))				
			AND ((@ID != 0 AND F.Id = @ID) OR @ID = 0)	
			AND ISNULL(IsDelete, 0) = 0
			AND F.CreateUid = @CREATOR	--lấy thêm những cái mà người đang đăng nhập tạo
			AND ISNULL(F.IsSubmit, 0) = 0
			AND (@DATEFROM IS NULL OR (@DATEFROM IS NOT NULL AND DATEDIFF(DAY, @DATEFROM, CreateDate) >=0 ))
			AND (@DATETO IS NULL OR (@DATETO IS NOT NULL AND DATEDIFF(DAY, CreateDate, @DATETO) >=0))
		ORDER BY F.CreateDate DESC, F.Subject DESC
		RETURN;
	END
	--SP_CMS_FORMTEMPLATE_GET
	--------------------------------------------------------------------------------------------------------
	--LẤY RA NHỮNG CÁI NÀO MÀ ĐƯỢC NGƯỜI ĐANG ĐĂNG NHẬP ĐÃ TẠO
	MYPOSTS:
	BEGIN

		WITH CATEGORY(ID, NAME, PARENTID, PARENTNAME, LEVEL) AS(
			SELECT ID, Name, ParentID, CONVERT(NVARCHAR(500),''), 0
			FROM SysCategoryValue
			WHERE ParentID IS NULL AND Category = '054E0F62-4EFE-41E1-A18D-5C28A6531539'
			UNION ALL
			SELECT B.ID, B.Name, B.ParentID, A.NAME, A.LEVEL + 1
			FROM CATEGORY A, SysCategoryValue B
			WHERE A.ID = B.ParentID --AND ISNULL(B.Actived, 0) = 1 AND ISNULL(B.IsDelete, 0) = 0
		), 
		EMPMASTER AS (
			SELECT EmpId, Code, LocalName FROM HrEmpMaster
		),
		FORM_COUNT AS (
			SELECT CATEGORY, COUNT(Id) NUM FROM CmsFormTemplate
			GROUP BY CATEGORY
		),
		POSTACTION AS (
			SELECT MasterId, COUNT(MasterId) NUM FROM CmsPostAction
			WHERE ModuleId = '720DFEB8-A8FC-4ADB-BC81-33A9BAF633A0' AND CategoryId = '95A464F6-6D97-4F9C-B6F3-2D840A5A884C'
			GROUP BY MasterId
		)

		SELECT F.Id, F.Category, C.NAME CategoryName
			, CASE WHEN @ID != 0 THEN F.Subject ELSE '[' + C.NAME + '] ' +  F.Subject END Subject
			, E.LocalName, F.CreateUid, F.CreateDate, F.UpdateDate
			--, CONVERT(VARCHAR(10), F.CreateDate, 102) + ' ' + CONVERT(VARCHAR(8), F.CreateDate, 108) CreateDateC
			, ISNULL(A.LocalName, '') APRROVENAME, IsAttachFile
			, CASE WHEN @ID != 0 THEN F.Descript ELSE '' END Descript
			--, ISNULL(A.LocalName + '|' + CONVERT(VARCHAR(10), F.ApproveDate, 102), '|') ApproveDateC
			, F.IsAcive, F.IsSubmit, F.Reason, F.ApproveDate, F.ConfirmDate, f.IsApprove
			--, CONVERT(VARCHAR(10), F.ConfirmDate, 102) + ' ' + CONVERT(VARCHAR(8), F.ConfirmDate, 108) ConfirmDateC
			--, F.Subject + '|' + C.NAME + ': ' + CONVERT(VARCHAR(5), D.NUM) +' Posts' + '|' + E.LocalName + '|' + CONVERT(VARCHAR(10), F.CreateDate, 102) + ' ' + CONVERT(VARCHAR(8), F.CreateDate, 108) SubjectC
			, ISNULL(G.NUM, 0) NUM_READ
			, CASE WHEN ISNULL(IsSubmit, 0) = 0 THEN 'Temporary' WHEN IsSubmit = 1 AND ISNULL(IsApprove, 0) = 0 THEN 'Progressing' WHEN IsApprove = 1 THEN 'Approved' WHEN IsApprove = 0 THEN 'Reject' END STATUS
		FROM CmsFormTemplate F
		INNER JOIN EMPMASTER E ON F.CreateUid = E.EmpId
		LEFT JOIN EMPMASTER A ON F.ApproveUid = A.EmpId
		LEFT JOIN CATEGORY C ON F.Category = C.ID
		INNER JOIN FORM_COUNT D ON F.Category = D.Category
		LEFT JOIN POSTACTION G ON F.Id = G.MasterId
		WHERE 1=1
			AND (@SUBJECT IS NULL OR (@SUBJECT IS NOT NULL AND F.Subject LIKE '%' + @SUBJECT + '%'))				
			AND ((@ID != 0 AND F.Id = @ID) OR @ID = 0)	
			AND ISNULL(IsDelete, 0) = 0
			AND F.CreateUid = @CREATOR	--lấy thêm những cái mà người đang đăng nhập tạo
			AND (@DATEFROM IS NULL OR (@DATEFROM IS NOT NULL AND DATEDIFF(DAY, @DATEFROM, CreateDate) >=0 ))
			AND (@DATETO IS NULL OR (@DATETO IS NOT NULL AND DATEDIFF(DAY, CreateDate, @DATETO) >=0))
		ORDER BY F.CreateDate DESC, F.Subject DESC
		RETURN;
	END	

--	[SP_CMS_FORMTEMPLATE_GET]
END

GO
/****** Object:  StoredProcedure [dbo].[SP_CMS_FORMTEMPLATE_INSERT]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 06-12-2016
-- Description:	INSERT FORMTEMPALTE
-- =============================================
CREATE PROCEDURE [dbo].[SP_CMS_FORMTEMPLATE_INSERT]
	-- Add the parameters for the stored procedure here
	@SUBJECT NVARCHAR(500) = NULL,
	@DESCRIPTION ntext = NULL,
	@ACTIVE BIT = 1,
	@CATEGORY VARCHAR(36) = NULL,
	@FILEPATH NVARCHAR(1000) = NULL,
	@FILENAME NVARCHAR(1000) = NULL,
	@USERID VARCHAR(20) = NULL
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @ID INT
	DECLARE @EMPID VARCHAR(20) = @USERID--(SELECT EMPID FROM HrEmpMaster WHERE Code = @USERID)
	DECLARE @CATENAME VARCHAR(200) = (SELECT Name FROM SYSCATEGORYVALUE WHERE ID = @CATEGORY)


	INSERT INTO CmsFormTemplate(Subject, Descript, Category, IsAcive, Writer, WriteDate,  CreateUid, CreateDate, IsAttachFile)
	VALUES(@SUBJECT, @DESCRIPTION, @CATEGORY, @ACTIVE, @EMPID, GETDATE(), @EMPID, GETDATE(), CASE WHEN @FILENAME <> '' THEN 1 ELSE 0 END)

	SET @ID = (SELECT SCOPE_IDENTITY())

	IF @FILENAME <> ''
	BEGIN
		DECLARE @TB_FILENAME TABLE (ID INT, FILENAME NVARCHAR(500))
		DECLARE @TB_FILEPATH TABLE (ID INT, FILEPATH NVARCHAR(500))

		INSERT INTO @TB_FILENAME SELECT ID, SplitItem FROM FN_SplitString(@FILENAME, '|')
		INSERT INTO @TB_FILEPATH SELECT ID, SplitItem FROM FN_SplitString(@FILEPATH, '|')

		INSERT INTO Attachment(ModuleId, MasterId, FileName, FilePath)
		SELECT '720DFEB8-A8FC-4ADB-BC81-33A9BAF633A0', @ID, A.FILENAME, B.FILEPATH
			--, REPLACE(FilePath, '/Resources/FormTemplate/','/Resources/FormTemplate/' + @CATENAME + '/') 
		FROM @TB_FILENAME A
		INNER JOIN @TB_FILEPATH B ON A.ID = B.ID
	END

	SELECT 'OK' RESULT
END

GO
/****** Object:  StoredProcedure [dbo].[SP_CMS_FORMTEMPLATE_UPDATE]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 06-12-2016
-- Description:	UPDATE FORMTEMPALTE
-- =============================================
CREATE PROCEDURE [dbo].[SP_CMS_FORMTEMPLATE_UPDATE]
	-- Add the parameters for the stored procedure here
	@ID INT,
	@SUBJECT NVARCHAR(500) = NULL,
	@DESCRIPTION ntext = NULL,
	@ACTIVE BIT = 1,
	@CATEGORY VARCHAR(36) = NULL,
	@FILEPATH NVARCHAR(1000) = NULL,
	@FILENAME NVARCHAR(1000) = NULL,
	@USERID VARCHAR(20) = NULL
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @EMPID VARCHAR(20) = @USERID--(SELECT EMPID FROM HrEmpMaster WHERE Code = @USERID)
	DECLARE @CATENAME VARCHAR(200) = (SELECT Name FROM SYSCATEGORYVALUE WHERE ID = @CATEGORY)

	--CẬP NHẬT FORMTEMPLATE
	UPDATE CmsFormTemplate 
	SET Subject = @SUBJECT,
		Descript = @DESCRIPTION,
		UpdateUid = @USERID,
		UpdateDate = GETDATE(),
		IsAcive = @ACTIVE,
		Category = @CATEGORY,
		IsAttachFile = CASE WHEN @FILENAME <> '' THEN 1 ELSE 0 END
	WHERE Id = @ID

	--XÓA FILE ĐÍNH KÈM
	DELETE Attachment WHERE ModuleId = '720DFEB8-A8FC-4ADB-BC81-33A9BAF633A0' AND MasterId = @ID

	--INSERT FILE ATTACHMENT

	IF @FILENAME <> ''
	BEGIN
		DECLARE @TB_FILENAME TABLE (ID INT, FILENAME NVARCHAR(500))
		DECLARE @TB_FILEPATH TABLE (ID INT, FILEPATH NVARCHAR(500))

		INSERT INTO @TB_FILENAME SELECT ID, SplitItem FROM FN_SplitString(@FILENAME, '|')
		INSERT INTO @TB_FILEPATH SELECT ID, SplitItem FROM FN_SplitString(@FILEPATH, '|')

		INSERT INTO Attachment(ModuleId, MasterId, FileName, FilePath)
		SELECT '720DFEB8-A8FC-4ADB-BC81-33A9BAF633A0', @ID, A.FILENAME, B.FilePath
			--, REPLACE(FilePath, '/Resources/FormTemplate/','/Resources/FormTemplate/' + @CATENAME + '/') 
		FROM @TB_FILENAME A
		INNER JOIN @TB_FILEPATH B ON A.ID = B.ID
		WHERE B.FILEPATH NOT IN (SELECT FILEPATH FROM Attachment WHERE ModuleId = '720DFEB8-A8FC-4ADB-BC81-33A9BAF633A0' AND MasterId = @ID)
	END

	SELECT 'OK' RESULT
END

GO
/****** Object:  StoredProcedure [dbo].[SP_CMS_GET_TREEVIEW_VIA_CATEGORY]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 28-11-2016
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_CMS_GET_TREEVIEW_VIA_CATEGORY]
	@CATEGORY VARCHAR(36) = '054e0f62-4efe-41e1-a18d-5c28a6531539',
	@ROLE VARCHAR(4) = 'US01'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @CATEGORY = '054e0f62-4efe-41e1-a18d-5c28a6531539'
		GOTO FORMTEMPLATE
	ELSE
		GOTO NORMAL

	NORMAL:
	BEGIN
		WITH CATEGORY(ID, NAME, PARENTID, PARENTNAME, LEVEL) AS(
			SELECT ID, Name, ParentID, CONVERT(NVARCHAR(500),''), 0
			FROM SysCategoryValue
			WHERE ParentID IS NULL AND Category = @CATEGORY
			UNION ALL
			SELECT B.ID, B.Name, B.ParentID, A.NAME, A.LEVEL + 1
			FROM CATEGORY A, SysCategoryValue B
			WHERE A.ID = B.ParentID AND ISNULL(B.Actived, 0) = 1 AND ISNULL(B.IsDelete, 0) = 0
		)
		SELECT  CONVERT(VARCHAR(36), A.ID) ID, A.NAME, ISNULL(CONVERT(VARCHAR(36),A.PARENTID), '-1') PARENTID, PARENTNAME, LEVEL, b.SubCode ICON FROM CATEGORY A
		LEFT JOIN SysCategoryValue B ON A.ID = B.ID
		ORDER BY A.LEVEL, B.Sequence
	END

	FORMTEMPLATE:
	BEGIN
		--KIỂM TRA NẾU ROLE NÀY CÓ QUYỀN INSERT THÌ HIỆN MYPOST
		DECLARE @HASINSERT BIT = (SELECT IsAllow FROM SysRoleMapping WHERE RoleId = @ROLE AND ControllerId = 'FormTemplateController' AND ActionId = 'Insert');		
		WITH CATEGORY(ID, NAME, PARENTID, PARENTNAME, LEVEL) AS(
			SELECT ID, Name, ParentID, CONVERT(NVARCHAR(500),''), 0
			FROM SysCategoryValue
			WHERE ParentID IS NULL AND Category = @CATEGORY AND (@HASINSERT IS NOT NULL OR (@HASINSERT IS NULL AND ID <> 'EAF964F0-F557-40C7-AD06-F0B4A6571A4F'))
			UNION ALL
			SELECT B.ID, B.Name, B.ParentID, A.NAME, A.LEVEL + 1
			FROM CATEGORY A, SysCategoryValue B
			WHERE A.ID = B.ParentID AND ISNULL(B.Actived, 0) = 1 AND ISNULL(B.IsDelete, 0) = 0
		), NUMCATE AS (
			SELECT CATEGORY, COUNT(Id) NUM 
			FROM CmsFormTemplate
			WHERE IsApprove = 1 AND ISNULL(IsDelete, 0) = 0
			GROUP BY CATEGORY
		)

		SELECT  CONVERT(VARCHAR(36), A.ID) ID, A.NAME + ISNULL(' (' + CONVERT(VARCHAR(5), C.NUM) + ')', '') NAME, ISNULL(CONVERT(VARCHAR(36),A.PARENTID), '-1') PARENTID, PARENTNAME, LEVEL, b.SubCode ICON 
		FROM CATEGORY A
		LEFT JOIN SysCategoryValue B ON A.ID = B.ID
		LEFT JOIN NUMCATE C ON B.ID = C.Category
		ORDER BY A.LEVEL, B.Sequence
	END

END

GO
/****** Object:  StoredProcedure [dbo].[SP_CMS_POSTS_GET]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2016-12-15
-- Description:	LẤY LÊN DANH SÁCH BÀI ĐĂNG
-- =============================================
CREATE PROCEDURE [dbo].[SP_CMS_POSTS_GET]
	-- Add the parameters for the stored procedure here
	@SUBJECT NVARCHAR(100) = null,--'querry',
	@CREATOR VARCHAR(20) = '1000083',
	@KIND VARCHAR(36) = null,
	@CATEGORY VARCHAR(36) = null,--'C4FF5A2F-CD32-4785-9499-A26E5148D58D'
	@ID INT = 0,
	@DATEFROM DATE = NULL,
	@DATETO DATE = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;
	
	IF @CATEGORY = '5EC2C2DF-990F-4A31-915B-11262C30F90B' SET @CATEGORY = NULL;--LẤY HẾT TẤT CẢ

	WITH CATEGORY(ID, NAME, PARENTID, PARENTNAME, LEVEL) AS(
		SELECT ID, Name, ParentID, CONVERT(NVARCHAR(500),''), 0
		FROM SysCategoryValue
		WHERE ((@CATEGORY IS NULL AND ParentID IS NULL) OR ID = @CATEGORY) AND Category = '7ee83563-73bf-4562-b91b-29ff46071775'
		UNION ALL
		SELECT B.ID, B.Name, B.ParentID, A.NAME, A.LEVEL + 1
		FROM CATEGORY A, SysCategoryValue B
		WHERE A.ID = B.ParentID --AND ISNULL(B.Actived, 0) = 1 AND ISNULL(B.IsDelete, 0) = 0
	), 
	EMPMASTER AS (
		SELECT EmpId, Code, LocalName FROM HrEmpMaster-- WHERE @CREATOR IS NULL OR (@CREATOR IS NOT NULL AND EmpId = @CREATOR)
	),	
	POSTACTION AS (
		SELECT MasterId, COUNT(MasterId) NUM FROM CmsPostAction
		WHERE ModuleId = '720DFEB8-A8FC-4ADB-BC81-33A9BAF633A0' AND CategoryId = '95A464F6-6D97-4F9C-B6F3-2D840A5A884C'
		GROUP BY MasterId
	),
	KINDFAQ AS (
		SELECT ID, SubCode, Name FROM SysCategoryValue WHERE Category = '0ab7cf6d-56a4-4cf1-bd9e-1d5fbc1c0ff0'
	)
	SELECT F.PostId
		,CASE WHEN @ID <> 0 THEN F.Subject ELSE '[' + C.NAME + ISNULL(' - ' + K.NAME, '') + '] ' + F.Subject END Subject
		, F.IsActive, F.IsAttachFile, G.NUM NUMREAD, E.LocalName CREATERNM, F.CreateUid, F.CreateDate, C.NAME CATENAME, F.ApplyToPlant
		,F.Kind, ISNULL(K.Name, '') KindName, F.Category
		--,CASE WHEN @ID = 0 THEN '' ELSE F.Content END Content,
		,CASE WHEN @ID <> 0 THEN F.Content ELSE '' END Content
		,CASE WHEN ApplyToPlant = '' THEN '' ELSE STUFF ((SELECT ', ' + E.EnName+' '
						FROM HrDeptMaster E
						INNER JOIN (SELECT SplitItem, id FROM FN_SplitString(F.ApplyToPlant,',')) SP ON E.Id = SplitItem
						ORDER BY SP.id
						FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)') , 1, 1, '')
					END AS  ApplyToPlantName
	FROM CmsPosts F
	INNER JOIN EMPMASTER E ON F.CreateUid = E.EmpId
	INNER JOIN CATEGORY C ON F.Category = C.ID
	LEFT JOIN POSTACTION G ON F.PostId = G.MasterId
	LEFT JOIN KINDFAQ K ON F.Kind = K.ID
	WHERE (1=1		
		AND F.IsActive = 1 OR (F.CreateUid = @CREATOR AND F.IsActive IN (0,1)))
		AND F.IsDelete = 0
		AND ((@SUBJECT IS NOT NULL AND F.Subject LIKE '%' + @SUBJECT +'%') OR @SUBJECT IS NULL)
		AND ((@ID <> 0 AND F.PostId = @ID) OR @ID = 0)
		AND (@DATEFROM IS NULL OR (@DATEFROM IS NOT NULL AND DATEDIFF(DAY, @DATEFROM, CreateDate) >=0 ))
		AND (@DATETO IS NULL OR (@DATETO IS NOT NULL AND DATEDIFF(DAY, CreateDate, @DATETO) >=0))
		AND (@KIND IS NULL OR (@KIND IS NOT NULL AND Kind = @KIND))
	ORDER BY F.CreateDate DESC, F.Subject DESC
		
--	[[SP_CMS_POSTS_GET]]
END

GO
/****** Object:  StoredProcedure [dbo].[SP_CMS_POSTS_GET_PLANT]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2016-12-16
-- Description:	LẤY LÊN DANH SÁCH NHÀ MÁY
-- =============================================
CREATE PROCEDURE [dbo].[SP_CMS_POSTS_GET_PLANT]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	WITH DEPT(ID, NAME, PARENTID, LEVEL, Code) AS(
			SELECT ID, EnName, Parent, 0, Code FROM HrDeptMaster
			WHERE Parent IS NULL
			UNION ALL
			SELECT B.ID, B.EnName, B.Parent, A.LEVEL + 1, B.Code FROM DEPT A, HrDeptMaster B
			WHERE A.ID = B.Parent --AND B.DelFlag = 0
	)	

	SELECT Id, NAME,  PARENTID
	FROM DEPT
	WHERE Level IN (0,1)
	ORDER BY Code

END

GO
/****** Object:  StoredProcedure [dbo].[SP_CMS_POSTS_GET_TOP10]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2016-12-15
-- Description:	LẤY LÊN DANH SÁCH BÀI ĐĂNG
-- =============================================
CREATE PROCEDURE [dbo].[SP_CMS_POSTS_GET_TOP10]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;
	
	WITH CATEGORY(ID, NAME, PARENTID, PARENTNAME, LEVEL) AS(
		SELECT ID, Name, ParentID, CONVERT(NVARCHAR(500),''), 0
		FROM SysCategoryValue
		WHERE  ParentID IS NULL AND Category = '7ee83563-73bf-4562-b91b-29ff46071775'
		UNION ALL
		SELECT B.ID, B.Name, B.ParentID, A.NAME, A.LEVEL + 1
		FROM CATEGORY A, SysCategoryValue B
		WHERE A.ID = B.ParentID --AND ISNULL(B.Actived, 0) = 1 AND ISNULL(B.IsDelete, 0) = 0
	), 
	EMPMASTER AS (
		SELECT EmpId, Code, LocalName FROM HrEmpMaster-- WHERE @CREATOR IS NULL OR (@CREATOR IS NOT NULL AND EmpId = @CREATOR)
	),	
	KINDFAQ AS (
		SELECT ID, SubCode, Name FROM SysCategoryValue WHERE Category = '0ab7cf6d-56a4-4cf1-bd9e-1d5fbc1c0ff0'
	)
	SELECT TOP 10 F.PostId
		, '[' + C.NAME + ISNULL(' - ' + K.NAME, '') + '] ' + F.Subject Subject
		, E.LocalName CREATERNM, F.CreateUid, F.CreateDate
		,F.Kind, ISNULL(K.Name, '') KindName, F.Category
	FROM CmsPosts F
	INNER JOIN EMPMASTER E ON F.CreateUid = E.EmpId
	INNER JOIN CATEGORY C ON F.Category = C.ID
	LEFT JOIN KINDFAQ K ON F.Kind = K.ID
	WHERE 1=1		
		AND F.IsActive = 1
		AND F.IsDelete = 0
	ORDER BY F.CreateDate DESC, F.Subject DESC
		
--	[[SP_CMS_POSTS_GET]]
END

GO
/****** Object:  StoredProcedure [dbo].[SP_CMS_POSTS_INSERT]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 06-12-2016
-- Description:	INSERT NEW FAQ
-- =============================================
CREATE PROCEDURE [dbo].[SP_CMS_POSTS_INSERT]
	-- Add the parameters for the stored procedure here
	@SUBJECT NVARCHAR(1000) = NULL,
	@CONTENT NTEXT = NULL,
	@ACTIVE BIT = 1,
	@CATEGORY VARCHAR(36) = NULL,
	@KIND VARCHAR(36) = NULL,
	@APPLYFORPLANT VARCHAR(200) = NULL,
	@USERID VARCHAR(20) = NULL
AS
BEGIN

	SET NOCOUNT ON;

	INSERT INTO CmsPosts(SUBJECT, ISACTIVE, Category, CONTENT, KIND, APPLYTOPLANT, CREATEUID, CREATEDATE)
	VALUES (@SUBJECT, @ACTIVE, @CATEGORY, @CONTENT, @KIND, @APPLYFORPLANT, @USERID, GETDATE())

	SELECT 'OK' RESULT
END

GO
/****** Object:  StoredProcedure [dbo].[SP_CMS_POSTS_UPDATE]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 06-12-2016
-- Description:	UPDATE FORMTEMPALTE
-- =============================================
CREATE PROCEDURE [dbo].[SP_CMS_POSTS_UPDATE]
	-- Add the parameters for the stored procedure here
	@ID INT,
	@SUBJECT NVARCHAR(1000) = NULL,
	@CONTENT NTEXT = NULL,
	@ACTIVE BIT = 1,
	@CATEGORY VARCHAR(36) = NULL,
	@KIND VARCHAR(36) = NULL,
	@APPLYFORPLANT VARCHAR(200) = NULL,
	@USERID VARCHAR(20) = NULL
AS
BEGIN

	SET NOCOUNT ON;

	UPDATE CmsPosts 
	SET Subject = @SUBJECT,
		Content = @CONTENT,
		IsActive = @ACTIVE,
		Kind = @KIND,
		Category = @CATEGORY,
		UpdateUid = @USERID,
		UpdateDate = GETDATE(),
		ApplyToPlant = @APPLYFORPLANT
	WHERE PostId = @ID

	SELECT 'OK' RESULT
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetMenu_Via_MasterMenu]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetMenu_Via_MasterMenu] 
	-- Add the parameters for the stored procedure here
	@MasterMenu varchar(36) = 'b60d622f-44fb-4494-b730-a2dd9b218fa2'
AS
BEGIN
	WITH TEMP(ID, Name, ParentID, Sequence , Action, Controller, Param, Icon, Actived)
	as (
			Select ID, Name, ParentID, Sequence , Action, Controller, Param, Icon, Actived
			From SysMenu
			Where ParentID is null and Actived = 1
			Union All
			Select B.ID, B.Name, B.ParentID, B.Sequence , B.Action, B.Controller, B.Param, B.Icon, B.Actived
			From TEMP as A, SysMenu as B
			Where A.ID = B.ParentID and B.Actived = 1
	)
	SELECT *
	FROM TEMP
	ORDER BY ParentID, Sequence
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetMenu_Via_MasterMenu_User]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetMenu_Via_MasterMenu_User] 
	-- Add the parameters for the stored procedure here
	@MasterMenu varchar(36) = '16FAAE45-DA0F-4A21-AEE7-FD3376C211A1',
	@User varchar(36) = 'ad01'
AS
BEGIN

	DECLARE @TBTEMP TABLE (ID UNIQUEIDENTIFIER, NAME NVARCHAR(100), PARENTID UNIQUEIDENTIFIER
							, SEQUENCE TINYINT, ACTION VARCHAR(100), CONTROLLER VARCHAR(100)
							, PARAM NVARCHAR(100), ICON VARCHAR(100), ACTIVED BIT, ISALLOW BIT)

	;WITH TEMP(ID, NAME, PARENTID, [SEQUENCE] , [ACTION], CONTROLLER, [PARAM], ICON, ACTIVED)
	AS (
			SELECT ID, NAME, PARENTID, [SEQUENCE] , [ACTION], CONTROLLER, [PARAM], ICON, ACTIVED
			FROM SYSMENU
			WHERE PARENTID IS NULL AND ACTIVED = 1
			UNION ALL
			SELECT B.ID, B.NAME, B.PARENTID, B.[SEQUENCE] , B.[ACTION], B.CONTROLLER, B.[PARAM], B.ICON, B.ACTIVED
			FROM TEMP AS A, SYSMENU AS B
			WHERE A.ID = B.PARENTID AND B.ACTIVED = 1
	)

	INSERT INTO @TBTEMP
	SELECT DISTINCT T.ID, T.NAME, T.PARENTID, T.[SEQUENCE] , T.[ACTION], T.CONTROLLER, T.[PARAM], T.ICON, T.ACTIVED, S.ISALLOW
	FROM TEMP T
	LEFT JOIN SYSROLEMAPPING S ON T.CONTROLLER + 'CONTROLLER' = S.CONTROLLERID AND S.ACTIONID = 'INDEX' AND S.ROLEID = @USER
	WHERE (S.ISALLOW = 1 AND PARENTID IS NOT NULL) OR PARENTID IS NULL

	SELECT A.ID, A.NAME, A.PARENTID, A.[SEQUENCE] , A.[ACTION], A.CONTROLLER, A.[PARAM], A.ICON, A.ACTIVED 
	FROM @TBTEMP A
	LEFT JOIN(
		SELECT PARENTID, COUNT(ID) NUM
		FROM @TBTEMP
		WHERE PARENTID IS NOT NULL
		GROUP BY PARENTID 
	) B ON A.ID = B.PARENTID
	WHERE A.ISALLOW = 1 OR (A.PARENTID IS NULL AND NUM IS NOT NULL)
	ORDER BY A.PARENTID, A.[SEQUENCE]
	--[SP_GETMENU_VIA_MASTERMENU_USER]
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetMenu_Via_MasterMenu_User_System]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetMenu_Via_MasterMenu_User_System] 
	-- Add the parameters for the stored procedure here
	@MasterMenu varchar(36) = '16FAAE45-DA0F-4A21-AEE7-FD3376C211A1',
	@User varchar(36) = 'ad01',
	@SystemId int = 3
AS
BEGIN

	DECLARE @TBTEMP TABLE (ID UNIQUEIDENTIFIER, NAME NVARCHAR(100), PARENTID UNIQUEIDENTIFIER
							, SEQUENCE TINYINT, ACTION VARCHAR(100), CONTROLLER VARCHAR(100)
							, PARAM NVARCHAR(100), ICON VARCHAR(100), ACTIVED BIT, ISALLOW BIT)

	;WITH TEMP(ID, NAME, PARENTID, [SEQUENCE] , [ACTION], CONTROLLER, [PARAM], ICON, ACTIVED)
	AS (
			SELECT ID, NAME, PARENTID, [SEQUENCE] , [ACTION], CONTROLLER, [PARAM], ICON, ACTIVED
			FROM SYSMENU
			WHERE PARENTID IS NULL AND ACTIVED = 1 AND SystemId = @SystemId
			UNION ALL
			SELECT B.ID, B.NAME, B.PARENTID, B.[SEQUENCE] , B.[ACTION], B.CONTROLLER, B.[PARAM], B.ICON, B.ACTIVED
			FROM TEMP AS A, SYSMENU AS B
			WHERE A.ID = B.PARENTID AND B.ACTIVED = 1 AND SystemId = @SystemId
	)

	INSERT INTO @TBTEMP
	SELECT DISTINCT T.ID, T.NAME, T.PARENTID, T.[SEQUENCE] , T.[ACTION], T.CONTROLLER, T.[PARAM], T.ICON, T.ACTIVED, S.ISALLOW
	FROM TEMP T
	LEFT JOIN SYSROLEMAPPING S ON T.CONTROLLER + 'CONTROLLER' = S.CONTROLLERID AND S.ACTIONID = 'INDEX' AND S.ROLEID = @USER
	--WHERE (S.ISALLOW = 1 AND PARENTID IS NOT NULL) OR PARENTID IS NULL
	
	SELECT A.ID, A.NAME, A.PARENTID, A.[SEQUENCE] , A.[ACTION], A.CONTROLLER, A.[PARAM], A.ICON, A.ACTIVED 
	FROM @TBTEMP A
	LEFT JOIN(
		SELECT PARENTID, COUNT(ID) NUM
		FROM @TBTEMP
		WHERE PARENTID IS NOT NULL
		GROUP BY PARENTID 
	) B ON A.ID = B.PARENTID
	--WHERE A.ISALLOW = 1 OR (A.PARENTID IS NULL AND NUM IS NOT NULL)
	ORDER BY A.PARENTID, A.[SEQUENCE]
	--[SP_GETMENU_VIA_MASTERMENU_USER]
END
GO
/****** Object:  StoredProcedure [dbo].[SP_SYS_ATTACHMENT_GET]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.24
-- Description:	LẤY LÊN DANH SÁCH FILE ĐÍNH KÈM
-- =============================================
CREATE PROCEDURE [dbo].[SP_SYS_ATTACHMENT_GET]
	-- Add the parameters for the stored procedure here
	@MODULEID VARCHAR(36) = '8C0D1530-AB8F-40D0-922C-63C9A208778A',
	@MASTERID INT = 8
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT AttachId, ModuleId, MasterId, [FileName], FilePath, FileType, FileSize 
	FROM Attachment
	WHERE ModuleId = @MODULEID AND MasterId = @MASTERID
END

GO
/****** Object:  StoredProcedure [dbo].[SP_SYS_ATTACHMENT_INSERT]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.24
-- Description:	INSERT ATTACHMENT FILE
-- =============================================
CREATE PROCEDURE [dbo].[SP_SYS_ATTACHMENT_INSERT]
	-- Add the parameters for the stored procedure here
	@MODULEID VARCHAR(36) = '234DD956-CD7F-4870-A1D4-865857432084',
	@MASTERID INT = 12 ,
	@FILENAME NVARCHAR(500) = 'aa728f0a-525a-4a0a-8a44-e13da661d1e4.jpg',
	@FILEPATH NVARCHAR(500) = '../Resource/Application/Violation/aa728f0a-525a-4a0a-8a44-e13da661d1e4-20171224 114254.jpg',
	@FILETYPE VARCHAR(50) = 'image/jpeg',
	@FILESIZE INT = 2331438
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO Attachment
	VALUES(@MODULEID, @MASTERID, @FILENAME, @FILEPATH, @FILETYPE, @FILESIZE)
END

GO
/****** Object:  StoredProcedure [dbo].[SP_SYS_DEPT_GET_TREE]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 28-11-2016
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_SYS_DEPT_GET_TREE]
	@DEPTID INT= 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	WITH DEPT(ID, NAME, KONAME, PARENTID, LEVEL, Code) AS(
		SELECT ID, ENNAME, KONAME, Parent, 0, Code FROM HrDeptMaster
		WHERE (@DEPTID <> 0 AND Id = @DEPTID) OR (@DEPTID = 0 AND Parent IS NULL)
		UNION ALL
		SELECT B.ID, B.EnName, B.KONAME, B.Parent, A.LEVEL + 1, B.Code FROM DEPT A, HrDeptMaster B
		WHERE A.ID = B.Parent AND B.IsDelete = 0
	)	

	SELECT * FROM DEPT
	ORDER BY CODE

END

GO
/****** Object:  StoredProcedure [dbo].[SP_SYS_GET_LOG_BY_DEPTID]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_SYS_GET_LOG_BY_DEPTID]
	@DEPTID INT = 66
--SP_SYS_GET_LOG_BY_DEPTID
AS
BEGIN

	SET NOCOUNT ON;

	WITH DEPT(ID, NAME, KONAME, PARENTID, LEVEL, Code) AS(
			SELECT ID, ENNAME, KONAME, Parent, 0, Code FROM HrDeptMaster
			WHERE (@DEPTID <> 0 AND Id = @DEPTID) OR (@DEPTID = 0 AND Parent IS NULL)
			UNION ALL
			SELECT B.ID, B.EnName, B.KONAME, B.Parent, A.LEVEL + 1, B.Code FROM DEPT A, HrDeptMaster B
			WHERE A.ID = B.Parent AND B.IsDelete = 0
		)

	SELECT E.LocalName,F.DeptName, F.PlantName, F.OrganizationName, S.LogTime, S.IpAddress, S.UserId, F.SectName
	FROM HrEmpMaster E
	INNER JOIN DEPT D ON E.[DeptCode] = D.ID
	LEFT JOIN HrDeptMasterFull F ON D.ID = F.Id
	INNER JOIN SysLogHistory S ON E.Code = S.UserId
	
	RETURN
	SELECT  hrem.LocalName, hrem.Code, hrem.DeptCode, hrdmf.DeptName, hrdmf.OrganizationName, hrdmf.PlantName,
	syslh.IpAddress, syslh.LogTime
	FROM HrEmpMaster hrem
	JOIN HrDeptMasterFull hrdmf ON hrem.DeptCode = hrdmf.Id
	JOIN SysLogHistory syslh ON hrem.Code = syslh.UserId
END
GO
/****** Object:  StoredProcedure [dbo].[SP_SYS_GET_MAIL_GROUP]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2016-12-15
-- Description:	LẤY LÊN DANH SÁCH BÀI ĐĂNG
-- =============================================
CREATE PROCEDURE [dbo].[SP_SYS_GET_MAIL_GROUP]
	-- Add the parameters for the stored procedure here
	@DEPTID INT = 191,
	@DEPTNAME NVARCHAR(200)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;
	
	WITH DEPT(ID, NAME, KONAME, PARENTID, LEVEL, Code) AS(
		SELECT ID, ENNAME, KONAME, Parent, 0, Code FROM HrDeptMaster
		WHERE (@DEPTID <> 0 AND Id = @DEPTID) OR (@DEPTID = 0 AND Parent IS NULL)
		UNION ALL
		SELECT B.ID, B.EnName, B.KONAME, B.Parent, A.LEVEL + 1, B.Code FROM DEPT A, HrDeptMaster B
		WHERE A.ID = B.Parent AND B.IsDelete = 0
	)	
	
	SELECT A.NAME
		, CASE WHEN B.Organization = 185 THEN 'vn' WHEN B.Organization = 179 THEN 'vd' END + A.Code + '@hyosung.com' MAILGROUP
		, A.KONAME
		, B.OrganizationName, B.PlantName, B.DeptName, B.SectName
	FROM DEPT A
	INNER JOIN HrDeptMasterFull B ON A.ID = B.Id
	WHERE @DEPTNAME IS NULL OR (@DEPTNAME IS NOT NULL AND A.NAME LIKE '%' + @DEPTNAME + '%')
	ORDER BY A.CODE ASC
	
END

GO
/****** Object:  StoredProcedure [dbo].[SP_SYS_LOG_HISTORY]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_SYS_LOG_HISTORY]
	@SUBJECT NVARCHAR(500) = NULL,
	@DEPTID INT = 0,
	@DATEFROM DATE = NULL,
	@DATETO DATE = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		WITH DEPT(ID, NAME, KONAME, PARENTID, LEVEL, Code) AS(
			SELECT ID, ENNAME, KONAME, Parent, 0, Code FROM HrDeptMaster
			WHERE (@DEPTID <> 0 AND Id = @DEPTID) OR (@DEPTID = 0 AND Parent IS NULL)
			UNION ALL
			SELECT B.ID, B.EnName, B.KONAME, B.Parent, A.LEVEL + 1, B.Code FROM DEPT A, HrDeptMaster B
			WHERE A.ID = B.Parent AND B.IsDelete = 0
		)

	SELECT S.UserId, E.LocalName, F.OrganizationName,F.PlantName, F.DeptName, S.LogTime, S.IpAddress, S.PcBrowser, F.SectName
	FROM HrEmpMaster E
	INNER JOIN DEPT D ON E.[DeptCode] = D.ID
	LEFT JOIN HrDeptMasterFull F ON D.ID = F.Id
	INNER JOIN SysLogHistory S ON E.Code = S.UserId

	WHERE 1=1
		AND (@SUBJECT IS NULL OR (@SUBJECT IS NOT NULL AND S.UserId LIKE '%' + @SUBJECT + '%' OR E.LocalName LIKE N'%' + @SUBJECT + '%' OR F.OrganizationName LIKE N'%' + @SUBJECT + '%' OR F.PlantName LIKE N'%' + @SUBJECT + '%' OR F.DeptName LIKE N'%' + @SUBJECT + '%'))
		AND (@DATEFROM IS NULL OR (@DATEFROM IS NOT NULL AND DATEDIFF(DAY, @DATEFROM, S.LogTime) >=0 ))
		AND (@DATETO IS NULL OR (@DATETO IS NOT NULL AND DATEDIFF(DAY, S.LogTime, @DATETO) >=0))

	RETURN
END

GO
/****** Object:  StoredProcedure [dbo].[SP_SYS_LOG_HISTORY_DIAGRAM_SITE_ACTIVITY]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.04.03
-- Description:	LẤY DỮ LIỆU SỐ LƯỢT ĐĂNG NHẬP TRONG NĂM
-- =============================================
CREATE PROCEDURE [dbo].[SP_SYS_LOG_HISTORY_DIAGRAM_SITE_ACTIVITY]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @TB_MONTH TABLE([MONTH] TINYINT, VALUE INT)
	DECLARE @MONTH INT = 1
	WHILE 1=1
	BEGIN
		INSERT INTO @TB_MONTH
		SELECT @MONTH, COUNT(UserId)
		FROM SysLogHistory
		WHERE DATEDIFF(YEAR, LogTime, GETDATE()) = 0 AND DATEPART(MONTH, LogTime) = @MONTH

		IF @MONTH >= 12
			BREAK
		SET @MONTH = @MONTH + 1
	END

	SELECT * FROM @TB_MONTH
END

GO
/****** Object:  StoredProcedure [dbo].[SP_SYS_MAIL_LIST]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2016-12-15
-- Description:	LẤY LÊN DANH SÁCH BÀI ĐĂNG
-- =============================================
CREATE PROCEDURE [dbo].[SP_SYS_MAIL_LIST]
	-- Add the parameters for the stored procedure here
	@SEARCHTYPE INT = 1, --1:EMP 2:NAME
	@EMPID VARCHAR(max) = 'VN55160524;vn55120697;vn55121895;vn55130863;vn55104052;vn55150827;vn55111981;vn55170532;vn55160939;vn55150815;vn55170127;vn55130401;vn55102959;vn55170524;vd52161081;vn55150150;vn55151729;vn55160630;vn55170528;vn55121006;vn55130664;vn55130187;vn55170521;vn55151015;vn55161568;vn55161405;vn55140503;vn55161937;vn55170220;vn55151275;vn55162011;vn55131153;vn55121524;vn55140193;vn55111960;vn55131163;vn55140512;vn55161161;vn55120829;vn55121033;vn55160833;vn55160208;vn55150022;vn55131107;vn55111180;vn55161735;vn55161757;vn55160015;vn55161841;vd52161096;vn55130213;vn55161418;vn55170544;vn55121347;vn55112332;vn55160361;vn55161788;vn55170534;vn55170281;vn55110757;vn55161705;vn55170525;vn55161202;vn55150341;vn55161704;vn55160381;vn55160947;vn55121069;vn55160714;vn55170517;vn55170399;vn55141041;vn55130189;vn55161438;vn55111069;vn55120545;vn55161275;vn55121345;vn55120631;vn55170388;vn55161796;vn55170531;vn55151093;vn55151798;vn55140944;vn55161427;vn55161828;vn55170523;vn55160293;vn55121480;vn55151496;vn55121857;vn55170030;vn55170520;vn55120034;vn55161445;vn55162124;vn55162152;vn55170151;vn55150200;vn55110651;vn55112137;vn55104017;vn55140976;vn55170527;vn55160899;vn55081425;vn55150238;50146;vn55140892;vn55102938;vn55120964;vn55111990;vn55170193;vn55120388;vd52160455;vn55170207;vn55150869;vn55160620;vn55110953;vn55160729;vn55161967;vn55170526;vn55121870;vn55170518;vn55110114;vn55121793;vn55170535;vn55121047;vn55141204;vn55170522;vn55150777;vn55150817;vn55150721;vn55170519;vn55170056;vn55170530;vn55104937;vn55111149;vn55170509;vn55161124;vn55105143;vn55170120;vn55151477;vn55150839;vn55161875;vn55112328;vn55121350;vn55151248;vn55151822;vn55121440;vn55120262;vn55161698;vn55160984;vn55121028;vn55140095;vn55140667;vn55111020;vn55162062;vn55151226;vn55170427;vn55150803;vn55151641;vn55120055;vn55170013;vn55160839;vn55161629;vn55160583;vn55121779;vn55162020;vn55170536;vn55104383;vn55120272;vn55150367;vn55161225;vn55160762;vn55131126;vn55141143;vn55092255;vn55161652;vn55160359;vn55130218;vn55160654;vn55170533;vn55120386;vn55151603;vn55104051;vn55160933;vn55150243;vn55120016;vn55160890;50210;vn55162058;vn55120014;vn55162041;50042;vn55170029;vn55151676;vn55102926;vn55121885;vn55120755;vd52150501;vn55161948;vn55170044;vn55151669;vn55160625;vn55150116;vn55161356;vn55120371;vn55161192;vn55151583;vn55170529;vn55104064;vn55130239;vn55140165;vn55150355;vn55121559;vn55121394;vn55120219;vn55110765;vn55112025;vn55151634;vn55170330;vn55130675;vn55150413;vn55161806;vn55161789;vn55160049;vn55121384;vn55161462;vn55110885;vn55121393;vn55111567',
	@EMPNAME NVARCHAR(max) = NULL,
	@SEX VARCHAR(1) = NULL,
	@NATION VARCHAR(2) = NULL,
	@DEPTID INT = 0,
	@HASEMAIL BIT = 1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;	

	IF @SEARCHTYPE = 1
		GOTO SEARCHBYID
	IF @SEARCHTYPE = 2
		GOTO SEARCHBYNAME
	SEARCHBYID:
	BEGIN
		WITH DEPT(ID, NAME, KONAME, PARENTID, LEVEL, Code) AS(
			SELECT ID, ENNAME, KONAME, Parent, 0, Code FROM HrDeptMaster
			WHERE (@DEPTID <> 0 AND Id = @DEPTID) OR (@DEPTID = 0 AND Parent IS NULL)
			UNION ALL
			SELECT B.ID, B.EnName, B.KONAME, B.Parent, A.LEVEL + 1, B.Code FROM DEPT A, HrDeptMaster B
			WHERE A.ID = B.Parent AND B.IsDelete = 0
		)
	
		SELECT F.OrganizationName, F.PlantName, F.DeptName, F.SectName, E.Code, E.LocalName, ISNULL(E.Email, '') Email
		FROM HrEmpMaster E
		INNER JOIN DEPT D ON E.[DeptCode] = D.ID
		LEFT JOIN HrDeptMasterFull F ON D.ID = F.Id
		WHERE 1=1	
			AND Status = 1
			AND (@SEX IS NULL OR (@SEX IS NOT NULL AND E.SEX = @SEX))
			AND (@NATION IS NULL OR (@NATION IS NOT NULL AND E.NATION = @NATION))
			AND (@EMPID IS NULL OR (@EMPID IS NOT NULL AND E.Code COLLATE Korean_Wansung_CI_AS IN (SELECT REPLACE(SplitItem, ' ','') FROM FN_SplitString(@EMPID, ';'))))
			AND ((@HASEMAIL = 1 AND ISNULL(E.Email, '') <> '') OR (@HASEMAIL = 0 AND ISNULL(E.Email, '') = ''))
		RETURN
	END

	SEARCHBYNAME:
	BEGIN
		WITH DEPT(ID, NAME, KONAME, PARENTID, LEVEL, Code) AS(
			SELECT ID, ENNAME, KONAME, Parent, 0, Code FROM HrDeptMaster
			WHERE (@DEPTID <> 0 AND Id = @DEPTID) OR (@DEPTID = 0 AND Parent IS NULL)
			UNION ALL
			SELECT B.ID, B.EnName, B.KONAME, B.Parent, A.LEVEL + 1, B.Code FROM DEPT A, HrDeptMaster B
			WHERE A.ID = B.Parent AND B.IsDelete = 0
		)
	
		SELECT F.OrganizationName, F.PlantName, F.DeptName, F.SectName, E.Code, E.LocalName, ISNULL(E.Email, '') Email
		FROM HrEmpMaster E
		INNER JOIN DEPT D ON E.[DeptCode] = D.ID
		LEFT JOIN HrDeptMasterFull F ON D.ID = F.Id
		WHERE 1=1	
			AND Status = 1
			AND (@SEX IS NULL OR (@SEX IS NOT NULL AND E.SEX = @SEX))
			AND (@NATION IS NULL OR (@NATION IS NOT NULL AND E.NATION = @NATION))
			AND (@EMPNAME IS NULL OR (@EMPNAME IS NOT NULL AND E.LocalName LIKE '%' + @EMPNAME + '%'))
			AND ((@HASEMAIL = 1 AND ISNULL(E.Email, '') <> '') OR (@HASEMAIL = 0 AND ISNULL(E.Email, '') = ''))
		RETURN
	END
	
END

GO
/****** Object:  StoredProcedure [dbo].[SP_SYS_NOTICES_GET]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 29-11-2016
-- Description:	LẤY LÊN DANH SÁCH FORMTEMPLATE
-- =============================================
CREATE PROCEDURE [dbo].[SP_SYS_NOTICES_GET]
	-- Add the parameters for the stored procedure here
	@SUBJECT NVARCHAR(100) = null,--'querry',
	@USERID VARCHAR(20) = NULL,
	@CREATOR VARCHAR(20) = '100083',
	@ID INT = 0,
	@DATEFROM DATE = NULL,
	@DATETO DATE = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ROLE VARCHAR(5) = (SELECT TOP 1 RoleId FROM SysUserMapping WHERE UserId = @CREATOR);

	WITH EMPMASTER AS (
		SELECT EmpId, Code, LocalName, DeptCode FROM HrEmpMaster-- WHERE @CREATOR IS NULL OR (@CREATOR IS NOT NULL AND EmpId = @CREATOR)
	)

	SELECT F.Id, F.Subject, E.LocalName, F.CreateUid, F.CreateDate, IsAttachFile
		, CASE WHEN @ID != 0 THEN F.Descript ELSE '' END Descript, F.IsAcive, F.UpdateDate
	FROM SysNotices F
	INNER JOIN EMPMASTER E ON F.CreateUid = E.EmpId
	WHERE 1=1		
		--AND (@CREATOR IS NOT NULL AND F.CreateUid = @CREATOR AND ISNULL(IsDelete, 0) = 0)
		AND ISNULL(IsDelete, 0) = 0
		AND ((@ID != 0 AND F.Id = @ID) OR @ID = 0)		
		AND (@SUBJECT IS NULL OR (@SUBJECT IS NOT NULL AND F.Subject LIKE '%' + @SUBJECT + '%'))
		AND (@DATEFROM IS NULL OR (@DATEFROM IS NOT NULL AND DATEDIFF(DAY, @DATEFROM, CreateDate) >=0 ))
		AND (@DATETO IS NULL OR (@DATETO IS NOT NULL AND DATEDIFF(DAY, CreateDate, @DATETO) >=0))
	ORDER BY F.CreateDate DESC, F.Subject DESC
	RETURN;

END

GO
/****** Object:  StoredProcedure [dbo].[SP_SYS_NOTICES_GET_TOP_10]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 29-11-2016
-- Description:	LẤY LÊN DANH SÁCH FORMTEMPLATE
-- =============================================
CREATE PROCEDURE [dbo].[SP_SYS_NOTICES_GET_TOP_10]
	-- Add the parameters for the stored procedure here
AS
BEGIN

	SET NOCOUNT ON;

	WITH EMPMASTER AS (
		SELECT EmpId, Code, LocalName, DeptCode FROM HrEmpMaster-- WHERE @CREATOR IS NULL OR (@CREATOR IS NOT NULL AND EmpId = @CREATOR)
	)

	SELECT TOP 5 F.Id, F.Subject , F.CreateDate, IsAttachFile, F.UpdateDate
		, F.IsAcive, F.IsSubmit, F.Reason, F.ApproveDate, F.ConfirmDate, f.IsApprove
		, E.LocalName
	FROM SysNotices F
	LEFT JOIN EMPMASTER E ON F.CreateUid = E.EmpId
	WHERE 1=1	
		AND ISNULL(IsDelete, 0) = 0	AND IsAcive = 1
			
	ORDER BY F.CreateDate DESC, F.Subject DESC
	RETURN;
END

GO
/****** Object:  StoredProcedure [dbo].[SP_SYS_NOTICES_INSERT]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 06-12-2016
-- Description:	INSERT FORMTEMPALTE
-- =============================================
CREATE PROCEDURE [dbo].[SP_SYS_NOTICES_INSERT]
	-- Add the parameters for the stored procedure here
	@SUBJECT NVARCHAR(500) = NULL,
	@DESCRIPTION ntext = NULL,
	@ACTIVE BIT = 1,
	@FILEPATH NVARCHAR(1000) = NULL,
	@FILENAME NVARCHAR(1000) = NULL,
	@USERID VARCHAR(20) = NULL
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @ID INT
	DECLARE @EMPID VARCHAR(20) = @USERID--(SELECT EMPID FROM HrEmpMaster WHERE Code = @USERID)

	INSERT INTO SysNotices(Subject, Descript, IsAcive, Writer, WriteDate,  CreateUid, CreateDate, IsAttachFile)
	VALUES(@SUBJECT, @DESCRIPTION, @ACTIVE, @EMPID, GETDATE(), @EMPID, GETDATE(), CASE WHEN @FILENAME <> '' THEN 1 ELSE 0 END)

	SET @ID = (SELECT SCOPE_IDENTITY())

	IF @FILENAME <> ''
	BEGIN
		DECLARE @TB_FILENAME TABLE (ID INT, FILENAME NVARCHAR(500))
		DECLARE @TB_FILEPATH TABLE (ID INT, FILEPATH NVARCHAR(500))

		INSERT INTO @TB_FILENAME SELECT ID, SplitItem FROM FN_SplitString(@FILENAME, '|')
		INSERT INTO @TB_FILEPATH SELECT ID, SplitItem FROM FN_SplitString(@FILEPATH, '|')

		INSERT INTO Attachment(ModuleId, MasterId, FileName, FilePath)
		SELECT '01e35e18-c660-4e7a-b1f8-f71c1c667f10', @ID, A.FILENAME, B.FILEPATH
		FROM @TB_FILENAME A
		INNER JOIN @TB_FILEPATH B ON A.ID = B.ID
	END

	SELECT 'OK' RESULT
END

GO
/****** Object:  StoredProcedure [dbo].[SP_SYS_NOTICES_UPDATE]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 06-12-2016
-- Description:	UPDATE FORMTEMPALTE
-- =============================================
CREATE PROCEDURE [dbo].[SP_SYS_NOTICES_UPDATE]
	-- Add the parameters for the stored procedure here
	@ID INT,
	@SUBJECT NVARCHAR(500) = NULL,
	@DESCRIPTION ntext = NULL,
	@ACTIVE BIT = 1,
	@FILEPATH NVARCHAR(1000) = NULL,
	@FILENAME NVARCHAR(1000) = NULL,
	@USERID VARCHAR(20) = NULL
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @EMPID VARCHAR(20) = @USERID--(SELECT EMPID FROM HrEmpMaster WHERE Code = @USERID)

	--CẬP NHẬT FORMTEMPLATE
	UPDATE SysNotices 
	SET Subject = @SUBJECT,
		Descript = @DESCRIPTION,
		UpdateUid = @USERID,
		UpdateDate = GETDATE(),
		IsAcive = @ACTIVE,
		IsAttachFile = CASE WHEN @FILENAME <> '' THEN 1 ELSE 0 END
	WHERE Id = @ID

	--XÓA FILE ĐÍNH KÈM
	DELETE Attachment WHERE ModuleId = '01e35e18-c660-4e7a-b1f8-f71c1c667f10' AND MasterId = @ID

	--INSERT FILE ATTACHMENT

	IF @FILENAME <> ''
	BEGIN
		DECLARE @TB_FILENAME TABLE (ID INT, FILENAME NVARCHAR(500))
		DECLARE @TB_FILEPATH TABLE (ID INT, FILEPATH NVARCHAR(500))

		INSERT INTO @TB_FILENAME SELECT ID, SplitItem FROM FN_SplitString(@FILENAME, '|')
		INSERT INTO @TB_FILEPATH SELECT ID, SplitItem FROM FN_SplitString(@FILEPATH, '|')

		INSERT INTO Attachment(ModuleId, MasterId, FileName, FilePath)
		SELECT '01e35e18-c660-4e7a-b1f8-f71c1c667f10', @ID, A.FILENAME, B.FilePath
			--, REPLACE(FilePath, '/Resources/FormTemplate/','/Resources/FormTemplate/' + @CATENAME + '/') 
		FROM @TB_FILENAME A
		INNER JOIN @TB_FILEPATH B ON A.ID = B.ID
		WHERE B.FILEPATH NOT IN (SELECT FILEPATH FROM Attachment WHERE ModuleId = '01e35e18-c660-4e7a-b1f8-f71c1c667f10' AND MasterId = @ID)
	END

	SELECT 'OK' RESULT
END

GO
/****** Object:  StoredProcedure [dbo].[SP_SYS_ROLE_GETUSER]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.04.10
-- Description:	LẤY LÊN DANH SACH USER THEO ROLE
-- =============================================
CREATE PROCEDURE [dbo].[SP_SYS_ROLE_GETUSER] 
	-- Add the parameters for the stored procedure here
	@ROLEID VARCHAR(5) = 'ad01',
	@SYSTEMID UNIQUEIDENTIFIER = '1BBA22EF-6912-460B-B112-A72DEC62F508'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT A.RoleId, E.Code, E.LocalName, D.ORGANIZATIONNAME, D.PLANTNAME, D.DEPTNAME, D.SECTNAME
	FROM SysUserMapping A
	LEFT JOIN SysRole B ON A.RoleId = B.RoleId
	LEFT JOIN HrEmpMaster E ON A.UserId = E.EmpId
	LEFT JOIN HrDeptMasterFull D ON E.DeptCode = D.Id
	WHERE A.RoleId = @ROLEID AND B.SystemId = @SYSTEMID
	ORDER BY D.CODE, E.Code
END

GO
/****** Object:  StoredProcedure [dbo].[SP_SYS_USER_LIST]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2016-12-15
-- Description:	LẤY LÊN DANH SÁCH NHÂN VIÊN
-- =============================================
CREATE PROCEDURE [dbo].[SP_SYS_USER_LIST]
	-- Add the parameters for the stored procedure here
	@SEARCHTYPE INT = 1, --1:EMP 2:NAME
	@EMPID NVARCHAR(max) = N'hs20170701',
	@EMPNAME NVARCHAR(max) = N'hs20170701',
	@DEPTID INT = 0,
	@SEX VARCHAR(1) = NULL,
	@NATION VARCHAR(2) = NULL,
	@HASEMAIL BIT = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;	

	--IF @SEARCHTYPE = 1 AND (CHARINDEX('VN', @EMPID) != 0 OR CHARINDEX('VD', @EMPID) != 0 OR CHARINDEX('hs', @EMPID) != 0)
	IF CHARINDEX('VN', @EMPID) != 0 OR CHARINDEX('VD', @EMPID) != 0 OR CHARINDEX('hs', @EMPID) != 0
		GOTO SEARCHBYID
	ELSE
		GOTO SEARCHBYNAME

	SEARCHBYID:
	BEGIN
		WITH DEPT(ID, NAME, KONAME, PARENTID, LEVEL, Code) AS(
			SELECT ID, ENNAME, KONAME, Parent, 0, Code FROM HrDeptMaster
			WHERE (@DEPTID <> 0 AND Id = @DEPTID) OR (@DEPTID = 0 AND Parent IS NULL)
			UNION ALL
			SELECT B.ID, B.EnName, B.KONAME, B.Parent, A.LEVEL + 1, B.Code FROM DEPT A, HrDeptMaster B
			WHERE A.ID = B.Parent AND B.IsDelete = 0
		),
		CATE AS (
			SELECT  ID, Sequence, Name FROM SysCategoryValue WHERE Category IN ('4C238FFC-EFB5-459B-B1E1-1670DFF78925')
		),
		PHONEINFO AS (
			SELECT TOP 1 CreateUid, HandPhoneNumber, PhoneNumber
			FROM GATE.VisitorApplicationMaster
			WHERE CreateUid COLLATE Korean_Wansung_CI_AS IN (SELECT REPLACE(SplitItem, ' ', '') FROM FN_SplitString(@EMPID, ';')) 
			ORDER BY CreateDate DESC
		)
	
		SELECT F.OrganizationName, F.PlantName, F.DeptName, F.SectName, E.Code, E.LocalName, ISNULL(E.Email, '') Email
			, C.NAME, E.Costcenter
			, F.OrganizationName + ISNULL(' > ' + F.PlantName, '') + ISNULL(' > ' + F.DeptName,'') + ISNULL(' > ' +  F.SectName,'') DeptFullName, E.DeptCode DeptId
			, P.HandPhoneNumber, P.PhoneNumber
		FROM HrEmpMaster E
		INNER JOIN DEPT D ON E.[DeptCode] = D.ID
		LEFT JOIN HrDeptMasterFull F ON D.ID = F.Id
		INNER JOIN CATE C ON E.uStatus = C.ID
		LEFT JOIN PHONEINFO P ON E.Code = P.CreateUid
		WHERE 1=1	
			AND Status = 1
			AND (@EMPID IS NULL OR (@EMPID IS NOT NULL AND E.Code COLLATE Korean_Wansung_CI_AS IN (SELECT REPLACE(SplitItem, ' ', '') FROM FN_SplitString(@EMPID, ';'))))
			AND (@SEX IS NULL OR (@SEX IS NOT NULL AND E.SEX = @SEX))
			AND (@NATION IS NULL OR (@NATION IS NOT NULL AND E.NATION = @NATION))
			AND (@HASEMAIL IS NULL OR ((@HASEMAIL = 1 AND ISNULL(E.Email, '') <> '') OR (@HASEMAIL = 0 AND ISNULL(E.Email, '') = '')))
		ORDER BY D.Code, E.Code
		RETURN
	END

	SEARCHBYNAME:
	BEGIN
		WITH DEPT(ID, NAME, KONAME, PARENTID, LEVEL, Code) AS(
			SELECT ID, ENNAME, KONAME, Parent, 0, Code FROM HrDeptMaster
			WHERE (@DEPTID <> 0 AND Id = @DEPTID) OR (@DEPTID = 0 AND Parent IS NULL)
			UNION ALL
			SELECT B.ID, B.EnName, B.KONAME, B.Parent, A.LEVEL + 1, B.Code FROM DEPT A, HrDeptMaster B
			WHERE A.ID = B.Parent AND B.IsDelete = 0
		),
		CATE AS (
			SELECT  ID, Sequence, Name FROM SysCategoryValue WHERE Category IN ('4C238FFC-EFB5-459B-B1E1-1670DFF78925')
		)
	
		SELECT F.OrganizationName, F.PlantName, F.DeptName, F.SectName, E.Code, E.LocalName, ISNULL(E.Email, '') Email
			, C.NAME, E.Costcenter
			, F.OrganizationName + ISNULL(' > ' + F.PlantName, '') + ISNULL(' > ' + F.DeptName,'') + ISNULL(' > ' +  F.SectName,'') DeptFullName, E.DeptCode DeptId
			, P.HandPhoneNumber, P.PhoneNumber
		FROM HrEmpMaster E
		INNER JOIN DEPT D ON E.[DeptCode] = D.ID
		LEFT JOIN HrDeptMasterFull F ON D.ID = F.Id
		INNER JOIN CATE C ON E.uStatus = C.ID
		OUTER APPLY (
			SELECT TOP 1 HandPhoneNumber, PhoneNumber
			FROM GATE.VisitorApplicationMaster 
			WHERE CreateUid = E.Code
			ORDER BY CreateDate DESC
		) P
		WHERE 1=1	
			AND Status = 1
			AND (@EMPID IS NULL OR (@EMPID IS NOT NULL AND (E.LocalName LIKE '%' + @EMPID + '%') OR (E.EnName LIKE '%' + @EMPID + '%')))
			AND (@SEX IS NULL OR (@SEX IS NOT NULL AND E.SEX = @SEX))
			AND (@NATION IS NULL OR (@NATION IS NOT NULL AND E.NATION = @NATION))
			AND (@HASEMAIL IS NULL OR ((@HASEMAIL = 1 AND ISNULL(E.Email, '') <> '') OR (@HASEMAIL = 0 AND ISNULL(E.Email, '') = '')))
		ORDER BY D.Code, E.Code
		RETURN
	END
	
END

GO
/****** Object:  StoredProcedure [dbo].[SP_SYS_USER_LOGIN]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.11.01
-- Description:	KIỂM TRA THÔNG TIN KHI LOGIN
-- =============================================
CREATE PROCEDURE [dbo].[SP_SYS_USER_LOGIN]
	-- Add the parameters for the stored procedure here
	@EMPID VARCHAR(20) = 'LH18030101',
	@PASSWORD NVARCHAR(500) = 'jDo3W1SCeTE='
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;	
	
	SELECT E.Code, E.LocalName, ISNULL(E.Email, '') Email, E.EmpId, CAST(E.Img AS VARBINARY(MAX)) AS Img
		, E.DeptCode, E.uStatus, ISNULL(M.RoleId, '') RoleId, ISNULL(R.RoleName, '') RoleName, E.[Password], ISNULL(J.Name, '') JobTitle, ISNULL(P.Name, '') PositionName, CONVERT(VARCHAR(10), CONVERT(DATE, JoinDate), 102) JoinDate
		, D.OrganizationName + ISNULL(' > ' + D.PlantName, '') + ISNULL(' > ' + D.DeptName,'') + ISNULL(' > ' +  D.SectName,'') DeptFullName
	FROM HrEmpMaster E
	LEFT JOIN SysUserMapping M ON E.EmpId = M.UserId
	LEFT JOIN SysRole R ON M.RoleId = R.RoleId
	LEFT JOIN HrDeptMasterFull D ON E.DeptCode = D.Id
	LEFT JOIN SysCategoryValue J ON E.JobTitleId = J.SubCode AND J.Category = '1DCBC106-D82B-4C86-8013-EFA92CA0E788'
	LEFT JOIN SysCategoryValue P ON E.PositionId = P.SubCode AND P.Category = '1856B793-C271-423C-8954-981E4B86AF46'
	WHERE 1=1
		AND E.Code = @EMPID AND E.Password = @PASSWORD COLLATE SQL_Latin1_General_CP1_CS_AS
	

END

GO
/****** Object:  StoredProcedure [dbo].[SP_SYS_USER_LOGIN_GUARD]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.11.01
-- Description:	KIỂM TRA THÔNG TIN KHI LOGIN
-- =============================================
CREATE PROCEDURE [dbo].[SP_SYS_USER_LOGIN_GUARD]
	-- Add the parameters for the stored procedure here
	@EMPID VARCHAR(20) = 'LH18030101',
	@PASSWORD NVARCHAR(500) = 'jDo3W1SCeTE='
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;	
	
	SELECT GuardId Code, '[' + V.Name + '] ' + G.Name LocalName, '' Email, '' EmpId, CAST(NULL AS VARBINARY(MAX)) AS Img
		, 0 DeptCode, Gate uStatus, '' RoleId, '' RoleName, [Password], '' JobTitle, '' PositionName, CONVERT(VARCHAR(10), CONVERT(DATE, G.CreateDate), 102) JoinDate
		, '' DeptFullName
	FROM GATE.Guard G
	LEFT JOIN SysCategoryValue C ON G.Gate = C.ID
	LEFT JOIN SysCategoryValue V ON G.Vendor = V.ID
	WHERE GuardId = @EMPID

END

GO
/****** Object:  StoredProcedure [dbo].[SP_SYSTEM_INTERFACE_DEPARTMENT]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 02.12.2016
-- Description:	INTERFACE T_SYS_DEPT
-- =============================================
CREATE PROCEDURE [dbo].[SP_SYSTEM_INTERFACE_DEPARTMENT] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	
	WITH TB_DEPTMASTER AS (
		SELECT A.DEPT_ID, A.ORG_NM, A.ORG_FNM, A.DEPT_PID, A.DEL_LG, A.ORG_TYPE --, B.PL_CD COST_CENTER
		FROM [LinkOracleMeal]..[HS].[V_DEPT] A		
	)

	MERGE INTO HrDeptMaster A
	USING (
		SELECT * FROM TB_DEPTMASTER
	)B
	ON A.Code COLLATE Korean_Wansung_CI_AS = B.DEPT_ID
	WHEN MATCHED THEN
	UPDATE SET A.IsDelete = B.DEL_LG, A.KONAME = B.ORG_FNM, A.EnName = B.ORG_NM
	WHEN NOT MATCHED THEN
		INSERT (Code , ENNAME, KONAME, IsDelete, ParentCode)
		VALUES (B.DEPT_ID, B.ORG_NM, B.ORG_FNM, B.DEL_LG, B.DEPT_PID);


	MERGE INTO HrDeptMaster A
	USING HrDeptMaster B
	ON A.ParentCode = B.Code
	WHEN MATCHED THEN
	UPDATE SET A.Parent = B.ID;
	
	DELETE HrDeptMasterFull;
	WITH 
		DEPT(ID, NAME, KONAME, PARENTID, LEVEL, Code) AS(
				SELECT ID, ENNAME, KONAME, Parent, 0, Code FROM HrDeptMaster
				WHERE Parent IS NULL
				UNION ALL
				SELECT B.ID, B.EnName, B.KONAME, B.Parent, A.LEVEL + 1, B.Code FROM DEPT A, HrDeptMaster B
				WHERE A.ID = B.Parent --AND B.DelFlag = 0
			)	
	SELECT * INTO #TEMP FROM DEPT
	--LẤY MẤY THẰNG SECTION RA TRƯỚC
	INSERT INTO HrDeptMasterFull(ID, CODE, ENNAME, KONAME, ORGANIZATION, PLANT, DEPT, SECT, ORGANIZATIONNAME, PLANTNAME, DEPTNAME, SECTNAME, [LEVEL])
	SELECT A.ID, A.CODE, A.NAME, A.KONAME, D.ID, B.PARENTID, A.PARENTID, A.ID,  D.NAME , C.NAME, B.NAME, A.NAME , A.[LEVEL]
	FROM #TEMP A
	LEFT JOIN #TEMP B ON A.PARENTID = B.ID--DEPARTMENT
	LEFT JOIN #TEMP C ON B.PARENTID = C.ID--PLANT
	LEFT JOIN #TEMP D ON C.PARENTID = D.ID--ORGANIZATION
	WHERE A.[LEVEL] = 3

	INSERT INTO HrDeptMasterFull (ID, CODE, ENNAME, KONAME, ORGANIZATION, PLANT, DEPT, ORGANIZATIONNAME, PLANTNAME, DEPTNAME, [LEVEL])
	SELECT A.ID, A.CODE, A.NAME, A.KONAME, B.PARENTID, A.PARENTID, A.ID, C.NAME, B.NAME, A.NAME , A.[LEVEL]
	FROM #TEMP A
	LEFT JOIN #TEMP B ON A.PARENTID = B.ID
	LEFT JOIN #TEMP C ON B.PARENTID = C.ID--PLANT
	WHERE A.[LEVEL] = 2

	INSERT INTO HrDeptMasterFull (ID, CODE, ENNAME, KONAME, ORGANIZATION, PLANT, ORGANIZATIONNAME, PLANTNAME, [LEVEL])
	SELECT A.ID, A.CODE, A.NAME, A.KONAME, A.PARENTID, A.ID, B.NAME, A.NAME , A.[LEVEL]
	FROM #TEMP A
	LEFT JOIN #TEMP B ON A.PARENTID = B.ID
	WHERE A.[LEVEL] = 1

	INSERT INTO HrDeptMasterFull (ID, CODE, ENNAME, KONAME, ORGANIZATION, ORGANIZATIONNAME, [LEVEL])
	SELECT A.ID, A.CODE, A.NAME, A.KONAME, A.ID, A.NAME , A.[LEVEL]
	FROM #TEMP A
	WHERE A.[LEVEL] = 0

	--SELECT * FROM HR_DEPT_MASTER_FULL ORDER BY [level]
	DROP TABLE #TEMP

END
GO
/****** Object:  StoredProcedure [dbo].[SP_SYSTEM_INTERFACE_EMPLOYEE]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_SYSTEM_INTERFACE_EMPLOYEE] 

AS
BEGIN	
	DECLARE @MAX_EMPID NVARCHAR(20)
	SET @MAX_EMPID = (SELECT MAX(EMPID) FROM HrEmpMaster)		

	INSERT INTO HrEmpMaster([EmpId],[Code],[LocalName],[EnName],[Email],[PositionId],[Status],[DeptCode],[Password],[uStatus],[Sex],[Nation],[InterfaceDate],[Costcenter], UserType)
	
	SELECT @MAX_EMPID + ROW_NUMBER() OVER( ORDER BY EMPLOYEE_ID ASC) AS EMPID
		,EMPLOYEE_ID, EMPLOYEE_NAME, EMPLOYEE_FNAME, EMAIL, POSITION_CODE
		, CASE F.WORKING_STATUS WHEN 1 THEN 1 ELSE 0 END
		, D.Id, UPPER(EMPLOYEE_ID),'2e8117cc-256e-481c-b3e5-5d979e670c20'
		,[Sex],[Nation],GETDATE(), B.PL_CD
		,'92E4ECB5-942F-4443-B1BA-E8D57D2075C3'--User type get from HR Interface
	FROM [LinkOracleMeal]..[HS].[V_EMP] F
	LEFT JOIN HrDeptMaster D ON F.DEPT_CODE = D.Code
	LEFT JOIN [LinkOracleMeal]..[HS].COST_CENTER B ON F.COST_CENTER = B.PK
	WHERE F.EMPLOYEE_ID COLLATE Vietnamese_CI_AS NOT IN (SELECT CODE FROM HrEmpMaster)

	
	MERGE INTO HrEmpMaster A
	USING (
		SELECT EMPLOYEE_ID, EMPLOYEE_NAME, EMPLOYEE_FNAME, EMAIL, POSITION_CODE
			, CASE F.WORKING_STATUS WHEN 1 THEN 1 ELSE 0 END STATUS, D.Id [DeptCode]
			,[Sex],[Nation], B.PL_CD, F.DATA, F.JOBTITLE_CODE, F.JOIN_DT
		FROM [LinkOracleMeal]..[HS].[V_EMP] F
		LEFT JOIN HrDeptMaster D ON F.DEPT_CODE = D.Code
		LEFT JOIN [LinkOracleMeal]..[HS].COST_CENTER B ON F.COST_CENTER = B.PK
		--WHERE EMPLOYEE_ID = 'VN55160524'
	) B
	ON LOWER(A.Code) = LOWER(B.EMPLOYEE_ID)
	WHEN MATCHED THEN
	UPDATE SET A.[LocalName] = B.EMPLOYEE_NAME
		,[EnName] = B.EMPLOYEE_FNAME
		,[Email] = B.EMAIL
		,[PositionId] = B.POSITION_CODE
		,[Status] = B.STATUS
		,[DeptCode] = B.[DeptCode]
		,[Sex] = B.Sex
		,[Nation] = B.Nation
		,[Costcenter] = B.PL_CD
		,[Img] = B.DATA
		,[JobTitleId] = B.JOBTITLE_CODE
		,[JoinDate] = B.JOIN_DT;
	INSERT INTO SysUserMapping(UserId, RoleId, CreateDate)
	SELECT EmpId, 'US01', GETDATE() FROM HrEmpMaster WHERE EmpId NOT IN (SELECT UserId FROM SysUserMapping)

END

GO
/****** Object:  StoredProcedure [dbo].[SP_SYSTEM_INTERFACE_MASTER_CODE]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20171023
-- Description:	INTERFACE POSITION VỚI JOB TITLE
-- =============================================
CREATE PROCEDURE [dbo].[SP_SYSTEM_INTERFACE_MASTER_CODE]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	MERGE INTO SysCategoryValue T1
	USING (
		SELECT * FROM TCSS.DBO.T_OPM_CATEGORY_VALUE
		WHERE iCATE_ID = 47
	) T2
	ON T1.Category = '1856B793-C271-423C-8954-981E4B86AF46' AND T1.SubCode collate SQL_Latin1_General_CP1_CI_AS = T2.sSubCode
	WHEN MATCHED THEN 
		UPDATE SET T1.Name = T2.sCATE_VALUE_TEXT , T1.Sequence = T2.iSEQ , T1.Actived = T2.bIS_ACTIVE
	WHEN NOT MATCHED THEN
		INSERT(NAME, SEQUENCE, ACTIVED, createuid, createdate, category) VALUES (T2.sCATE_VALUE_TEXT, T2.iSEQ, T2.bIS_ACTIVE, '1000083', getdate(), '1856B793-C271-423C-8954-981E4B86AF46');
END

GO
/****** Object:  StoredProcedure [dbo].[SP_TEMP_EMPLOYEE_PAGING_SORTING_FILTERING]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.10.02
-- Description:	PAGING - SORTING - FILTERING
-- =============================================
CREATE PROCEDURE [dbo].[SP_TEMP_EMPLOYEE_PAGING_SORTING_FILTERING]
	-- Add the parameters for the stored procedure here
	@PageNumber int = 1,
	@PageSize int = 5
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT ROW_NUMBER() OVER (ORDER BY E.Code) [RowNo], EmpId, LocalName
		, D.OrganizationName + ISNULL(' > ' + D.PlantName, '') + ISNULL(' > ' + D.DeptName,'') + ISNULL(' > ' +  D.SectName,'') DeptName
		, COUNT(E.Code) OVER() [TotalCount]
	FROM HrEmpMaster E
	LEFT JOIN HrDeptMasterFull D ON E.DeptCode = D.Id
	WHERE Status = 1 AND Nation = 1
	ORDER BY D.Code
	OFFSET(@PageNumber - 1) * @PageSize ROWS
	FETCH NEXT @PageSize ROWS ONLY;
END

GO
/****** Object:  StoredProcedure [EApproval].[SP_APPLICATION_APPROVAL_GETLIST]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20170711
-- Description:	LAY LEN DANH SACH APPLICATION
-- =============================================
CREATE PROCEDURE [EApproval].[SP_APPLICATION_APPROVAL_GETLIST]
	@MasterId int = 24,
	@ApplicationId int = 1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT  A.EmpId, A.ApproverType, A.IsApprove, A.DateApprove, A.Comment, C.Name ApproverTypeName, E.LocalName EmpName
		, D.OrganizationName + ISNULL(' > ' + D.PlantName, '') + ISNULL(' > ' + D.DeptName,'') + ISNULL(' > ' +  D.SectName,'') DeptFullName
	FROM EApproval.Approval A
	INNER JOIN HrEmpMaster E ON A.EmpId = E.Code
	INNER JOIN HrDeptMasterFull D ON E.DeptCode = D.Id
	INNER JOIN SysCategoryValue C ON A.ApproverType = C.ID AND C.Category = '2EA2A6A8-0C9A-446A-BA6B-B5197D22A4B8'
	WHERE A.ApplicationId = @ApplicationId AND MasterId = @MasterId
	ORDER BY A.Id
END

GO
/****** Object:  StoredProcedure [EApproval].[SP_APPLICATION_CONFIG_GETALL]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20170711
-- Description:	LAY LEN DANH SACH APPLICATION
-- =============================================
CREATE PROCEDURE [EApproval].[SP_APPLICATION_CONFIG_GETALL]
	@Name NVARCHAR(200) = NULL,
	@DeptId int = 0,
	@Kind VARCHAR(36) = NULL,
	@FromDate DATE = null,
	@ToDate DATE = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    WITH DEPT(ID, NAME, KONAME, PARENTID, LEVEL, Code) AS(
		SELECT ID, ENNAME, KONAME, Parent, 0, Code 
		FROM HrDeptMaster
		WHERE (@DEPTID <> 0 AND Id = @DEPTID) OR (@DEPTID = 0 AND Parent IS NULL)
		UNION ALL
		SELECT B.ID, B.EnName, B.KONAME, B.Parent, A.LEVEL + 1, B.Code 
		FROM DEPT A, HrDeptMaster B
		WHERE A.ID = B.Parent AND B.IsDelete = 0
	),
	CATE AS (
		SELECT Name, ID FROM SysCategoryValue WHERE Category IN ('2EA2A6A8-0C9A-446A-BA6B-B5197D22A4B8', '418D8192-A87B-4E78-9E46-07CC8FCD36D1')
	)

	SELECT A.Id, A.Code, A.Name
		, F.OrganizationName + ISNULL(' > ' + F.PlantName, '') + ISNULL(' > ' + F.DeptName,'') + ISNULL(' > ' +  F.SectName,'') DeptName, A.DeptId
		--, SUBSTRING(A.ApprovalLineDefault, CHARINDEX('|',A.ApprovalLineDefault) + 1, LEN(A.ApprovalLineDefault)) ApprovalLineName
		, '' ApprovalLineName
		, ISNULL(ApprovalLineJson, '') ApprovalLineJson
		, ISNULL(A.ApprovalLineDefault, '') ApprovalLineDefault
		, A.CreateUid, E.LocalName CreateName, A.CreateDate, A.Active
		, A.ApprovalKind, C.Name KindName, A.[Description]
	FROM EApproval.ApplicationConfig A
	INNER JOIN DEPT D ON A.DeptId = D.ID
	LEFT JOIN HrDeptMasterFull F ON A.DeptId = F.Id
	LEFT JOIN CATE C ON A.ApprovalKind = C.ID
	LEFT JOIN HrEmpMaster E ON A.CreateUid = E.EmpId
	WHERE 1=1
		AND (@Name IS NULL OR (@Name IS NOT NULL AND A.Name LIKE '%' + @Name + '%'))
		AND (@Kind IS NULL OR (@Kind IS NOT NULL AND A.ApprovalKind = @Kind))
		AND DATEDIFF(DAY, A.CreateDate, @FromDate) <= 0
		AND DATEDIFF(DAY, A.CreateDate, ISNULL(@ToDate, GETDATE())) >= 0
		AND DeleteUid IS NULL
	ORDER BY CreateDate DESC
END

--SELECT SUBSTRING('12;13|NGHIA > NGHIA', CHARINDEX('|','12;13|NGHIA > NGHIA') + 1, LEN('12;13|NGHIA > NGHIA'))


GO
/****** Object:  StoredProcedure [EApproval].[SP_APPLICATION_CONFIG_GETLIST]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA	
-- Create date: 20170810
-- Description:	LẤY LÊN DANH SÁCH APPLICATION THEO PHÒNG BAN
-- =============================================
CREATE PROCEDURE [EApproval].[SP_APPLICATION_CONFIG_GETLIST]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @TB_RESULT TABLE (ID INT, NAME NVARCHAR(200), PARENTID INT, CODE VARCHAR(10))
	INSERT INTO @TB_RESULT
	--*-1 tránh trường hợp trùng id
	SELECT Id*-1, EnName, NULL, Code 
	FROM HrDeptMaster
	WHERE Id IN (SELECT DeptId FROM EApproval.ApplicationConfig WHERE DeleteUid IS NULL)

	INSERT INTO @TB_RESULT
	--*-1 tránh trường hợp trùng id
	SELECT Id, Name, DeptId*-1, NULL
	FROM EApproval.ApplicationConfig	
	WHERE DeleteUid IS NULL

	SELECT * FROM @TB_RESULT
	ORDER BY CODE, ID

END

GO
/****** Object:  StoredProcedure [EApproval].[SP_APPLICATION_EMAILREQUEST_GETDETAIL]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20170831
-- Description:	LAY LEN THÔNG TIN CHO EMAIL REQUEST
-- =============================================
CREATE PROCEDURE [EApproval].[SP_APPLICATION_EMAILREQUEST_GETDETAIL]
	--@ID INT,
	@MASTERID INT = 33
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT S.Id, S.MasterId, S.EmpId, S.DeptId, S.Request, S.TimesPerMonth, S.Reason
		, F.OrganizationName + ISNULL(' > ' + F.PlantName, '') + ISNULL(' > ' + F.DeptName,'') + ISNULL(' > ' +  F.SectName,'') DeptName
		, E.LocalName EmpName, C.Name RequestName
	FROM EApproval.EmailAddress S
	LEFT JOIN HrEmpMaster E ON S.EmpId = E.Code
	LEFT JOIN SysCategoryValue C ON S.Request = C.ID
	LEFT JOIN HrDeptMasterFull F ON S.DeptId = F.Id
	WHERE MasterId = @MASTERID
END

GO
/****** Object:  StoredProcedure [EApproval].[SP_APPLICATION_INFORMATIONSYSTEM_GETDETAIL]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20170906
-- Description:	LAY LEN THÔNG TIN CHO INFORMATION SYSTEM
-- =============================================
CREATE PROCEDURE [EApproval].[SP_APPLICATION_INFORMATIONSYSTEM_GETDETAIL]
	--@ID INT,
	@MASTERID INT = 37
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @EMPSELECTED VARCHAR(20) = (SELECT EmpId FROM EApproval.InformationSystem WHERE Id = @MASTERID)

	IF @EMPSELECTED IS NULL
	BEGIN
		--LẤY LÊN NGƯỜI ĐẦU TIÊN TRONG DÒNG APPROVE CỦA IT LÀM NGƯỜI XỬ LÝ ĐƠN NÀY
		SET @EMPSELECTED = (
			SELECT TOP 1 A.EmpId 
			FROM EApproval.Approval A
			INNER JOIN HrEmpMaster E ON A.EmpId = E.Code
			--CHỈ LẤY LÊN DANH SÁCH NHỮNG NGƯỜI THUỘC IT
			INNER JOIN HrDeptMasterFull D ON E.DeptCode = D.Id AND D.Dept IN (77, 127)
			WHERE MasterId = @MASTERID AND ApplicationId = 6-- ĐƠN INFORMATION SYSTEM
			ORDER BY A.Id	
		)
	END


	SELECT A.ID, MasterId, [System], S.Name SystemName, Seriousness, C.Name SeriousName, Explanation, ISNULL(A.EmpId, @EMPSELECTED) EmpId, E.LocalName EmpName, ISNULL(NumDays, 0) NumDays, Solution
	FROM EApproval.InformationSystem A
	LEFT JOIN SysCategoryValue S ON A.System = S.ID
	LEFT JOIN SysCategoryValue C ON A.Seriousness = C.ID
	LEFT JOIN HrEmpMaster E ON ISNULL(A.EmpId, @EMPSELECTED) = E.Code
	WHERE A.MasterId = @MASTERID
END

GO
/****** Object:  StoredProcedure [EApproval].[SP_APPLICATION_ITEQUIPMENT_GETDETAIL]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20170831
-- Description:	LAY LEN THÔNG TIN CHO IT EQUIPMENT
-- =============================================
CREATE PROCEDURE [EApproval].[SP_APPLICATION_ITEQUIPMENT_GETDETAIL]
	--@ID INT,
	@MASTERID INT = 33
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT S.Id, S.MasterId, S.Remark, S.ItemName, S.OS, S.Version, S.Qty				
	FROM EApproval.ItEquipment S
	WHERE MasterId = @MASTERID
END

GO
/****** Object:  StoredProcedure [EApproval].[SP_APPLICATION_MASTER_APPROVE]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20170825
-- Description:	LƯU THÔNG TIN APPROVE CỦA APPLICATION
-- =============================================
CREATE PROCEDURE [EApproval].[SP_APPLICATION_MASTER_APPROVE]
	@MasterId int = 24,
	@ApplicationId int = 1,
	@IsApprove bit = 1,
	@Comment nvarchar(200) = 'aaaa',
	@UserId varchar(20) = 'vn55104017',
	@LinkApplication varchar(100) = 'http://localhost:5678/ApplicationConfig/Index'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @APPLICATIONTYPE UNIQUEIDENTIFIER, @APPROVERTYPE UNIQUEIDENTIFIER, @ISLASTAPPROVER INT, @NEXTAPPROVER VARCHAR(20) = ''
	SELECT @APPLICATIONTYPE = ApprovalKind FROM EApproval.ApplicationMaster WHERE Id = @MasterId
	SELECT @APPROVERTYPE = ApproverType FROM EApproval.Approval WHERE ApplicationId = @ApplicationId AND MasterId = @MasterId AND EmpId = @UserId	

	--LƯU THÔNG TIN APPROVE
	UPDATE EApproval.Approval SET IsApprove = @IsApprove, Comment = @Comment, DateApprove = GETDATE()
	WHERE ApplicationId = @ApplicationId
		AND MasterId = @MasterId
		AND EmpId = @UserId

	--Kiểm tra xem có phải là người cuối cùng approve hay không	
	SET @ISLASTAPPROVER = (SELECT COUNT(1) 
							FROM EApproval.Approval 
							WHERE ApplicationId = @ApplicationId 
								AND MasterId = @MasterId AND ApproverType <> '045872C8-638C-4A12-A70B-4E471C5D90EB' --KHÔNG TÍNH NHỮNG NGƯỜI THAM KHẢO
								AND IsApprove IS NULL--NHỮNG NGƯỜI CHƯA APPROVE
							)
	--LẤY RA THÔNG TIN NGƯỜI APPROVER KẾ TIẾP
	IF (@APPLICATIONTYPE = '2600C4A7-CFB3-4E08-A08D-EDF0C1D99A71')
	BEGIN
		SET @NEXTAPPROVER = (SELECT TOP 1 EmpId 
		FROM EApproval.Approval 
		WHERE ApplicationId = @ApplicationId 
			AND MasterId = @MasterId AND ApproverType <> '045872C8-638C-4A12-A70B-4E471C5D90EB' --KHÔNG TÍNH NHỮNG NGƯỜI THAM KHẢO
			AND IsApprove IS NULL--NHỮNG NGƯỜI CHƯA APPROVE
		)
	END
	ELSE
		SET @NEXTAPPROVER = ''
	
	IF @IsApprove = 0 AND @APPROVERTYPE = 'E408D53D-6E62-4D63-A3D4-CD3EA9A14D36'
		SET @NEXTAPPROVER = ''

	--Kiểm tra xem người này có phải là người duyệt cuối cùng hay không
		--hoặc nếu người này là người approver và người này từ chối đơn -> cập nhật lại cho bên master và kết thúc đơn
		--còn từ chối đơn nhưng người này là consente thì vẫn tiếp tục duyệt
	IF @ISLASTAPPROVER = 0 OR (@IsApprove = 0 AND @APPROVERTYPE = 'E408D53D-6E62-4D63-A3D4-CD3EA9A14D36')
	BEGIN
		UPDATE EApproval.ApplicationMaster 
		SET ApprovalStatus = CASE WHEN @APPROVERTYPE = '5325E6FF-6430-49A2-B3D3-D9ABDBE06F9E' THEN '00F2EC64-CC9B-4FCA-AB4C-B37961EFAD53' -- NẾU NGƯỜI CONSENTE THÌ MẶC ĐỊNH ĐƠN LÀ APPROVED
			ELSE CASE WHEN @IsApprove = 1 THEN '00F2EC64-CC9B-4FCA-AB4C-B37961EFAD53' ELSE '9A96D85B-8189-46BA-84CD-3389FDC501B7' END--CÒN NẾU LÀ APPROVER THÌ XÉT XEM NGƯỜI NÀY ĐỒNG Ý HAY TỪ CHỐI ĐƠN
			END,
			NextApprover = ''
		WHERE Id = @MasterId
	END
	--VẪN CÒN NGƯỜI APPROVE VÀ LOẠI ĐƠN LÀ ORDER--> CẬP NHẬT NGƯỜI APPROVE KẾ TIẾP
		--CÒN PARALLEL THÌ KO SET NGƯỜI APPROVER KẾ TIẾP
	ELSE IF @APPLICATIONTYPE = '2600C4A7-CFB3-4E08-A08D-EDF0C1D99A71'  
	BEGIN
		UPDATE EApproval.ApplicationMaster SET NextApprover = @NEXTAPPROVER WHERE Id = @MasterId
	END

	IF ISNULL(@NEXTAPPROVER,'') <> ''
	BEGIN
		DECLARE @EMAIL VARCHAR(1000), @CCBCC VARCHAR(1000) = 'nghia55160524@hyosung.com', @BODY NVARCHAR(MAX) = 'test', @SUBJECT NVARCHAR(MAX) = 'test'

		--LẤY RA THÔNG TIN NGƯỜI APPROVER ĐÊ GỬI MAIL
		SET @EMAIL = (
			SELECT Email FROM HrEmpMaster WHERE Code = @NEXTAPPROVER
		)

		SET @SUBJECT = (
			SELECT  '[' + B.Name + ']' + ' ' + [Subject] 
			FROM EApproval.ApplicationMaster A
			INNER JOIN EApproval.ApplicationConfig B ON A.ApplicationId = B.Id 
			WHERE A.Id = @MasterId
		)
		
		SELECT @BODY = 
			'<p>Dear Mr/Ms: ' + E.LocalName + '. Please view and approve this application follow link bellow</p>'+
			'<table width="95%" align="center" cellpadding="2" cellspacing="1" bgcolor="#F2F2F2" style="font-size: 14px; border: 1px solid #c7c7c7">'+
			  '<tbody>'+
			   '<tr valign="top" bgcolor="#FFFFFF">'+
				  '<td  align="left" width="10%"><b>Application</b></td>'+
				  '<td>'+C.Name+'</td>'+
				'</tr>'+
				'<tr valign="top" bgcolor="#f9f9f9">'+
				  '<td  align="left"><b>Subject</b></td>'+
				  '<td>' + A.Subject + '</td>'+
				'</tr>'+
				'<tr valign="top" bgcolor="#FFFFFF">'+
				  '<td align="left"><b>Creator</b></td>'+
				  N'<td>' + E.LocalName + '</td>'+
				'</tr>'+
				'<tr valign="top" bgcolor="#f9f9f9">'+
				  '<td align="left"><b>Create Date</b></td>'+
				  '<td valign="top"><div>'+CONVERT(VARCHAR, A.CreateDate, 111)+'</div></td>'+
				'</tr>'+
				'<tr valign="top" bgcolor="#FFFFFF">'+
				  '<td colspan="2" align="center"><p style="color: #023aa0; font: Arial; margin: 5px 0;">Click the button bellow to view detail</p>'+
					'<p style="margin:5px 0; background: #F9F9F9;background-image: -webkit-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: -moz-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: -ms-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: -o-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: linear-gradient(to bottom, #F9F9F9, #EFEFEF);-webkit-border-radius: 5;-moz-border-radius: 5;border-radius: 5px;font-family: Arial;color: #323232;padding: 10px 20px 10px 20px;border: solid #c7c7c7 1px;text-decoration: none;width: 100px"><a href="'+@LinkApplication+'">Click View Detail</a></p></td>'+
				'</tr>'+
			  '</tbody>'+
			'</table>'
		FROM EApproval.ApplicationMaster A
		INNER JOIN EApproval.ApplicationConfig C ON A.ApplicationId = C.Id
		INNER JOIN HrEmpMaster E ON A.CreateUid = E.Code
		WHERE A.Id = @MasterId

		EXEC msdb.dbo.sp_send_dbmail
			@profile_name = 'Hyosung Portal',
			@recipients = @EMAIL,
			@copy_recipients = @CCBCC,
			@body = @BODY,
			@subject = @subject,
			@body_format = 'HTML' ;
	END
END



GO
/****** Object:  StoredProcedure [EApproval].[SP_APPLICATION_MASTER_CONFIRM]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20170830
-- Description:	CONFIRM - RECALL APPLICATION
-- =============================================
CREATE PROCEDURE [EApproval].[SP_APPLICATION_MASTER_CONFIRM]
	@MasterId int,
	@Status bit,
	@LinkApplication VARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF @Status = 1
	BEGIN
		--CẬP NHẬT THÔNG TIN
		UPDATE EApproval.ApplicationMaster 
		SET ApprovalStatus = 'C4FF5A2F-CD32-4785-9499-A26E5148D58D', ConfirmDate = GETDATE() 
		WHERE Id = @MasterId

		DECLARE @EMAIL VARCHAR(1000), @CCBCC VARCHAR(1000) = 'nghia55160524@hyosung.com', @BODY NVARCHAR(MAX) = '', @SUBJECT NVARCHAR(MAX) = ''
		DECLARE @APPROVALLINE NVARCHAR(2000) = (SELECT ApprovalLine FROM EApproval.ApplicationMaster WHERE ID = @MasterId)
		DECLARE @APPLICATIONTYPE UNIQUEIDENTIFIER = (SELECT ApprovalKind FROM EApproval.ApplicationMaster WHERE Id = @MasterId)
		DECLARE @APPLICATIONID INT = (SELECT ApplicationId FROM EApproval.ApplicationMaster WHERE Id = @MasterId)
		--LẤY RA THÔNG TIN NGƯỜI APPROVER ĐÊ GỬI MAIL
		IF @APPLICATIONTYPE = '2600C4A7-CFB3-4E08-A08D-EDF0C1D99A71'
			SET @EMAIL = (
				SELECT Email FROM HrEmpMaster WHERE Code = (SELECT NextApprover FROM EApproval.ApplicationMaster WHERE Id = @MasterId)
			)
		ELSE
			SET @EMAIL = (
				SELECT STUFF((SELECT ';' + EmpId 
				FROM HrEmpMaster 
				WHERE Code IN (SELECT EmpId 
								FROM EApproval.Approval 
								WHERE MasterId = @MasterId AND ApplicationId = @APPLICATIONID AND ApproverType <> '045872C8-638C-4A12-A70B-4E471C5D90EB')
				FOR XML PATH('')), 1, 1, '')
		)
		SET @SUBJECT = (
			SELECT  '[' + B.Name + ']' + ' ' + [Subject] 
			FROM EApproval.ApplicationMaster A
			INNER JOIN EApproval.ApplicationConfig B ON A.ApplicationId = B.Id 
			WHERE A.Id = @MasterId
		)
		
		SELECT @BODY = 
			'<p>Dear Mr/Ms: ' + E.LocalName + '. Please view and approve this application follow link bellow</p>'+
			'<table width="95%" align="center" cellpadding="2" cellspacing="1" bgcolor="#F2F2F2" style="font-size: 14px; border: 1px solid #c7c7c7">'+
			  '<tbody>'+
			   '<tr valign="top" bgcolor="#FFFFFF">'+
				  '<td  align="left" width="10%"><b>Application</b></td>'+
				  '<td>'+C.Name+'</td>'+
				'</tr>'+
				'<tr valign="top" bgcolor="#f9f9f9">'+
				  '<td  align="left"><b>Subject</b></td>'+
				  '<td>' + A.Subject + '</td>'+
				'</tr>'+
				'<tr valign="top" bgcolor="#FFFFFF">'+
				  '<td align="left"><b>Creator</b></td>'+
				  N'<td>' + E.LocalName + '</td>'+
				'</tr>'+
				'<tr valign="top" bgcolor="#f9f9f9">'+
				  '<td align="left"><b>Create Date</b></td>'+
				  '<td valign="top"><div>'+CONVERT(VARCHAR, A.CreateDate, 111)+'</div></td>'+
				'</tr>'+
				'<tr valign="top" bgcolor="#FFFFFF">'+
				  '<td colspan="2" align="center"><p style="color: #023aa0; font: Arial; margin: 5px 0;">Click the button bellow to view detail</p>'+
					'<p style="margin:5px 0; background: #F9F9F9;background-image: -webkit-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: -moz-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: -ms-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: -o-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: linear-gradient(to bottom, #F9F9F9, #EFEFEF);-webkit-border-radius: 5;-moz-border-radius: 5;border-radius: 5px;font-family: Arial;color: #323232;padding: 10px 20px 10px 20px;border: solid #c7c7c7 1px;text-decoration: none;width: 100px"><a href="'+@LinkApplication+'">Click View Detail</a></p></td>'+
				'</tr>'+
			  '</tbody>'+
			'</table>'
		FROM EApproval.ApplicationMaster A
		INNER JOIN EApproval.ApplicationConfig C ON A.ApplicationId = C.Id
		INNER JOIN HrEmpMaster E ON A.CreateUid = E.Code
		WHERE A.Id = @MasterId

		EXEC msdb.dbo.sp_send_dbmail
			@profile_name = 'Hyosung Portal',
			@recipients = @EMAIL,
			@copy_recipients = @CCBCC,
			@body = @BODY,
			@subject = @subject,
			@body_format = 'HTML' ;
	END

	ELSE
	BEGIN
		--CẬP NHẬT THÔNG TIN
		UPDATE EApproval.ApplicationMaster 
		SET ApprovalStatus = '9C817780-2079-4417-B87B-B7E537BBAE8A', ConfirmDate = NULL
		WHERE Id = @MasterId
	END

END



GO
/****** Object:  StoredProcedure [EApproval].[SP_APPLICATION_MASTER_GETALL]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20170711
-- Description:	LAY LEN DANH SACH APPLICATION
-- =============================================
CREATE PROCEDURE [EApproval].[SP_APPLICATION_MASTER_GETALL]
	@Name NVARCHAR(200) = NULL,
	@DeptId int = 0,
	@Kind VARCHAR(36) = 'd20ecc69-5e3a-4222-9686-073ed8e9c47f',
	@FromDate DATE = null,
	@ToDate DATE = null,
	@UserId VARCHAR(20) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--LẤY LÊN DANH SÁCH NHỮNG ĐƠN MÀ NGƯỜI ĐĂNG NHẬP LÀ NGƯỜI THAM KHẢO
	DECLARE @TB_CIRCULATOR TABLE(Applicationid int)
	IF (@Kind IS NULL OR @Kind = '')
		SET @Kind = 'a69279bc-122d-418a-b74a-5e8a088cc0cc'
	IF @Kind = 'd20ecc69-5e3a-4222-9686-073ed8e9c47f'
	BEGIN
		INSERT INTO @TB_CIRCULATOR
		SELECT distinct MasterId FROM EApproval.Approval
		WHERE ApproverType = '045872C8-638C-4A12-A70B-4E471C5D90EB' AND EmpId = @UserId
	END

    ;WITH 
	--DEPT(ID, NAME, KONAME, PARENTID, LEVEL, Code) AS(
	--	SELECT ID, ENNAME, KONAME, Parent, 0, Code 
	--	FROM HrDeptMaster
	--	WHERE (@DEPTID <> 0 AND Id = @DEPTID) OR (@DEPTID = 0 AND Parent IS NULL)
	--	UNION ALL
	--	SELECT B.ID, B.EnName, B.KONAME, B.Parent, A.LEVEL + 1, B.Code 
	--	FROM DEPT A, HrDeptMaster B
	--	WHERE A.ID = B.Parent AND B.IsDelete = 0
	--),
	CATE AS (
		SELECT Name, ID FROM SysCategoryValue WHERE Category IN ('2EA2A6A8-0C9A-446A-BA6B-B5197D22A4B8', '418D8192-A87B-4E78-9E46-07CC8FCD36D1')
													OR (Category = '054E0F62-4EFE-41E1-A18D-5C28A6531539' and ParentID = 'EAF964F0-F557-40C7-AD06-F0B4A6571A4F')
	)	
	SELECT A.Id, A.Code, A.[Subject]
		, F.OrganizationName + ISNULL(' > ' + F.PlantName, '') + ISNULL(' > ' + F.DeptName,'') + ISNULL(' > ' +  F.SectName,'') DeptName, A.DeptId
		, ISNULL(A.ApprovalLineJson, '') ApprovalLineJson
		, ISNULL(A.ApprovalLine, '') ApprovalLine, S.Name ApprovalStatusName, A.ApprovalStatus
		, A.CreateUid, E.LocalName CreateName, A.CreateDate
		, A.ApprovalKind, C.Name KindName, A.[Description]
		, A.ApplicationId, M.Name ApplicationName
		, A.NextApprover, N.LocalName NextApproverName, CONVERT(VARCHAR, A.RequestDate, 102) RequestDate
	FROM EApproval.ApplicationMaster A
	INNER JOIN EApproval.ApplicationConfig M ON A.ApplicationId = M.Id
	--INNER JOIN DEPT D ON A.DeptId = D.ID
	LEFT JOIN HrDeptMasterFull F ON A.DeptId = F.Id
	LEFT JOIN CATE C ON A.ApprovalKind = C.ID
	LEFT JOIN CATE S ON A.ApprovalStatus = S.ID
	LEFT JOIN HrEmpMaster E ON A.CreateUid = E.Code
	LEFT JOIN HrEmpMaster N ON A.NextApprover = N.Code
	WHERE 1=1
		AND (@Name IS NULL OR (@Name IS NOT NULL AND A.[Subject] LIKE '%' + @Name + '%'))
		AND DATEDIFF(DAY, A.CreateDate, @FromDate) <= 0
		AND DATEDIFF(DAY, A.CreateDate, ISNULL(@ToDate, GETDATE())) >= 0
		AND A.DeleteUid IS NULL

		--LẤY LÊN NHỮNG ĐƠN NÀO MÀ NGƯỜI ĐĂNG NHẬP TẠO HOẶC NHỮNG ĐƠN MÀ NGƯỜI NÀY CÓ TRONG DÒNG APPROVE
		AND (((@KIND = 'a69279bc-122d-418a-b74a-5e8a088cc0cc')
			--LẤY LÊN NHỮNG ĐƠN MÀ TỚI NGƯỜI ĐĂNG NHẬP DUYỆT
			OR (@KIND = 'e01e60c8-ea26-402b-99cd-a06afcbd9a4e' AND A.NextApprover = @UserId)

			--LẤY LÊN NHỮNG ĐƠN ĐANG TRONG QUÁ TRÌNH DUYỆT, BAO GỒM CẢ ĐƠN CỦA NGƯỜI ĐĂNG NHẬP VÀ NHỮNG ĐƠN CÓ NGƯỜI DUYỆT NẰM TRONG ĐÓ
			OR (@KIND = '9cb97992-165d-45bf-8575-71230a4163a0' AND A.ApprovalStatus = 'C4FF5A2F-CD32-4785-9499-A26E5148D58D')

			--LẤY LÊN NHỮNG ĐƠN ĐÃ HOÀN THÀNH, BAO GỒM CẢ ĐƠN CỦA NGƯỜI ĐĂNG NHẬP VÀ NGƯỜI NẰM TRONG DÒNG APPROVE
			OR (@KIND = '09b05af8-057c-4dda-9dc1-839141dc7db7' AND A.ApprovalStatus = '00F2EC64-CC9B-4FCA-AB4C-B37961EFAD53')

			--LẤY LÊN NHỮNG ĐƠN ĐÃ BỊ TỪ CHỐI, BAO GỒM CẢ ĐƠN CỦA NGƯỜI ĐĂNG NHẬP VÀ NGƯỜI NẰM TRONG DÒNG APPROVE
			OR (@KIND = 'db3197ae-8220-4492-a6ec-f7c10135fa3c' AND A.ApprovalStatus = '9A96D85B-8189-46BA-84CD-3389FDC501B7') AND (A.CreateUid = @UserId OR A.ApprovalLine LIKE '%'+@UserId+'%'))

			--LẤY LÊN NHỮNG ĐƠN MÀ NGƯỜI ĐĂNG NHẬP LÀ NGƯỜI THAM KHẢO
			OR @KIND = 'd20ecc69-5e3a-4222-9686-073ed8e9c47f' AND A.Id IN (SELECT ApplicationId FROM @TB_CIRCULATOR))
	ORDER BY CreateDate DESC
END

GO
/****** Object:  StoredProcedure [EApproval].[SP_APPLICATION_MASTER_GETDETAIL]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20170711
-- Description:	LẤY LÊN THÔNG TIN CHI TIẾT APPLICATION
-- =============================================
CREATE PROCEDURE [EApproval].[SP_APPLICATION_MASTER_GETDETAIL]
	@ID INT = 24,
	@USERID VARCHAR(20) = 'vn55110755'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ISRECALL BIT = 0
	
	DECLARE @APPLICATIONID INT, @CREAEUID VARCHAR(20), @CONFIRMDATE DATETIME, @FIRSTAPPROVER VARCHAR(20), @FIRSTAPPROVERSTATUS BIT, @NEXTAPPROVER VARCHAR(20)
	--LẤY RA THÔNG TIN CỦA ĐƠN
	SELECT @APPLICATIONID = ApplicationId, @CREAEUID = CreateUid, @CONFIRMDATE = ConfirmDate, @NEXTAPPROVER = NextApprover
	FROM EApproval.ApplicationMaster WHERE Id = @ID
	--LẤY RA THÔNG TIN NGƯỜI ĐẦU TIÊN APPROVE
	SELECT TOP 1 @FIRSTAPPROVER = EmpId, @FIRSTAPPROVERSTATUS = IsApprove
	FROM EApproval.Approval 
	WHERE ApplicationId = @APPLICATIONID AND MasterId = @ID
	ORDER BY Seq

	--LẤY RA THÔNG TIN NGƯỜI HIỆN TẠI
	DECLARE @APPROVESTATUS BIT, @SEQ TINYINT
	SELECT @APPROVESTATUS = IsApprove, @SEQ = Seq 
	FROM EApproval.Approval 
	WHERE ApplicationId = @APPLICATIONID AND MasterId = @ID AND EmpId = @USERID

	--LẤY RA THÔNG TIN NGƯỜI APPROVE KẾ TIẾP
	DECLARE @NEXTAPPROVESTATUS BIT, @NEXTSEQ TINYINT
	SELECT @NEXTAPPROVESTATUS = IsApprove, @NEXTSEQ = Seq 
	FROM EApproval.Approval 
	WHERE ApplicationId = @APPLICATIONID AND MasterId = @ID AND EmpId = @NEXTAPPROVER 

	--NHỮNG TRƯỜNG HỢP ĐƯỢC PHÉP RECALL:
	--1. LÀ NGƯỜI TẠO ĐÃ CONFIRM VÀ NGƯỜI ĐẦU TIÊN CHƯA APPROVE
		--1.1 LÀ NGƯỜI TẠO:@USERID = CREATEUID
		--1.2 ĐÃ CONFIRM: CONFIRMDATE: IS NOT NULL
		--1.3 NGƯỜI ĐẦU TIÊN CHƯA APPROVE: @ISAPPROVE: NULL
	--2. LÀ NGƯỜI ĐÃ APPR RỒI, VÀ NGƯỜI TIẾP THEO APPR(@NEXTSEQ - @SEQ = 1) PHẢI CHƯA APPR
		--2.1 LÀ NGƯỜI ĐÃ APPROVE RỒI (ISAPPROVE = 1)
		--2.1 NGƯỜI NÀY VÀ NGƯỜI KẾ TIẾP PHẢI NẰM SÁT NHAU: @NEXTSEQ - @SEQ = 1
		--2.3 THẰNG KẾ TIẾP PHẢI CHƯA APPROVE: @NEXTAPPROVESTATUS = NULL

	IF (@USERID = @CREAEUID AND @CONFIRMDATE IS NOT NULL AND @FIRSTAPPROVERSTATUS IS NULL)
		SET @ISRECALL = 1
	IF @APPROVESTATUS = 1 AND @NEXTAPPROVESTATUS IS NULL AND (@NEXTSEQ - @SEQ = 1)
		SET @ISRECALL = 1

    ;WITH 
	CATE AS (
		SELECT Name, ID FROM SysCategoryValue WHERE Category IN ('2EA2A6A8-0C9A-446A-BA6B-B5197D22A4B8', '418D8192-A87B-4E78-9E46-07CC8FCD36D1')
													OR (Category = '054E0F62-4EFE-41E1-A18D-5C28A6531539' and ParentID = 'EAF964F0-F557-40C7-AD06-F0B4A6571A4F')
	)	
	SELECT A.Id, A.Code, A.[Subject]
		, ISNULL(@ISRECALL, 0) ISRECALL
		, F.OrganizationName + ISNULL(' > ' + F.PlantName, '') + ISNULL(' > ' + F.DeptName,'') + ISNULL(' > ' +  F.SectName,'') DeptName, A.DeptId
		, ISNULL(A.ApprovalLineJson, '') ApprovalLineJson
		, ISNULL(A.ApprovalLine, '') ApprovalLine, S.Name ApprovalStatusName, A.ApprovalStatus
		, A.CreateUid, E.LocalName CreateName, A.CreateDate
		, A.ApprovalKind, C.Name KindName, A.[Description]
		, A.ApplicationId, M.Name ApplicationName
		, A.NextApprover, N.LocalName NextApproverName
		--THÔNG TIN CHO APPLICATION FOR SYSTEM ROLE
		, A.System, CONVERT(VARCHAR, A.RequestDate, 102) RequestDate
		, A.Applicant, K.LocalName ApplicantName
		, A.CostCenter
	FROM EApproval.ApplicationMaster A
	INNER JOIN EApproval.ApplicationConfig M ON A.ApplicationId = M.Id
	LEFT JOIN HrDeptMasterFull F ON A.DeptId = F.Id
	LEFT JOIN CATE C ON A.ApprovalKind = C.ID
	LEFT JOIN CATE S ON A.ApprovalStatus = S.ID
	LEFT JOIN HrEmpMaster E ON A.CreateUid = E.Code
	LEFT JOIN HrEmpMaster N ON A.NextApprover = N.Code
	LEFT JOIN HrEmpMaster K ON A.Applicant = K.Code
	WHERE 1=1
		AND A.Id = @ID
	ORDER BY CreateDate DESC
END

GO
/****** Object:  StoredProcedure [EApproval].[SP_APPLICATION_MASTER_INSERT]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20170819
-- Description:	LUU THÔNG TIN APPLICATION
-- =============================================
CREATE PROCEDURE [EApproval].[SP_APPLICATION_MASTER_INSERT]
	@ApplicationId int = NULL,
	@Subject nvarchar(200) = NULL,
	@Applicant varchar(20) = NULL,
	@RequestDate VARCHAR(20) = NULL,
	@CostCenter varchar(20) NULL,
	@DeptId int = NULL,
	@System varchar(200) = NULL,
	@ApprovalKind varchar(36) = NULL,
	@ApprovalLine nvarchar(2000) = NULL,
	@ApprovalLineJson nvarchar(4000) = NULL,
	@ApprovalStatus varchar(36) = NULL,
	@NextApprover varchar(20) NULL,
	@ConfirmDate datetime NULL,
	@Description nvarchar(500) NULL,
	@Opinion nvarchar(500) NULL,
	@ContactPerson nvarchar(200) NULL,
	@Content ntext = NULL,
	@CreateDate datetime = NULL,
	@CreateUid varchar(20) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @NEWID INT

	--LẤY RA MÃ PHÒNG BAN, NHỮNG NGƯỜI NÀO THUỘC SECTION THÌ LẤY THEO DEPARTMENT, CÒN NHỮNG NGƯỜI CÒN LẠI THÌ LẤY THEO PHÒNG BAN CỦA HỌ
	DECLARE @DEPTCODE VARCHAR(10) = (SELECT CASE WHEN [Level] >= 3 THEN (SELECT Code FROM HrDeptMaster WHERE ID = Dept)
												ELSE CODE END 
												FROM HrDeptMasterFull WHERE Id = @DeptId)
	
	--ĐẾM SỐ LƯỢNG ĐƠN THEO PHÒNG BAN TẠO TRONG THÁNG HIỆN TẠI
	DECLARE @COUNT INT = (SELECT COUNT(1) 
						FROM EApproval.ApplicationMaster 
						WHERE 1=1
							AND Code LIKE '%'+ @DEPTCODE +'%' AND DeleteUid IS NULL
							AND DATEDIFF(MONTH, CreateDate, GETDATE()) = 0)

	DECLARE @CODE VARCHAR(40) = (SELECT Code + '_' + @DEPTCODE + '_' + CONVERT(VARCHAR(6), CONVERT(DATETIME, @RequestDate), 112) + '_' + REPLICATE('0', 3 - LEN(@COUNT)) + CONVERT(VARCHAR(4), @COUNT + 1) FROM EApproval.ApplicationConfig WHERE Id = @ApplicationId) 
		
	--LẤY RA DỮ LIỆU THÔ CỦA APPROVAL LINE
	DECLARE @TB_RAW TABLE(Id int, Content varchar(500))
	INSERT INTO @TB_RAW
	SELECT * FROM FN_SplitString(@ApprovalLine,'|')

	--TÁCH MÃ NHÂN VIÊN TRƯỚC
	DECLARE @TB_RAW_EMPID TABLE(Id INT, EmpId VARCHAR(20))
	INSERT INTO @TB_RAW_EMPID 
	SELECT * FROM FN_SplitString((SELECT Content FROM @TB_RAW WHERE Id = 1), '_')

	--TÁCH LOẠI NGƯỜI APPROVE
	DECLARE @TB_RAW_APPROVETYPE TABLE(Id INT, [Type] UNIQUEIDENTIFIER)
	INSERT INTO @TB_RAW_APPROVETYPE 
	SELECT * FROM FN_SplitString((SELECT Content FROM @TB_RAW WHERE Id = 3), '_')

	SET @NextApprover = (SELECT EmpId FROM @TB_RAW_EMPID WHERE Id = 1)
	
	--THÊM VÀO BẢNG APPROVAL
	INSERT INTO EApproval.ApplicationMaster(ApplicationId, [Subject], Code, Applicant, RequestDate, CostCenter, DeptId, [System]
										, ApprovalKind, ApprovalLine, ApprovalLineJson, NextApprover, Description, Opinion, ContactPerson, [Content]
										, CreateDate, CreateUid, ApprovalStatus)
	VALUES(@ApplicationId, @Subject, @Code, @Applicant, @RequestDate, @CostCenter, @DeptId, @System
			, @ApprovalKind, @ApprovalLine, @ApprovalLineJson, @NextApprover, @Description, @Opinion, @ContactPerson, @Content
			, GETDATE(), @CreateUid, '9C817780-2079-4417-B87B-B7E537BBAE8A')
	SET @NEWID = SCOPE_IDENTITY()	
	
	--THÊM VÀO BẢNG APPROVAL HISTORY
	INSERT INTO EApproval.ApprovalHistory
	SELECT @ApprovalLine, @ApprovalLineJson, @ApplicationId, @NEWID, @CreateUid, @CreateDate			

	--THÊM VÀO BẢNG APPROVAL
	INSERT INTO EApproval.Approval(ApplicationId, MasterId, EmpId, ApproverType, Seq)
	SELECT @ApplicationId, @NEWID, A.EmpId, B.Type, A.Id
	FROM @TB_RAW_EMPID A
	LEFT JOIN @TB_RAW_APPROVETYPE B ON A.Id = B.Id

	SELECT ISNULL(@NEWID, 0) ApplicationId
END



GO
/****** Object:  StoredProcedure [EApproval].[SP_APPLICATION_MASTER_RECALL]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20170830
-- Description:	RECALL LẠI ĐƠN VỪA APPROVE
-- =============================================
CREATE PROCEDURE [EApproval].[SP_APPLICATION_MASTER_RECALL]
	@MasterId int = 42,
	@ApplicationId int = 6,
	@UserId varchar(20) = 'vn55141027'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @NEXTAPPROVER VARCHAR(20)
	SELECT @NEXTAPPROVER = NextApprover FROM EApproval.ApplicationMaster WHERE Id = @MasterId

	--KIỂM TRA XEM NGƯỜI NÀY ĐÃ APPROVE CHƯA, CHƯA APPROVE THÌ MỚI CHO RECALL
	IF EXISTS (SELECT 1 FROM EApproval.Approval WHERE ApplicationId = @ApplicationId AND MasterId = @MasterId AND EmpId = @NEXTAPPROVER AND IsApprove IS NULL)
	BEGIN
		--select * from EApproval.Approval WHERE ApplicationId = @ApplicationId AND MasterId = @MasterId  AND EmpId = @UserId
		UPDATE EApproval.Approval 
		SET IsApprove = NULL, DateApprove = NULL, Comment = NULL
		WHERE ApplicationId = @ApplicationId AND MasterId = @MasterId AND EmpId = @UserId --AND IsApprove IS NULL

		--CẬP NHẬT BÊN BẢNG MASTER NỮA
		UPDATE EApproval.ApplicationMaster SET NextApprover = @UserId WHERE Id = @MasterId
	END
END



GO
/****** Object:  StoredProcedure [EApproval].[SP_APPLICATION_MASTER_UPDATE]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20170822
-- Description:	CẬP NHẬT THÔNG TIN APPLICATION
-- =============================================
CREATE PROCEDURE [EApproval].[SP_APPLICATION_MASTER_UPDATE]
	@Id int = null,
	@ApplicationId int = NULL,
	@Subject nvarchar(200) = NULL,
	@Applicant varchar(20) = NULL,
	@RequestDate varchar(20) = NULL,
	@CostCenter varchar(20) NULL,
	@DeptId int = NULL,
	@System varchar(200) = NULL,
	@ApprovalKind varchar(36) = NULL,
	@ApprovalLine nvarchar(2000) = NULL,
	@ApprovalLineJson nvarchar(4000) = NULL,
	@ApprovalStatus varchar(36) = NULL,
	@NextApprover varchar(20) NULL,
	@ConfirmDate datetime NULL,
	@Description nvarchar(500) NULL,
	@Opinion nvarchar(500) NULL,
	@ContactPerson nvarchar(200) NULL,
	@Content ntext = NULL,
	@UpdateDate datetime = NULL,
	@UpdateUid varchar(20) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--NẾU THAY ĐỔI DÒNG APPROVAL LINE THÌ CẬP NHẬT LẠI BÊN BẢNG APPROVE
	IF((SELECT ApprovalLine FROM EApproval.ApplicationMaster WHERE Id = @Id) <> @ApprovalLine)
	BEGIN
		--LẤY RA DỮ LIỆU THÔ CỦA APPROVAL LINE
		DECLARE @TB_RAW TABLE(Id int, Content varchar(500))
		INSERT INTO @TB_RAW
		SELECT * FROM FN_SplitString(@ApprovalLine,'|')

		--TÁCH MÃ NHÂN VIÊN TRƯỚC
		DECLARE @TB_RAW_EMPID TABLE(Id INT, EmpId VARCHAR(20))
		INSERT INTO @TB_RAW_EMPID 
		SELECT * FROM FN_SplitString((SELECT Content FROM @TB_RAW WHERE Id = 1), '_')

		--TÁCH LOẠI NGƯỜI APPROVE
		DECLARE @TB_RAW_APPROVETYPE TABLE(Id INT, [Type] UNIQUEIDENTIFIER)
		INSERT INTO @TB_RAW_APPROVETYPE 
		SELECT * FROM FN_SplitString((SELECT Content FROM @TB_RAW WHERE Id = 3), '_')

		--XÓA DÒNG APPROVE CŨ
		DELETE EApproval.Approval WHERE MasterId = @Id

		--THÊM LẠI DÒNG APPROVAL
		INSERT INTO EApproval.Approval(ApplicationId, MasterId, EmpId, ApproverType, Seq)
		SELECT @ApplicationId, @Id, A.EmpId, B.Type, A.Id
		FROM @TB_RAW_EMPID A
		LEFT JOIN @TB_RAW_APPROVETYPE B ON A.Id = B.Id
		
		SET @NextApprover = (SELECT EmpId FROM @TB_RAW_EMPID WHERE Id = 1)
		UPDATE EApproval.ApplicationMaster 
		SET NextApprover = @NextApprover
		WHERE Id = @Id

		--CẬP NHẬT LẠI BÊN BẢNG APPROVAL HISTORY
		UPDATE EApproval.ApprovalHistory
		SET ApprovalLine = @ApprovalLine,
			ApprovalLineJson = @ApprovalLineJson
		WHERE ApplicationId = @ApplicationId
			AND MasterId = @Id
	END

	--NẾU ĐỔI LẠI LOẠI APPLICATION THÌ CẬP NHẬT LẠI MÃ ĐƠN
	IF ((SELECT ApplicationId FROM EApproval.ApplicationMaster WHERE Id = @Id) <> @ApplicationId)
	BEGIN
		--LẤY RA MÃ PHÒNG BAN, NHỮNG NGƯỜI NÀO THUỘC SECTION THÌ LẤY THEO DEPARTMENT, CÒN NHỮNG NGƯỜI CÒN LẠI THÌ LẤY THEO PHÒNG BAN CỦA HỌ
		DECLARE @DEPTCODE VARCHAR(10) = (SELECT CASE WHEN [Level] >= 3 THEN (SELECT Code FROM HrDeptMaster WHERE ID = Dept)
													ELSE CODE END 
													FROM HrDeptMasterFull WHERE Id = @DeptId)
	
		--ĐẾM SỐ LƯỢNG ĐƠN THEO PHÒNG BAN TẠO TRONG THÁNG HIỆN TẠI
		DECLARE @COUNT INT = (SELECT COUNT(1) 
							FROM EApproval.ApplicationMaster 
							WHERE 1=1
								AND Code LIKE '%'+ @DEPTCODE +'%' AND DeleteUid IS NULL
								AND DATEDIFF(MONTH, CreateDate, GETDATE()) = 0)

		DECLARE @CODE VARCHAR(40) = (SELECT Code + '_' + @DEPTCODE + '_' + CONVERT(VARCHAR(6), CONVERT(DATETIME, @RequestDate), 112) + '_' + REPLICATE('0', 3 - LEN(@COUNT)) + CONVERT(VARCHAR(4), @COUNT + 1) FROM EApproval.ApplicationConfig WHERE Id = @ApplicationId) 
		UPDATE EApproval.ApplicationMaster 
		SET Code = @CODE
		WHERE Id = @Id
	END

	UPDATE EApproval.ApplicationMaster
	SET ApplicationId = @ApplicationId,
		[Subject] = @Subject,
		Applicant = @Applicant,
		RequestDate = @RequestDate, 
		CostCenter = @CostCenter,
		DeptId = @DeptId,
		[System] = @System,
		ApprovalKind = @ApprovalKind,
		ApprovalLine = @ApprovalLine,
		ApprovalLineJson = @ApprovalLineJson,
		[Description] = @Description,
		Opinion = @Opinion,
		ContactPerson = @ContactPerson,
		[Content] = @Content,
		UpdateDate =@UpdateDate,
		UpdateUId = @UpdateUid
	WHERE Id = @Id
END



GO
/****** Object:  StoredProcedure [EApproval].[SP_APPLICATION_NETCLIENTPOLICY_GETDETAIL]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20170831
-- Description:	LAY LEN THÔNG TIN CHO NET-CLIENT POLICY
-- =============================================
CREATE PROCEDURE [EApproval].[SP_APPLICATION_NETCLIENTPOLICY_GETDETAIL]
	--@ID INT,
	@MASTERID INT = 59
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT S.Id, S.MasterId, DBO.FN_INT2IP(S.Ip) Ip, S.FromDate, S.ToDate, S.AssetNo, S.Reason, s.IsAllowance
	FROM EApproval.NETCLIENTPOLICY S
	WHERE MasterId = @MASTERID
END

GO
/****** Object:  StoredProcedure [EApproval].[SP_APPLICATION_SYSTEMROLE_GETDETAIL]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20170711
-- Description:	LAY LEN DANH SACH APPLICATION
-- =============================================
CREATE PROCEDURE [EApproval].[SP_APPLICATION_SYSTEMROLE_GETDETAIL]
	--@ID INT,
	@MASTERID INT = 19
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT S.Id, S.MasterId, S.EmpId, S.DeptId, S.Module, S.EmpIdSameRole, S.Remark
		, F.OrganizationName + ISNULL(' > ' + F.PlantName, '') + ISNULL(' > ' + F.DeptName,'') + ISNULL(' > ' +  F.SectName,'') DeptName
		, E.LocalName EmpName, C.Name ModuleName, R.LocalName EmpNameSameRole
	FROM EApproval.SystemRole S
	LEFT JOIN HrEmpMaster E ON S.EmpId = E.Code
	LEFT JOIN SysCategoryValue C ON S.Module = C.ID
	LEFT JOIN HrEmpMaster R ON S.EmpIdSameRole = R.Code
	LEFT JOIN HrDeptMasterFull F ON S.DeptId = F.Id
	WHERE MasterId = @MASTERID
END

GO
/****** Object:  StoredProcedure [EApproval].[SP_APPROVAL_HISTORY]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20170824
-- Description:	LAY LEN DANH SACH APPROVAL HISTORY
-- =============================================
CREATE PROCEDURE [EApproval].[SP_APPROVAL_HISTORY]
	@USERID VARCHAR(20) ='vn55160524' ,
	@APPLICATIONID INT = 8
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT TOP 10 A.Id, A.MasterId, A.ApplicationId, E.Name ApplicationMasterName
		, ISNULL(M.[Subject], V.CODE) ApplicationSubject, A.CreateDate
		, A.ApprovalLine, A.ApprovalLineJson
	FROM EApproval.ApprovalHistory A
	INNER JOIN EApproval.ApplicationConfig E ON A.ApplicationId = E.Id
	LEFT JOIN EApproval.ApplicationMaster M ON A.MasterId = M.Id
	LEFT JOIN GATE.VisitorApplicationMaster V ON A.MasterId = V.Id
	WHERE A.CreateUid = @USERID
		AND A.ApplicationId = @APPLICATIONID
	ORDER BY A.CreateDate DESC
END

GO
/****** Object:  StoredProcedure [EApproval].[SP_EMPLOYEE_INFOR]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20170815
-- Description:	LAY LEN THONG TIN NHÂN VIÊN
-- =============================================
CREATE PROCEDURE [EApproval].[SP_EMPLOYEE_INFOR]
	@Name NVARCHAR(200) = '',
	@EMPID VARCHAR(20) = 'hs20170701'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT E.Code, E.LocalName
		, D.OrganizationName + ISNULL(' > ' + D.PlantName, '') + ISNULL(' > ' + D.DeptName,'') + ISNULL(' > ' +  D.SectName,'') DeptName, D.Id DeptId
		, E.Costcenter
	FROM HrEmpMaster E
	LEFT JOIN HrDeptMasterFull D ON E.DeptCode = D.Id
	WHERE E.Code LIKE '%' + @EMPID +'%'
	ORDER BY D.Code, E.Code
END

GO
/****** Object:  StoredProcedure [GATE].[SP_CONTAINER_GET]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2018.04.04
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [GATE].[SP_CONTAINER_GET]
	-- Add the parameters for the stored procedure here
	@ID INT = NULL,
	@MASTERID INT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT DISTINCT C.Id, MasterId, VendorId, V.TaxCode, V.CompanyName, ContainerNum, C.FromDate, C.ToDate, IsImport 
		,CASE WHEN IsImport = 1 THEN 'Import' ELSE 'Export' END IsImportName
		,B.Code + ' From: ' + CONVERT(VARCHAR(10),  B.FromDate, 102) + ' to: ' + CONVERT(VARCHAR(10), B.ToDate, 102) Code
	FROM GATE.ContainerDetail C
	LEFT JOIN GATE.Vendor V ON C.VendorId = V.Id --AND V.VendorType = '3CE0802E-C30B-4038-8D50-369841AE0743'
	LEFT JOIN GATE.VisitorApplicationMaster D ON C.MasterId = D.Id
	OUTER APPLY(
		SELECT TOP 1 M.Code, P.FromDate, P.ToDate
		FROM GATE.ContainerDetail P
		LEFT JOIN GATE.VisitorApplicationMaster M ON P.MasterId = M.Id
		WHERE C.ContainerNum = P.ContainerNum AND M.Gate LIKE '%' + D.Gate + '%'
				--F1<F2 & F2<T1
			AND ((DATEDIFF(DAY, P.FromDate, C.FromDate) >= 0 AND DATEDIFF(DAY, C.FromDate, P.ToDate) >= 0)
				--F1<T2 & T2<T1
				OR (DATEDIFF(DAY, P.FromDate, C.ToDate) >= 0 AND DATEDIFF(DAY, C.ToDate, P.ToDate) >= 0)
				)
			AND P.DeleteUid IS NULL AND M.DeleteUid IS NULL AND M.Temp = 0
			AND C.Id <> P.Id 
			AND M.ApprovalStatus = '00F2EC64-CC9B-4FCA-AB4C-B37961EFAD53'
	)B
	WHERE 1=1
		AND C.DeleteUid IS NULL
		AND (@MASTERID IS NULL OR C.MasterId = @MASTERID)
		AND (@Id IS NULL OR C.Id = @Id)
END

GO
/****** Object:  StoredProcedure [GATE].[SP_CONTAINER_INSERT]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2018.04.04
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [GATE].[SP_CONTAINER_INSERT]
	-- Add the parameters for the stored procedure here
	@MASTERID INT,
	@VENDORID INT,	
	@CONTAINERNUM VARCHAR(20),
	@FROMDATE DATE,
	@TODATE DATE,
	@ISIMPORT BIT,
	@USERID VARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF EXISTS (SELECT 1 FROM GATE.ContainerDetail WHERE MasterId = @MASTERID and ContainerNum = @CONTAINERNUM AND DeleteUid IS NULL)
	BEGIN
		SELECT 'This Container already exists' Result
		RETURN
	END
	--KIỂM TRA NGƯỜI NÀY ĐÃ CÓ Ở ĐƠN KHÁC CÙNG THỜI GIAN ĐĂNG KÝ HAY KHÔNG
	DECLARE @CODE VARCHAR(20), @FROM VARCHAR(10), @TO VARCHAR(10)
	DECLARE @GATE VARCHAR(1000) = (SELECT Gate FROM GATE.VisitorApplicationMaster WHERE Id = @MASTERID)


	SELECT TOP 1 @CODE = B.Code, @FROM = CONVERT(VARCHAR(10), A.FromDate, 102), @TO = CONVERT(VARCHAR(10), A.ToDate, 102)
	FROM GATE.ContainerDetail A
	LEFT JOIN GATE.VisitorApplicationMaster B ON B.Id = A.MasterId
	WHERE MasterId != @MASTERID 
		AND ContainerNum = @CONTAINERNUM AND B.Gate LIKE '%' + @GATE + '%'
			--F1<F2 & F2<T1
		AND ((DATEDIFF(DAY, A.FromDate, @FromDate) >= 0 AND DATEDIFF(DAY, @FromDate, A.ToDate) >= 0)
			--F1<T2 & T2<T1
			OR (DATEDIFF(DAY, A.FromDate, @ToDate) >= 0 AND DATEDIFF(DAY, @ToDate, A.ToDate) >= 0)
			)
		--AND DATEDIFF(DAY, A.ToDate, @FromDate) <= 0 
		AND B.DeleteUid IS NULL AND A.DeleteUid IS NULL AND B.Temp = 1
		--CHỈ KIỂM TRA TRONG ĐƠN ĐÃ ĐƯỢC APPROVE HOẶC LÀ NHỮNG ĐƠN ĐANG ĐƯỢC DUYỆT
		AND (B.ApprovalStatus = '00F2EC64-CC9B-4FCA-AB4C-B37961EFAD53' OR B.ApprovalStatus = 'C4FF5A2F-CD32-4785-9499-A26E5148D58D')
	IF ISNULL(@CODE, '') <> ''
	BEGIN
		SELECT 'This container: ' + @CONTAINERNUM + ' already exists' + ' in application: ' + @CODE + ', registration time is: ' + @FROM + ' to: ' + @TO MESS
		RETURN
	END

	INSERT INTO 
	GATE.ContainerDetail(MasterId, VendorId, ContainerNum, FromDate, ToDate, IsImport, CreateDate, CreateUid)
	VALUES (@MASTERID, @VENDORID , @CONTAINERNUM, @FROMDATE, @TODATE, @ISIMPORT, GETDATE(), @USERID)

	SELECT 'Ok' Result
	RETURN
END

GO
/****** Object:  StoredProcedure [GATE].[SP_CONTAINER_TRACKINGDAILY_GET]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.17
-- Description:	MOOD LIKE SHIT
-- =============================================
CREATE PROCEDURE [GATE].[SP_CONTAINER_TRACKINGDAILY_GET]
	-- Add the parameters for the stored procedure here
	@ApplicationMasterId int = NULL,
	@Workdate date = '2018.04.19',
	@GateId varchar(36) = null,
	@UserId varchar(20) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @GateId = (SELECT TOP 1 Gate FROM GATE.Guard WHERE GuardId = @UserId AND DeleteUid IS NULL)
	;WITH DETAIL AS (
		SELECT COUNT(1) NumCheck, ContainerId
		FROM GATE.ContainerTrackingDaily
		GROUP BY ContainerId
	)
    -- Insert statements for procedure here
	SELECT A.Id Id, A.ContainerNum, A.VendorId, V.CompanyName, A.FromDate, A.ToDate, A.IsImport
		,M.Gate GateRegis		
		,CASE WHEN IsImport = 1 THEN 'Import' ELSE 'Export' END IsImportName
		,CASE WHEN ISNULL(M.Gate,'') = '' THEN '' ELSE 
			STUFF ((SELECT ', ' + G.Name+' '
					FROM SysCategoryValue G
					INNER JOIN (SELECT SplitItem, id FROM FN_SplitString(M.Gate,'|')) SP ON G.Id = SplitItem
					ORDER BY SP.id
					FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)') , 1, 1, '')
				END AS  GateNameRegis
		,W.IsCheckIn, L.NumCheck, M.Code
	FROM GATE.ContainerDetail A
	LEFT JOIN GATE.Vendor V ON A.VendorId = V.Id
	INNER JOIN GATE.VisitorApplicationMaster M ON A.MasterId = M.Id AND M.DeleteUid IS NULL-- AND M.Temp = 1
	LEFT JOIN SysCategoryValue R ON M.Gate = R.ID	

	--LEFT JOIN GATE.VisitorWorkingDaily W ON A.Id = W.VisitorId AND DATEDIFF(DAY, W.WorkDate, @Workdate) = 0
	OUTER APPLY (
		SELECT TOP 1 ContainerId, GateId, IsCheckIn
		FROM GATE.ContainerTrackingDaily 
		WHERE A.Id = ContainerId
		ORDER BY CreateDate DESC
	) W 
	LEFT JOIN DETAIL L ON A.Id = L.ContainerId
	WHERE (@ApplicationMasterId IS NULL OR A.MasterId = @ApplicationMasterId)
		AND DATEDIFF(DAY, @Workdate , A.FromDate) <= 0
		AND DATEDIFF(DAY , A.ToDate, @Workdate) <= 0
		AND (@GateId IS NULL OR M.Gate LIKE '%' + @GateId + '%')
		AND M.ApprovalStatus = '00F2EC64-CC9B-4FCA-AB4C-B37961EFAD53'
		AND A.DeleteUid IS NULL
	ORDER BY ContainerNum
END

GO
/****** Object:  StoredProcedure [GATE].[SP_CONTAINER_TRACKINGDAILY_GET_DETAIL]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.17
-- Description:	MOOD LIKE SHIT
-- =============================================
CREATE PROCEDURE [GATE].[SP_CONTAINER_TRACKINGDAILY_GET_DETAIL]
	-- Add the parameters for the stored procedure here
	@ContainerId int = 443
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT V.Id, V.ContainerId, ScanTime, IsCheckIn, GateId
		, V.Remark, V.VehicleId, D.DriverPlate, V.CreateUid, D.DriverName
		, C.Name GateName, G.Name CreateName, V.CreateDate
		, CASE IsCheckIn WHEN  1 THEN 'IN' WHEN 0 THEN 'OUT' ELSE '' END IsCheckInName
		, V.WorkDate, E.ContainerNum
	FROM GATE.ContainerTrackingDaily V
	LEFT JOIN SysCategoryValue C ON V.GateId = C.ID
	LEFT JOIN GATE.Guard G ON V.CreateUid = G.GuardId
	LEFT JOIN GATE.VisitorApplicationDetailVehicle D ON V.VehicleId = D.Id
	LEFT JOIN GATE.ContainerDetail E ON V.ContainerId = E.Id
	WHERE ContainerId = @ContainerId
END

GO
/****** Object:  StoredProcedure [GATE].[SP_CONTAINER_TRACKINGDAILY_INSERT]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.17
-- Description:	MOOD LIKE SHIT
-- =============================================
CREATE PROCEDURE [GATE].[SP_CONTAINER_TRACKINGDAILY_INSERT]
	-- Add the parameters for the stored procedure here
	@ContainerId int, 
	@UserId varchar(20),
	@VehicleId int,
	@Remark nvarchar(500),
	@IsCheckIn bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @GATEID UNIQUEIDENTIFIER = (SELECT Gate FROM GATE.Guard WHERE GuardId = @UserId)
	
	INSERT INTO GATE.ContainerTrackingDaily(ContainerId, WorkDate, ScanTime, IsCheckIn, GateId, Remark, VehicleId, CreateUid, CreateDate)
	VALUES(@ContainerId, GETDATE(), CONVERT(VARCHAR(5), GETDATE(), 108), @IsCheckIn, @GATEID, @Remark, @VehicleId, @UserId, GETDATE())

END

GO
/****** Object:  StoredProcedure [GATE].[SP_CONTAINER_UPDATE]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2018.04.04
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [GATE].[SP_CONTAINER_UPDATE]
	-- Add the parameters for the stored procedure here
	@ID INT,
	@MASTERID INT,
	@VENDORID INT,	
	@CONTAINERNUM VARCHAR(20),
	@FROMDATE DATE,
	@TODATE DATE,
	@ISIMPORT BIT,
	@USERID VARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF EXISTS (SELECT 1 FROM GATE.ContainerDetail WHERE MasterId = @MASTERID and ContainerNum = @CONTAINERNUM AND DeleteUid IS NULL AND Id <> @ID)
	BEGIN
		SELECT 'This container already exists' Result
		RETURN
	END
	--KIỂM TRA NGƯỜI NÀY ĐÃ CÓ Ở ĐƠN KHÁC CÙNG THỜI GIAN ĐĂNG KÝ HAY KHÔNG
	DECLARE @CODE VARCHAR(20), @FROM VARCHAR(10), @TO VARCHAR(10)--, @MASTERID INT
	DECLARE @GATE VARCHAR(1000) = (SELECT Gate FROM GATE.VisitorApplicationMaster WHERE Id = @MASTERID)

	SELECT TOP 1 @CODE = B.Code, @FROM = CONVERT(VARCHAR(10), A.FromDate, 102), @TO = CONVERT(VARCHAR(10), A.ToDate, 102)--, @MASTERID = A.MasterId
				FROM GATE.ContainerDetail A
				LEFT JOIN GATE.VisitorApplicationMaster B ON B.Id = A.MasterId
				WHERE MasterId != @MASTERID 
					AND ContainerNum = @CONTAINERNUM AND B.Gate LIKE '%' + @GATE + '%'
						--F1<F2 & F2<T1
					AND ((DATEDIFF(DAY, A.FromDate, @FromDate) >= 0 AND DATEDIFF(DAY, @FromDate, A.ToDate) >= 0)
						--F1<T2 & T2<T1
						OR (DATEDIFF(DAY, A.FromDate, @ToDate) >= 0 AND DATEDIFF(DAY, @ToDate, A.ToDate) >= 0)
						)
					AND A.DeleteUid IS NULL AND A.DeleteUid IS NULL AND B.Temp = 1
					--CHỈ KIỂM TRA TRONG ĐƠN ĐÃ ĐƯỢC APPROVE
					AND B.ApprovalStatus = '00F2EC64-CC9B-4FCA-AB4C-B37961EFAD53'
	IF ISNULL(@CODE, '') <> ''
	BEGIN
		SELECT 'This container: ' + @CONTAINERNUM + ' already exists' + ' in application: ' + @CODE + ', registration time is: ' + @FROM + ' to: ' + @TO MESS
		RETURN
	END
	UPDATE GATE.ContainerDetail
	SET VendorId = @VENDORID,
		ContainerNum = @CONTAINERNUM,
		FromDate = @FROMDATE,
		ToDate = @TODATE,
		IsImport = @ISIMPORT,
		UpdateUId = @USERID,
		UpdateDate = GETDATE()
	WHERE Id = @ID
	SELECT 'Ok' Result
	RETURN
END

GO
/****** Object:  StoredProcedure [GATE].[SP_FORGETCARD_DELETE]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20171023
-- Description:	XÓA THÔNG TIN NGƯỜI QUÊN THẺ
-- =============================================
CREATE PROCEDURE [GATE].[SP_FORGETCARD_DELETE]
	@EMPID VARCHAR(20) = 'VN55160524',
	@WORKDATE DATE = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	UPDATE GATE.ForgetCard SET DeleteDate = GETDATE()
	WHERE EmpId = @EMPID AND DATEDIFF(DAY, WorkDate, @WORKDATE) = 0

END

GO
/****** Object:  StoredProcedure [GATE].[SP_FORGETCARD_GETALL]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20171023
-- Description:	LAY LEN DANH SACH NHAN VIEN QUEN THE
-- =============================================
CREATE PROCEDURE [GATE].[SP_FORGETCARD_GETALL]
	@DEPTID INT = 0,
	@EMPID VARCHAR(20) = NULL,
	@EMPNAME NVARCHAR(200) = NULL,
	@POSITION VARCHAR(36) = NULL,
	@JOBTITLE VARCHAR(36) = NULL,
	@FROMDATE DATE = NULL,
	@TODATE DATE = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	;WITH 
	DEPT(ID, NAME, KONAME, PARENTID, LEVEL, Code) AS(
		SELECT ID, ENNAME, KONAME, Parent, 0, Code 
		FROM HrDeptMaster
		WHERE (@DEPTID <> 0 AND Id = @DEPTID) OR (@DEPTID = 0 AND Parent IS NULL)
		UNION ALL
		SELECT B.ID, B.EnName, B.KONAME, B.Parent, A.LEVEL + 1, B.Code 
		FROM DEPT A, HrDeptMaster B
		WHERE A.ID = B.Parent AND B.IsDelete = 0
	),
	CATE AS (
		SELECT Name, ID, SubCode, Category FROM SysCategoryValue WHERE Category IN ('1856B793-C271-423C-8954-981E4B86AF46', '1DCBC106-D82B-4C86-8013-EFA92CA0E788', '654039b3-e6e4-4df7-a4d8-4887bb832619')
	)	

	SELECT M.OrganizationName, M.PlantName, M.DeptName, M.SectName, J.Name JobTitle, p.Name Posistion, f.EmpId, e.LocalName EmpName
		, CONVERT(VARCHAR(10), f.WorkDate, 102) ForGetDate, F.WorkDate
		--, ISNULL(CONVERT(VARCHAR(10), F.TimeIn, 102) + ' ' +  CONVERT(VARCHAR(5), F.TimeIn, 114), '') TimeIn
		--, ISNULL(CONVERT(VARCHAR(10), F.TimeOut, 102) + ' ' +  CONVERT(VARCHAR(5), F.TimeOut, 114), '') [TimeOut]	
		, ISNULL(F.TimeIn, '') TimeIn, ISNULL(F.[TimeOut], '') [TimeOut]
		, ISNULL(CASE WHEN F.Reason = '0F5E6657-5E46-4D2A-9376-217682CB8EAC' THEN F.ReasonOthers ELSE R.Name END, '') ReasonName
	FROM GATE.ForgetCard F
	INNER JOIN HrEmpMaster E ON F.EmpId = E.Code
	INNER JOIN DEPT D ON E.DeptCode = D.ID
	LEFT JOIN HrDeptMasterFull M ON D.ID = M.Id
	LEFT JOIN CATE P ON E.PositionId = P.SubCode AND P.Category = '1856B793-C271-423C-8954-981E4B86AF46'
	LEFT JOIN CATE J ON E.JobTitleId = J.SubCode AND J.Category = '1DCBC106-D82B-4C86-8013-EFA92CA0E788'
	LEFT JOIN CATE R ON F.Reason = R.ID AND R.Category = '654039b3-e6e4-4df7-a4d8-4887bb832619'
	WHERE 1=1
		AND (@EMPID IS NULL OR (@EMPID IS NOT NULL AND F.EmpId = @EMPID))
		AND (@EMPNAME IS NULL OR (@EMPNAME IS NOT NULL AND E.LocalName LIKE '%' + @EMPNAME + '%'))
		AND (@POSITION IS NULL OR (@POSITION IS NOT NULL AND E.PositionId = @POSITION))
		AND (@JOBTITLE IS NULL OR (@JOBTITLE IS NOT NULL AND E.JobTitleId = @JOBTITLE))
		AND DATEDIFF(DAY, @FROMDATE , F.WorkDate) >= 0
		AND DATEDIFF(DAY , F.WorkDate, @TODATE) >= 0
		AND F.DeleteDate IS NULL
	ORDER BY F.CREATEDATE desc
END

GO
/****** Object:  StoredProcedure [GATE].[SP_FORGETCARD_GETINFOR]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20171023
-- Description:	XÓA THÔNG TIN NGƯỜI QUÊN THẺ
-- =============================================
CREATE PROCEDURE [GATE].[SP_FORGETCARD_GETINFOR]
	@EMPID NVARCHAR(200) = N'vd52170013',
	@WORKDATE DATE = '2018.06.03'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	;WITH 
	CATE AS (
		SELECT Name, ID, SubCode, Category FROM SysCategoryValue WHERE Category IN ('1856B793-C271-423C-8954-981E4B86AF46', '1DCBC106-D82B-4C86-8013-EFA92CA0E788', '07643577-62D2-4AA3-83B6-148664A731EF', '654039b3-e6e4-4df7-a4d8-4887bb832619')
	)	

	SELECT E.Code EmpId, E.LocalName EmpName, J.Name JobTitle, p.Name Posistion
		, CONVERT(VARCHAR(10), CONVERT(DATE, E.JoinDate), 102) JOINDATE
		, CAST(E.Img AS VARBINARY(MAX)) AS Img
		, D.OrganizationName + ISNULL(', ' + D.PlantName, '') + ISNULL(', ' + D.DeptName,'') + ISNULL(', ' +  D.SectName,'') DeptFullName
		, CASE WHEN D.Plant IN (10, 66, 11, 12, 85, 184, 217, 218, 219,247,292) 
			THEN ISNULL(D.DeptName,'') + ISNULL(', ' +  D.SectName,'') 
			ELSE ISNULL(D.PlantName, '') + ISNULL(', ' + D.DeptName,'') + ISNULL(', ' +  D.SectName,'') END DeptNamePrint
		, D.OrganizationName, D.Organization
		, D.Plant DeptId
		--, ISNULL(CONVERT(VARCHAR(10), F.TimeIn, 102) + ' ' +  CONVERT(VARCHAR(5), F.TimeIn, 114), '') TimeIn
		--, ISNULL(CONVERT(VARCHAR(10), F.TimeOut, 102) + ' ' +  CONVERT(VARCHAR(5), F.TimeOut, 114), '') [TimeOut]
		, ISNULL(F.TimeIn, '') TimeIn, ISNULL(F.[TimeOut], '') [TimeOut], ISNULL(F.WorkDate, GETDATE()) WorkDate
		, F.SecurityName, F.TemporaryCard, F.GateId, G.Name GateName
		, LOWER(ISNULL(CONVERT(VARCHAR(36), F.Reason), '')) Reason, ISNULL(F.ReasonOthers, '') ReasonOthers
		, ISNULL(CASE WHEN F.Reason = '0F5E6657-5E46-4D2A-9376-217682CB8EAC' THEN F.ReasonOthers ELSE R.Name END, '') ReasonName
		, F.Id
	FROM HrEmpMaster E
	LEFT JOIN HrDeptMasterFull D ON E.DeptCode = D.Id
	LEFT JOIN CATE P ON E.PositionId = P.SubCode AND P.Category = '1856B793-C271-423C-8954-981E4B86AF46'
	LEFT JOIN CATE J ON E.JobTitleId = J.SubCode AND J.Category = '1DCBC106-D82B-4C86-8013-EFA92CA0E788'	
	LEFT JOIN GATE.ForgetCard F ON E.Code = F.EmpId AND DATEDIFF(DAY, @WORKDATE, F.WorkDate) = 0
	LEFT JOIN CATE R ON F.Reason = R.ID AND R.Category = '654039b3-e6e4-4df7-a4d8-4887bb832619'
	LEFT JOIN CATE G ON G.ID = F.GateId AND G.Category = '07643577-62D2-4AA3-83B6-148664A731EF'
	WHERE (E.Code = @EMPID OR E.LocalName = @EMPID OR E.EnName = @EMPID) AND E.[Status] = 1

END

GO
/****** Object:  StoredProcedure [GATE].[SP_FORGETCARD_UPDATE]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20171023
-- Description:	LƯU THÔNG TIN NGƯỜI QUÊN THẺ
-- =============================================
CREATE PROCEDURE [GATE].[SP_FORGETCARD_UPDATE]
	@EMPID VARCHAR(20) = 'VN55160524',
	@WORKDATE DATE,
	@TIMEIN varchar(5),
	@TIMEOUT varchar(5),
	@SECURITYNAME NVARCHAR(200),
	@TEMPORATYCARD VARCHAR(20),
	@GATENUMBER VARCHAR(36),
	@REASON VARCHAR(36) = NULL,
	@REASONOTHER NVARCHAR(500) = NULL, 
	@CHECKIN BIT = NULL,
	@ID INT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF @CHECKIN IS NULL
	BEGIN
		IF EXISTS (SELECT 1 FROM GATE.ForgetCard WHERE EmpId = @EMPID AND DATEDIFF(DAY, CreateDate, @WORKDATE) = 0)
			UPDATE GATE.ForgetCard 
				SET TimeIn = @TIMEIN, 
					[TimeOut] = @TIMEOUT, 
					SecurityName = @SECURITYNAME, 
					UpdateDate = GETDATE(),
					TemporaryCard = @TEMPORATYCARD,
					GateId = @GATENUMBER,
					Reason = @REASON,
					ReasonOthers = @REASONOTHER
			WHERE EmpId = @EMPID AND DATEDIFF(DAY, @WORKDATE, WorkDate) = 0
		ELSE 
			INSERT INTO GATE.ForgetCard(EmpId, WorkDate, TimeIn, [TimeOut], SecurityName, CreateDate, TemporaryCard, GateId, Reason, ReasonOthers)
			VALUES(@EMPID, @WORKDATE, @TIMEIN, @TIMEOUT, @SECURITYNAME, GETDATE(), @TEMPORATYCARD, @GATENUMBER, @REASON, @REASONOTHER)
	END
	ELSE
	BEGIN
		IF @CHECKIN = 1
			INSERT INTO GATE.ForgetCard(EmpId, WorkDate, TimeIn, [TimeOut], SecurityName, CreateDate, TemporaryCard, GateId, Reason, ReasonOthers)
				VALUES(@EMPID, @WORKDATE, CONVERT(VARCHAR(5), GETDATE(), 114), NULL, @SECURITYNAME, GETDATE(), @TEMPORATYCARD, @GATENUMBER, @REASON, @REASONOTHER)
		ELSE
			UPDATE GATE.ForgetCard 
				SET [TimeOut] = CONVERT(VARCHAR(5), GETDATE(), 114), 
					SecurityName = @SECURITYNAME, 
					UpdateDate = GETDATE(),
					TemporaryCard = @TEMPORATYCARD,
					GateId = @GATENUMBER,
					Reason = @REASON,
					ReasonOthers = @REASONOTHER
			WHERE Id = @ID --EmpId = @EMPID AND DATEDIFF(DAY, @WORKDATE, WorkDate) = 0
	END



END

GO
/****** Object:  StoredProcedure [GATE].[SP_GUARD_GET]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20180129
-- Description:	LẤY LÊN DANH SÁCH BẢO VỆ
-- =============================================
CREATE PROCEDURE [GATE].[SP_GUARD_GET]
	-- Add the parameters for the stored procedure here
	@ID INT = null,
	@FROMDATE DATE = '20170101',
	@TODATE DATE = '20171231'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	;WITH CATE AS(
		SELECT ID, Name, SubCode 
		FROM SysCategoryValue 
		WHERE Category IN ('07643577-62D2-4AA3-83B6-148664A731EF', 'FB5D2CB8-1CF2-4203-B3E2-37ADCECFDDEE')
	)

    SELECT A.GuardId, A.Name, A.Gate, C.Name GateName, A.Remark, A.Vendor, V.Name VendorName
		,A.IsActive, CASE A.IsActive WHEN 1 THEN 'Y' ELSE 'N' END IsActiveString
		,A.CreateDate, A.CreateUid, A.UpdateDate, A.UpdateUId, D.LocalName CreateName, A.[Password]
	FROM GATE.Guard A	
	LEFT JOIN CATE C ON A.Gate = C.ID
	LEFT JOIN CATE V ON A.Vendor = V.ID
	LEFT JOIN HrEmpMaster D ON A.CreateUid = D.Code
	WHERE 1=1
		AND DATEDIFF(DAY, @FROMDATE , A.CreateDate) >= 0
		AND DATEDIFF(DAY , A.CreateDate, @TODATE) >= 0
		AND A.DeleteUid IS NULL
	ORDER BY A.CreateUid DESC
END

GO
/****** Object:  StoredProcedure [GATE].[SP_GUARD_INSERT]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20180129
-- Description:	LẤY LÊN DANH SÁCH BẢO VỆ
-- =============================================
CREATE PROCEDURE [GATE].[SP_GUARD_INSERT]
	-- Add the parameters for the stored procedure here
	@NAME NVARCHAR(200) = 'NGHĨA',
	@PASSWORD NVARCHAR(100) = 'AAA',
	@GATE VARCHAR(36) = 'cdb7cab9-0f31-40e9-a7a7-18ca538d8c92',
	@REMARK NVARCHAR(500) = 'AA',
	@VENDOR VARCHAR(36) = '175eafa7-3c1e-48ea-8475-74465adf90ed',
	@ISACTIVE BIT = 1,
	@USERID VARCHAR(20) = 'VN55160524'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @SEQ VARCHAR(2) = CONVERT(VARCHAR(2), (SELECT [Sequence] FROM SysCategoryValue WHERE ID = @GATE))
	--DECLARE @NO VARCHAR(2) = CONVERT(VARCHAR(2), (SELECT COUNT(1) + 1 FROM GATE.Guard WHERE Gate = @GATE AND VENDOR = @VENDOR AND DeleteUid IS NULL AND DATEDIFF(MONTH, CreateDate, GETDATE()) = 0))
	DECLARE @NO VARCHAR(2) = CONVERT(VARCHAR(2), (SELECT COUNT(1) + 1 FROM GATE.Guard WHERE Gate = @GATE AND DeleteUid IS NULL AND DATEDIFF(MONTH, CreateDate, GETDATE()) = 0))
	
	DECLARE @COUNT VARCHAR(2) = REPLICATE('0', 2 - LEN(@NO)) + @NO
	DECLARE @GATENUMBER VARCHAR(2) = REPLICATE('0', 2 - LEN(@SEQ)) + @SEQ
	
	--CODE: LH01180201
	--LH: MÃ VENDOR, 1801: NĂM THÁNG TẠO, 01: SỐ THỨ TỰ CỔNG, 01: SỐ THỨ TỰ TẠO

	--DECLARE @CODE VARCHAR(20) = (SELECT SubCode FROM SysCategoryValue WHERE ID = @VENDOR) + SUBSTRING(REPLACE(CONVERT(VARCHAR, GETDATE(), 2), '.', ''), 1, 4) + @GATENUMBER + @COUNT
	DECLARE @CODE VARCHAR(20) = 'GATE' + @GATENUMBER + @COUNT

	INSERT INTO GATE.Guard(GuardId, Name, [Password], Gate, Vendor, Remark, IsActive, CreateDate, CreateUid)
	VALUES(@CODE, @NAME, @PASSWORD, @GATE, @VENDOR, @REMARK, @ISACTIVE, GETDATE(), @USERID)
	
END

GO
/****** Object:  StoredProcedure [GATE].[SP_GUARD_UPDATE]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20180129
-- Description:	LẤY LÊN DANH SÁCH BẢO VỆ
-- =============================================
CREATE PROCEDURE [GATE].[SP_GUARD_UPDATE]
	-- Add the parameters for the stored procedure here
	@GuardId VARCHAR(20),
	@NAME NVARCHAR(200) = 'NGHĨA',
	@REMARK NVARCHAR(500) = 'AA',
	@ISACTIVE BIT = 1,
	@CHANGEPASS BIT = 0,
	@NEWPASS NVARCHAR(500),
	@USERID VARCHAR(20) = 'VN55160524'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	UPDATE GATE.Guard
	SET Name = @NAME, Remark = @REMARK, IsActive = @ISACTIVE, UpdateDate = GETDATE(), UpdateUId = @USERID, Password = @NEWPASS
	WHERE GuardId = @GuardId
END

GO
/****** Object:  StoredProcedure [GATE].[SP_PASSINGGOODS_APPROVAL_HISTORY]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20170825
-- Description:	LƯU THÔNG TIN APPROVE CỦA APPLICATION
-- =============================================
CREATE PROCEDURE [GATE].[SP_PASSINGGOODS_APPROVAL_HISTORY]
	@MasterId int = 13,
	@ApplicationId int = 12
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @TB TABLE (Id int, EmpId varchar(20), EmpName nvarchar(100), ApprovalType uniqueidentifier, ApproverTypeName nvarchar(100), IsApprove bit, 
					Seq tinyint, Comment nvarchar(200), DateApprove datetime, JobTitle varchar(50))
	
	INSERT INTO @TB
	SELECT 0, A.CreateUid, '[Confirm]' + ' ' +  E.LocalName, 'E408D53D-6E62-4D63-A3D4-CD3EA9A14D36', NULL
		, CASE WHEN A.ConfirmDate IS NULL THEN NULL ELSE 1 END, 0, NULL, ConfirmDate, J.Name JobTitle
	FROM GATE.PassingGoodsMaster A
	LEFT JOIN HrEmpMaster E ON A.CreateUid = E.Code
	LEFT JOIN SysCategoryValue J ON J.Category = '1DCBC106-D82B-4C86-8013-EFA92CA0E788' AND E.JobTitleId = J.SubCode
	WHERE A.Id = @MasterId 

	INSERT INTO @TB
	SELECT A.Id, A.EmpId, '[' + C.Name + ']' + ' ' +  E.LocalName, A.ApproverType, C.Name, A.IsApprove, A.Seq, A.Comment, A.DateApprove, J.Name JobTitle
	FROM EApproval.Approval A
	LEFT JOIN HrEmpMaster E ON A.EmpId = E.Code
	LEFT JOIN SysCategoryValue C ON A.ApproverType = C.ID
	LEFT JOIN SysCategoryValue J ON J.Category = '1DCBC106-D82B-4C86-8013-EFA92CA0E788' AND E.JobTitleId = J.SubCode
	WHERE A.ApplicationId = @ApplicationId AND A.MasterId = @MasterId

	SELECT Id, EmpId, EmpName, ApprovalType, ApproverTypeName, IsApprove, Seq, ISNULL(Comment, '') Comment, DateApprove
		,CONVERT(varchar(10), DateApprove, 102) + ' ' + CONVERT(varchar(8), DateApprove, 114) DateApproveFormat, JobTitle
	FROM @TB


END



GO
/****** Object:  StoredProcedure [GATE].[SP_PASSINGGOODS_APPROVE]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20170825
-- Description:	LƯU THÔNG TIN APPROVE CỦA APPLICATION
-- =============================================
CREATE PROCEDURE [GATE].[SP_PASSINGGOODS_APPROVE]
	@MasterId int = 24,
	@ApplicationId int = 1,
	@IsApprove bit = 1,
	@Comment nvarchar(200) = 'aaaa',
	@UserId varchar(20) = 'vn55104017',
	@LinkApplication varchar(100) = 'http://localhost:5678/ApplicationConfig/Index'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET @ApplicationId = 12;

	DECLARE @APPLICATIONTYPE UNIQUEIDENTIFIER, @APPROVERTYPE UNIQUEIDENTIFIER, @ISLASTAPPROVER INT, @NEXTAPPROVER VARCHAR(20) = '', @NEXTAPPROVERNAME NVARCHAR(200) = ''
	SELECT @APPLICATIONTYPE = ApprovalKind FROM GATE.PassingGoodsMaster WHERE Id = @MasterId
	SELECT @APPROVERTYPE = ApproverType FROM EApproval.Approval WHERE ApplicationId = @ApplicationId AND MasterId = @MasterId AND EmpId = @UserId	

	--LƯU THÔNG TIN APPROVE
	UPDATE EApproval.Approval SET IsApprove = @IsApprove, Comment = @Comment, DateApprove = GETDATE()
	WHERE ApplicationId = @ApplicationId
		AND MasterId = @MasterId
		AND EmpId = @UserId

	--Kiểm tra xem có phải là người cuối cùng approve hay không	
	SET @ISLASTAPPROVER = (SELECT COUNT(1) 
							FROM EApproval.Approval 
							WHERE ApplicationId = @ApplicationId 
								AND MasterId = @MasterId AND ApproverType <> '045872C8-638C-4A12-A70B-4E471C5D90EB' --KHÔNG TÍNH NHỮNG NGƯỜI THAM KHẢO
								AND IsApprove IS NULL--NHỮNG NGƯỜI CHƯA APPROVE
							)
	--LẤY RA THÔNG TIN NGƯỜI APPROVER KẾ TIẾP
	IF (@APPLICATIONTYPE = '2600C4A7-CFB3-4E08-A08D-EDF0C1D99A71')
	BEGIN
		SET @NEXTAPPROVER = (SELECT TOP 1 EmpId 
		FROM EApproval.Approval 
		WHERE ApplicationId = @ApplicationId 
			AND MasterId = @MasterId AND ApproverType <> '045872C8-638C-4A12-A70B-4E471C5D90EB' --KHÔNG TÍNH NHỮNG NGƯỜI THAM KHẢO
			AND IsApprove IS NULL--NHỮNG NGƯỜI CHƯA APPROVE
		)
	END
	ELSE
		SET @NEXTAPPROVER = ''
	--NẾU TỪ CHỐI ĐƠN VÀ LÀ NGƯỜI APPROVE THÌ KHÔNG SET NGƯỜI KẾ TIẾP APPROVE NỮA, MÀ ĐƠN SẼ DỪNG TẠI ĐÂY
	IF @IsApprove = 0 AND @APPROVERTYPE = 'E408D53D-6E62-4D63-A3D4-CD3EA9A14D36'
		SET @NEXTAPPROVER = ''

	--Kiểm tra xem người này có phải là người duyệt cuối cùng hay không
		--hoặc nếu người này là người approver và người này từ chối đơn -> cập nhật lại cho bên master và kết thúc đơn
		--còn từ chối đơn nhưng người này là consente thì vẫn tiếp tục duyệt
	IF @ISLASTAPPROVER = 0 OR (@IsApprove = 0 AND @APPROVERTYPE = 'E408D53D-6E62-4D63-A3D4-CD3EA9A14D36')
	BEGIN
		UPDATE GATE.PassingGoodsMaster 
		SET ApprovalStatus = CASE WHEN @APPROVERTYPE = '5325E6FF-6430-49A2-B3D3-D9ABDBE06F9E' THEN '00F2EC64-CC9B-4FCA-AB4C-B37961EFAD53' -- NẾU NGƯỜI CONSENTE THÌ MẶC ĐỊNH ĐƠN LÀ APPROVED
			ELSE CASE WHEN @IsApprove = 1 THEN '00F2EC64-CC9B-4FCA-AB4C-B37961EFAD53' ELSE '9A96D85B-8189-46BA-84CD-3389FDC501B7' END--CÒN NẾU LÀ APPROVER THÌ XÉT XEM NGƯỜI NÀY ĐỒNG Ý HAY TỪ CHỐI ĐƠN
			END,
			NextApprover = ''
		WHERE Id = @MasterId

		GOTO SEND_EMAIL_RESULT
	END
	--VẪN CÒN NGƯỜI APPROVE VÀ LOẠI ĐƠN LÀ ORDER--> CẬP NHẬT NGƯỜI APPROVE KẾ TIẾP
		--CÒN PARALLEL THÌ KO SET NGƯỜI APPROVER KẾ TIẾP
	ELSE IF @APPLICATIONTYPE = '2600C4A7-CFB3-4E08-A08D-EDF0C1D99A71'  
	BEGIN
		UPDATE GATE.PassingGoodsMaster SET NextApprover = @NEXTAPPROVER WHERE Id = @MasterId
	END

	IF ISNULL(@NEXTAPPROVER,'') <> ''
	BEGIN
		DECLARE @EMAIL VARCHAR(1000), @CCBCC VARCHAR(1000) = 'nghia55160524@hyosung.com', @BODY NVARCHAR(MAX) = 'test', @SUBJECT NVARCHAR(MAX) = 'test'

		--LẤY RA THÔNG TIN NGƯỜI APPROVER ĐÊ GỬI MAIL
		--SET @EMAIL = (
			SELECT @EMAIL = Email, @NEXTAPPROVERNAME = LocalName FROM HrEmpMaster WHERE Code = @NEXTAPPROVER
		--)

		SET @SUBJECT = (
			SELECT  '{{In Processing}}[' + B.Name + ']' + ' ' + A.Code 
			FROM GATE.PassingGoodsMaster A
			INNER JOIN EApproval.ApplicationConfig B ON @ApplicationId = B.Id 
			WHERE A.Id = @MasterId
		)
		
		SELECT @BODY = 
			'<p>Dear Mr/Ms: ' + @NEXTAPPROVERNAME + '. Please view and approve this application follow link bellow</p>'+
			'<table width="95%" align="center" cellpadding="2" cellspacing="1" bgcolor="#F2F2F2" style="font-size: 14px; border: 1px solid #c7c7c7">'+
			  '<tbody>'+
			   '<tr valign="top" bgcolor="#FFFFFF">'+
				  '<td  align="left" width="10%"><b>Application</b></td>'+
				  '<td>'+C.Name+'</td>'+
				'</tr>'+
				'<tr valign="top" bgcolor="#f9f9f9">'+
				  '<td  align="left"><b>Subject</b></td>'+
				  '<td>' + A.Code + '</td>'+
				'</tr>'+
				'<tr valign="top" bgcolor="#FFFFFF">'+
				  '<td align="left"><b>Creator</b></td>'+
				  N'<td>' + E.LocalName + '</td>'+
				'</tr>'+
				'<tr valign="top" bgcolor="#f9f9f9">'+
				  '<td align="left"><b>Create Date</b></td>'+
				  '<td valign="top"><div>'+CONVERT(VARCHAR, A.CreateDate, 111)+'</div></td>'+
				'</tr>'+
				'<tr valign="top" bgcolor="#FFFFFF">'+
				  '<td colspan="2" align="center"><p style="color: #023aa0; font: Arial; margin: 5px 0;">Click the button bellow to view detail</p>'+
					'<p style="margin:5px 0; background: #F9F9F9;background-image: -webkit-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: -moz-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: -ms-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: -o-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: linear-gradient(to bottom, #F9F9F9, #EFEFEF);-webkit-border-radius: 5;-moz-border-radius: 5;border-radius: 5px;font-family: Arial;color: #323232;padding: 10px 20px 10px 20px;border: solid #c7c7c7 1px;text-decoration: none;width: 100px"><a href="'+@LinkApplication+'">Click View Detail</a></p></td>'+
				'</tr>'+
			  '</tbody>'+
			'</table>'
		FROM GATE.PassingGoodsMaster A
		INNER JOIN EApproval.ApplicationConfig C ON @ApplicationId = C.Id
		INNER JOIN HrEmpMaster E ON A.CreateUid = E.Code
		WHERE A.Id = @MasterId

		EXEC msdb.dbo.sp_send_dbmail
			@profile_name = 'Hyosung Portal',
			@recipients = @EMAIL,
			@copy_recipients = @CCBCC,
			@body = @BODY,
			@subject = @subject,
			@body_format = 'HTML' ;
		RETURN
	END

	SEND_EMAIL_RESULT:
	BEGIN

		DECLARE @TB_RAW TABLE(Id int, Content varchar(500))
		INSERT INTO @TB_RAW
		SELECT * FROM FN_SplitString((select ApprovalLine from GATE.PassingGoodsMaster where Id = 157),'|')

		--TÁCH LOẠI NGƯỜI APPROVE
		DECLARE @TB_RAW_APPROVETYPE TABLE(Id INT, EMPID VARCHAR(20))
		INSERT INTO @TB_RAW_APPROVETYPE 
		SELECT * FROM FN_SplitString((SELECT Content FROM @TB_RAW WHERE Id = 4), ',')

		--LẤY RA THÔNG TIN NGƯỜI TẠO ĐƠN ĐÊ GỬI MAIL
		SET @EMAIL = (
			SELECT Email FROM HrEmpMaster WHERE Code = (SELECT CreateUid FROM GATE.PassingGoodsMaster WHERE ID= @MasterId)
		)

		SET @CCBCC = (
				SELECT STUFF((SELECT ';' + Email 
				FROM HrEmpMaster 
				WHERE Code IN (SELECT EMPID FROM @TB_RAW_APPROVETYPE)
				FOR XML PATH('')), 1, 1, ''))

		SET @SUBJECT = (
			SELECT  '{{Finished}}[' + B.Name + ']' + ' ' + A.Code 
			FROM GATE.PassingGoodsMaster A
			INNER JOIN EApproval.ApplicationConfig B ON @ApplicationId = B.Id 
			WHERE A.Id = @MasterId
		)
		
		SELECT @BODY = 
			'<p>Dear Mr/Ms: ' + E.LocalName + '. The application already approved. Please view follow link bellow</p>'+
			'<table width="95%" align="center" cellpadding="2" cellspacing="1" bgcolor="#F2F2F2" style="font-size: 14px; border: 1px solid #c7c7c7">'+
			  '<tbody>'+
			   '<tr valign="top" bgcolor="#FFFFFF">'+
				  '<td  align="left" width="10%"><b>Application</b></td>'+
				  '<td>'+C.Name+'</td>'+
				'</tr>'+
				'<tr valign="top" bgcolor="#f9f9f9">'+
				  '<td  align="left"><b>Subject</b></td>'+
				  '<td>' + A.Code + '</td>'+
				'</tr>'+
				'<tr valign="top" bgcolor="#FFFFFF">'+
				  '<td align="left"><b>Creator</b></td>'+
				  N'<td>' + E.LocalName + '</td>'+  
				'</tr>'+
				'<tr valign="top" bgcolor="#f9f9f9">'+
				  '<td align="left"><b>Create Date</b></td>'+
				  '<td valign="top"><div>'+CONVERT(VARCHAR, A.CreateDate, 111)+'</div></td>'+
				'</tr>'+
				'<tr valign="top" bgcolor="#FFFFFF">'+
				  '<td colspan="2" align="center"><p style="color: #023aa0; font: Arial; margin: 5px 0;">Click the button bellow to view detail</p>'+
					'<p style="margin:5px 0; background: #F9F9F9;background-image: -webkit-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: -moz-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: -ms-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: -o-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: linear-gradient(to bottom, #F9F9F9, #EFEFEF);-webkit-border-radius: 5;-moz-border-radius: 5;border-radius: 5px;font-family: Arial;color: #323232;padding: 10px 20px 10px 20px;border: solid #c7c7c7 1px;text-decoration: none;width: 100px"><a href="'+@LinkApplication+'">Click View Detail</a></p></td>'+
				'</tr>'+
			  '</tbody>'+
			'</table>'
		FROM GATE.PassingGoodsMaster A
		INNER JOIN EApproval.ApplicationConfig C ON @ApplicationId = C.Id
		INNER JOIN HrEmpMaster E ON A.CreateUid = E.Code
		WHERE A.Id = @MasterId

		SET @CCBCC = @CCBCC + ';nghia55160524@hyosung.com'
		EXEC msdb.dbo.sp_send_dbmail
			@profile_name = 'Hyosung Portal',
			@recipients = @EMAIL,
			@copy_recipients = @CCBCC,
			@body = @BODY,
			@subject = @subject,
			@body_format = 'HTML' ;
		RETURN
	END
END



GO
/****** Object:  StoredProcedure [GATE].[SP_PASSINGGOODS_CONFIRM]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20170830
-- Description:	CONFIRM - RECALL APPLICATION
-- =============================================
CREATE PROCEDURE [GATE].[SP_PASSINGGOODS_CONFIRM]
	@MasterId int,
	@Status bit,
	@LinkApplication VARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF @Status = 1
	BEGIN
		--CẬP NHẬT THÔNG TIN
		UPDATE GATE.PassingGoodsMaster
		SET ApprovalStatus = 'C4FF5A2F-CD32-4785-9499-A26E5148D58D', ConfirmDate = GETDATE() 
		WHERE Id = @MasterId

		DECLARE @EMAIL VARCHAR(1000) = '', @CCBCC VARCHAR(1000), @BODY NVARCHAR(MAX) = '', @SUBJECT NVARCHAR(MAX) = ''
		DECLARE @APPROVALLINE NVARCHAR(2000) = (SELECT ApprovalLine FROM GATE.PassingGoodsMaster WHERE ID = @MasterId)
		--LOẠI APPROVE: ORDER HAY PARALLEL
		DECLARE @APPLICATIONTYPE UNIQUEIDENTIFIER = (SELECT ApprovalKind FROM GATE.PassingGoodsMaster WHERE Id = @MasterId)
		--LOẠI ĐƠN: LONGTERM - SHORTTERM
		DECLARE @APPLICATIONID INT = 12
		--LẤY RA THÔNG TIN NGƯỜI APPROVER ĐÊ GỬI MAIL
		IF @APPLICATIONTYPE = '2600C4A7-CFB3-4E08-A08D-EDF0C1D99A71'
			--NẾU LÀ ORDER THÌ CHỈ LẤY EMAIL CỦA NGƯỜI DUYỆT KẾ TIẾP ĐỂ GỬI
			SET @EMAIL = (
				SELECT Email FROM HrEmpMaster WHERE Code = (SELECT NextApprover FROM GATE.PassingGoodsMaster WHERE Id = @MasterId)
			)
		ELSE
		--CÒN NẾU LÀ PARALLEL THÌ LẤY HẾT TẤT CẢ CÁC MEO ĐỂ GỬI 1 LẦN
		SET @EMAIL = (
			SELECT STUFF((SELECT ';' + Email 
			FROM HrEmpMaster 
			WHERE Code IN (SELECT EmpId 
							FROM EApproval.Approval 
							WHERE MasterId = @MasterId AND ApplicationId = @APPLICATIONID AND ApproverType <> '045872C8-638C-4A12-A70B-4E471C5D90EB')
			FOR XML PATH('')), 1, 1, '')
		)
		SET @SUBJECT = (
			SELECT  '{{In Processing}}[' + B.Name + ']' + ' ' + A.Code 
			FROM GATE.PassingGoodsMaster A
			INNER JOIN EApproval.ApplicationConfig B ON @APPLICATIONID = B.Id 
			WHERE A.Id = @MasterId
		)
		
		SELECT @BODY = 
			'<p>Dear Mr/Ms: ' + E.LocalName + '. Please view and approve this application follow link bellow</p>'+
			'<table width="95%" align="center" cellpadding="2" cellspacing="1" bgcolor="#F2F2F2" style="font-size: 14px; border: 1px solid #c7c7c7">'+
			  '<tbody>'+
			   '<tr valign="top" bgcolor="#FFFFFF">'+
				  '<td  align="left" width="10%"><b>Application</b></td>'+
				  '<td>'+C.Name+'</td>'+
				'</tr>'+
				'<tr valign="top" bgcolor="#f9f9f9">'+
				  '<td  align="left"><b>Subject</b></td>'+
				  '<td>' + A.Code + '</td>'+
				'</tr>'+
				'<tr valign="top" bgcolor="#FFFFFF">'+
				  '<td align="left"><b>Creator</b></td>'+
				  N'<td>' + E.LocalName + '</td>'+
				'</tr>'+
				'<tr valign="top" bgcolor="#f9f9f9">'+
				  '<td align="left"><b>Create Date</b></td>'+
				  '<td valign="top"><div>'+CONVERT(VARCHAR, A.CreateDate, 111)+'</div></td>'+
				'</tr>'+
				'<tr valign="top" bgcolor="#FFFFFF">'+
				  '<td colspan="2" align="center"><p style="color: #023aa0; font: Arial; margin: 5px 0;">Click the button bellow to view detail</p>'+
					'<p style="margin:5px 0; background: #F9F9F9;background-image: -webkit-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: -moz-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: -ms-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: -o-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: linear-gradient(to bottom, #F9F9F9, #EFEFEF);-webkit-border-radius: 5;-moz-border-radius: 5;border-radius: 5px;font-family: Arial;color: #323232;padding: 10px 20px 10px 20px;border: solid #c7c7c7 1px;text-decoration: none;width: 100px"><a href="'+@LinkApplication+'">Click View Detail</a></p></td>'+
				'</tr>'+
			  '</tbody>'+
			'</table>'
		FROM GATE.PassingGoodsMaster A
		INNER JOIN EApproval.ApplicationConfig C ON @APPLICATIONID = C.Id
		INNER JOIN HrEmpMaster E ON A.CreateUid = E.Code
		WHERE A.Id = @MasterId

		EXEC msdb.dbo.sp_send_dbmail
			@profile_name = 'Hyosung Portal',
			@recipients = @EMAIL,
			@copy_recipients = @CCBCC,
			@body = @BODY,
			@subject = @subject,
			@body_format = 'HTML' ;
	END

	ELSE
	BEGIN
		--CẬP NHẬT THÔNG TIN
		UPDATE GATE.PassingGoodsMaster 
		SET ApprovalStatus = '9C817780-2079-4417-B87B-B7E537BBAE8A', ConfirmDate = NULL
		WHERE Id = @MasterId
	END

END



GO
/****** Object:  StoredProcedure [GATE].[SP_PASSINGGOODS_DETAIL_GET]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.24
-- Description:	LẤY LÊN DANH SÁCH ĐƠN MANG HÀNG RA VÀO CỔNG
-- =============================================
CREATE PROCEDURE [GATE].[SP_PASSINGGOODS_DETAIL_GET]
	-- Add the parameters for the stored procedure here
	@ID INT = NULL,
	@MASTERID INT = 28,
	@ISIMPORT BIT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT D.Id, MasterId, ItemName, Serial, [Description], Quantity, ItemLocation, ImportDate, D.ReImportDate
		,D.ReImport, CASE WHEN D.ReImport = 1 THEN 'Y' ELSE 'N' END ReImportName
		,IsAttachment, D.Remark
		,D.ImportUid, G.Name ImportName, S.Name ImportGate
		,M.Code
	FROM GATE.PassingGoodsDetail D
	LEFT JOIN GATE.Guard G ON D.ImportUid = G.GuardId
	LEFT JOIN SysCategoryValue S on G.Gate = S.ID
	LEFT JOIN GATE.PassingGoodsMaster M ON D.MasterId = M.ID
	WHERE (@ID IS NOT NULL AND D.Id = @ID) OR (@ID IS NULL AND D.MasterId = @MASTERID)
		--AND (@ISIMPORT IS NULL OR (@ISIMPORT IS NOT NULL AND D.ReImport = @ISIMPORT))
	ORDER BY D.Id
END

GO
/****** Object:  StoredProcedure [GATE].[SP_PASSINGGOODS_DETAIL_GET_FOR_SECURITY]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.24
-- Description:	LẤY LÊN DANH SÁCH ĐƠN MANG HÀNG RA VÀO CỔNG
-- =============================================
CREATE PROCEDURE [GATE].[SP_PASSINGGOODS_DETAIL_GET_FOR_SECURITY]
	-- Add the parameters for the stored procedure here
	--@ID INT = NULL,
	--@MASTERID INT = 28,
	@ISIMPORT BIT = 1,
	@FROMDATE DATE = '20000101',
	@TODATE DATE = '20990101',
	@USERID varchar(20) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	;WITH POSTACTION AS (
		SELECT * 
		FROM CmsPostAction 
		WHERE ModuleId = '8C0D1530-AB8F-40D0-922C-63C9A208778A' AND CategoryId = '95A464F6-6D97-4F9C-B6F3-2D840A5A884C' AND UserId = @USERID
	)
    -- Insert statements for procedure here
	SELECT D.Id, D.MasterId, ItemName, Serial, [Description], Quantity, ItemLocation, ImportDate, D.ReImportDate, D.ReImport
		,IsAttachment, D.Remark
		,D.ImportUid, G.Name ImportName, S.Name ImportGate
		,M.Code, M.Applicant, E.LocalName ApplicantName
		,M.DeptId, F.OrganizationName OrgName, F.PlantName, F.DeptName, F.SectName
		,M.ApplicationDate, M.ExportDate
		,CASE WHEN I.ActionId IS NOT NULL THEN 1 ELSE 0 END ISVIEW
	FROM GATE.PassingGoodsDetail D
	LEFT JOIN GATE.Guard G ON D.ImportUid = G.GuardId
	LEFT JOIN SysCategoryValue S on G.Gate = S.ID
	LEFT JOIN GATE.PassingGoodsMaster M ON D.MasterId = M.ID
	LEFT JOIN HrEmpMaster E ON M.Applicant = E.Code
	LEFT JOIN HrDeptMasterFull F ON M.DeptId = F.Id
	LEFT JOIN POSTACTION I ON M.Id = I.MasterId
	WHERE (@ISIMPORT IS NULL OR (@ISIMPORT IS NOT NULL AND D.ReImport = @ISIMPORT AND D.ImportDate IS NULL))
		AND DATEDIFF(DAY, @FROMDATE , M.CreateDate) >= 0
		AND DATEDIFF(DAY , M.CreateDate, @TODATE) >= 0
		AND M.ApprovalStatus = '00F2EC64-CC9B-4FCA-AB4C-B37961EFAD53'
		AND M.ExportUid IS NOT NULL
	ORDER BY D.Id
END

GO
/****** Object:  StoredProcedure [GATE].[SP_PASSINGGOODS_DETAIL_INSERT]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.25
-- Description: LƯU THÔNG TIN PASSING GOODS
-- =============================================
CREATE PROCEDURE [GATE].[SP_PASSINGGOODS_DETAIL_INSERT]
	-- Add the parameters for the stored procedure here
	@MASTERID INT,
	@ITEMNAME NVARCHAR(200),
	@SERIAL VARCHAR(50),
	@DESCRIPTION NVARCHAR(500),
	@QUANTITY INT,
	@ITEMLOCATION NVARCHAR(100),
	@ISATTACHMENT BIT,
	@REIMPORT BIT,
	@REIMPORTDATE DATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	INSERT INTO GATE.PassingGoodsDetail(MasterId, ItemName, Serial, Description, Quantity, ItemLocation, IsAttachment, ReImportDate, ReImport)
	VALUES(@MASTERID, @ITEMNAME, @SERIAL, @DESCRIPTION, @QUANTITY, @ITEMLOCATION, @ISATTACHMENT, @REIMPORTDATE, @REIMPORT)
	
	DECLARE @RESULT INT = SCOPE_IDENTITY()
	SELECT @RESULT
END

GO
/****** Object:  StoredProcedure [GATE].[SP_PASSINGGOODS_DETAIL_UPDATE]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.25
-- Description: LƯU THÔNG TIN PASSING GOODS
-- =============================================
CREATE PROCEDURE [GATE].[SP_PASSINGGOODS_DETAIL_UPDATE]
	-- Add the parameters for the stored procedure here
	@ID INT,
	@MASTERID INT,
	@ITEMNAME NVARCHAR(200),
	@SERIAL VARCHAR(50),
	@DESCRIPTION NVARCHAR(500),
	@QUANTITY INT,
	@ITEMLOCATION NVARCHAR(100),
	@ISATTACHMENT BIT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	UPDATE GATE.PassingGoodsDetail
	SET ItemName = @ITEMNAME,
		Serial = @SERIAL,
		Description = @DESCRIPTION,
		Quantity = @QUANTITY,
		ItemLocation = @ITEMLOCATION,
		IsAttachment = @ISATTACHMENT
	WHERE Id = @ID
END

GO
/****** Object:  StoredProcedure [GATE].[SP_PASSINGGOODS_DETAIL_UPDATE_CHECKOUT]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.25
-- Description: LƯU THÔNG TIN PASSING GOODS
-- =============================================
CREATE PROCEDURE [GATE].[SP_PASSINGGOODS_DETAIL_UPDATE_CHECKOUT]
	-- Add the parameters for the stored procedure here
	@ID INT,
	@MASTERID INT,
	@GATEID VARCHAR(36),
	@PASSDATE DATETIME,
	@IMPORTDATE DATETIME,
	@REMARK NVARCHAR(500),
	@SECURITYNAME NVARCHAR(200),
	@FINISHDATE DATETIME,
	@FINISHREASON NVARCHAR(500)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF @FINISHDATE IS NULL
		UPDATE GATE.PassingGoodsDetail
		SET GATE = @GATEID,
			PassDate = @PASSDATE,
			ImportDate = @IMPORTDATE,
			SecurityName = @SECURITYNAME,
			Remark = @REMARK
		WHERE Id = @ID
	ELSE
		UPDATE GATE.PassingGoodsMaster
		SET FinishDate = @FINISHDATE,
			FinishReason = @FINISHREASON,
			FinishApplication = 1
		WHERE Id = @MASTERID
END

GO
/****** Object:  StoredProcedure [GATE].[SP_PASSINGGOODS_GET]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.24
-- Description:	LẤY LÊN DANH SÁCH ĐƠN MANG HÀNG RA VÀO CỔNG
-- =============================================
CREATE PROCEDURE [GATE].[SP_PASSINGGOODS_GET]
	-- Add the parameters for the stored procedure here
	@ID INT = null,
	@FROMDATE DATE = '20000101',
	@TODATE DATE = '20990101',
	@USERID VARCHAR(20) = 'VN55160524',
	@APPROVESTATUS VARCHAR(36) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	;WITH CATE AS(
		SELECT ID, Name, SubCode 
		FROM SysCategoryValue 
		WHERE Category = '054E0F62-4EFE-41E1-A18D-5C28A6531539' and ParentID = 'EAF964F0-F557-40C7-AD06-F0B4A6571A4F'
	), POSTACTION AS (
		SELECT * 
		FROM CmsPostAction 
		WHERE ModuleId = '8C0D1530-AB8F-40D0-922C-63C9A208778A' AND CategoryId = '95A464F6-6D97-4F9C-B6F3-2D840A5A884C' AND UserId = @USERID
	)
    -- Insert statements for procedure here
	SELECT M.Id, M.Code, M.Applicant, E.LocalName ApplicantName
		,M.DeptId, D.OrganizationName OrgName, D.PlantName, D.DeptName, D.SectName
		,M.ApplicationDate, M.ReImport, M.ReImportDate, ISNULL(M.Reason, '  ') Reason, M.FinishApplication, M.FinishReason, M.FinishDate
		,M.ApprovalKind, C.Name KindName
		,ISNULL(M.ApprovalLineJson, '') ApprovalLineJson
		,ISNULL(M.ApprovalLine, '') ApprovalLine, C.Name ApprovalStatusName, M.ApprovalStatus
		,M.NextApprover, N.LocalName NextApproverName
		,M.CreateDate, M.CreateUid, U.LocalName CreateName
		,CASE WHEN I.ActionId IS NOT NULL THEN 1 ELSE 0 END ISVIEW
		,M.ExportDate, M.ExportUid, S.Name GateName, G.Name ExportName

	FROM GATE.PassingGoodsMaster M
	LEFT JOIN HrEmpMaster E ON M.Applicant = E.Code
	LEFT JOIN HrDeptMasterFull D ON M.DeptId = D.Id
	LEFT JOIN CATE C ON M.ApprovalStatus = C.ID
	LEFT JOIN HrEmpMaster U ON M.CreateUid = U.Code
	LEFT JOIN HrEmpMaster N ON M.NextApprover = N.Code
	LEFT JOIN POSTACTION I ON M.Id = I.MasterId
	LEFT JOIN GATE.Guard G ON M.ExportUid = G.GuardId
	LEFT JOIN SysCategoryValue S ON G.Gate = S.ID
	WHERE 1=1
		AND DATEDIFF(DAY, @FROMDATE , M.CreateDate) >= 0
		AND DATEDIFF(DAY , M.CreateDate, @TODATE) >= 0
		AND M.DeleteUid IS NULL
		AND ((@APPROVESTATUS IS NULL AND (M.CreateUid = @USERID OR M.ApprovalLine  LIKE '%' + @USERID + '%'))
			OR (@APPROVESTATUS IS NOT NULL AND M.ApprovalStatus = @APPROVESTATUS AND (M.CreateUid = @USERID OR M.ApprovalLine  LIKE '%' + @USERID + '%')))
		AND M.Temp = 0
		AND ((M.CreateUid <> @USERID AND M.ApprovalStatus <> '9C817780-2079-4417-B87B-B7E537BBAE8A') OR M.CreateUid = @USERID)
	ORDER BY M.CreateDate DESC
END

GO
/****** Object:  StoredProcedure [GATE].[SP_PASSINGGOODS_GET_FOR_SECURITY]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.24
-- Description:	LẤY LÊN DANH SÁCH ĐƠN MANG HÀNG RA VÀO CỔNG
-- =============================================
CREATE PROCEDURE [GATE].[SP_PASSINGGOODS_GET_FOR_SECURITY]
	-- Add the parameters for the stored procedure here
	@ID INT = null,
	@FROMDATE DATE = '20000101',
	@TODATE DATE = '20990101',
	@APPROVESTATUS VARCHAR(36) = NULL,
	@USERID VARCHAR(20) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	;WITH CATE AS(
		SELECT ID, Name, SubCode 
		FROM SysCategoryValue 
		WHERE Category = '054E0F62-4EFE-41E1-A18D-5C28A6531539' and ParentID = 'EAF964F0-F557-40C7-AD06-F0B4A6571A4F'
	), POSTACTION AS (
		SELECT * 
		FROM CmsPostAction 
		WHERE ModuleId = '8C0D1530-AB8F-40D0-922C-63C9A208778A' AND CategoryId = '95A464F6-6D97-4F9C-B6F3-2D840A5A884C' AND UserId = @USERID
	)
    -- Insert statements for procedure here
	SELECT M.Id, M.Code, M.Applicant, E.LocalName ApplicantName
		,M.DeptId, D.OrganizationName OrgName, D.PlantName, D.DeptName, D.SectName
		,M.ApplicationDate, M.ReImport, M.ReImportDate, ISNULL(M.Reason, '  ') Reason, M.FinishApplication, M.FinishReason, M.FinishDate
		,M.ApprovalKind, C.Name KindName
		,ISNULL(M.ApprovalLineJson, '') ApprovalLineJson
		,ISNULL(M.ApprovalLine, '') ApprovalLine, C.Name ApprovalStatusName, M.ApprovalStatus
		,M.NextApprover, N.LocalName NextApproverName
		,M.CreateDate, M.CreateUid, U.LocalName CreateName
		,M.ExportDate, M.ExportUid, S.Name GateName, G.Name ExportName
		,CASE WHEN I.ActionId IS NOT NULL THEN 1 ELSE 0 END ISVIEW

	FROM GATE.PassingGoodsMaster M
	LEFT JOIN HrEmpMaster E ON M.Applicant = E.Code
	LEFT JOIN HrDeptMasterFull D ON M.DeptId = D.Id
	LEFT JOIN CATE C ON M.ApprovalStatus = C.ID
	LEFT JOIN HrEmpMaster U ON M.CreateUid = U.Code
	LEFT JOIN HrEmpMaster N ON M.NextApprover = N.Code
	LEFT JOIN GATE.Guard G ON M.ExportUid = G.GuardId
	LEFT JOIN SysCategoryValue S ON G.Gate = S.ID
	LEFT JOIN POSTACTION I ON M.Id = I.MasterId
	WHERE 1=1
		AND DATEDIFF(DAY, @FROMDATE , M.CreateDate) >= 0
		AND DATEDIFF(DAY , M.CreateDate, @TODATE) >= 0
		AND M.DeleteUid IS NULL
		AND ((@APPROVESTATUS IS NULL)
			OR (@APPROVESTATUS IS NOT NULL AND M.ApprovalStatus = @APPROVESTATUS ))
		AND M.Temp = 0
	ORDER BY M.CreateDate DESC
END

GO
/****** Object:  StoredProcedure [GATE].[SP_PASSINGGOODS_GETDETAIL]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.11.20
-- Description:	LẤY LÊN DANH SÁCH VISITOR APPLICATION MASTER
-- =============================================
CREATE PROCEDURE [GATE].[SP_PASSINGGOODS_GETDETAIL]
	-- Add the parameters for the stored procedure here
	@ID INT = 228,
	@USERID VARCHAR(20) = 'vn55160524'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
	--KIỂM TRA XEM NGƯỜI ĐĂNG NHẬP ĐÃ XEM ĐƠN NÀY CHƯA?
	IF NOT EXISTS (SELECT 1 FROM CmsPostAction WHERE ModuleId = '8C0D1530-AB8F-40D0-922C-63C9A208778A' AND CategoryId = '95A464F6-6D97-4F9C-B6F3-2D840A5A884C' AND MasterId = @ID AND UserId = @USERID)
	BEGIN
		INSERT INTO CmsPostAction (ModuleId, CategoryId, MasterId, UserId, ActionDate)
		VALUES ('8C0D1530-AB8F-40D0-922C-63C9A208778A', '95A464F6-6D97-4F9C-B6F3-2D840A5A884C', @ID, @USERID, GETDATE())
	END

	DECLARE @ISRECALL BIT = 0
	
	DECLARE @APPLICATIONID INT, @CREAEUID VARCHAR(20), @CONFIRMDATE DATETIME, @FIRSTAPPROVER VARCHAR(20), @FIRSTAPPROVERSTATUS BIT, @NEXTAPPROVER VARCHAR(20)
	--LẤY RA THÔNG TIN CỦA ĐƠN
	SELECT @APPLICATIONID = 12, @CREAEUID = CreateUid, @CONFIRMDATE = ConfirmDate, @NEXTAPPROVER = NextApprover
	FROM GATE.PassingGoodsMaster WHERE Id = @ID
	--LẤY RA THÔNG TIN NGƯỜI ĐẦU TIÊN APPROVE
	SELECT TOP 1 @FIRSTAPPROVER = EmpId, @FIRSTAPPROVERSTATUS = IsApprove
	FROM EApproval.Approval 
	WHERE ApplicationId = @APPLICATIONID AND MasterId = @ID
	ORDER BY Seq

	--LẤY RA THÔNG TIN NGƯỜI HIỆN TẠI
	DECLARE @APPROVESTATUS BIT, @SEQ TINYINT
	SELECT @APPROVESTATUS = IsApprove, @SEQ = Seq 
	FROM EApproval.Approval 
	WHERE ApplicationId = @APPLICATIONID AND MasterId = @ID AND EmpId = @USERID

	--LẤY RA THÔNG TIN NGƯỜI APPROVE KẾ TIẾP
	DECLARE @NEXTAPPROVESTATUS BIT, @NEXTSEQ TINYINT
	SELECT @NEXTAPPROVESTATUS = IsApprove, @NEXTSEQ = Seq 
	FROM EApproval.Approval 
	WHERE ApplicationId = @APPLICATIONID AND MasterId = @ID AND EmpId = @NEXTAPPROVER 

	--NHỮNG TRƯỜNG HỢP ĐƯỢC PHÉP RECALL:
	--1. LÀ NGƯỜI TẠO ĐÃ CONFIRM VÀ NGƯỜI ĐẦU TIÊN CHƯA APPROVE
		--1.1 LÀ NGƯỜI TẠO:@USERID = CREATEUID
		--1.2 ĐÃ CONFIRM: CONFIRMDATE: IS NOT NULL
		--1.3 NGƯỜI ĐẦU TIÊN CHƯA APPROVE: @ISAPPROVE: NULL
	--2. LÀ NGƯỜI ĐÃ APPR RỒI, VÀ NGƯỜI TIẾP THEO APPR(@NEXTSEQ - @SEQ = 1) PHẢI CHƯA APPR
		--2.1 LÀ NGƯỜI ĐÃ APPROVE RỒI (ISAPPROVE = 1)
		--2.1 NGƯỜI NÀY VÀ NGƯỜI KẾ TIẾP PHẢI NẰM SÁT NHAU: @NEXTSEQ - @SEQ = 1
		--2.3 THẰNG KẾ TIẾP PHẢI CHƯA APPROVE: @NEXTAPPROVESTATUS = NULL

	IF (@USERID = @CREAEUID AND @CONFIRMDATE IS NOT NULL AND @FIRSTAPPROVERSTATUS IS NULL)
		SET @ISRECALL = 1
	IF @APPROVESTATUS = 1 AND @NEXTAPPROVESTATUS IS NULL AND (@NEXTSEQ - @SEQ = 1)
		SET @ISRECALL = 1


	;WITH CATE AS(
		SELECT ID, Name, SubCode 
		FROM SysCategoryValue 
		WHERE Category IN ('2EA2A6A8-0C9A-446A-BA6B-B5197D22A4B8'
							, '418D8192-A87B-4E78-9E46-07CC8FCD36D1'
							, '07643577-62D2-4AA3-83B6-148664A731EF'--PURPOSE
							, '509BA468-CA9B-4A65-9EFB-6E1C5CE977F1')-- GATE
							OR (Category = '054E0F62-4EFE-41E1-A18D-5C28A6531539' and ParentID = 'EAF964F0-F557-40C7-AD06-F0B4A6571A4F')
	)

	SELECT M.Id, M.Code, M.Applicant, E.LocalName ApplicantName
		,M.DeptId, D.OrganizationName OrgName, D.PlantName, D.DeptName, D.SectName
		,M.ApplicationDate, M.ReImport, M.ReImportDate, M.Reason, M.FinishApplication, M.FinishReason, M.FinishDate
		,M.ApprovalKind, C.Name KindName
		,ISNULL(M.ApprovalLineJson, '') ApprovalLineJson
		,ISNULL(M.ApprovalLine, '') ApprovalLine, C.Name ApprovalStatusName, M.ApprovalStatus
		,M.NextApprover, N.LocalName NextApproverName
		,M.CreateDate, M.CreateUid, U.LocalName CreateName
		,@ISRECALL IsRecall
		,M.ExportDate, M.ExportUid, S.Name GateName, G.Name ExportName

	FROM GATE.PassingGoodsMaster M
	LEFT JOIN HrEmpMaster E ON M.Applicant = E.Code
	LEFT JOIN HrDeptMasterFull D ON M.DeptId = D.Id
	LEFT JOIN CATE C ON M.ApprovalStatus = C.ID
	LEFT JOIN HrEmpMaster U ON M.CreateUid = U.Code
	LEFT JOIN HrEmpMaster N ON M.NextApprover = N.Code
	LEFT JOIN GATE.Guard G ON M.ExportUid = G.GuardId
	LEFT JOIN SysCategoryValue S ON G.Gate = S.ID
	WHERE M.Id = @ID		
	ORDER BY M.CreateDate DESC
END

GO
/****** Object:  StoredProcedure [GATE].[SP_PASSINGGOODS_INSERT]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.25
-- Description: LƯU THÔNG TIN PASSING GOODS
-- =============================================
CREATE PROCEDURE [GATE].[SP_PASSINGGOODS_INSERT]
	-- Add the parameters for the stored procedure here
	@APPLICANT VARCHAR(20),
	@DEPTID INT,
	@APPLICATIONDATE DATE,
	@REIMPORT BIT,
	@REIMPORTDATE DATE,
	@REASON NVARCHAR(500),
	@USERID VARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--ĐẾM SỐ LƯỢNG ĐƠN THEO THÁNG, CHỈ TÍNH NHỮNG CÁI NÀO KHÔNG PHẢI LÀ ĐƠN LƯU TẠM
	DECLARE @COUNT INT = (SELECT COUNT(1) FROM GATE.PassingGoodsMaster WHERE DATEDIFF(MONTH, CreateDate, GETDATE()) = 0) + 1

	DECLARE @CODE VARCHAR(20)
	SET @CODE = (SELECT Code + '-' + CONVERT(VARCHAR(6), CONVERT(DATETIME, GETDATE()), 112) + '-' + REPLICATE('0', 3 - LEN(@COUNT)) + CONVERT(VARCHAR(3), @COUNT)
				FROM EApproval.ApplicationConfig WHERE Id = 12)

    -- Insert statements for procedure here
	INSERT INTO GATE.PassingGoodsMaster(CODE, Applicant, DeptId, ApplicationDate, ReImport, 
										ReImportDate, Reason, Temp, CreateDate, CreateUid)
	VALUES(@CODE, @APPLICANT, @DEPTID, @APPLICATIONDATE, @REIMPORT, @REIMPORTDATE, @REASON, 1, GETDATE(), @USERID)

	DECLARE @RESULT INT = SCOPE_IDENTITY()
	SELECT @RESULT
END

GO
/****** Object:  StoredProcedure [GATE].[SP_PASSINGGOODS_RECALL]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20170830
-- Description:	RECALL LẠI ĐƠN VỪA APPROVE
-- =============================================
CREATE PROCEDURE [GATE].[SP_PASSINGGOODS_RECALL]
	@MasterId int = 42,
	@ApplicationId int = 12,
	@UserId varchar(20) = 'vn55141027'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @NEXTAPPROVER VARCHAR(20)
	SELECT @NEXTAPPROVER = NextApprover FROM GATE.PassingGoodsMaster WHERE Id = @MasterId

	--KIỂM TRA XEM NGƯỜI NÀY ĐÃ APPROVE CHƯA, CHƯA APPROVE THÌ MỚI CHO RECALL
	IF EXISTS (SELECT 1 FROM EApproval.Approval WHERE ApplicationId = @ApplicationId AND MasterId = @MasterId AND EmpId = @NEXTAPPROVER AND IsApprove IS NULL)
	BEGIN
		--select * from EApproval.Approval WHERE ApplicationId = @ApplicationId AND MasterId = @MasterId  AND EmpId = @UserId
		UPDATE EApproval.Approval 
		SET IsApprove = NULL, DateApprove = NULL, Comment = NULL
		WHERE ApplicationId = @ApplicationId AND MasterId = @MasterId AND EmpId = @UserId --AND IsApprove IS NULL

		--CẬP NHẬT BÊN BẢNG MASTER NỮA
		UPDATE GATE.PassingGoodsMaster SET NextApprover = @UserId WHERE Id = @MasterId
	END
END



GO
/****** Object:  StoredProcedure [GATE].[SP_PASSINGGOODS_UPDATE]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.25
-- Description: LƯU THÔNG TIN PASSING GOODS
-- =============================================
CREATE PROCEDURE [GATE].[SP_PASSINGGOODS_UPDATE]
	-- Add the parameters for the stored procedure here
	@ID INT,
	@APPLICANT VARCHAR(20),
	@DEPTID INT,
	@APPLICATIONDATE DATE,
	@REIMPORT BIT,
	@REIMPORTDATE DATE,
	@REASON NVARCHAR(500),
	@USERID VARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	UPDATE GATE.PassingGoodsMaster
	SET Applicant = @APPLICANT,
		DeptId = @DEPTID,
		ApplicationDate = @APPLICATIONDATE,
		ReImport = @REIMPORT,
		ReImportDate = @REIMPORTDATE,
		Reason = @REASON,
		UpdateDate = GETDATE(),
		UpdateUId = @USERID
	WHERE ID = @ID
END

GO
/****** Object:  StoredProcedure [GATE].[SP_PASSINGGOODS_UPDATE_ALLDATA]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.03
-- Description:	CẬP NHẬT LẠI TẤT CẢ DỮ LIỆU SAU KHI NGƯỜI DÙNG NHẤN SAVE
-- ==========================================================================================
CREATE PROCEDURE [GATE].[SP_PASSINGGOODS_UPDATE_ALLDATA]
	-- Add the parameters for the stored procedure here
	@Id int = 126,
	@ApplicationId int = 12,
	@ApprovalLine nvarchar(2000) = 'vn55111704_vd52170013|Võ Công Danh > Lê Huỳnh Duy|E408D53D-6E62-4D63-A3D4-CD3EA9A14D36_E408D53D-6E62-4D63-A3D4-CD3EA9A14D36',
	@ApprovalLineJson nvarchar(4000) = '[{"EmpId":"vn55111704","Name":"Võ Công Danh","DeptFullName":"Hyosung Vietnam > Main Office > IT > Information System","ApproverType":"E408D53D-6E62-4D63-A3D4-CD3EA9A14D36","ApproverTypeName":"Approver","Seq":1},{"EmpId":"vd52170013","Name":"Lê Huỳnh Duy","DeptFullName":"Hyosung Dong Nai > Main Office > IT","ApproverType":"E408D53D-6E62-4D63-A3D4-CD3EA9A14D36","ApproverTypeName":"Approver","Seq":2}]|[{"EmpId":"vn55110755","EmpName":"Đỗ Thị Hồng Chăm"}]',
	@UserId varchar(20) = 'vn55160524'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	--LẤY RA DỮ LIỆU THÔ CỦA APPROVAL LINE
	DECLARE @TB_RAW TABLE(Id int, Content varchar(500))
	INSERT INTO @TB_RAW
	SELECT * FROM FN_SplitString(@ApprovalLine,'|')

	--TÁCH MÃ NHÂN VIÊN TRƯỚC
	DECLARE @TB_RAW_EMPID TABLE(Id INT, EmpId VARCHAR(20))
	INSERT INTO @TB_RAW_EMPID 
	SELECT * FROM FN_SplitString((SELECT Content FROM @TB_RAW WHERE Id = 1), '_')

	--TÁCH LOẠI NGƯỜI APPROVE
	DECLARE @TB_RAW_APPROVETYPE TABLE(Id INT, [Type] UNIQUEIDENTIFIER)
	INSERT INTO @TB_RAW_APPROVETYPE 
	SELECT * FROM FN_SplitString((SELECT Content FROM @TB_RAW WHERE Id = 3), '_')

	DECLARE @NextApprover VARCHAR(20)
	SET @NextApprover = (SELECT EmpId FROM @TB_RAW_EMPID WHERE Id = 1)

	--XÓA ĐI DỮ LIỆU CŨ
	DELETE EApproval.ApprovalHistory
	WHERE ApplicationId = @ApplicationId AND MasterId = @Id

	DELETE EApproval.Approval
	WHERE ApplicationId = @ApplicationId AND MasterId = @Id

	--THÊM VÀO BẢNG APPROVAL HISTORY
	INSERT INTO EApproval.ApprovalHistory
	SELECT @ApprovalLine, @ApprovalLineJson, @ApplicationId, @Id, @UserId, GETDATE()			

	--THÊM VÀO BẢNG APPROVAL
	INSERT INTO EApproval.Approval(ApplicationId, MasterId, EmpId, ApproverType, Seq)
	SELECT @ApplicationId, @Id, A.EmpId, B.Type, A.Id
	FROM @TB_RAW_EMPID A
	LEFT JOIN @TB_RAW_APPROVETYPE B ON A.Id = B.Id

	UPDATE GATE.PassingGoodsMaster 
	SET Temp = 0, NextApprover = @NextApprover, ApprovalStatus = '9C817780-2079-4417-B87B-B7E537BBAE8A', 
		ApprovalKind = '2600C4A7-CFB3-4E08-A08D-EDF0C1D99A71',--TẠM THỜI CHỈ LÀM CHỨC NĂNG ORDER TRƯỚC
		ApprovalLine = @ApprovalLine,
		ApprovalLineJson = @ApprovalLineJson
	WHERE Id = @Id
	
END

GO
/****** Object:  StoredProcedure [GATE].[SP_REPORT_CHECKIN_NOTOUT]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2018.05.23
-- Description:	DANH SACH NHUNG NGUOI CHECKIN NHUNG KHONG CHECKOUT
-- =================================================================
CREATE PROCEDURE [GATE].[SP_REPORT_CHECKIN_NOTOUT]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @DATE_09 DATETIME = CONVERT(DATETIME, CONVERT(VARCHAR, DATEADD(DAY, -1, GETDATE()), 102) + ' 08:59')
	DECLARE @EMAIL VARCHAR(1000) = 'khoa55170639@hyosung.com;huyen52170006@hyosung.com;phuong52170016@hyosung.com;nhat55180910@hyosung.com;anh55171649@hyosung.com'
		, @CCBCC VARCHAR(1000) = 'nghia55160524@hyosung.com', @BODY NVARCHAR(MAX) = ''
		, @SUBJECT NVARCHAR(MAX) = N'[Hyosung Portal] Danh sách khách thăm CHECK IN nhưng không CHECK OUT'
	DECLARE @TBHEADER NVARCHAR(MAX) = 
			N'<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=0 style="width:948.0pt;margin-left:-.15pt;border-collapse:collapse">
				<tr style="height:15.0pt">
					<td width=37 nowrap valign=bottom style="width:28.0pt;border:solid windowtext 1.0pt;background:#9BBB59;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
						<p class=MsoNormal><b><span style="color:white">STT<o:p></o:p></span></b></p>
					</td>
					<td width=169 nowrap valign=bottom style="width:127.0pt;border:solid windowtext 1.0pt;border-left:none;background:#9BBB59;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
						<p class=MsoNormal><b><span style="color:white">Mã đơn<o:p></o:p></span></b></p>
					</td>
					<td width=77 nowrap valign=bottom style="width:53.0pt;border:solid windowtext 1.0pt;border-left:none;background:#9BBB59;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
						<p class=MsoNormal><b><span style="color:white">CMND<o:p></o:p></span></b></p>
					</td>
					<td width=168 nowrap valign=bottom style="width:1.75in;border:solid windowtext 1.0pt;border-left:none;background:#9BBB59;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
						<p class=MsoNormal><b><span style="color:white">Tên<o:p></o:p></span></b></p>
					</td>
					<td width=75 nowrap valign=bottom style="width:51.0pt;border:solid windowtext 1.0pt;border-left:none;background:#9BBB59;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
						<p class=MsoNormal><b><span style="color:white">Từ ngày<o:p></o:p></span></b></p>
					</td>
					<td width=75 nowrap valign=bottom style="width:51.0pt;border:solid windowtext 1.0pt;border-left:none;background:#9BBB59;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
						<p class=MsoNormal><b><span style="color:white">Đến ngày<o:p></o:p></span></b></p>
					</td>
					<td width=227 nowrap valign=bottom style="width:170.0pt;border:solid windowtext 1.0pt;border-left:none;background:#9BBB59;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
						<p class=MsoNormal><b><span style="color:white">Tên vendor<o:p></o:p></span></b></p>
					</td>
					<td width=113 nowrap valign=bottom style="width:85.0pt;border:solid windowtext 1.0pt;border-left:none;background:#9BBB59;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
						<p class=MsoNormal><b><span style="color:white">Ngày làm việc<o:p></o:p></span></b></p>
					</td>
					<td width=64 nowrap valign=bottom style="width:48.0pt;border:solid windowtext 1.0pt;border-left:none;background:#9BBB59;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
						<p class=MsoNormal><b><span style="color:white">Giờ vào<o:p></o:p></span></b></p>
					</td>
					<td width=64 nowrap valign=bottom style="width:48.0pt;border:solid windowtext 1.0pt;border-left:none;background:#9BBB59;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
						<p class=MsoNormal><b><span style="color:white">Giờ ra<o:p></o:p></span></b></p>
					</td>
					<td width=151 nowrap valign=bottom style="width:113.0pt;border:solid windowtext 1.0pt;border-left:none;background:#9BBB59;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
						<p class=MsoNormal><b><span style="color:white">Cổng vào<o:p></o:p></span></b></p>
					</td>
					<td width=64 nowrap valign=bottom style="width:48.0pt;border:solid windowtext 1.0pt;border-left:none;background:#9BBB59;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
						<p class=MsoNormal><b><span style="color:white">Ghi chú<o:p></o:p></span></b></p>
					</td>
				</tr>'
	DECLARE @TBFOOTER NVARCHAR(MAX) = '</table>'


	;WITH 
	TB_CHECKIN AS (
					SELECT ROW_NUMBER() OVER(PARTITION BY VISITORID ORDER BY CREATEDATE) RowNum, *
					FROM GATE.VISITORWORKINGDAILY 
					WHERE DATEDIFF(HOUR, CreateDate, @DATE_09) <= 23 AND DATEDIFF(HOUR, CreateDate, @DATE_09) >= 0 AND IsCheckIn = 1
					--ORDER BY CreateDate DESC
					),
	TB_CHECKOUT AS (
				SELECT ROW_NUMBER() OVER(PARTITION BY VISITORID ORDER BY CREATEDATE) RowNum, *
				FROM GATE.VISITORWORKINGDAILY 
				WHERE DATEDIFF(HOUR, DATEADD(DAY, -1, @DATE_09), CreateDate) >= 0 AND IsCheckIn = 0
				--ORDER BY CreateDate DESC
	),
	CATE AS (
		SELECT * FROM SysCategoryValue WHERE Category = '07643577-62D2-4AA3-83B6-148664A731EF'
	)

	SELECT @BODY =
	STUFF ((SELECT '' + '
		    <tr style="height:15.0pt">
				<td width=37 nowrap valign=bottom style="width:28.0pt;border:solid windowtext 1.0pt;border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
					<p class=MsoNormal align=right style="text-align:right"><span style="color:black">'+CONVERT(VARCHAR, ROWNUM)+'<o:p></o:p></span></p>
				</td>
				<td width=169 nowrap valign=bottom style="width:127.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
					<p class=MsoNormal><span style="color:black">'+Code+'<o:p></o:p></span></p>
				</td>
				<td width=77 nowrap valign=bottom style="width:53.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
					<p class=MsoNormal align=right style="text-align:right"><span style="color:black">'+IdentityCard+'<o:p></o:p></span></p>
				</td>
				<td width=168 nowrap valign=bottom style="width:1.75in;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
					<p class=MsoNormal><span style="color:black">'+FullName+'<o:p></o:p></span></p>
				</td>
				<td width=75 nowrap valign=bottom style="width:51.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
					<p class=MsoNormal align=right style="text-align:right"><span style="color:black">'+CONVERT(VARCHAR, FromDate, 102)+'<o:p></o:p></span></p>
				</td>
				<td width=75 nowrap valign=bottom style="width:51.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
					<p class=MsoNormal align=right style="text-align:right"><span style="color:black">'+CONVERT(VARCHAR, ToDate, 102)+'<o:p></o:p></span></p>
				</td>
				<td width=227 nowrap valign=bottom style="width:170.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
					<p class=MsoNormal><span style="color:black">'+CompanyName+'<o:p></o:p></span></p>
				</td>
				<td width=113 nowrap valign=bottom style="width:85.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
					<p class=MsoNormal align=right style="text-align:right"><span style="color:black">'+CONVERT(VARCHAR, WorkDate, 102)+'<o:p></o:p></span></p>
				</td>
				<td width=64 nowrap valign=bottom style="width:48.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
					<p class=MsoNormal align=right style="text-align:right"><span style="color:black">'+[IN]+'<o:p></o:p></span></p>
				</td>
				<td width=64 nowrap valign=bottom style="width:48.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
					<p class=MsoNormal><span style="color:black">'+[OUT]+'<o:p></o:p></span></p>
				</td>
				<td width=151 nowrap valign=bottom style="width:113.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
					<p class=MsoNormal><span style="color:black">'+GateIn+'<o:p></o:p></span></p>
				</td>
				<td width=64 nowrap valign=bottom style="width:48.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
					<p class=MsoNormal><span style="color:black">'+RemarkIn+'<o:p></o:p></span></p>
				</td>
			</tr>'
	FROM(
		SELECT ROW_NUMBER() OVER(ORDER BY A.CreateDate) ROWNUM
			, F.CODE, A.WorkDate, A.VisitorId, C.IdentityCard, C.FullName, C.FromDate, C.ToDate
			, G.CompanyName
			, A.ScanTime [IN], ISNULL(B.ScanTime, '') [OUT], D.Name GateIn, ISNULL(A.Remark, '') RemarkIn
			, E.Name GateOut, B.Remark RemarkOut, A.CreateDate CreateDateIn, B.CreateDate CreateDateOut
		FROM TB_CHECKIN A
		LEFT JOIN TB_CHECKOUT B ON A.VisitorId = B.VisitorId AND A.RowNum = B.RowNum
		LEFT JOIN GATE.VisitorApplicationDetailPerson C ON A.VisitorId = C.Id
		LEFT JOIN CATE D ON A.GateId = D.ID
		LEFT JOIN CATE E ON B.GateId = E.ID
		LEFT JOIN GATE.VisitorApplicationMaster F ON C.ApplicationMaster = F.Id
		LEFT JOIN GATE.Vendor G ON F.Vendor = G.Id
		WHERE B.ScanTime IS NULL
		--ORDER BY A.CreateDate DESC
	)SOURCE
	FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)') , 1, 1, '') 

	SET @BODY = @TBHEADER + @BODY + @TBFOOTER

	IF ISNULL(@BODY, '') = ''
		RETURN;
	
	EXEC msdb.dbo.sp_send_dbmail
		@profile_name = 'Hyosung Portal',
		@recipients = @EMAIL,
		@copy_recipients = @CCBCC,
		@body = @BODY,
		@subject = @subject,
		@body_format = 'HTML';

END

GO
/****** Object:  StoredProcedure [GATE].[SP_REPORT_VEHICLE]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2018.05.24
-- Description:	DANH SACH XE CHECKIN-OUT
-- =================================================================
CREATE PROCEDURE [GATE].[SP_REPORT_VEHICLE]
	-- Add the parameters for the stored procedure here
	@ApplicationType int = NULL,
	@FromDate Date = '20180401',
	@ToDate Date = '20180525',
	@WorkDateFrom Date = '20180401',
	@WorkDateTo Date = '20180525',
	@Status int = NULL--1: no enter, 2: in-out, 3: in

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	;WITH 
	TB_VISITOR AS (
					SELECT * 
					FROM GATE.VisitorApplicationDetailVehicle
					WHERE 1=1
						--AND DATEDIFF(DAY, FromDate, @WorkDateFrom) <= 0 AND DATEDIFF(DAY, ToDate, @WorkDateTo) >= 0 
						AND DeleteUid IS NULL
	),
	TB_CHECKIN AS (
					SELECT ROW_NUMBER() OVER(PARTITION BY VehicleId ORDER BY CREATEDATE) RowNum, *
					FROM GATE.VehicleCheckingDaily 
					WHERE DATEDIFF(DAY, CreateDate, @WorkDateFrom) <= 0 AND DATEDIFF(DAY, CreateDate, @WorkDateTo) >= 0 
						AND IsCheckIn = 1
					--ORDER BY CreateDate DESC
					),
	TB_CHECKOUT AS (
				SELECT ROW_NUMBER() OVER(PARTITION BY VehicleId ORDER BY CREATEDATE) RowNum, *
				FROM GATE.VehicleCheckingDaily 
				WHERE DATEDIFF(HOUR, @WorkDateFrom, CreateDate) >= 0 AND IsCheckIn = 0
				--ORDER BY CreateDate DESC
	),
	CATE AS (
		SELECT * FROM SysCategoryValue WHERE Category = '07643577-62D2-4AA3-83B6-148664A731EF'
	)

	SELECT F.CODE, A.WorkDate WorkDateIn, A.VehicleCard, C.DriverPlate, C.FromDate, C.ToDate
		, G.CompanyName
		, A.ScanTime [IN], ISNULL(B.ScanTime, '') [OUT], D.Name GateIn, ISNULL(A.Remark, '') RemarkIn
		, E.Name GateOut, B.Remark RemarkOut, B.WorkDate WorkDateOut
		--, A.CreateDate CreateDateIn, B.CreateDate CreateDateOut
		, F.CreateDate, F.Applicant, H.LocalName ApplicantName
		, I.OrganizationName OrgName, I.PlantName, I.DeptName, I.SectName
		, CASE WHEN A.ScanTime IS NULL AND B.ScanTime IS NULL THEN 'NO ENTER'
			WHEN A.ScanTime IS NOT NULL AND B.ScanTime IS NULL THEN 'IN'
			WHEN A.ScanTime IS NOT NULL AND B.ScanTime IS NOT NULL THEN 'IN-OUT' END [Status]
	FROM TB_VISITOR C
	INNER JOIN TB_CHECKIN A ON C.Id = A.VehicleId
	LEFT JOIN TB_CHECKOUT B ON A.VehicleId = B.VehicleId AND A.RowNum = B.RowNum
	LEFT JOIN CATE D ON A.GateId = D.ID
	LEFT JOIN CATE E ON B.GateId = E.ID
	INNER JOIN GATE.VisitorApplicationMaster F ON C.ApplicationMaster = F.Id  AND (@ApplicationType IS NULL OR F.ApplicationType = @ApplicationType) AND F.ApprovalStatus = '00F2EC64-CC9B-4FCA-AB4C-B37961EFAD53' AND F.DeleteUid IS NULL
	LEFT JOIN GATE.Vendor G ON F.Vendor = G.Id
	LEFT JOIN HrEmpMaster H ON F.Applicant = H.Code
	LEFT JOIN HrDeptMasterFull I ON H.DeptCode = I.Id
	WHERE 1=1
		--AND (@Status IS NULL OR (@Status = 1 AND A.ScanTime IS NULL AND B.ScanTime IS NULL)
		--	OR (@Status = 2 AND A.ScanTime IS NOT NULL AND B.ScanTime IS NOT NULL)
		--	OR (@Status = 3 AND A.ScanTime IS NOT NULL AND B.ScanTime IS NULL)
		--	)
	ORDER BY C.CreateDate DESC, C.DriverPlate
	

END

GO
/****** Object:  StoredProcedure [GATE].[SP_REPORT_VISITOR]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2018.05.24
-- Description:	DANH SACH KHACH CHECKIN-OUT
-- =================================================================
CREATE PROCEDURE [GATE].[SP_REPORT_VISITOR]
	-- Add the parameters for the stored procedure here
	@ApplicationType int = NULL,
	@FromDate Date = '20180528',
	@ToDate Date = '20180528',
	@WorkDateFrom Date = '20180613',
	@WorkDateTo Date = '20180613',
	@Status int = NULL--1: no enter, 2: in-out, 3: in

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	;WITH 
	
	TB_CHECKIN AS (
					SELECT ROW_NUMBER() OVER(PARTITION BY VISITORID ORDER BY CREATEDATE) RowNum, *
					FROM GATE.VISITORWORKINGDAILY 
					WHERE DATEDIFF(DAY, CreateDate, @WorkDateFrom) <= 0 AND DATEDIFF(DAY, CreateDate, @WorkDateTo) >= 0 
						AND IsCheckIn = 1
					--ORDER BY CreateDate DESC
					),
	TB_CHECKOUT AS (
				SELECT ROW_NUMBER() OVER(PARTITION BY VISITORID ORDER BY CREATEDATE) RowNum, *
				FROM GATE.VISITORWORKINGDAILY 
				WHERE DATEDIFF(HOUR, @WorkDateFrom, CreateDate) >= 0 
					AND IsCheckIn = 0
				--ORDER BY CreateDate DESC
	),
	TB_VISITOR AS (
					SELECT * 
					FROM GATE.VisitorApplicationDetailPerson
					WHERE 1=1
						--AND DATEDIFF(DAY, @FromDate, CreateDate) >= 0 AND DATEDIFF(DAY, CreateDate, @ToDate) >= 0
						--AND DATEDIFF(DAY, FromDate, @WorkDateFrom) <= 0 AND DATEDIFF(DAY, ToDate, @WorkDateTo) >= 0 
						AND DeleteUid IS NULL
	),
	CATE AS (
		SELECT * FROM SysCategoryValue WHERE Category = '07643577-62D2-4AA3-83B6-148664A731EF'
	)

	SELECT F.CODE, A.WorkDate WorkDateIn, A.VisitorId, C.IdentityCard, C.FullName, C.FromDate, C.ToDate, A.VisitorCard
		, G.CompanyName, C.PhoneNumber
		, A.ScanTime [IN], ISNULL(B.ScanTime, '') [OUT], D.Name GateIn, ISNULL(A.Remark, '') RemarkIn
		, E.Name GateOut, B.Remark RemarkOut, B.WorkDate WorkDateOut
		--, A.CreateDate CreateDateIn, B.CreateDate CreateDateOut
		, F.CreateDate, F.Applicant, H.LocalName ApplicantName
		, I.OrganizationName OrgName, I.PlantName, I.DeptName, I.SectName
		, CASE WHEN A.ScanTime IS NULL AND B.ScanTime IS NULL THEN 'NO ENTER'
			WHEN A.ScanTime IS NOT NULL AND B.ScanTime IS NULL THEN 'IN'
			WHEN A.ScanTime IS NOT NULL AND B.ScanTime IS NOT NULL THEN 'IN-OUT' END [Status]
	FROM TB_CHECKIN A
	--INNER JOIN TB_CHECKIN A ON C.Id = A.VisitorId
	LEFT JOIN TB_VISITOR C ON C.Id = A.VisitorId
	LEFT JOIN TB_CHECKOUT B ON A.VisitorId = B.VisitorId AND A.RowNum = B.RowNum
	LEFT JOIN CATE D ON A.GateId = D.ID
	LEFT JOIN CATE E ON B.GateId = E.ID
	INNER JOIN GATE.VisitorApplicationMaster F ON C.ApplicationMaster = F.Id  AND (@ApplicationType IS NULL OR F.ApplicationType = @ApplicationType) AND F.ApprovalStatus = '00F2EC64-CC9B-4FCA-AB4C-B37961EFAD53' --AND F.DeleteUid IS NULL
	LEFT JOIN GATE.Vendor G ON F.Vendor = G.Id
	LEFT JOIN HrEmpMaster H ON F.Applicant = H.Code
	LEFT JOIN HrDeptMasterFull I ON H.DeptCode = I.Id
	WHERE 1=1
		--AND (@Status IS NULL OR (@Status = 1 AND A.ScanTime IS NULL AND B.ScanTime IS NULL)
		--	OR (@Status = 2 AND A.ScanTime IS NOT NULL AND B.ScanTime IS NOT NULL)
		--	OR (@Status = 3 AND A.ScanTime IS NOT NULL AND B.ScanTime IS NULL)
		--	)
	ORDER BY C.CreateDate DESC, C.IdentityCard
	

END

GO
/****** Object:  StoredProcedure [GATE].[SP_VEHICLE_CHECKINGDAILY_GET]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.17
-- Description:	MOOD LIKE SHIT
-- =============================================
CREATE PROCEDURE [GATE].[SP_VEHICLE_CHECKINGDAILY_GET]
	-- Add the parameters for the stored procedure here
	@ApplicationMasterId int = NULL,
	@Workdate date = '2018.03.12',
	@IsCheckOut bit = 1,
	@GateId varchar(36) = NULL,
	@ApplicationType int = 8,

	@UserId varchar(20) = null,
	@ApprovalStatus varchar(36) = '00F2EC64-CC9B-4FCA-AB4C-B37961EFAD53'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	WITH DETAIL AS (
		SELECT COUNT(1) NumCheck, VehicleId
		FROM GATE.VehicleCheckingDaily
		GROUP BY VehicleId
	)
    -- Insert statements for procedure here
	SELECT A.Id Id, A.DriverPlate, A.VehicleType, T.Name VehicleTypeName, A.DriverName, A.PhoneDriver
		,A.FromDate, A.ToDate
		,M.Gate GateRegis--, R.Name GateNameRegis		
		,M.Vendor, D.CompanyName, D.TermsOfUse
		
		,ISNULL(CASE WHEN IsCheckIn = 1 THEN W.VehicleCard ELSE NULL END, A.VehicleCard) VehicleCard
		,CASE IsCheckIn WHEN 1 THEN W.ChangeDriver ELSE '' END ChangeDriver, IsCheckIn

		,CASE WHEN ISNULL(M.Gate,'') = '' THEN '' ELSE 
			STUFF ((SELECT ', ' + G.Name+' '
					FROM SysCategoryValue G
					INNER JOIN (SELECT SplitItem, id FROM FN_SplitString(M.Gate,'|')) SP ON G.Id = SplitItem
					ORDER BY SP.id
					FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)') , 1, 1, '')
				END AS  GateNameRegis
		,L.NumCheck, M.Code
	FROM GATE.VisitorApplicationDetailVehicle A
	LEFT JOIN GATE.VisitorApplicationMaster M ON A.ApplicationMaster = M.Id		
	LEFT JOIN SysCategoryValue R ON M.Gate = R.ID	

	OUTER APPLY (
		SELECT TOP 1 VehicleId, VehicleCard, GateId, IsCheckIn, ChangeDriver
		FROM GATE.VehicleCheckingDaily 
		WHERE A.Id = VehicleId --AND ApplicationType = M.ApplicationType --AND DATEDIFF(DAY, WorkDate, @Workdate) = 0
		ORDER BY CreateDate DESC
	) W 
	LEFT JOIN SysCategoryValue G ON W.GateId = G.ID

	LEFT JOIN SysCategoryValue T ON A.VehicleType = T.ID

	LEFT JOIN GATE.Vendor D ON M.Vendor = D.Id
	LEFT JOIN DETAIL L ON A.Id = L.VehicleId
	WHERE (@ApplicationMasterId IS NULL OR A.ApplicationMaster = @ApplicationMasterId)
		AND (@Workdate IS NULL OR (DATEDIFF(DAY, @Workdate , A.FromDate) <= 0 AND DATEDIFF(DAY , A.ToDate, @Workdate) <= 0))
		AND (@GateId IS NULL OR M.Gate LIKE '%' + @GateId + '%')
		AND M.ApprovalStatus = ISNULL(@ApprovalStatus, '00F2EC64-CC9B-4FCA-AB4C-B37961EFAD53')
		AND (@UserId IS NULL OR M.CreateUid = @UserId OR M.ApprovalLine LIKE '%' + @USERID + '%')
		AND A.DeleteUid IS NULL
		AND M.DeleteUid IS NULL
	ORDER BY M.CreateDate DESC
END

GO
/****** Object:  StoredProcedure [GATE].[SP_VEHICLE_CHECKINGDAILY_GET_DETAIL]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.17
-- Description:	MOOD LIKE SHIT
-- =============================================
CREATE PROCEDURE [GATE].[SP_VEHICLE_CHECKINGDAILY_GET_DETAIL]
	-- Add the parameters for the stored procedure here
	@Vehicle int = 217
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT V.Id, V.VehicleId, ScanTime, IsCheckIn, GateId, V.Remark, VehicleCard, V.CreateUid 
		, C.Name GateName, G.Name CreateName, V.CreateDate
		, CASE IsCheckIn WHEN  1 THEN 'IN' WHEN 0 THEN 'OUT' ELSE '' END IsCheckInName
		, V.WorkDate, V.ChangeDriver
	FROM GATE.VehicleCheckingDaily V
	LEFT JOIN SysCategoryValue C ON V.GateId = C.ID
	LEFT JOIN GATE.Guard G ON V.CreateUid = G.GuardId  AND G.DeleteUid IS NULL
	WHERE VehicleId = @Vehicle
END

GO
/****** Object:  StoredProcedure [GATE].[SP_VEHICLE_CHECKINGDAILY_INSERT]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.17
-- Description:	MOOD LIKE SHIT
-- =============================================
CREATE PROCEDURE [GATE].[SP_VEHICLE_CHECKINGDAILY_INSERT]
	-- Add the parameters for the stored procedure here
	@VehicleId int, 
	@UserId varchar(20),
	@VehicleCard varchar(15),
	@Remark nvarchar(500),
	@IsCheckIn bit,
	@NewDriver nvarchar(200)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @GATEID UNIQUEIDENTIFIER = (SELECT TOP 1 Gate FROM GATE.Guard WHERE GuardId = @UserId AND DeleteUid IS NULL)

	INSERT INTO GATE.VehicleCheckingDaily(VehicleId, WorkDate, ScanTime, IsCheckIn, GateId, Remark, VehicleCard, CreateUid, CreateDate, ChangeDriver)
	VALUES(@VehicleId, GETDATE(), CONVERT(VARCHAR(5), GETDATE(), 108), @IsCheckIn, @GATEID, @Remark , @VehicleCard, @UserId, GETDATE(), @NewDriver)
	
END

GO
/****** Object:  StoredProcedure [GATE].[SP_VEHICLE_GET_IN]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2018/04/07
-- Description:	LẤY LÊN NHỮNG CHIẾC XE ĐÃ ĐI VÀO
-- =============================================
CREATE PROCEDURE [GATE].[SP_VEHICLE_GET_IN]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	WITH TB_TEMP AS (
		SELECT ROW_NUMBER() OVER (PARTITION BY VehicleId ORDER BY CreateDate DESC) NUM, Id, VehicleId, IsCheckIn, ChangeDriver
		FROM GATE.VehicleCheckingDaily V
	)

	SELECT V.VehicleId, D.DriverPlate, ISNULL(V.ChangeDriver, D.DriverName) DriverName, WorkDate, ScanTime
	FROM GATE.VehicleCheckingDaily V
	INNER JOIN TB_TEMP T ON V.Id = T.Id AND NUM = 1
	LEFT JOIN GATE.VisitorApplicationDetailVehicle D ON V.VehicleId = D.Id
	WHERE V.IsCheckIn = 1
	ORDER BY V.CreateDate DESC
END

GO
/****** Object:  StoredProcedure [GATE].[SP_VEHICLE_SENDMAIL]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2018.07.05
-- Description:	GỬI MAIL THẺ KHÁCH VÀ XE
-- =============================================
CREATE PROCEDURE [GATE].[SP_VEHICLE_SENDMAIL]
	-- Add the parameters for the stored procedure here
	@MASTERID INT = 3321,
	@UserId varchar(20) = 'VN55160524',
	@Type int = 1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @EMAIL VARCHAR(1000) = '', @CCBCC VARCHAR(1000), @BODY NVARCHAR(MAX) = '', @SUBJECT NVARCHAR(MAX) = '', @ATTACHMENT NVARCHAR(1000)

	SET @ATTACHMENT = 'D:\www\ForgetCardTest\Resource\Template\' +  CASE @Type WHEN 1 THEN 'P Waste Template.xlsx'
																				WHEN 2 THEN 'P Support Template.xlsx'
																				WHEN 3 THEN 'P Material Template.xlsx'
																				WHEN 4 THEN 'P Finished Template.xlsx'
																				WHEN 5 THEN 'P Contruction Template.xlsx' END

	DECLARE @TBBODY NVARCHAR(MAX) = '<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=0 style="width:665.75pt;margin-left:-.15pt;border-collapse:collapse">
										<tr style="height:15.0pt">
											<td width=126 nowrap valign=bottom style="width:94.25pt;border:solid windowtext 1.0pt;background:#70AD47;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
												<p class=MsoNormal><b><span style="color:white">Vehicle Card<o:p></o:p></span></b></p>
											</td>
											<td width=138 nowrap valign=bottom style="width:103.5pt;border:solid windowtext 1.0pt;border-left:none;background:#70AD47;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
												<p class=MsoNormal><b><span style="color:white">Vehicle Plate<o:p></o:p></span></b></p>
											</td>
											<td width=198 nowrap valign=bottom style="width:148.5pt;border:solid windowtext 1.0pt;border-left:none;background:#70AD47;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
												<p class=MsoNormal><b><span style="color:white">Vendor Name<o:p></o:p></span></b></p>
											</td>
											<td width=198 nowrap valign=bottom style="width:148.5pt;border:solid windowtext 1.0pt;border-left:none;background:#70AD47;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
												<p class=MsoNormal><b><span style="color:white">Gate<o:p></o:p></span></b></p>
											</td>
											<td width=114 nowrap valign=bottom style="width:85.5pt;border:solid windowtext 1.0pt;border-left:none;background:#70AD47;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
												<p class=MsoNormal><b><span style="color:white">From Date<o:p></o:p></span></b></p>
											</td>
											<td width=114 nowrap valign=bottom style="width:85.5pt;border:solid windowtext 1.0pt;border-left:none;background:#70AD47;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
												<p class=MsoNormal><b><span style="color:white">To Date<o:p></o:p></span></b></p>
											</td>
										</tr>'
	DECLARE @TBFOOTER NVARCHAR(MAX) = '</table>'

	SET @EMAIL = 
			--(SELECT Email
			--FROM GATE.VisitorApplicationMaster A
			--LEFT JOIN HrEmpMaster E ON A.CreateUid = E.Code
			--WHERE Id = @MASTERID)		
	'nghia55160524@hyosung.com'

	SET @CCBCC = (SELECT Email FROM HrEmpMaster WHERE Code = @UserId)

	SET @SUBJECT = '[Hyosung Portal] Access card number for long term applications'
	SELECT @BODY =
	STUFF ((SELECT '' + '
				<tr style="height:15.0pt">
					<td width=126 nowrap valign=bottom style="width:94.25pt;border:solid windowtext 1.0pt;border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
						<p class=MsoNormal><span style="color:black">'+ISNULL(VehicleCard, '')+'</span></p>
					</td>
					<td width=138 nowrap valign=bottom style="width:103.5pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
						<p class=MsoNormal><span style="color:black">'+DriverPlate+'</span></p>
					</td>
					<td width=198 nowrap valign=bottom style="width:148.5pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
						<p class=MsoNormal><span style="color:black">'+V.CompanyName+'</span></p>
					</td>
					<td width=198 nowrap valign=bottom style="width:148.5pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
						<p class=MsoNormal><span style="color:black">'+
							CASE WHEN ISNULL(M.Gate,'') = '' THEN '' ELSE 
							STUFF ((SELECT ', ' + CONVERT(VARCHAR, G.Sequence)+''
									FROM SysCategoryValue G
									INNER JOIN (SELECT SplitItem, id FROM FN_SplitString(M.Gate,'|')) SP ON G.Id = SplitItem
									ORDER BY SP.id
									FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)') , 1, 1, '')
								END
						+'</span></p>
					</td>
					<td width=114 nowrap valign=bottom style="width:85.5pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
						<p class=MsoNormal><span style="color:black">'+CONVERT(VARCHAR(10), A.FromDate, 102)+'</span></p>
					</td>
					<td width=114 nowrap valign=bottom style="width:85.5pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
						<p class=MsoNormal><span style="color:black">'+CONVERT(VARCHAR(10), A.ToDate, 102)+'</span></p>
					</td>
				</tr>'
		
	FROM GATE.VisitorApplicationDetailVehicle A
	LEFT JOIN GATE.VisitorApplicationMaster M ON A.ApplicationMaster = M.Id
	LEFT JOIN GATE.Vendor V ON M.Vendor = V.Id
	WHERE APPLICATIONMASTER = @MASTERID
	FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)') , 1, 1, '') 


	SET @BODY = @TBBODY + @BODY + @TBFOOTER

	EXEC msdb.dbo.sp_send_dbmail
		@profile_name = 'Hyosung Portal',
		@recipients = @EMAIL,
		@copy_recipients = @CCBCC,
		@body = @BODY,
		@subject = @subject,
		@body_format = 'HTML',
		@importance = 'HIGH',
		@file_attachments= @ATTACHMENT ;

	UPDATE GATE.VisitorApplicationMaster SET IsSendMail = 1 WHERE Id = @MASTERID
END

GO
/****** Object:  StoredProcedure [GATE].[SP_VENDOR_DELETE]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20171124
-- Description:	THÊM VENDOR
-- =============================================
CREATE PROCEDURE [GATE].[SP_VENDOR_DELETE]
	@Id int,
	@UserId varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF EXISTS (SELECT 1 FROM GATE.VisitorApplicationMaster WHERE Vendor = @Id)
	BEGIN
		SELECT 'Please delete all visitor application that involed with this vendor'
		RETURN
	END

	UPDATE GATE.Vendor
	SET DeleteDate = GETDATE(), DeleteUid = @UserId
	WHERE Id = @Id

	SELECT 'Ok'
END

GO
/****** Object:  StoredProcedure [GATE].[SP_VENDOR_FIND]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20171124
-- Description:	LẤY LÊN DANH SÁCH VENDOR
-- =============================================
CREATE PROCEDURE [GATE].[SP_VENDOR_FIND]
	@VALUE NVARCHAR(100) = N'0301096513',
	@VENDORTYPE VARCHAR(36) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--DECLARE @DEPTID INT = (
	--	SELECT CASE WHEN D.Level >= 2 THEN D.Dept ELSE D.Id END
	--	FROM HrEmpMaster E
	--	LEFT JOIN HrDeptMasterFull D ON E.DeptCode = D.Id
	--	WHERE E.Code = @EMPID
	--);

	--WITH DEPT(ID, NAME, KONAME, PARENTID, LEVEL, Code) AS(
	--		SELECT ID, ENNAME, KONAME, Parent, 0, Code FROM HrDeptMaster
	--		WHERE Id = @DEPTID
	--		UNION ALL
	--		SELECT B.ID, B.EnName, B.KONAME, B.Parent, A.LEVEL + 1, B.Code FROM DEPT A, HrDeptMaster B
	--		WHERE A.ID = B.Parent AND B.IsDelete = 0
	--	)

	SELECT V.Id, V.CompanyName, V.Address, V.DeptId
		,V.PersonInCharge, V.ContactPerson, V.TaxCode, V.PhoneNumber, V.Email, V.IsActive, V.CreateUid, V.CreateDate
		,D.OrganizationName, D.PlantName, D.DeptName, D.SectName
		,C.LocalName CreateName, P.LocalName PersonInChargeName, V.TermsOfUse
	FROM GATE.Vendor V
	LEFT JOIN HrEmpMaster C ON V.CreateUid = C.Code
	LEFT JOIN HrEmpMaster P ON V.PersonInCharge = P.Code
	LEFT JOIN HrDeptMasterFull D ON P.DeptCode = D.Id
	WHERE 1=1
		AND DeleteUid IS NULL
		AND (@VENDORTYPE IS NULL OR V.VendorType = @VENDORTYPE)
		--AND (TaxCode LIKE '%' + @VALUE + '%' OR CompanyName LIKE '%' + @VALUE + '%')
END

GO
/****** Object:  StoredProcedure [GATE].[SP_VENDOR_GET]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20171124
-- Description:	LẤY LÊN DANH SÁCH VENDOR
-- =============================================
CREATE PROCEDURE [GATE].[SP_VENDOR_GET]
	@ID INT = NULL,
	@EMPID VARCHAR(20) = 'VN55160524',
	@FROMDATE DATE = '20170101',
	@TODATE DATE = '20181231',
	@VENDORTYPE VARCHAR(36) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;



	DECLARE @DEPTID INT = (
		SELECT CASE WHEN D.Level >= 2 THEN D.Dept ELSE D.Id END
		FROM HrEmpMaster E
		LEFT JOIN HrDeptMasterFull D ON E.DeptCode = D.Id
		WHERE E.Code = @EMPID
	);

	WITH DEPT(ID, NAME, KONAME, PARENTID, LEVEL, Code) AS(
			SELECT ID, ENNAME, KONAME, Parent, 0, Code FROM HrDeptMaster
			WHERE Id = @DEPTID
			UNION ALL
			SELECT B.ID, B.EnName, B.KONAME, B.Parent, A.LEVEL + 1, B.Code FROM DEPT A, HrDeptMaster B
			WHERE A.ID = B.Parent AND B.IsDelete = 0
		),
	APP AS (
		SELECT COUNT(Id) CountNum, Vendor
		FROM GATE.VisitorApplicationMaster
		WHERE CreateUid = @EMPID
		GROUP BY Vendor
	)

	SELECT V.Id, UPPER(V.CompanyName) CompanyName, V.Address, V.DeptId
		,V.PersonInCharge, V.ContactPerson, V.TaxCode, V.PhoneNumber, V.Email, V.IsActive, V.CreateUid, V.CreateDate
		,D.OrganizationName, D.PlantName, D.DeptName, D.SectName
		,C.LocalName CreateName, P.LocalName PersonInChargeName, V.TermsOfUse, A.CountNum
	FROM GATE.Vendor V
	LEFT JOIN HrEmpMaster C ON V.CreateUid = C.Code
	LEFT JOIN HrEmpMaster P ON V.PersonInCharge = P.Code
	LEFT JOIN HrDeptMasterFull D ON P.DeptCode = D.Id
	LEFT JOIN APP A ON V.Id = A.Vendor
	WHERE 1=1 
		AND (@ID IS NULL OR (@ID IS NOT NULL AND V.Id = @ID))
		--AND DeptId IN (SELECT ID FROM DEPT)
		AND DATEDIFF(DAY, @FROMDATE , V.CreateDate) >= 0
		AND DATEDIFF(DAY , V.CreateDate, @TODATE) >= 0
		AND DeleteUid IS NULL
		--AND (@VENDORTYPE IS NULL OR V.VendorType = @VENDORTYPE)
	ORDER BY A.CountNum DESC, CompanyName
END

GO
/****** Object:  StoredProcedure [GATE].[SP_VENDOR_INSERT]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20171124
-- Description:	THÊM VENDOR
-- =============================================
CREATE PROCEDURE [GATE].[SP_VENDOR_INSERT]
	@CompanyName nvarchar(100),
	@Address nvarchar(300),
	@DeptId int,
	@PersonInCharge varchar(20),
	@ContactPerson nvarchar(70),
	@IdentityCard varchar(15),
	@PhoneNumber varchar(15),
	@Email varchar(70),
	@Active bit,
	@UserId varchar(20),
	@VendorType varchar(36) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;
	INSERT INTO GATE.Vendor(CompanyName, Address, DeptId, PersonInCharge, ContactPerson, TaxCode, PhoneNumber, Email, IsActive, CreateDate, CreateUid, VendorType)
	VALUES(UPPER(@CompanyName), @Address, @DeptId, @PersonInCharge, @ContactPerson, @IdentityCard, @PhoneNumber, @Email, @Active, GETDATE(), @UserId, ISNULL(@VendorType, '44ac3638-10bb-4b9a-af30-b3cb9fd6aaaa'))

END

GO
/****** Object:  StoredProcedure [GATE].[SP_VENDOR_UPDATE]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20171124
-- Description:	THÊM VENDOR
-- =============================================
CREATE PROCEDURE [GATE].[SP_VENDOR_UPDATE]
	@Id int,
	@CompanyName nvarchar(100),
	@Address nvarchar(300),
	@DeptId int,
	@PersonInCharge varchar(20),
	@ContactPerson nvarchar(70),
	@IdentityCard varchar(15),
	@PhoneNumber varchar(15),
	@Email varchar(70),
	@Active bit,
	@UserId varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	UPDATE GATE.Vendor
	SET
		CompanyName = @CompanyName,
		[Address] = @Address,
		DeptId = @DeptId,
		PersonInCharge = @PersonInCharge, 
		TaxCode = @IdentityCard,
		PhoneNumber = @PhoneNumber, 
		Email = @Email,
		IsActive = @Active,
		UpdateDate = GETDATE(),
		UpdateUId = @UserId,
		ContactPerson = @ContactPerson
	WHERE Id = @Id

END

GO
/****** Object:  StoredProcedure [GATE].[SP_VIOLATION_GET]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.21
-- Description:	LẤY LÊNH DANH SÁCH NHỮNG NGƯỜI VI PHẠM
-- =============================================
CREATE PROCEDURE [GATE].[SP_VIOLATION_GET]
	-- Add the parameters for the stored procedure here
	@ID INT = NULL,
	@FROMDATE DATE = '20000101',
	@TODATE DATE = '20990101',
	@USERID VARCHAR(20) = 'VN55160524',
	@APPROVESTATUS VARCHAR(36) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		
	IF @ID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM CmsPostAction WHERE ModuleId = '234dd956-cd7f-4870-a1d4-865857432084' AND CategoryId = '95A464F6-6D97-4F9C-B6F3-2D840A5A884C' AND MasterId = @ID AND UserId = @USERID)
	BEGIN
		INSERT INTO CmsPostAction (ModuleId, CategoryId, MasterId, UserId, ActionDate)
		VALUES ('234dd956-cd7f-4870-a1d4-865857432084', '95A464F6-6D97-4F9C-B6F3-2D840A5A884C', @ID, @USERID, GETDATE())
	END

	;WITH CATE AS(
		SELECT ID, Name, SubCode 
		FROM SysCategoryValue 
		WHERE Category IN ('2EA2A6A8-0C9A-446A-BA6B-B5197D22A4B8'
							, '418D8192-A87B-4E78-9E46-07CC8FCD36D1'
							, 'c6820f36-56bb-4f92-a128-73ba0f45c436'--VIOLATION 
							, 'AED27DE5-1310-4A02-997B-87A6EF9686BD' -- VEHICLE
							--, '234DD956-CD7F-4870-A1D4-865857432084'--VIOALTION MODULE ATTACHMENT
							)
							OR (Category = '054E0F62-4EFE-41E1-A18D-5C28A6531539' and ParentID = 'EAF964F0-F557-40C7-AD06-F0B4A6571A4F')
	), POSTACTION AS (
		SELECT * 
		FROM CmsPostAction 
		WHERE ModuleId = '234dd956-cd7f-4870-a1d4-865857432084' AND CategoryId = '95A464F6-6D97-4F9C-B6F3-2D840A5A884C' AND UserId = @USERID
	)
	--[GATE].[SP_VIOLATION_GET]
	SELECT A.Id, A.Code, A.EmpId, E.LocalName EmpName
		
		,A.VisitorId, D.IdentityCard , D.FullName VisitorName, R.Vendor VendorId, O.CompanyName VendorName
		--, D.VehicleType, H.Name VehicleTypeName, D.DriverPlate

		,F.OrganizationName OrgName, F.PlantName, F.DeptName, F.SectName
		,A.ViolateDate, A.ViolateType, V.Name ViolationTypeName, A.ReasonDetail
		,A.PersonInCharge
		,P.LocalName PersonInChargeName
		,A.IsAttachment, A.IsBlackList

		--,A.ApprovalKind, C.Name KindName
		--,ISNULL(A.ApprovalLineJson, '') ApprovalLineJson
		--,ISNULL(A.ApprovalLine, '') ApprovalLine, S.Name ApprovalStatusName, A.ApprovalStatus		
		--,A.NextApprover, N.LocalName NextApproverName

		,A.ConfirmDate, A.CreateDate, A.CreateUid, U.LocalName CreateName

		,CASE WHEN I.ActionId IS NOT NULL THEN 1 ELSE 0 END ISVIEW
	FROM GATE.Violation A
	LEFT JOIN GATE.VisitorApplicationDetailPerson D ON A.VisitorId = D.Id
	LEFT JOIN GATE.VisitorApplicationMaster R ON D.ApplicationMaster = R.Id
	LEFT JOIN GATE.Vendor O ON R.Vendor = O.Id
	LEFT JOIN HrEmpMaster E ON A.EmpId = E.Code
	LEFT JOIN HrDeptMasterFull F ON A.DeptId = F.Id

	LEFT JOIN HrEmpMaster P ON A.PersonInCharge = P.Code

	LEFT JOIN CATE V ON A.ViolateType = V.ID
	--LEFT JOIN CATE H ON D.VehicleType = H.ID
	--LEFT JOIN CATE C ON A.ApprovalKind = C.ID
	--LEFT JOIN CATE S ON A.ApprovalStatus = S.ID

	--LEFT JOIN HrEmpMaster N ON N.Code = A.NextApprover
	LEFT JOIN HrEmpMaster U ON U.Code = A.CreateUid

	LEFT JOIN POSTACTION I ON A.Id = I.MasterId
	WHERE 1=1
		AND ((@ID IS NOT NULL AND A.Id = @ID) OR ( @ID IS NULL AND (
			DATEDIFF(DAY, @FROMDATE , A.CreateDate) >= 0
			AND DATEDIFF(DAY , A.CreateDate, @TODATE) >= 0
			AND A.DeleteUid IS NULL
			AND ((@APPROVESTATUS IS NULL AND (A.CreateUid = @USERID OR A.ApprovalLine  LIKE '%' + @USERID + '%'))
				OR (@APPROVESTATUS IS NOT NULL AND A.ApprovalStatus = @APPROVESTATUS AND (A.CreateUid = @USERID OR A.ApprovalLine  LIKE '%' + @USERID + '%')))		
		)))
	ORDER BY A.CreateDate DESC
END

GO
/****** Object:  StoredProcedure [GATE].[SP_VIOLATION_INSERT]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.03
-- Description:	INSERT
-- =============================================
CREATE PROCEDURE [GATE].[SP_VIOLATION_INSERT]
	-- Add the parameters for the stored procedure here
	@VISITORID INT = 0,
	@EMPID VARCHAR(20) = 'vn55110755',
	@DEPT INT = 111,
	@VIOLATEDATE DATE ='20171224',
	@VIOLATETYPE VARCHAR(36) = '0b6d893b-d4ae-4a06-94c8-c42d6bebb8d4',
	@REASONDETAIL NTEXT = '',
	@ISBLACKLIST BIT = 0 ,
	@PERSONINCHARGE VARCHAR(20) = 'vn55160524',
	@ISATTACHMENT BIT = 0,
	@USERID VARCHAR(20) = 'vn55160524'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	--ĐẾM SỐ LƯỢNG ĐƠN THEO THÁNG, CHỈ TÍNH NHỮNG CÁI NÀO KHÔNG PHẢI LÀ ĐƠN LƯU TẠM
	DECLARE @COUNT INT = (SELECT COUNT(1) FROM GATE.Violation WHERE DATEDIFF(MONTH, CreateDate, GETDATE()) = 0) + 1

	DECLARE @CODE VARCHAR(20)
	SET @CODE = (SELECT Code + '-' + CONVERT(VARCHAR(6), CONVERT(DATETIME, GETDATE()), 112) + '-' + REPLICATE('0', 3 - LEN(@COUNT)) + CONVERT(VARCHAR(3), @COUNT)
				FROM EApproval.ApplicationConfig WHERE Id = 10)

	INSERT INTO GATE.Violation(CODE, VisitorId, EmpId, DeptId, Violatedate, ViolateType, ReasonDetail, IsBlackList, PersonInCharge, IsAttachment, CreateUid, CreateDate)
	VALUES(@CODE, @VISITORID, @EMPID, @DEPT, @VIOLATEDATE, @VIOLATETYPE, @REASONDETAIL, @ISBLACKLIST, @PERSONINCHARGE, @ISATTACHMENT, @USERID, GETDATE())
	
	DECLARE @RESULT INT = SCOPE_IDENTITY()
	SELECT ISNULL(@RESULT, 0) RESULT
END

GO
/****** Object:  StoredProcedure [GATE].[SP_VIOLATION_UPDATE]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.03
-- Description:	INSERT
-- =============================================
CREATE PROCEDURE [GATE].[SP_VIOLATION_UPDATE]
	-- Add the parameters for the stored procedure here
	@ID INT,
	@VISITORID INT,
	@EMPID VARCHAR(20),
	@DEPT INT,
	@VIOLATEDATE DATE,
	@VIOLATETYPE VARCHAR(36),
	@REASONDETAIL NTEXT,
	@ISBLACKLIST BIT,
	@PERSONINCHARGE VARCHAR(20),
	@ISATTACHMENT BIT,
	@USERID VARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	--ĐẾM SỐ LƯỢNG ĐƠN THEO THÁNG, CHỈ TÍNH NHỮNG CÁI NÀO KHÔNG PHẢI LÀ ĐƠN LƯU TẠM
	UPDATE GATE.Violation
	SET VisitorId = @VISITORID,
		EmpId = @EMPID,
		DeptId = @DEPT,
		Violatedate = @VIOLATEDATE,
		ViolateType = @VIOLATETYPE,
		ReasonDetail = @REASONDETAIL,
		ISBLACKLIST = @ISBLACKLIST,
		PersonInCharge = @PERSONINCHARGE,
		IsAttachment = @ISATTACHMENT,
		UpdateUId = @USERID,
		UpdateDate = GETDATE()
	WHERE Id = @ID
END

GO
/****** Object:  StoredProcedure [GATE].[SP_VISITOR_APPLICATION_DETAIL_DELETE]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.03
-- Description:	XÓA VISITOR DETAIL
-- =============================================
CREATE PROCEDURE [GATE].[SP_VISITOR_APPLICATION_DETAIL_DELETE]
	-- Add the parameters for the stored procedure here
	@Id int = null,
	@UserId varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE GATE.VisitorApplicationDetail
	SET DeleteDate = GETDATE(), DeleteUid = @UserId
	WHERE Id = @Id

END

GO
/****** Object:  StoredProcedure [GATE].[SP_VISITOR_APPLICATION_DETAIL_GET]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.03
-- Description:	LẤY LÊN DANH SÁCH VISITOR THEO MASTER ID
-- =============================================
CREATE PROCEDURE [GATE].[SP_VISITOR_APPLICATION_DETAIL_GET]
	-- Add the parameters for the stored procedure here
	@ApplicationMasterid INT = 2506,
	@Id int = null

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT A.Id, A.ApplicationMaster, A.[Image], A.FullName
		,A.IdentityCard, A.PhoneNumber, A.FromDate, A.ToDate
		,A.IsWorkHourOfficial, CASE WHEN A.IsWorkHourOfficial = 1 THEN 'Y' ELSE 'N' END IsWorkHourOfficialName
		,A.VisitorCard, A.IssuedDate, A.IssuedUid, B.Code + ' From: ' + CONVERT(VARCHAR(10),  B.FromDate, 102) + ' to: ' + CONVERT(VARCHAR(10), B.ToDate, 102) Code
	FROM GATE.VisitorApplicationDetailPerson A
	LEFT JOIN GATE.VisitorApplicationMaster C ON A.ApplicationMaster = C.Id
	OUTER APPLY(
		SELECT TOP 1 M.Code, P.FromDate, P.ToDate
		FROM GATE.VisitorApplicationDetailPerson P
		LEFT JOIN GATE.VisitorApplicationMaster M ON P.ApplicationMaster = M.Id
		WHERE A.IdentityCard = P.IdentityCard AND M.Gate LIKE '%' + C.Gate + '%'
			--AND DATEDIFF(DAY, P.ToDate, A.FromDate) <= 0 
			--F1<F2 & F2<T1
			AND ((DATEDIFF(DAY, P.FromDate, A.FromDate) >= 0 AND DATEDIFF(DAY, A.FromDate, P.ToDate) >= 0)
				--F1<T2 & T2<T1
				OR (DATEDIFF(DAY, P.FromDate, A.ToDate) >= 0 AND DATEDIFF(DAY, A.ToDate, P.ToDate) >= 0)
				)
			AND P.DeleteUid IS NULL AND M.DeleteUid IS NULL
			AND A.Id <> P.Id 
			AND M.ApprovalStatus = '00F2EC64-CC9B-4FCA-AB4C-B37961EFAD53'

	)B
	--LEFT JOIN SysCategoryValue C ON A.VehicleType = C.ID AND C.Category = 'aed27de5-1310-4a02-997b-87a6ef9686bd'
	WHERE 1=1
		AND A.DeleteUid IS NULL
		AND (@ApplicationMasterid IS NULL OR (@ApplicationMasterid IS NOT NULL AND A.ApplicationMaster = @ApplicationMasterid))
		AND (@Id IS NULL OR (@Id IS NOT NULL AND A.Id = @Id))

	
END

GO
/****** Object:  StoredProcedure [GATE].[SP_VISITOR_APPLICATION_DETAIL_INSERT]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.03
-- Description:	INSERT VISITOR APPLICATION DETAIL
-- =============================================
CREATE PROCEDURE [GATE].[SP_VISITOR_APPLICATION_DETAIL_INSERT]
	-- Add the parameters for the stored procedure here
	@ApplicationMasterid INT = 292,
	@Image varchar(200) = null,
	@FullName nvarchar(200) = 'nghia',
	@IdentityCard varchar(15) = '123',
	@PhoneNumber varchar(15) = '1243',
	@FromDate datetime = '20180321',
	@ToDate datetime = '20180328',
	@DriverPlate varchar(20) = null,
	@VehicleType varchar(36) = null,
	@IsWorkHourOfficial bit = 1,
	@PhoneDriver varchar(15) = null,
	@DriverName nvarchar(500),
	@UserId varchar(20) = 'VN55160524'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @CODE VARCHAR(20), @FROM VARCHAR(10), @TO VARCHAR(10), @MASTERID INT
	DECLARE @GATE VARCHAR(1000) = (SELECT Gate FROM GATE.VisitorApplicationMaster WHERE Id = @ApplicationMasterid)
	--DECLARE @GATE_TB TABLE (ID IN)
	IF (@IdentityCard IS NOT NULL)
	BEGIN
		--KIỂM TRA NGƯỜI NÀY ĐÃ TỒN TẠI TRONG CÙNG 1 ĐƠN HAY CHƯA
		IF(EXISTS (SELECT 1 FROM GATE.VisitorApplicationDetailPerson WHERE ApplicationMaster = @ApplicationMasterid AND IdentityCard = @IdentityCard AND DeleteUid IS NULL))
		BEGIN
			SELECT 'This person: ' + @IdentityCard + ' already exists' MESS
			RETURN
		END

		--KIỂM TRA NGƯỜI NÀY ĐÃ CÓ Ở ĐƠN KHÁC CÙNG THỜI GIAN ĐĂNG KÝ HAY KHÔNG		
		
		SELECT TOP 1 @CODE = B.Code, @FROM = CONVERT(VARCHAR(10), A.FromDate, 102), @TO = CONVERT(VARCHAR(10), A.ToDate, 102), @MASTERID = A.ApplicationMaster
		FROM GATE.VisitorApplicationDetailPerson A
		LEFT JOIN GATE.VisitorApplicationMaster B ON B.Id = A.ApplicationMaster
		WHERE ApplicationMaster != @ApplicationMasterid 
			AND IdentityCard = @IdentityCard AND B.Gate LIKE '%' + @GATE + '%'
				--F1<F2 & F2<T1
			AND ((DATEDIFF(DAY, A.FromDate, @FromDate) >= 0 AND DATEDIFF(DAY, @FromDate, A.ToDate) >= 0)
				--F1<T2 & T2<T1
				OR (DATEDIFF(DAY, A.FromDate, @ToDate) >= 0 AND DATEDIFF(DAY, @ToDate, A.ToDate) >= 0)
				)
			--AND DATEDIFF(DAY, A.ToDate, @FromDate) <= 0 
			AND A.DeleteUid IS NULL AND B.DeleteUid IS NULL
			--CHỈ KIỂM TRA TRONG ĐƠN ĐÃ ĐƯỢC APPROVE HOẶC LÀ NHỮNG ĐƠN ĐANG ĐƯỢC DUYỆT
			AND (B.ApprovalStatus = '00F2EC64-CC9B-4FCA-AB4C-B37961EFAD53' OR B.ApprovalStatus = 'C4FF5A2F-CD32-4785-9499-A26E5148D58D')

		IF ISNULL(@CODE, '') <> ''
		BEGIN
			SELECT CONVERT(VARCHAR, @MASTERID) + '|' +@CODE+ '|This person: <b>' + @IdentityCard + '</b> already exists' + ' in application: <b>' + @CODE + '</b>, registration time is: <b>' + @FROM + '</b> to: <b>' + @TO + '</b>' MESS
			RETURN
		END

		INSERT INTO GATE.VisitorApplicationDetailPerson(ApplicationMaster, [Image], FullName, IdentityCard, PhoneNumber
												, FromDate, ToDate, IsWorkHourOfficial, CreateUid, CreateDate)
		VALUES(@ApplicationMasterid, @Image, @FullName, @IdentityCard, @PhoneNumber, @FromDate, @ToDate, @IsWorkHourOfficial, @UserId, GETDATE())
		SELECT 'Ok' Result
		RETURN
	END
	IF @DriverPlate IS NOT NULL
	BEGIN
		IF(EXISTS (SELECT 1 FROM GATE.VisitorApplicationDetailVehicle WHERE ApplicationMaster = @ApplicationMasterid AND DriverPlate = @DriverPlate AND DeleteUid IS NULL))
		BEGIN
			SELECT 'This vehicle: ' + @DriverPlate + ' already exists' MESS
			RETURN
		END

		--KIỂM TRA NGƯỜI NÀY ĐÃ CÓ Ở ĐƠN KHÁC CÙNG THỜI GIAN ĐĂNG KÝ HAY KHÔNG
		
		SELECT TOP 1 @CODE = B.Code, @FROM = CONVERT(VARCHAR(10), A.FromDate, 102), @TO = CONVERT(VARCHAR(10), A.ToDate, 102), @MASTERID = A.ApplicationMaster
		FROM GATE.VisitorApplicationDetailVehicle A
		LEFT JOIN GATE.VisitorApplicationMaster B ON B.Id = A.ApplicationMaster
		WHERE ApplicationMaster != @ApplicationMasterid 
			AND DriverPlate = @DriverPlate AND B.Gate LIKE '%' + @GATE + '%'
				--F1<F2 & F2<T1
			AND ((DATEDIFF(DAY, A.FromDate, @FromDate) >= 0 AND DATEDIFF(DAY, @FromDate, A.ToDate) >= 0)
				--F1<T2 & T2<T1
				OR (DATEDIFF(DAY, A.FromDate, @ToDate) >= 0 AND DATEDIFF(DAY, @ToDate, A.ToDate) >= 0)
				)
			AND A.DeleteUid IS NULL AND B.DeleteUid IS NULL
			--CHỈ KIỂM TRA TRONG ĐƠN ĐÃ ĐƯỢC APPROVE HOẶC LÀ NHỮNG ĐƠN ĐANG ĐƯỢC DUYỆT
			AND (B.ApprovalStatus = '00F2EC64-CC9B-4FCA-AB4C-B37961EFAD53' OR B.ApprovalStatus = 'C4FF5A2F-CD32-4785-9499-A26E5148D58D')
		IF ISNULL(@CODE, '') <> ''
		BEGIN
			--SELECT CONVERT(VARCHAR, @MASTERID) + '|This vehicle: ' + @DriverPlate + ' already exists' + ' in application: ' + @CODE + ', registration time is: ' + @FROM + ' to: ' + @TO MESS
			SELECT CONVERT(VARCHAR, @MASTERID) + '|' +@CODE+ '|This person: <b>' + @DriverPlate + '</b> already exists' + ' in application: <b>' + @CODE + '</b>, registration time is: <b>' + @FROM + '</b> to: <b>' + @TO + '</b>' MESS
			RETURN
		END

		INSERT INTO GATE.VisitorApplicationDetailVehicle(ApplicationMaster, FromDate, ToDate, VehicleType, DriverPlate, PhoneDriver, CreateUid, CreateDate, DriverName)
		VALUES(@ApplicationMasterid, @FromDate, @ToDate, @VehicleType, @DriverPlate, @PhoneDriver, @UserId, GETDATE(), @DriverName)
		SELECT 'Ok' Result
		RETURN
	END
END

GO
/****** Object:  StoredProcedure [GATE].[SP_VISITOR_APPLICATION_DETAIL_UPDATE]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.03
-- Description:	UPDATE VISITOR APPLICATION DETAIL
-- =============================================
CREATE PROCEDURE [GATE].[SP_VISITOR_APPLICATION_DETAIL_UPDATE]
	-- Add the parameters for the stored procedure here
	@Id INT,
	@ApplicationMasterid INT,
	@Image varchar(200),
	@FullName nvarchar(200),
	@IdentityCard varchar(15),
	@PhoneNumber varchar(15),
	@FromDate datetime,
	@ToDate datetime,
	@DriverPlate varchar(20),
	@VehicleType varchar(36),
	@IsWorkHourOfficial bit,
	@PhoneDriver varchar(15),
	@DriverName nvarchar(500),
	@UserId varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @CODE VARCHAR(20), @FROM VARCHAR(10), @TO VARCHAR(10), @MASTERID INT
	DECLARE @GATE VARCHAR(1000) = (SELECT Gate FROM GATE.VisitorApplicationMaster WHERE Id = @ApplicationMasterid)

	IF (@IdentityCard IS NOT NULL)
	BEGIN
		IF(EXISTS (SELECT 1 FROM GATE.VisitorApplicationDetailPerson WHERE ApplicationMaster = @ApplicationMasterid AND IdentityCard = @IdentityCard AND ID <> @Id AND DeleteUid IS NULL))
		BEGIN
			SELECT 'This person already exists' Result
			RETURN
		END
		
		--KIỂM TRA NGƯỜI NÀY ĐÃ CÓ Ở ĐƠN KHÁC CÙNG THỜI GIAN ĐĂNG KÝ HAY KHÔNG		
			

		SELECT TOP 1 @CODE = B.Code, @FROM = CONVERT(VARCHAR(10), A.FromDate, 102), @TO = CONVERT(VARCHAR(10), A.ToDate, 102), @MASTERID = A.ApplicationMaster
					FROM GATE.VisitorApplicationDetailPerson A
					LEFT JOIN GATE.VisitorApplicationMaster B ON B.Id = A.ApplicationMaster
					WHERE ApplicationMaster != @ApplicationMasterid 
						AND IdentityCard = @IdentityCard AND B.Gate LIKE '%' + @GATE + '%'
						--F1<F2 & F2<T1
					AND ((DATEDIFF(DAY, A.FromDate, @FromDate) >= 0 AND DATEDIFF(DAY, @FromDate, A.ToDate) >= 0)
						--F1<T2 & T2<T1
						OR (DATEDIFF(DAY, A.FromDate, @ToDate) >= 0 AND DATEDIFF(DAY, @ToDate, A.ToDate) >= 0)
						)
					--AND DATEDIFF(DAY, A.ToDate, @FromDate) <= 0 
					AND A.DeleteUid IS NULL
					--CHỈ KIỂM TRA TRONG ĐƠN ĐÃ ĐƯỢC APPROVE
					AND B.ApprovalStatus = '00F2EC64-CC9B-4FCA-AB4C-B37961EFAD53'
		IF ISNULL(@CODE, '') <> ''
		BEGIN
			SELECT CONVERT(VARCHAR, @MASTERID) + '|This person: ' + @IdentityCard + ' already exists' + ' in application: ' + @CODE + ', registration time is: ' + @FROM + ' to: ' + @TO MESS
			RETURN
		END

		UPDATE GATE.VisitorApplicationDetailPerson
		SET [Image] = @Image,
			FullName = @FullName,
			IdentityCard = @IdentityCard,
			PhoneNumber = @PhoneNumber,
			FromDate = @FromDate,
			ToDate = @ToDate,
			IsWorkHourOfficial = @IsWorkHourOfficial,
			UpdateUid = @UserId,
			UpdateDate = GETDATE()  
		WHERE Id = @Id
		SELECT 'Ok' Result
		RETURN
	END
	IF (@DriverPlate IS NOT NULL)
	BEGIN
		IF(EXISTS (SELECT 1 FROM GATE.VisitorApplicationDetailVehicle WHERE ApplicationMaster = @ApplicationMasterid AND DriverPlate = @DriverPlate AND ID <> @Id AND DeleteUid IS NULL))
		BEGIN
			SELECT 'This vehicle already exists' Result
			RETURN
		END
		--KIỂM TRA NGƯỜI NÀY ĐÃ CÓ Ở ĐƠN KHÁC CÙNG THỜI GIAN ĐĂNG KÝ HAY KHÔNG
		
		SELECT TOP 1 @CODE = B.Code, @FROM = CONVERT(VARCHAR(10), A.FromDate, 102), @TO = CONVERT(VARCHAR(10), A.ToDate, 102), @MASTERID = A.ApplicationMaster
					FROM GATE.VisitorApplicationDetailVehicle A
					LEFT JOIN GATE.VisitorApplicationMaster B ON B.Id = A.ApplicationMaster
					WHERE ApplicationMaster != @ApplicationMasterid 
						AND DriverPlate = @DriverPlate AND B.Gate LIKE '%' + @GATE + '%'
							--F1<F2 & F2<T1
						AND ((DATEDIFF(DAY, A.FromDate, @FromDate) >= 0 AND DATEDIFF(DAY, @FromDate, A.ToDate) >= 0)
							--F1<T2 & T2<T1
							OR (DATEDIFF(DAY, A.FromDate, @ToDate) >= 0 AND DATEDIFF(DAY, @ToDate, A.ToDate) >= 0)
							)
						AND A.DeleteUid IS NULL
						--CHỈ KIỂM TRA TRONG ĐƠN ĐÃ ĐƯỢC APPROVE
						AND B.ApprovalStatus = '00F2EC64-CC9B-4FCA-AB4C-B37961EFAD53'
		IF ISNULL(@CODE, '') <> ''
		BEGIN
			SELECT CONVERT(VARCHAR, @MASTERID) + '|This vehicle: ' + @DriverPlate + ' already exists' + ' in application: ' + @CODE + ', registration time is: ' + @FROM + ' to: ' + @TO MESS
			RETURN
		END
		UPDATE GATE.VisitorApplicationDetailVehicle
		SET FromDate = @FromDate,
			ToDate = @ToDate,
			DriverPlate = @DriverPlate,
			VehicleType = @VehicleType,
			PhoneDriver = @PhoneDriver,
			DriverName = @DriverName,
			UpdateUid = @UserId,
			UpdateDate = GETDATE()  
		WHERE Id = @Id
		SELECT 'Ok' Result
		RETURN
	END
END

GO
/****** Object:  StoredProcedure [GATE].[SP_VISITOR_APPLICATION_DETAIL_VEHICLE_GET]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.03
-- Description:	LẤY LÊN DANH SÁCH VISITOR THEO MASTER ID
-- =============================================
CREATE PROCEDURE [GATE].[SP_VISITOR_APPLICATION_DETAIL_VEHICLE_GET]
	-- Add the parameters for the stored procedure here
	@ApplicationMasterid INT = 2506,
	@Id int = null

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT A.Id, A.ApplicationMaster, A.VehicleType, A.DriverPlate, A.FromDate, A.ToDate, C.Name VehicleTypeName, A.PhoneDriver, A.DriverName
		,A.VehicleCard, A.IssuedDate, A.IssuedUid
		,B.Code + ' From: ' + CONVERT(VARCHAR(10),  B.FromDate, 102) + ' to: ' + CONVERT(VARCHAR(10), B.ToDate, 102) Code
	FROM GATE.VisitorApplicationDetailVehicle A
	LEFT JOIN SysCategoryValue C ON A.VehicleType = C.ID AND C.Category = 'aed27de5-1310-4a02-997b-87a6ef9686bd'
	LEFT JOIN GATE.VisitorApplicationMaster D ON A.ApplicationMaster = A.Id
	OUTER APPLY(
		SELECT TOP 1 M.Code, P.FromDate, P.ToDate
		FROM GATE.VisitorApplicationDetailVehicle P
		LEFT JOIN GATE.VisitorApplicationMaster M ON P.ApplicationMaster = M.Id
		WHERE A.DriverPlate = P.DriverPlate AND M.Gate LIKE '%' + D.Gate + '%'

				--F1<F2 & F2<T1
			AND ((DATEDIFF(DAY, P.FromDate, A.FromDate) >= 0 AND DATEDIFF(DAY, A.FromDate, P.ToDate) >= 0)
				--F1<T2 & T2<T1
				OR (DATEDIFF(DAY, P.FromDate, A.ToDate) >= 0 AND DATEDIFF(DAY, A.ToDate, P.ToDate) >= 0)
				)
			AND P.DeleteUid IS NULL 
			AND A.Id <> P.Id 
			AND M.ApprovalStatus = '00F2EC64-CC9B-4FCA-AB4C-B37961EFAD53'
	)B
	WHERE 1=1
		AND A.DeleteUid IS NULL
		AND (@ApplicationMasterid IS NULL OR (@ApplicationMasterid IS NOT NULL AND A.ApplicationMaster = @ApplicationMasterid))
		AND (@Id IS NULL OR (@Id IS NOT NULL AND A.Id = @Id))

END

GO
/****** Object:  StoredProcedure [GATE].[SP_VISITOR_APPLICATION_GET_APPROVAL]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.12
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [GATE].[SP_VISITOR_APPLICATION_GET_APPROVAL]
	-- Add the parameters for the stored procedure here
	@ApplicationId int = 8,
	@MasterId int = 127
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT A.Id, A.ApplicationId, A.MasterId, A.EmpId, '(' + SUBSTRING(C.Name, 1, 1) + ') ' + E.LocalName EmpName, A.ApproverType, C.Name ApproverTypeName, A.IsApprove, A.Comment, A.DateApprove, A.Seq
	FROM EApproval.Approval A
	LEFT JOIN HrEmpMaster E ON A.EmpId = E.Code
	LEFT JOIN SysCategoryValue C ON A.ApproverType = C.ID
	WHERE ApplicationId = @ApplicationId AND MasterId = @MasterId

	
END

GO
/****** Object:  StoredProcedure [GATE].[SP_VISITOR_APPLICATION_MASTER_APPROVAL_HISTORY]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20170825
-- Description:	LƯU THÔNG TIN APPROVE CỦA APPLICATION
-- =============================================
CREATE PROCEDURE [GATE].[SP_VISITOR_APPLICATION_MASTER_APPROVAL_HISTORY]
	@MasterId int = 151,
	@ApplicationId int = 8
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @TB TABLE (Id int, EmpId varchar(20), EmpName nvarchar(100), ApprovalType uniqueidentifier, ApproverTypeName nvarchar(100), IsApprove bit, Seq tinyint
				, Comment nvarchar(200), DateApprove datetime, JobTitle varchar(50))
	
	INSERT INTO @TB
	SELECT 0, A.CreateUid, '[Confirm]' + ' ' +  E.LocalName, 'E408D53D-6E62-4D63-A3D4-CD3EA9A14D36', NULL
		, CASE WHEN A.ConfirmDate IS NULL THEN NULL ELSE 1 END, 0, NULL, ConfirmDate, J.Name JobTitle
	FROM GATE.VisitorApplicationMaster A
	LEFT JOIN HrEmpMaster E ON A.CreateUid = E.Code
	LEFT JOIN SysCategoryValue J ON J.Category = '1DCBC106-D82B-4C86-8013-EFA92CA0E788' AND E.JobTitleId = J.SubCode
	WHERE A.Id = @MasterId 

	INSERT INTO @TB
	SELECT A.Id, A.EmpId, '[' + C.Name + ']' + ' ' +  E.LocalName, A.ApproverType, C.Name, A.IsApprove, A.Seq, A.Comment, A.DateApprove, J.Name JobTitle
	FROM EApproval.Approval A
	LEFT JOIN HrEmpMaster E ON A.EmpId = E.Code
	LEFT JOIN SysCategoryValue C ON A.ApproverType = C.ID
	LEFT JOIN SysCategoryValue J ON J.Category = '1DCBC106-D82B-4C86-8013-EFA92CA0E788' AND E.JobTitleId = J.SubCode
	WHERE A.ApplicationId = @ApplicationId AND A.MasterId = @MasterId

	SELECT Id, EmpId, EmpName, ApprovalType, ApproverTypeName, IsApprove, Seq, ISNULL(Comment, '') Comment, DateApprove, JobTitle
		,CONVERT(varchar(10), DateApprove, 102) + ' ' + CONVERT(varchar(8), DateApprove, 114) DateApproveFormat 
	FROM @TB


END



GO
/****** Object:  StoredProcedure [GATE].[SP_VISITOR_APPLICATION_MASTER_APPROVE]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20170825
-- Description:	LƯU THÔNG TIN APPROVE CỦA APPLICATION
-- =============================================
CREATE PROCEDURE [GATE].[SP_VISITOR_APPLICATION_MASTER_APPROVE]
	@MasterId int = 24,
	@ApplicationId int = 1,
	@IsApprove bit = 1,
	@Comment nvarchar(200) = 'aaaa',
	@UserId varchar(20) = 'vn55104017',
	@LinkApplication varchar(100) = 'http://localhost:5678/ApplicationConfig/Index'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @APPLICATIONTYPE UNIQUEIDENTIFIER, @APPROVERTYPE UNIQUEIDENTIFIER, @ISLASTAPPROVER INT, @NEXTAPPROVER VARCHAR(20) = '', @NEXTAPPROVERNAME NVARCHAR(200) = ''
	SELECT @APPLICATIONTYPE = ApprovalKind FROM GATE.VisitorApplicationMaster WHERE Id = @MasterId
	SELECT @APPROVERTYPE = ApproverType FROM EApproval.Approval WHERE ApplicationId = @ApplicationId AND MasterId = @MasterId AND EmpId = @UserId	

	--LƯU THÔNG TIN APPROVE
	UPDATE EApproval.Approval SET IsApprove = @IsApprove, Comment = @Comment, DateApprove = GETDATE()
	WHERE ApplicationId = @ApplicationId
		AND MasterId = @MasterId
		AND EmpId = @UserId

	--Kiểm tra xem có phải là người cuối cùng approve hay không	
	SET @ISLASTAPPROVER = (SELECT COUNT(1) 
							FROM EApproval.Approval 
							WHERE ApplicationId = @ApplicationId 
								AND MasterId = @MasterId AND ApproverType <> '045872C8-638C-4A12-A70B-4E471C5D90EB' --KHÔNG TÍNH NHỮNG NGƯỜI THAM KHẢO
								AND IsApprove IS NULL--NHỮNG NGƯỜI CHƯA APPROVE
							)
	--LẤY RA THÔNG TIN NGƯỜI APPROVER KẾ TIẾP
	IF (@APPLICATIONTYPE = '2600C4A7-CFB3-4E08-A08D-EDF0C1D99A71')
	BEGIN
		SET @NEXTAPPROVER = (SELECT TOP 1 EmpId 
		FROM EApproval.Approval 
		WHERE ApplicationId = @ApplicationId 
			AND MasterId = @MasterId AND ApproverType <> '045872C8-638C-4A12-A70B-4E471C5D90EB' --KHÔNG TÍNH NHỮNG NGƯỜI THAM KHẢO
			AND IsApprove IS NULL--NHỮNG NGƯỜI CHƯA APPROVE
		)
	END
	ELSE
		SET @NEXTAPPROVER = ''
	--NẾU TỪ CHỐI ĐƠN VÀ LÀ NGƯỜI APPROVE THÌ KHÔNG SET NGƯỜI KẾ TIẾP APPROVE NỮA, MÀ ĐƠN SẼ DỪNG TẠI ĐÂY
	IF @IsApprove = 0 AND @APPROVERTYPE = 'E408D53D-6E62-4D63-A3D4-CD3EA9A14D36'
		SET @NEXTAPPROVER = ''

	--Kiểm tra xem người này có phải là người duyệt cuối cùng hay không
		--hoặc nếu người này là người approver và người này từ chối đơn -> cập nhật lại cho bên master và kết thúc đơn
		--còn từ chối đơn nhưng người này là consente thì vẫn tiếp tục duyệt
	IF @ISLASTAPPROVER = 0 OR (@IsApprove = 0 AND @APPROVERTYPE = 'E408D53D-6E62-4D63-A3D4-CD3EA9A14D36')
	BEGIN
		UPDATE GATE.VisitorApplicationMaster 
		SET ApprovalStatus = CASE WHEN @APPROVERTYPE = '5325E6FF-6430-49A2-B3D3-D9ABDBE06F9E' THEN '00F2EC64-CC9B-4FCA-AB4C-B37961EFAD53' -- NẾU NGƯỜI CONSENTE THÌ MẶC ĐỊNH ĐƠN LÀ APPROVED
			ELSE CASE WHEN @IsApprove = 1 THEN '00F2EC64-CC9B-4FCA-AB4C-B37961EFAD53' ELSE '9A96D85B-8189-46BA-84CD-3389FDC501B7' END--CÒN NẾU LÀ APPROVER THÌ XÉT XEM NGƯỜI NÀY ĐỒNG Ý HAY TỪ CHỐI ĐƠN
			END,
			NextApprover = ''
		WHERE Id = @MasterId

		GOTO SEND_EMAIL_RESULT
	END
	--VẪN CÒN NGƯỜI APPROVE VÀ LOẠI ĐƠN LÀ ORDER--> CẬP NHẬT NGƯỜI APPROVE KẾ TIẾP
		--CÒN PARALLEL THÌ KO SET NGƯỜI APPROVER KẾ TIẾP
	ELSE IF @APPLICATIONTYPE = '2600C4A7-CFB3-4E08-A08D-EDF0C1D99A71'  
	BEGIN
		UPDATE GATE.VisitorApplicationMaster SET NextApprover = @NEXTAPPROVER WHERE Id = @MasterId
	END

	IF ISNULL(@NEXTAPPROVER,'') <> ''
	BEGIN
		DECLARE @EMAIL VARCHAR(1000), @CCBCC VARCHAR(1000), @BODY NVARCHAR(MAX) = 'test', @SUBJECT NVARCHAR(MAX) = 'test'

		--LẤY RA THÔNG TIN NGƯỜI APPROVER ĐÊ GỬI MAIL
		--SET @EMAIL = (
			SELECT @EMAIL = Email, @NEXTAPPROVERNAME = LocalName FROM HrEmpMaster WHERE Code = @NEXTAPPROVER
		--)

		SET @SUBJECT = (
			SELECT  '{{In Processing}}[' + B.Name + ']' + ' ' + A.Code 
			FROM GATE.VisitorApplicationMaster A
			INNER JOIN EApproval.ApplicationConfig B ON A.ApplicationType = B.Id 
			WHERE A.Id = @MasterId
		)
		
		SELECT @BODY = 
			'<p>Dear Mr/Ms: ' + @NEXTAPPROVERNAME + '. Please view and approve this application follow link bellow</p>'+
			'<table width="95%" align="center" cellpadding="2" cellspacing="1" bgcolor="#F2F2F2" style="font-size: 14px; border: 1px solid #c7c7c7">'+
			  '<tbody>'+
			   '<tr valign="top" bgcolor="#FFFFFF">'+
				  '<td  align="left" width="10%"><b>Application</b></td>'+
				  '<td>'+C.Name+'</td>'+
				'</tr>'+
				'<tr valign="top" bgcolor="#f9f9f9">'+
				  '<td  align="left"><b>Subject</b></td>'+
				  '<td>' + A.Code + '</td>'+
				'</tr>'+
				'<tr valign="top" bgcolor="#FFFFFF">'+
				  '<td align="left"><b>Creator</b></td>'+
				  N'<td>' + E.LocalName + '</td>'+
				'</tr>'+
				'<tr valign="top" bgcolor="#f9f9f9">'+
				  '<td align="left"><b>Create Date</b></td>'+
				  '<td valign="top"><div>'+CONVERT(VARCHAR, A.CreateDate, 111)+'</div></td>'+
				'</tr>'+
				'<tr valign="top" bgcolor="#FFFFFF">'+
				  '<td colspan="2" align="center"><p style="color: #023aa0; font: Arial; margin: 5px 0;">Click the button bellow to view detail</p>'+
					'<p style="margin:5px 0; background: #F9F9F9;background-image: -webkit-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: -moz-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: -ms-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: -o-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: linear-gradient(to bottom, #F9F9F9, #EFEFEF);-webkit-border-radius: 5;-moz-border-radius: 5;border-radius: 5px;font-family: Arial;color: #323232;padding: 10px 20px 10px 20px;border: solid #c7c7c7 1px;text-decoration: none;width: 100px"><a href="'+@LinkApplication+'">Click View Detail</a></p></td>'+
				'</tr>'+
			  '</tbody>'+
			'</table>'
			, @CCBCC = E.Email 
		FROM GATE.VisitorApplicationMaster A
		INNER JOIN EApproval.ApplicationConfig C ON A.ApplicationType = C.Id
		INNER JOIN HrEmpMaster E ON A.CreateUid = E.Code
		LEFT JOIN HrEmpMaster N ON A.NextApprover = N.Code
		WHERE A.Id = @MasterId

		EXEC msdb.dbo.sp_send_dbmail
			@profile_name = 'Hyosung Portal',
			@recipients = @EMAIL,
			@copy_recipients = @CCBCC,
			@body = @BODY,
			@subject = @subject,
			@body_format = 'HTML' ;
		RETURN
	END

	SEND_EMAIL_RESULT:
	BEGIN

		DECLARE @TB_RAW TABLE(Id int, Content varchar(500))
		INSERT INTO @TB_RAW
		SELECT * FROM FN_SplitString((select ApprovalLine from GATE.VisitorApplicationMaster where Id = @MasterId),'|')

		--TÁCH LOẠI NGƯỜI APPROVE
		DECLARE @TB_RAW_APPROVETYPE TABLE(Id INT, EMPID VARCHAR(20))
		INSERT INTO @TB_RAW_APPROVETYPE 
		SELECT * FROM FN_SplitString((SELECT Content FROM @TB_RAW WHERE Id = 4), ',')

		--LẤY RA THÔNG TIN NGƯỜI TẠO ĐƠN ĐÊ GỬI MAIL
		SET @EMAIL = (
			SELECT Email FROM HrEmpMaster WHERE Code = (SELECT CreateUid FROM GATE.VisitorApplicationMaster WHERE ID= @MasterId)
		)

		SET @CCBCC = ISNULL((
				SELECT STUFF((SELECT ';' + Email 
				FROM HrEmpMaster 
				WHERE Code IN (SELECT EMPID FROM @TB_RAW_APPROVETYPE)
				FOR XML PATH('')), 1, 1, '')), '')  

		SET @SUBJECT = (
			SELECT  '{{' + CASE WHEN @IsApprove = 1 THEN 'Finish' ELSE 'Reject' END +'}}[' + B.Name + ']' + ' ' + A.Code
			FROM GATE.VisitorApplicationMaster A
			INNER JOIN EApproval.ApplicationConfig B ON A.ApplicationType = B.Id 
			WHERE A.Id = @MasterId
		)
		
		SELECT @BODY = 
			CASE WHEN @IsApprove = 1 THEN
			'<p>Dear Mr/Ms: ' + E.LocalName + '. The application already approved. Please view follow link bellow</p>'
			ELSE '<p>Dear Mr/Ms: ' + E.LocalName + '. The application was rejected with the reason: ' + @Comment + '. Please view follow link bellow</p>' END +
			'<table width="95%" align="center" cellpadding="2" cellspacing="1" bgcolor="#F2F2F2" style="font-size: 14px; border: 1px solid #c7c7c7">'+
			  '<tbody>'+
			   '<tr valign="top" bgcolor="#FFFFFF">'+
				  '<td  align="left" width="10%"><b>Application</b></td>'+
				  '<td>'+C.Name+'</td>'+
				'</tr>'+
				'<tr valign="top" bgcolor="#f9f9f9">'+
				  '<td  align="left"><b>Subject</b></td>'+
				  '<td>' + A.Code + '</td>'+
				'</tr>'+
				'<tr valign="top" bgcolor="#FFFFFF">'+
				  '<td align="left"><b>Creator</b></td>'+
				  N'<td>' + E.LocalName + '</td>'+  
				'</tr>'+
				'<tr valign="top" bgcolor="#f9f9f9">'+
				  '<td align="left"><b>Create Date</b></td>'+
				  '<td valign="top"><div>'+CONVERT(VARCHAR, A.CreateDate, 111)+'</div></td>'+
				'</tr>'+
				'<tr valign="top" bgcolor="#FFFFFF">'+
				  '<td colspan="2" align="center"><p style="color: #023aa0; font: Arial; margin: 5px 0;">Click the button bellow to view detail</p>'+
					'<p style="margin:5px 0; background: #F9F9F9;background-image: -webkit-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: -moz-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: -ms-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: -o-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: linear-gradient(to bottom, #F9F9F9, #EFEFEF);-webkit-border-radius: 5;-moz-border-radius: 5;border-radius: 5px;font-family: Arial;color: #323232;padding: 10px 20px 10px 20px;border: solid #c7c7c7 1px;text-decoration: none;width: 100px"><a href="'+@LinkApplication+'">Click View Detail</a></p></td>'+
				'</tr>'+
			  '</tbody>'+
			'</table>'
		FROM GATE.VisitorApplicationMaster A
		INNER JOIN EApproval.ApplicationConfig C ON A.ApplicationType = C.Id
		INNER JOIN HrEmpMaster E ON A.CreateUid = E.Code
		WHERE A.Id = @MasterId

		EXEC msdb.dbo.sp_send_dbmail
			@profile_name = 'Hyosung Portal',
			@recipients = @EMAIL,
			@copy_recipients = @CCBCC,
			@body = @BODY,
			@subject = @SUBJECT,
			@body_format = 'HTML' ;
		RETURN
	END
END



GO
/****** Object:  StoredProcedure [GATE].[SP_VISITOR_APPLICATION_MASTER_CONFIRM]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20170830
-- Description:	CONFIRM - RECALL APPLICATION
-- =============================================
CREATE PROCEDURE [GATE].[SP_VISITOR_APPLICATION_MASTER_CONFIRM]
	@MasterId int,
	@Status bit,
	@LinkApplication VARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF @Status = 1
	BEGIN
		--CẬP NHẬT THÔNG TIN
		UPDATE GATE.VisitorApplicationMaster
		SET ApprovalStatus = 'C4FF5A2F-CD32-4785-9499-A26E5148D58D', ConfirmDate = GETDATE() 
		WHERE Id = @MasterId

		DECLARE @EMAIL VARCHAR(1000) = '', @CCBCC VARCHAR(1000), @BODY NVARCHAR(MAX) = '', @SUBJECT NVARCHAR(MAX) = ''
		DECLARE @APPROVALLINE NVARCHAR(2000) = (SELECT ApprovalLine FROM GATE.VisitorApplicationMaster WHERE ID = @MasterId)
		--LOẠI APPROVE: ORDER HAY PARALLEL
		DECLARE @APPLICATIONTYPE UNIQUEIDENTIFIER = (SELECT ApprovalKind FROM GATE.VisitorApplicationMaster WHERE Id = @MasterId)
		--LOẠI ĐƠN: LONGTERM - SHORTTERM
		DECLARE @APPLICATIONID INT = (SELECT ApplicationType FROM GATE.VisitorApplicationMaster WHERE Id = @MasterId)
		--LẤY RA THÔNG TIN NGƯỜI APPROVER ĐÊ GỬI MAIL
		IF @APPLICATIONTYPE = '2600C4A7-CFB3-4E08-A08D-EDF0C1D99A71'
			--NẾU LÀ ORDER THÌ CHỈ LẤY EMAIL CỦA NGƯỜI DUYỆT KẾ TIẾP ĐỂ GỬI
			SET @EMAIL = (
				SELECT Email FROM HrEmpMaster WHERE Code = (SELECT NextApprover FROM GATE.VisitorApplicationMaster WHERE Id = @MasterId)
			)
		ELSE
		--CÒN NẾU LÀ PARALLEL THÌ LẤY HẾT TẤT CẢ CÁC MEO ĐỂ GỬI 1 LẦN
		SET @EMAIL = (
			SELECT STUFF((SELECT ';' + Email 
			FROM HrEmpMaster 
			WHERE Code IN (SELECT EmpId 
							FROM EApproval.Approval 
							WHERE MasterId = @MasterId AND ApplicationId = @APPLICATIONID AND ApproverType <> '045872C8-638C-4A12-A70B-4E471C5D90EB')
			FOR XML PATH('')), 1, 1, '')
		)
		SET @SUBJECT = (
			SELECT  '{{In Processing}}[' + B.Name + ']' + ' ' + A.Code 
			FROM GATE.VisitorApplicationMaster A
			INNER JOIN EApproval.ApplicationConfig B ON A.ApplicationType = B.Id 
			WHERE A.Id = @MasterId
		)
		SELECT @BODY = 
			'<p>Dear Mr/Ms: ' + N.LocalName + '. Please view and approve this application follow link bellow</p>'+
			'<table width="95%" align="center" cellpadding="2" cellspacing="1" bgcolor="#F2F2F2" style="font-size: 14px; border: 1px solid #c7c7c7">'+
			  '<tbody>'+
			   '<tr valign="top" bgcolor="#FFFFFF">'+
				  '<td  align="left" width="10%"><b>Application</b></td>'+
				  '<td>'+C.Name+'</td>'+
				'</tr>'+
				'<tr valign="top" bgcolor="#f9f9f9">'+
				  '<td  align="left"><b>Doc No</b></td>'+
				  '<td>' + A.Code + '</td>'+
				'</tr>'+
				'<tr valign="top" bgcolor="#FFFFFF">'+
				  '<td align="left"><b>Creator</b></td>'+
				  N'<td>' + E.LocalName + '</td>'+
				'</tr>'+
				'<tr valign="top" bgcolor="#f9f9f9">'+
				  '<td align="left"><b>Create Date</b></td>'+
				  '<td valign="top"><div>'+CONVERT(VARCHAR, A.CreateDate, 111)+'</div></td>'+
				'</tr>'+
				'<tr valign="top" bgcolor="#FFFFFF">'+
				  '<td colspan="2" align="center"><p style="color: #023aa0; font: Arial; margin: 5px 0;">Click the button bellow to view detail</p>'+
					'<p style="margin:5px 0; background: #F9F9F9;background-image: -webkit-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: -moz-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: -ms-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: -o-linear-gradient(top, #F9F9F9, #EFEFEF);background-image: linear-gradient(to bottom, #F9F9F9, #EFEFEF);-webkit-border-radius: 5;-moz-border-radius: 5;border-radius: 5px;font-family: Arial;color: #323232;padding: 10px 20px 10px 20px;border: solid #c7c7c7 1px;text-decoration: none;width: 100px"><a href="'+@LinkApplication+'">Click View Detail</a></p></td>'+
				'</tr>'+
			  '</tbody>'+
			'</table>'
			, @CCBCC = E.Email 
		FROM GATE.VisitorApplicationMaster A
		INNER JOIN EApproval.ApplicationConfig C ON A.ApplicationType = C.Id
		INNER JOIN HrEmpMaster E ON A.Applicant = E.Code
		LEFT JOIN HrEmpMaster N ON A.NextApprover = N.Code
		WHERE A.Id = @MasterId

		EXEC msdb.dbo.sp_send_dbmail
			@profile_name = 'Hyosung Portal',
			@recipients = @EMAIL,
			@copy_recipients = @CCBCC,
			@body = @BODY,
			@subject = @subject,
			@body_format = 'HTML' ;
	END

	ELSE
	BEGIN
		--CẬP NHẬT THÔNG TIN
		UPDATE GATE.VisitorApplicationMaster 
		SET ApprovalStatus = '9C817780-2079-4417-B87B-B7E537BBAE8A', ConfirmDate = NULL
		WHERE Id = @MasterId
	END

END



GO
/****** Object:  StoredProcedure [GATE].[SP_VISITOR_APPLICATION_MASTER_COPY]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.03
-- Description:	INSERT
-- =============================================
CREATE PROCEDURE [GATE].[SP_VISITOR_APPLICATION_MASTER_COPY]
	-- Add the parameters for the stored procedure here
	@Id INT,
	@ApplicationType int,
	@UserId varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	--ĐẾM SỐ LƯỢNG ĐƠN THEO THÁNG
	DECLARE @COUNT INT = (SELECT COUNT(1) + 1 FROM GATE.VisitorApplicationMaster WHERE ApplicationType = @ApplicationType AND DATEDIFF(MONTH, CreateDate, GETDATE()) = 0)

	DECLARE @CODE VARCHAR(20)
	SET @CODE = (SELECT Code + '-' + CONVERT(VARCHAR(6), CONVERT(DATETIME, GETDATE()), 112) + '-' + REPLICATE('0', 4 - LEN(@COUNT)) + CONVERT(VARCHAR(4), @COUNT)
				FROM EApproval.ApplicationConfig WHERE Id = @ApplicationType)

	---===================================================================================================================================================
	-- COPY VISITOR MASTER
	---===================================================================================================================================================
	DECLARE @MASTERID INT
	INSERT INTO GATE.VisitorApplicationMaster(Code, DeptId, Applicant, PhoneNumber, HandPhoneNumber, ApplicationType, Vendor, Purpose
											,FromDate, ToDate, Gate, Location, LocationOther, Remark, CreateDate, CreateUid, ApprovalKind, ApprovalLine, ApprovalLineJson, ApprovalStatus, NextApprover, Temp)
	SELECT @CODE, DeptId, Applicant, PhoneNumber, HandPhoneNumber, ApplicationType, Vendor, Purpose, FromDate, ToDate, Gate, Location, LocationOther, Remark
		,GETDATE(), @UserId
		,ApprovalKind, ApprovalLine, ApprovalLineJson,'9C817780-2079-4417-B87B-B7E537BBAE8A', NextApprover, 0
	FROM GATE.VisitorApplicationMaster
	WHERE Id = @Id
	
	SET @MASTERID = IDENT_CURRENT('GATE.VisitorApplicationMaster')
	---===================================================================================================================================================
	-- COPY DETAIL
	---===================================================================================================================================================
	IF @ApplicationType = 8 OR @ApplicationType = 9
	BEGIN
		INSERT INTO GATE.VisitorApplicationDetailPerson(ApplicationMaster, Image, FullName, IdentityCard, PhoneNumber, FromDate, ToDate, IsWorkHourOfficial, CreateDate, CreateUid)
		SELECT @MASTERID, Image, FullName, IdentityCard, PhoneNumber, FromDate, ToDate, IsWorkHourOfficial, GETDATE(), @UserId
		FROM GATE.VisitorApplicationDetailPerson
		WHERE ApplicationMaster = @Id AND DeleteUid IS NULL
	
		INSERT INTO GATE.VisitorApplicationDetailVehicle(ApplicationMaster, FromDate, ToDate, DriverPlate, DriverName, PhoneDriver, VehicleType, CreateDate, CreateUid)
		SELECT @MASTERID, FromDate, ToDate, DriverPlate, DriverName, PhoneDriver, VehicleType, GETDATE(), @UserId
		FROM GATE.VisitorApplicationDetailVehicle
		WHERE ApplicationMaster = @Id AND DeleteUid IS NULL
	END
	ELSE IF @ApplicationType = 13
	BEGIN
		INSERT INTO GATE.ContainerDetail(MasterId, VendorId, ContainerNum, FromDate, ToDate, IsImport, CreateDate, CreateUid)
		SELECT @MASTERID, VendorId, ContainerNum, FromDate, ToDate, IsImport, GETDATE(), @UserId
		FROM GATE.ContainerDetail
		WHERE MasterId = @Id AND DeleteUid IS NULL
	END
	
	---===================================================================================================================================================
	-- COPY APPROVAL LINE
	---===================================================================================================================================================
	INSERT INTO EApproval.Approval(ApplicationId, MasterId, EmpId, ApproverType, Seq)
	SELECT ApplicationId, @MASTERID, EmpId, ApproverType, Seq
	FROM EApproval.Approval
	WHERE ApplicationId = @ApplicationType AND MasterId = @Id

	DECLARE @NEXTAPPROVER VARCHAR(20)
	
	-- UPDATE NEXT APPROVER 
	SET @NEXTAPPROVER = (SELECT TOP 1 EmpId FROM EApproval.Approval WHERE ApplicationId = @ApplicationType AND MasterId = @Id)
	UPDATE
	GATE.VisitorApplicationMaster SET NextApprover = @NEXTAPPROVER WHERE Id = @MASTERID

	SELECT 'Ok'
END

GO
/****** Object:  StoredProcedure [GATE].[SP_VISITOR_APPLICATION_MASTER_DELETE]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.03
-- Description:	UPDATE
-- =============================================
CREATE PROCEDURE [GATE].[SP_VISITOR_APPLICATION_MASTER_DELETE]
	-- Add the parameters for the stored procedure here
	@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @TEMP BIT = (SELECT Temp FROM GATE.VisitorApplicationMaster WHERE Id = @Id)
	IF(@TEMP = 1)
	BEGIN
		DELETE GATE.ContainerDetail WHERE MasterId = @Id
		DELETE GATE.VisitorApplicationDetailPerson WHERE ApplicationMaster = @Id
		DELETE GATE.VisitorApplicationDetailVehicle WHERE ApplicationMaster = @Id
		DELETE GATE.VisitorApplicationMaster WHERE Id = @Id AND Temp = 1		
	END
END

GO
/****** Object:  StoredProcedure [GATE].[SP_VISITOR_APPLICATION_MASTER_GET]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.11.20
-- Description:	LẤY LÊN DANH SÁCH VISITOR APPLICATION MASTER
-- =============================================
CREATE PROCEDURE [GATE].[SP_VISITOR_APPLICATION_MASTER_GET]
	-- Add the parameters for the stored procedure here
	@ID INT = null,
	@FROMDATE DATE = '20000101',
	@TODATE DATE = '20990101',
	@APPLICATIONTYPE INT = null,
	@USERID VARCHAR(20) = 'vn55111888',
	@APPROVESTATUS VARCHAR(36) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		
	--DECLARE @DEPTID INT = (
	--	SELECT CASE WHEN D.Level >= 2 THEN NULL ELSE D.Id END
	--	FROM HrEmpMaster E
	--	LEFT JOIN HrDeptMasterFull D ON E.DeptCode = D.Id
	--	WHERE E.Code = @USERID
	--)

	;WITH CATE AS(
		SELECT ID, Name, SubCode 
		FROM SysCategoryValue 
		WHERE Category IN ('2EA2A6A8-0C9A-446A-BA6B-B5197D22A4B8'
							, '418D8192-A87B-4E78-9E46-07CC8FCD36D1'
							, '07643577-62D2-4AA3-83B6-148664A731EF'--PURPOSE
							, '509BA468-CA9B-4A65-9EFB-6E1C5CE977F1')-- GATE
							OR (Category = '054E0F62-4EFE-41E1-A18D-5C28A6531539' and ParentID = 'EAF964F0-F557-40C7-AD06-F0B4A6571A4F')
	)
	, POSTACTION AS (
		SELECT * 
		FROM CmsPostAction 
		WHERE ModuleId = 'A6EF2580-36E6-4D18-8DED-BEF20807293B' AND CategoryId = '95A464F6-6D97-4F9C-B6F3-2D840A5A884C' AND UserId = @USERID
	)
	--, DEPT(ID, NAME, KONAME, PARENTID, LEVEL, Code) AS(
	--		SELECT ID, ENNAME, KONAME, Parent, 0, Code FROM HrDeptMaster
	--		WHERE @DEPTID IS NULL OR Id = @DEPTID
	--		UNION ALL
	--		SELECT B.ID, B.EnName, B.KONAME, B.Parent, A.LEVEL + 1, B.Code FROM DEPT A, HrDeptMaster B
	--		WHERE A.ID = B.Parent AND B.IsDelete = 0
	--)

	SELECT A.Id, A.Code, A.Applicant, E.LocalName ApplicantName, A.PhoneNumber, A.HandPhoneNumber
		,F.OrganizationName OrgName, F.PlantName, F.DeptName, F.SectName
		--, D.FullName ContactPerson, D.PhoneNumber ContactPhoneNumber
		,A.Purpose, P.Name PurposeName, A.LocationOther, A.Location
		,A.Gate--, G.Name GateName
		,A.ApplicationType, T.Name ApplicationTypeName
		,A.FromDate, A.ToDate
		,A.ApprovalKind, C.Name KindName
		,ISNULL(A.ApprovalLineJson, '') ApprovalLineJson
		,ISNULL(A.ApprovalLine, '') ApprovalLine, S.Name ApprovalStatusName, A.ApprovalStatus
		,CASE WHEN ISNULL(A.Location,'') = '' THEN '' ELSE 
			STUFF ((SELECT ', ' + D.EnName+' '
					FROM HrDeptMaster D
					INNER JOIN (SELECT SplitItem, id FROM FN_SplitString(A.Location,',')) SP ON D.Id = SplitItem
					ORDER BY SP.id
					FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)') , 1, 1, '')
				END AS  LocationName
		,CASE WHEN ISNULL(A.Gate,'') = '' THEN '' ELSE 
			STUFF ((SELECT ', ' + G.Name+' '
					FROM CATE G
					INNER JOIN (SELECT SplitItem, id FROM FN_SplitString(A.Gate,'|')) SP ON G.Id = SplitItem
					ORDER BY SP.id
					FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)') , 1, 1, '')
				END AS  GateName
		,A.NextApprover, N.LocalName NextApproverName
		,A.ConfirmDate, A.CreateDate, A.CreateUid, U.LocalName CreateName
		,A.Vendor, V.CompanyName, V.ContactPerson, V.Email ContactEmail, V.PhoneNumber ContactPhone, V.[Address] VendorAddress
		,CASE WHEN I.ActionId IS NOT NULL THEN 1 ELSE 0 END ISVIEW
	FROM GATE.VisitorApplicationMaster A
	LEFT JOIN HrEmpMaster E ON A.Applicant = E.Code
	LEFT JOIN GATE.Vendor V ON A.Vendor = V.Id
	LEFT JOIN EApproval.ApplicationConfig T ON A.ApplicationType = T.Id
	INNER JOIN HrDeptMasterFull F ON A.DeptId = F.Id --AND F.Id IN (SELECT ID FROM DEPT)
	LEFT JOIN CATE P ON A.Purpose = P.ID
	--LEFT JOIN CATE G ON A.Gate = G.ID
	LEFT JOIN CATE C ON A.ApprovalKind = C.ID
	LEFT JOIN CATE S ON A.ApprovalStatus = S.ID
	LEFT JOIN HrEmpMaster N ON N.Code = A.NextApprover
	LEFT JOIN HrEmpMaster U ON U.Code = A.CreateUid
	LEFT JOIN POSTACTION I ON A.Id = I.MasterId
	WHERE 1=1
		AND DATEDIFF(DAY, @FROMDATE , A.CreateDate) >= 0
		AND DATEDIFF(DAY , A.CreateDate, @TODATE) >= 0
		AND A.DeleteUid IS NULL
		AND ((@APPLICATIONTYPE IS NULL AND ApplicationType <> 13) OR A.ApplicationType = @APPLICATIONTYPE)
		AND ((@APPROVESTATUS IS NULL AND (A.CreateUid = @USERID OR A.ApprovalLine  LIKE '%' + @USERID + '%'))
			OR (@APPROVESTATUS IS NOT NULL AND A.ApprovalStatus = @APPROVESTATUS AND (A.CreateUid = @USERID OR A.ApprovalLine  LIKE '%' + @USERID + '%')))
		AND A.Temp = 0
		AND ((A.CreateUid <> @USERID AND A.ApprovalStatus <> '9C817780-2079-4417-B87B-B7E537BBAE8A') OR A.CreateUid = @USERID)
	ORDER BY A.CreateDate DESC
END
--9CB97992-165D-45BF-8575-71230A4163A0	In Process		C4FF5A2F-CD32-4785-9499-A26E5148D58D	Processing
--09B05AF8-057C-4DDA-9DC1-839141DC7DB7	Completed		00F2EC64-CC9B-4FCA-AB4C-B37961EFAD53	Approved
--E01E60C8-EA26-402B-99CD-A06AFCBD9A4E	New Rquest		9C817780-2079-4417-B87B-B7E537BBAE8A	Temporary
--DB3197AE-8220-4492-A6EC-F7C10135FA3C	Rejected		9A96D85B-8189-46BA-84CD-3389FDC501B7	Reject

GO
/****** Object:  StoredProcedure [GATE].[SP_VISITOR_APPLICATION_MASTER_GET_FOR_SECURITY]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.11.20
-- Description:	LẤY LÊN DANH SÁCH VISITOR APPLICATION MASTER
-- =============================================
CREATE PROCEDURE [GATE].[SP_VISITOR_APPLICATION_MASTER_GET_FOR_SECURITY]
	-- Add the parameters for the stored procedure here
	@ID INT = null,
	@FROMDATE DATE = '20000101',
	@TODATE DATE = '20990101',
	@APPLICATIONTYPE INT = NULL,
	@APPROVESTATUS VARCHAR(36) = NULL,
	@USERID VARCHAR(20) = 'LH18040801'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		
	;WITH CATE AS(
		SELECT ID, Name, SubCode 
		FROM SysCategoryValue 
		WHERE Category IN ('2EA2A6A8-0C9A-446A-BA6B-B5197D22A4B8'
							, '418D8192-A87B-4E78-9E46-07CC8FCD36D1'
							, '07643577-62D2-4AA3-83B6-148664A731EF'--PURPOSE
							, '509BA468-CA9B-4A65-9EFB-6E1C5CE977F1')-- GATE
							OR (Category = '054E0F62-4EFE-41E1-A18D-5C28A6531539' and ParentID = 'EAF964F0-F557-40C7-AD06-F0B4A6571A4F')
	)
	, POSTACTION AS (
		SELECT * 
		FROM CmsPostAction 
		WHERE ModuleId = 'A6EF2580-36E6-4D18-8DED-BEF20807293B' AND CategoryId = '95A464F6-6D97-4F9C-B6F3-2D840A5A884C' AND UserId = @USERID
	)

	SELECT A.Id, A.Code, A.Applicant, E.LocalName ApplicantName, A.PhoneNumber, A.HandPhoneNumber
		,F.OrganizationName OrgName, F.PlantName, F.DeptName, F.SectName
		--, D.FullName ContactPerson, D.PhoneNumber ContactPhoneNumber
		,A.Purpose, P.Name PurposeName, A.LocationOther, A.Location
		,A.Gate, G.Name GateName
		,A.ApplicationType, T.Name ApplicationTypeName
		,A.FromDate, A.ToDate
		,A.ApprovalKind, C.Name KindName
		,ISNULL(A.ApprovalLineJson, '') ApprovalLineJson
		,ISNULL(A.ApprovalLine, '') ApprovalLine, S.Name ApprovalStatusName, A.ApprovalStatus
		,CASE WHEN ISNULL(A.Location,'') = '' THEN '' ELSE 
			STUFF ((SELECT ', ' + D.EnName+' '
					FROM HrDeptMaster D
					INNER JOIN (SELECT SplitItem, id FROM FN_SplitString(A.Location,',')) SP ON D.Id = SplitItem
					ORDER BY SP.id
					FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)') , 1, 1, '')
				END AS  LocationName
		,A.NextApprover, N.LocalName NextApproverName
		,A.ConfirmDate, A.CreateDate, A.CreateUid, U.LocalName CreateName
		,A.Vendor, V.CompanyName, V.ContactPerson, V.Email ContactEmail, V.PhoneNumber ContactPhone, V.[Address] VendorAddress, V.TermsOfUse
		,CASE WHEN I.ActionId IS NOT NULL THEN 1 ELSE 0 END ISVIEW
	FROM GATE.VisitorApplicationMaster A
	LEFT JOIN HrEmpMaster E ON A.Applicant = E.Code
	LEFT JOIN GATE.Vendor V ON A.Vendor = V.Id
	LEFT JOIN EApproval.ApplicationConfig T ON A.ApplicationType = T.Id
	LEFT JOIN HrDeptMasterFull F ON A.DeptId = F.Id
	LEFT JOIN CATE P ON A.Purpose = P.ID
	LEFT JOIN CATE G ON A.Gate = G.ID
	LEFT JOIN CATE C ON A.ApprovalKind = C.ID
	LEFT JOIN CATE S ON A.ApprovalStatus = S.ID
	LEFT JOIN HrEmpMaster N ON N.Code = A.NextApprover
	LEFT JOIN HrEmpMaster U ON U.Code = A.CreateUid
	LEFT JOIN POSTACTION I ON A.Id = I.MasterId
	WHERE 1=1
		AND DATEDIFF(DAY, @FROMDATE , A.CreateDate) >= 0
		AND DATEDIFF(DAY , A.CreateDate, @TODATE) >= 0
		AND A.DeleteUid IS NULL
		AND (@APPLICATIONTYPE IS NULL OR (@APPLICATIONTYPE IS NOT NULL AND A.ApplicationType = @APPLICATIONTYPE))
		AND ((@APPROVESTATUS IS NULL)
			OR (@APPROVESTATUS IS NOT NULL AND A.ApprovalStatus = @APPROVESTATUS ))
		AND A.Temp = 0
		--CHỈ LẤY NHỮNG ĐƠN NÀO CÒN HIỆU LỰC
		AND DATEDIFF(DAY, A.FromDate, GETDATE()) >= 0
		AND DATEDIFF(DAY, GETDATE() , A.ToDate) >= 0
		--AND A.ApplicationType = 8
	ORDER BY A.CreateDate DESC
END
--9CB97992-165D-45BF-8575-71230A4163A0	In Process		C4FF5A2F-CD32-4785-9499-A26E5148D58D	Processing
--09B05AF8-057C-4DDA-9DC1-839141DC7DB7	Completed		00F2EC64-CC9B-4FCA-AB4C-B37961EFAD53	Approved
--E01E60C8-EA26-402B-99CD-A06AFCBD9A4E	New Rquest		9C817780-2079-4417-B87B-B7E537BBAE8A	Temporary
--DB3197AE-8220-4492-A6EC-F7C10135FA3C	Rejected		9A96D85B-8189-46BA-84CD-3389FDC501B7	Reject

GO
/****** Object:  StoredProcedure [GATE].[SP_VISITOR_APPLICATION_MASTER_GETDETAIL]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.11.20
-- Description:	LẤY LÊN DANH SÁCH VISITOR APPLICATION MASTER
-- =============================================
CREATE PROCEDURE [GATE].[SP_VISITOR_APPLICATION_MASTER_GETDETAIL]
	-- Add the parameters for the stored procedure here
	@ID INT = 721,
	@USERID VARCHAR(20) = 'vn55104937'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
	--KIỂM TRA XEM NGƯỜI ĐĂNG NHẬP ĐÃ XEM ĐƠN NÀY CHƯA?
	IF NOT EXISTS (SELECT 1 FROM CmsPostAction WHERE ModuleId = 'A6EF2580-36E6-4D18-8DED-BEF20807293B' AND CategoryId = '95A464F6-6D97-4F9C-B6F3-2D840A5A884C' AND MasterId = @ID AND UserId = @USERID)
	BEGIN
		INSERT INTO CmsPostAction (ModuleId, CategoryId, MasterId, UserId, ActionDate)
		VALUES ('A6EF2580-36E6-4D18-8DED-BEF20807293B', '95A464F6-6D97-4F9C-B6F3-2D840A5A884C', @ID, @USERID, GETDATE())
	END

	DECLARE @ISRECALL BIT = 0
	
	DECLARE @APPLICATIONID INT, @CREAEUID VARCHAR(20), @CONFIRMDATE DATETIME, @FIRSTAPPROVER VARCHAR(20), @FIRSTAPPROVERSTATUS BIT, @NEXTAPPROVER VARCHAR(20)
	--LẤY RA THÔNG TIN CỦA ĐƠN
	SELECT @APPLICATIONID = ApplicationType, @CREAEUID = CreateUid, @CONFIRMDATE = ConfirmDate, @NEXTAPPROVER = NextApprover
	FROM GATE.VisitorApplicationMaster WHERE Id = @ID
	--LẤY RA THÔNG TIN NGƯỜI ĐẦU TIÊN APPROVE
	SELECT TOP 1 @FIRSTAPPROVER = EmpId, @FIRSTAPPROVERSTATUS = IsApprove
	FROM EApproval.Approval 
	WHERE ApplicationId = @APPLICATIONID AND MasterId = @ID
	ORDER BY Seq

	--LẤY RA THÔNG TIN NGƯỜI HIỆN TẠI
	DECLARE @APPROVESTATUS BIT, @SEQ TINYINT
	SELECT @APPROVESTATUS = IsApprove, @SEQ = Seq 
	FROM EApproval.Approval 
	WHERE ApplicationId = @APPLICATIONID AND MasterId = @ID AND EmpId = @USERID

	--LẤY RA THÔNG TIN NGƯỜI APPROVE KẾ TIẾP
	DECLARE @NEXTAPPROVESTATUS BIT, @NEXTSEQ TINYINT
	SELECT @NEXTAPPROVESTATUS = IsApprove, @NEXTSEQ = Seq 
	FROM EApproval.Approval 
	WHERE ApplicationId = @APPLICATIONID AND MasterId = @ID AND EmpId = @NEXTAPPROVER 

	--NHỮNG TRƯỜNG HỢP ĐƯỢC PHÉP RECALL:
	--1. LÀ NGƯỜI TẠO ĐÃ CONFIRM VÀ NGƯỜI ĐẦU TIÊN CHƯA APPROVE
		--1.1 LÀ NGƯỜI TẠO:@USERID = CREATEUID
		--1.2 ĐÃ CONFIRM: CONFIRMDATE: IS NOT NULL
		--1.3 NGƯỜI ĐẦU TIÊN CHƯA APPROVE: @ISAPPROVE: NULL
	--2. LÀ NGƯỜI ĐÃ APPR RỒI, VÀ NGƯỜI TIẾP THEO APPR(@NEXTSEQ - @SEQ = 1) PHẢI CHƯA APPR
		--2.1 LÀ NGƯỜI ĐÃ APPROVE RỒI (ISAPPROVE = 1)
		--2.1 NGƯỜI NÀY VÀ NGƯỜI KẾ TIẾP PHẢI NẰM SÁT NHAU: @NEXTSEQ - @SEQ = 1
		--2.3 THẰNG KẾ TIẾP PHẢI CHƯA APPROVE: @NEXTAPPROVESTATUS = NULL

	IF (@USERID = @CREAEUID AND @CONFIRMDATE IS NOT NULL AND @FIRSTAPPROVERSTATUS IS NULL)
		SET @ISRECALL = 1
	IF @APPROVESTATUS = 1 AND @NEXTAPPROVESTATUS IS NULL AND (@NEXTSEQ - @SEQ = 1)
		SET @ISRECALL = 1


	;WITH CATE AS(
		SELECT ID, Name, SubCode 
		FROM SysCategoryValue 
		WHERE Category IN ('2EA2A6A8-0C9A-446A-BA6B-B5197D22A4B8'
							, '418D8192-A87B-4E78-9E46-07CC8FCD36D1'
							, '07643577-62D2-4AA3-83B6-148664A731EF'--PURPOSE
							, '509BA468-CA9B-4A65-9EFB-6E1C5CE977F1')-- GATE
							OR (Category = '054E0F62-4EFE-41E1-A18D-5C28A6531539' and ParentID = 'EAF964F0-F557-40C7-AD06-F0B4A6571A4F')
	)

	SELECT A.Id, A.Code, A.Applicant, E.LocalName ApplicantName, A.PhoneNumber, A.HandPhoneNumber
		,F.OrganizationName OrgName, F.PlantName, F.DeptName, F.SectName
		--, D.FullName ContactPerson, D.PhoneNumber ContactPhoneNumber
		,A.Purpose, P.Name PurposeName, A.LocationOther, A.Location
		,A.Gate--, G.Name GateName
		,A.ApplicationType, T.Name ApplicationTypeName
		,A.FromDate, A.ToDate
		,A.ApprovalKind, C.Name KindName
		,ISNULL(A.ApprovalLineJson, '') ApprovalLineJson
		,ISNULL(A.ApprovalLine, '') ApprovalLine, S.Name ApprovalStatusName, A.ApprovalStatus
		,CASE WHEN ISNULL(A.Location,'') = '' THEN '' ELSE 
			STUFF ((SELECT ', ' + D.EnName+' '
					FROM HrDeptMaster D
					INNER JOIN (SELECT SplitItem, id FROM FN_SplitString(A.Location,',')) SP ON D.Id = SplitItem
					ORDER BY SP.id
					FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)') , 1, 1, '')
				END AS  LocationName
		,CASE WHEN ISNULL(A.Location,'') = '' THEN '' ELSE 
			STUFF ((SELECT ',' + '[' + D.Code + '] ' + D.EnName COLLATE SQL_Latin1_General_CP1_CI_AS +' '
					FROM HrDeptMaster D
					INNER JOIN (SELECT SplitItem, id FROM FN_SplitString(A.Location,',')) SP ON D.Id = SplitItem
					ORDER BY SP.id
					FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)') , 1, 1, '')
				END AS  LocationDeptName
		,CASE WHEN ISNULL(A.Gate,'') = '' THEN '' ELSE 
			STUFF ((SELECT ', ' + G.Name+' '
					FROM CATE G
					INNER JOIN (SELECT SplitItem, id FROM FN_SplitString(A.Gate,'|')) SP ON G.Id = SplitItem
					ORDER BY SP.id
					FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)') , 1, 1, '')
				END AS  GateName
		,A.NextApprover, N.LocalName NextApproverName
		,A.ConfirmDate, A.CreateDate, A.CreateUid, U.LocalName CreateName
		,A.Vendor, V.CompanyName, V.ContactPerson, V.Email ContactEmail, V.PhoneNumber ContactPhone, V.[Address] VendorAddress
		,@ISRECALL IsRecall, A.Remark
	FROM GATE.VisitorApplicationMaster A
	LEFT JOIN HrEmpMaster E ON A.Applicant = E.Code
	--LEFT JOIN GATE.VisitorApplicationDetail D ON A.Id = D.ApplicationMaster AND D.IsContactPerson = 1
	LEFT JOIN GATE.Vendor V ON A.Vendor = V.Id
	LEFT JOIN EApproval.ApplicationConfig T ON A.ApplicationType = T.Id
	LEFT JOIN HrDeptMasterFull F ON A.DeptId = F.Id
	LEFT JOIN CATE P ON A.Purpose = P.ID
	LEFT JOIN CATE G ON A.Gate = G.ID
	LEFT JOIN CATE C ON A.ApprovalKind = C.ID
	LEFT JOIN CATE S ON A.ApprovalStatus = S.ID
	LEFT JOIN HrEmpMaster N ON N.Code = A.NextApprover
	LEFT JOIN HrEmpMaster U ON U.Code = A.CreateUid 
	WHERE A.Id = @ID		
	ORDER BY A.CreateDate DESC
END

GO
/****** Object:  StoredProcedure [GATE].[SP_VISITOR_APPLICATION_MASTER_INSERT]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.03
-- Description:	INSERT
-- =============================================
CREATE PROCEDURE [GATE].[SP_VISITOR_APPLICATION_MASTER_INSERT]
	-- Add the parameters for the stored procedure here
	@DeptId INT,
	@Applicant varchar(20),
	@PhoneNumber varchar(20),
	@HandPhoneNumber varchar(20),
	@ApplicationType int,
	@Vendor int,
	@Purpose varchar(36),
	@FromDate datetime,
	@ToDate datetime,
	@Gate varchar(1000),
	@Location varchar(300),
	@LocationOther nvarchar(200),
	@Remarke nvarchar(500),
	@UserId varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	--ĐẾM SỐ LƯỢNG ĐƠN THEO THÁNG, CHỈ TÍNH NHỮNG CÁI NÀO KHÔNG PHẢI LÀ ĐƠN LƯU TẠM
	DECLARE @COUNT INT = (SELECT COUNT(1) + 1 FROM GATE.VisitorApplicationMaster WHERE ApplicationType = @ApplicationType AND DATEDIFF(MONTH, CreateDate, GETDATE()) = 0)

	DECLARE @CODE VARCHAR(20)
	SET @CODE = (SELECT Code + '-' + CONVERT(VARCHAR(6), CONVERT(DATETIME, GETDATE()), 112) + '-' + REPLICATE('0', 4 - LEN(@COUNT)) + CONVERT(VARCHAR(4), @COUNT)
				FROM EApproval.ApplicationConfig WHERE Id = @ApplicationType)

	INSERT INTO GATE.VisitorApplicationMaster(Code, DeptId, Applicant, PhoneNumber, HandPhoneNumber, ApplicationType, Vendor, Purpose
											,FromDate, ToDate, Gate, Location, LocationOther, Remark, CreateDate, CreateUid, Temp)
	VALUES(@CODE, @DeptId, @Applicant, @PhoneNumber, @HandPhoneNumber, @ApplicationType, @Vendor, @Purpose,
		@FromDate, @ToDate, @Gate, @Location, @LocationOther, @Remarke, GETDATE(), @UserId, 1)

	SELECT SCOPE_IDENTITY()	
END

GO
/****** Object:  StoredProcedure [GATE].[SP_VISITOR_APPLICATION_MASTER_ISSUED_GET]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2018.04.18
-- Description:	LẤY LÊN DANH SÁCH ĐƠN DÀI HẠN ĐỂ CẤP THẺ
-- =============================================
CREATE PROCEDURE [GATE].[SP_VISITOR_APPLICATION_MASTER_ISSUED_GET]
	-- Add the parameters for the stored procedure here
	@FROMDATE DATE = '20000101',
	@TODATE DATE = '20990101',
	@USERID VARCHAR(20) = 'vn55111888'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	;WITH CATE AS(
		SELECT ID, Name, SubCode 
		FROM SysCategoryValue 
		WHERE Category IN ('2EA2A6A8-0C9A-446A-BA6B-B5197D22A4B8'
							, '418D8192-A87B-4E78-9E46-07CC8FCD36D1'
							, '07643577-62D2-4AA3-83B6-148664A731EF'--PURPOSE
							, '509BA468-CA9B-4A65-9EFB-6E1C5CE977F1')-- GATE
							OR (Category = '054E0F62-4EFE-41E1-A18D-5C28A6531539' and ParentID = 'EAF964F0-F557-40C7-AD06-F0B4A6571A4F')
	), VISITOR AS (
		SELECT COUNT(CASE WHEN VisitorCard IS NOT NULL THEN 1 ELSE NULL END) NumIssued, COUNT(1) Total, ApplicationMaster
		FROM GATE.VisitorApplicationDetailPerson
		WHERE DeleteUid IS NULL
		GROUP BY ApplicationMaster
	), VEHICLE AS (
		SELECT COUNT(CASE WHEN VehicleCard IS NOT NULL THEN 1 ELSE NULL END) NumIssued, COUNT(1) Total, ApplicationMaster
		FROM GATE.VisitorApplicationDetailVehicle
		WHERE DeleteUid IS NULL
		GROUP BY ApplicationMaster
	)
	SELECT A.Id, A.Code, A.Applicant, E.LocalName ApplicantName, A.PhoneNumber, A.HandPhoneNumber
		,F.OrganizationName OrgName, F.PlantName, F.DeptName, F.SectName
		,A.Purpose, P.Name PurposeName, A.LocationOther, A.Location
		,A.Gate--, G.Name GateName
		,A.ApplicationType, T.Name ApplicationTypeName
		,A.FromDate, A.ToDate
		,CASE WHEN ISNULL(A.Location,'') = '' THEN '' ELSE 
			STUFF ((SELECT ', ' + D.EnName+' '
					FROM HrDeptMaster D
					INNER JOIN (SELECT SplitItem, id FROM FN_SplitString(A.Location,',')) SP ON D.Id = SplitItem
					ORDER BY SP.id
					FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)') , 1, 1, '')
				END AS  LocationName
		,A.ConfirmDate, A.CreateDate, A.CreateUid, U.LocalName CreateName
		,A.Vendor, V.CompanyName, V.ContactPerson, V.Email ContactEmail, V.PhoneNumber ContactPhone, V.[Address] VendorAddress
		,ISNULL(O.Total, 0) TotalVisitor, ISNULL(O.NumIssued, 0) NumIssuedVisitor
		,ISNULL(C.Total, 0) ToTalVehicle, ISNULL(C.NumIssued, 0) NumIssuedVehicle
		,A.IsSendMail
	FROM GATE.VisitorApplicationMaster A
	LEFT JOIN HrEmpMaster E ON A.Applicant = E.Code
	LEFT JOIN GATE.Vendor V ON A.Vendor = V.Id
	LEFT JOIN EApproval.ApplicationConfig T ON A.ApplicationType = T.Id
	INNER JOIN HrDeptMasterFull F ON A.DeptId = F.Id
	LEFT JOIN CATE P ON A.Purpose = P.ID
	LEFT JOIN HrEmpMaster U ON U.Code = A.CreateUid
	LEFT JOIN VEHICLE C ON A.Id = C.ApplicationMaster
	LEFT JOIN VISITOR O ON A.Id = O.ApplicationMaster
	WHERE 1=1
		AND DATEDIFF(DAY, @FROMDATE , A.CreateDate) >= 0
		AND DATEDIFF(DAY , A.CreateDate, @TODATE) >= 0
		AND A.DeleteUid IS NULL
		AND A.ApprovalStatus = '00F2EC64-CC9B-4FCA-AB4C-B37961EFAD53'
		AND A.ApplicationType = 9
	ORDER BY A.CreateDate DESC
END
--9CB97992-165D-45BF-8575-71230A4163A0	In Process		C4FF5A2F-CD32-4785-9499-A26E5148D58D	Processing
--09B05AF8-057C-4DDA-9DC1-839141DC7DB7	Completed		00F2EC64-CC9B-4FCA-AB4C-B37961EFAD53	Approved
--E01E60C8-EA26-402B-99CD-A06AFCBD9A4E	New Rquest		9C817780-2079-4417-B87B-B7E537BBAE8A	Temporary
--DB3197AE-8220-4492-A6EC-F7C10135FA3C	Rejected		9A96D85B-8189-46BA-84CD-3389FDC501B7	Reject

GO
/****** Object:  StoredProcedure [GATE].[SP_VISITOR_APPLICATION_MASTER_RECALL]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20170830
-- Description:	RECALL LẠI ĐƠN VỪA APPROVE
-- =============================================
CREATE PROCEDURE [GATE].[SP_VISITOR_APPLICATION_MASTER_RECALL]
	@MasterId int = 42,
	@ApplicationId int = 6,
	@UserId varchar(20) = 'vn55141027'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @NEXTAPPROVER VARCHAR(20)
	SELECT @NEXTAPPROVER = NextApprover FROM GATE.VisitorApplicationMaster WHERE Id = @MasterId

	--KIỂM TRA XEM NGƯỜI NÀY ĐÃ APPROVE CHƯA, CHƯA APPROVE THÌ MỚI CHO RECALL
	IF EXISTS (SELECT 1 FROM EApproval.Approval WHERE ApplicationId = @ApplicationId AND MasterId = @MasterId AND EmpId = @NEXTAPPROVER AND IsApprove IS NULL)
	BEGIN
		--select * from EApproval.Approval WHERE ApplicationId = @ApplicationId AND MasterId = @MasterId  AND EmpId = @UserId
		UPDATE EApproval.Approval 
		SET IsApprove = NULL, DateApprove = NULL, Comment = NULL
		WHERE ApplicationId = @ApplicationId AND MasterId = @MasterId AND EmpId = @UserId --AND IsApprove IS NULL

		--CẬP NHẬT BÊN BẢNG MASTER NỮA
		UPDATE GATE.VisitorApplicationMaster SET NextApprover = @UserId WHERE Id = @MasterId
	END
END



GO
/****** Object:  StoredProcedure [GATE].[SP_VISITOR_APPLICATION_MASTER_UPDATE]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.03
-- Description:	UPDATE
-- =============================================
CREATE PROCEDURE [GATE].[SP_VISITOR_APPLICATION_MASTER_UPDATE]
	-- Add the parameters for the stored procedure here
	@Id int,
	@DeptId INT,
	@Applicant varchar(20),
	@PhoneNumber varchar(20),
	@HandPhoneNumber varchar(20),
	@ApplicationType int,
	@Vendor int,
	@Purpose varchar(36),
	@FromDate datetime,
	@ToDate datetime,
	@Gate varchar(1000),
	@Location varchar(300),
	@LocationOther nvarchar(200),
	@Remarke nvarchar(500),
	@UserId varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	UPDATE GATE.VisitorApplicationMaster
	SET DeptId = @DeptId, Applicant = @Applicant, PhoneNumber = @PhoneNumber, HandPhoneNumber = @HandPhoneNumber,
		Vendor = @Vendor, Purpose = @Purpose, FromDate = @FromDate, ToDate = @ToDate, Gate = @Gate, Location = @Location, 
		LocationOther = @LocationOther, Remark = @Remarke, UpdateDate = GETDATE(), UpdateUId = @UserId
	WHERE Id = @Id
END

GO
/****** Object:  StoredProcedure [GATE].[SP_VISITOR_APPLICATION_MASTER_UPDATE_ALLDATA]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.03
-- Description:	CẬP NHẬT LẠI TẤT CẢ DỮ LIỆU SAU KHI NGƯỜI DÙNG NHẤN SAVE
-- ==========================================================================================
CREATE PROCEDURE [GATE].[SP_VISITOR_APPLICATION_MASTER_UPDATE_ALLDATA]
	-- Add the parameters for the stored procedure here
	@Id int = 126,
	@ApplicationId int = 8,
	@ApprovalLine nvarchar(2000) = 'vn55111704_vd52170013|Võ Công Danh > Lê Huỳnh Duy|E408D53D-6E62-4D63-A3D4-CD3EA9A14D36_E408D53D-6E62-4D63-A3D4-CD3EA9A14D36',
	@ApprovalLineJson nvarchar(4000) = '[{"EmpId":"vn55111704","Name":"Võ Công Danh","DeptFullName":"Hyosung Vietnam > Main Office > IT > Information System","ApproverType":"E408D53D-6E62-4D63-A3D4-CD3EA9A14D36","ApproverTypeName":"Approver","Seq":1},{"EmpId":"vd52170013","Name":"Lê Huỳnh Duy","DeptFullName":"Hyosung Dong Nai > Main Office > IT","ApproverType":"E408D53D-6E62-4D63-A3D4-CD3EA9A14D36","ApproverTypeName":"Approver","Seq":2}]|[{"EmpId":"vn55110755","EmpName":"Đỗ Thị Hồng Chăm"}]',
	@UserId varchar(20) = 'vn55160524'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	--LẤY RA DỮ LIỆU THÔ CỦA APPROVAL LINE
	DECLARE @TB_RAW TABLE(Id int, Content varchar(500))
	INSERT INTO @TB_RAW
	SELECT * FROM FN_SplitString(@ApprovalLine,'|')

	--TÁCH MÃ NHÂN VIÊN TRƯỚC
	DECLARE @TB_RAW_EMPID TABLE(Id INT, EmpId VARCHAR(20))
	INSERT INTO @TB_RAW_EMPID 
	SELECT * FROM FN_SplitString((SELECT Content FROM @TB_RAW WHERE Id = 1), '_')

	--TÁCH LOẠI NGƯỜI APPROVE
	DECLARE @TB_RAW_APPROVETYPE TABLE(Id INT, [Type] UNIQUEIDENTIFIER)
	INSERT INTO @TB_RAW_APPROVETYPE 
	SELECT * FROM FN_SplitString((SELECT Content FROM @TB_RAW WHERE Id = 3), '_')

	DECLARE @NextApprover VARCHAR(20)
	SET @NextApprover = (SELECT EmpId FROM @TB_RAW_EMPID WHERE Id = 1)

	--XÓA ĐI DỮ LIỆU CŨ
	DELETE EApproval.ApprovalHistory
	WHERE ApplicationId = @ApplicationId AND MasterId = @Id

	DELETE EApproval.Approval
	WHERE ApplicationId = @ApplicationId AND MasterId = @Id

	--THÊM VÀO BẢNG APPROVAL HISTORY
	INSERT INTO EApproval.ApprovalHistory
	SELECT @ApprovalLine, @ApprovalLineJson, @ApplicationId, @Id, @UserId, GETDATE()			

	--THÊM VÀO BẢNG APPROVAL
	INSERT INTO EApproval.Approval(ApplicationId, MasterId, EmpId, ApproverType, Seq)
	SELECT @ApplicationId, @Id, A.EmpId, B.Type, A.Id
	FROM @TB_RAW_EMPID A
	LEFT JOIN @TB_RAW_APPROVETYPE B ON A.Id = B.Id

	UPDATE GATE.VisitorApplicationMaster 
	SET Temp = 0, NextApprover = @NextApprover, ApprovalStatus = '9C817780-2079-4417-B87B-B7E537BBAE8A', 
		ApprovalKind = '2600C4A7-CFB3-4E08-A08D-EDF0C1D99A71',--TẠM THỜI CHỈ LÀM CHỨC NĂNG ORDER TRƯỚC
		ApprovalLine = @ApprovalLine,
		ApprovalLineJson = @ApprovalLineJson
	WHERE Id = @Id
	
END

GO
/****** Object:  StoredProcedure [GATE].[SP_VISITOR_GET]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 20171223
-- Description:	LẤY LÊN DANH SÁCH VISITOR
-- =============================================
CREATE PROCEDURE [GATE].[SP_VISITOR_GET]
	-- Add the parameters for the stored procedure here
	@ID INT,
	@IDENTITYCARD VARCHAR(15),
	@VENDORID INT,
	@FROMDATE DATE = '20170101',
	@TODATE DATE = '20171231'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	;WITH CATE AS(
		SELECT ID, Name, SubCode 
		FROM SysCategoryValue 
		WHERE Category IN ('AED27DE5-1310-4A02-997B-87A6EF9686BD')
	)

    SELECT A.Id, A.IdentityCard, A.FullName, A.ApplicationMaster, A.PhoneNumber, A.FromDate, A.ToDate
		, A.IsWorkHourOfficial, A.CreateUid, A.CreateDate, D.LocalName CreateName, B.Vendor, E.CompanyName
	FROM GATE.VisitorApplicationDetailPerson A
	LEFT JOIN GATE.VisitorApplicationMaster B ON A.ApplicationMaster = B.Id 	
	--LEFT JOIN CATE C ON A.VehicleType = C.ID
	LEFT JOIN HrEmpMaster D ON A.CreateUid = D.Code
	LEFT JOIN GATE.Vendor E ON B.Vendor = E.Id
	WHERE 1=1
		AND (@VENDORID IS NULL OR A.ApplicationMaster = @VENDORID)
		AND (@IDENTITYCARD IS NULL OR A.IdentityCard = @IDENTITYCARD)
		AND DATEDIFF(DAY, @FROMDATE , A.CreateDate) >= 0
		AND DATEDIFF(DAY , A.CreateDate, @TODATE) >= 0
		AND A.DeleteUid IS NULL
	ORDER BY B.Vendor
END

GO
/****** Object:  StoredProcedure [GATE].[SP_VISITOR_LONGTERM_SENDMAIL]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2018.07.05
-- Description:	GỬI MAIL THẺ KHÁCH VÀ XE
-- =============================================
CREATE PROCEDURE [GATE].[SP_VISITOR_LONGTERM_SENDMAIL]
	-- Add the parameters for the stored procedure here
	@MASTERID INT = 1766,
	@UserId varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @EMAIL VARCHAR(1000) = '', @CCBCC VARCHAR(1000), @BODY NVARCHAR(MAX) = '', @SUBJECT NVARCHAR(MAX) = ''
	DECLARE @TBBODY NVARCHAR(MAX) = '<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=0 style="width:346.25pt;margin-left:-.15pt;border-collapse:collapse">
				<tr style="height:15.0pt">
					<td width=51 nowrap valign=bottom style="width:150.55pt;border:solid windowtext 1.0pt;background:#70AD47;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
						<p class=MsoNormal><b><span style="color:white">Name<o:p></o:p></span></b></p>
					</td>
					<td width=104 nowrap valign=bottom style="width:90.2pt;border:solid windowtext 1.0pt;border-left:none;background:#70AD47;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
						<p class=MsoNormal><b><span style="color:white">Identity Card<o:p></o:p></span></b></p>
					</td>
					<td width=96 nowrap valign=bottom style="width:1.0in;border:solid windowtext 1.0pt;border-left:none;background:#70AD47;padding:0in 5.4pt 0in 5.4pt;height:15.0pt"><p class=MsoNormal><b><span style="color:white">From Date<o:p></o:p></span></b></p></td>
					<td width=109 nowrap valign=bottom style="width:81.8pt;border:solid windowtext 1.0pt;border-left:none;background:#70AD47;padding:0in 5.4pt 0in 5.4pt;height:15.0pt"><p class=MsoNormal><b><span style="color:white">To Date<o:p></o:p></span></b></p></td>
					<td width=101 nowrap valign=bottom style="width:75.7pt;border:solid windowtext 1.0pt;border-left:none;background:#70AD47;padding:0in 5.4pt 0in 5.4pt;height:15.0pt"><p class=MsoNormal><b><span style="color:white">Visitor Card<o:p></o:p></span></b></p></td>
				</tr>'
	DECLARE @TBFOOTER NVARCHAR(MAX) = '</table>'

	SET @EMAIL = 
			--(SELECT Email
			--FROM GATE.VisitorApplicationMaster A
			--LEFT JOIN HrEmpMaster E ON A.CreateUid = E.Code
			--WHERE Id = @MASTERID)		
	'nghia55160524@hyosung.com'

	SET @CCBCC = (SELECT Email FROM HrEmpMaster WHERE Code = @UserId)

	SET @SUBJECT = '[Hyosung Portal] Access card number for long term applications'
	SELECT @BODY =
	STUFF ((SELECT '' + '
				<tr style="height:15.0pt">
					<td width=51 nowrap valign=bottom style="width:38.55pt;border:solid windowtext 1.0pt;border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
						<p class=MsoNormal><span style="color:black"></span>' + FullName + ' 
						</p>
					</td>
					<td width=104 nowrap valign=bottom style="width:78.2pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
						<p class=MsoNormal><span style="color:black"></span> '+ IdentityCard +'
						</p>
					</td>
					<td width=96 nowrap valign=bottom style="width:1.0in;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
						<p class=MsoNormal><span style="color:black"></span>'+CONVERT(VARCHAR(10), FromDate, 102)+'
						</p>
					</td>
					<td width=109 nowrap valign=bottom style="width:81.8pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
						<p class=MsoNormal><span style="color:black"></span>'+CONVERT(VARCHAR(10), ToDate, 102)+'
						</p>
					</td>
					<td width=101 nowrap valign=bottom style="width:75.7pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
						<p class=MsoNormal><span style="color:black"></span>'+ISNULL(VisitorCard, '')+'
						</p>
					</td>
				</tr>'
		
	FROM GATE.VISITORAPPLICATIONDETAILPERSON WHERE APPLICATIONMASTER = @MASTERID
	FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)') , 1, 1, '') 


	SET @BODY = @TBBODY + @BODY + @TBFOOTER

	EXEC msdb.dbo.sp_send_dbmail
		@profile_name = 'Hyosung Portal',
		@recipients = @EMAIL,
		@copy_recipients = @CCBCC,
		@body = @BODY,
		@subject = @subject,
		@body_format = 'HTML',
		@importance = 'HIGH',
		@file_attachments= N'D:\www\ForgetCardTest\Resource\Template\Visitor Card Template.xlsx' ;

	UPDATE GATE.VisitorApplicationMaster SET IsSendMail = 1 WHERE Id = @MASTERID

END

GO
/****** Object:  StoredProcedure [GATE].[SP_VISITOR_WORKINGDAILY_GET]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.17
-- Description:	MOOD LIKE SHIT
-- =============================================
CREATE PROCEDURE [GATE].[SP_VISITOR_WORKINGDAILY_GET]
	-- Add the parameters for the stored procedure here
	@ApplicationMasterId int = NULL,
	@Workdate date = '2018.04.27',
	@IsCheckOut bit = 1,
	@GateId varchar(36) = '7534158d-4896-4721-95a6-3ee1a4413148',
	@ApplicationType int = 8,

	@UserId varchar(20) = null,
	@ApprovalStatus varchar(36) = '00F2EC64-CC9B-4FCA-AB4C-B37961EFAD53'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	WITH DETAIL AS (
		SELECT COUNT(1) NumCheck, VisitorId
		FROM GATE.VisitorWorkingDaily
		GROUP BY VisitorId
	)
    -- Insert statements for procedure here
	SELECT A.Id Id, A.FullName, A.IdentityCard, A.PhoneNumber, A.FromDate, A.ToDate, ISNULL(A.[Image], '') [Image]
		,M.Gate GateRegis--, R.Name GateNameRegis
		,A.IsWorkHourOfficial, M.Vendor, D.CompanyName, D.TermsOfUse
		,ISNULL(CASE WHEN IsCheckIn = 1 THEN W.VisitorCard ELSE NULL END, A.VisitorCard) VisitorCard, M.ApplicationType

		,CASE WHEN A.IsWorkHourOfficial = 1 THEN 'Y' ELSE 'N' END IsWorkHourOfficialName
		,CASE WHEN ISNULL(M.Gate,'') = '' THEN '' ELSE 
			STUFF ((SELECT ', ' + G.Name+' '
					FROM SysCategoryValue G
					INNER JOIN (SELECT SplitItem, id FROM FN_SplitString(M.Gate,'|')) SP ON G.Id = SplitItem
					 ORDER BY SP.id
					FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)') , 1, 1, '')
				END AS  GateNameRegis
		,W.IsCheckIn, L.NumCheck, M.Code
	FROM GATE.VisitorApplicationDetailPerson A
	LEFT JOIN GATE.VisitorApplicationMaster M ON A.ApplicationMaster = M.Id		
	LEFT JOIN SysCategoryValue R ON M.Gate = R.ID	

	OUTER APPLY (
		SELECT TOP 1 VisitorId, VisitorCard, GateId, IsCheckIn
		FROM GATE.VisitorWorkingDaily 
		WHERE A.Id = VisitorId 
		ORDER BY CreateDate DESC
	) W 
	LEFT JOIN GATE.Vendor D ON M.Vendor = D.Id
	LEFT JOIN DETAIL L ON A.Id = L.VisitorId
	WHERE (@ApplicationMasterId IS NULL OR A.ApplicationMaster = @ApplicationMasterId)
		AND (@Workdate IS NULL OR (DATEDIFF(DAY, @Workdate , A.FromDate) <= 0 AND DATEDIFF(DAY , A.ToDate, @Workdate) <= 0))
		AND (@GateId IS NULL OR M.Gate LIKE '%' + @GateId + '%')
		AND M.ApprovalStatus = ISNULL(@ApprovalStatus, '00F2EC64-CC9B-4FCA-AB4C-B37961EFAD53')
		AND (@UserId IS NULL OR M.CreateUid = @UserId OR M.ApprovalLine LIKE '%' + @USERID + '%')
		AND A.DeleteUid IS NULL
		AND M.DeleteUid IS NULL
	ORDER BY M.CreateDate DESC
END

GO
/****** Object:  StoredProcedure [GATE].[SP_VISITOR_WORKINGDAILY_GET_DETAIL]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.17
-- Description:	MOOD LIKE SHIT
-- =============================================
CREATE PROCEDURE [GATE].[SP_VISITOR_WORKINGDAILY_GET_DETAIL]
	-- Add the parameters for the stored procedure here
	@VisitorId int = 720
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT V.Id, V.VisitorId, ScanTime, IsCheckIn, GateId, V.Remark, VisitorCard, V.CreateUid 
		, C.Name GateName, G.Name CreateName, V.CreateDate
		, CASE IsCheckIn WHEN  1 THEN 'IN' WHEN 0 THEN 'OUT' ELSE '' END IsCheckInName
		, V.WorkDate
	FROM GATE.VisitorWorkingDaily V
	LEFT JOIN SysCategoryValue C ON V.GateId = C.ID
	LEFT JOIN GATE.Guard G ON V.CreateUid = G.GuardId AND G.DeleteUid IS NULL
	WHERE VisitorId = @VisitorId
	ORDER BY CreateDate 
END

GO
/****** Object:  StoredProcedure [GATE].[SP_VISITOR_WORKINGDAILY_GET_HISTORY]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.17
-- Description:	MOOD LIKE SHIT
-- =============================================
CREATE PROCEDURE [GATE].[SP_VISITOR_WORKINGDAILY_GET_HISTORY]
	-- Add the parameters for the stored procedure here
	@FROMDATE DATE = '20000101',
	@TODATE DATE = '20990101',
	@IDENTITYCARD VARCHAR(20) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT B.Id, B.IdentityCard, B.FullName
		,A.WorkDate, A.TimeIn, A.TimeOut, A.GateId, G.Name GateName, A.VehicleCard, A.VisitorCard
		,A.VehicleType, X.Name VehicleTypeName, A.VehiclePlate, A.SecrityNameCreate, A.CreateDate
		,M.Gate GateRegis, R.Name GateNameRegis, B.VehicleType VehicleTypeRegis, V.Name VehicleTypeNameRegis, B.DriverPlate VehiclePlateRegis
		,B.FromDate, B.ToDate, B.PhoneNumber, B.IsWorkHourOfficial
		,M.Vendor, W.CompanyName
	FROM GATE.VisitorWorkingDaily A
	LEFT JOIN GATE.VisitorApplicationDetail B ON A.VisitorId = B.Id
	LEFT JOIN SysCategoryValue G ON A.GateId = G.ID
	LEFT JOIN SysCategoryValue X ON A.VehicleType = X.ID
	LEFT JOIN GATE.VisitorApplicationMaster M ON B.ApplicationMaster = M.Id	
	LEFT JOIN GATE.Vendor W ON M.Vendor = W.Id	
	LEFT JOIN SysCategoryValue R ON M.Gate = R.ID	
	LEFT JOIN SysCategoryValue V ON B.VehicleType = V.ID

	WHERE 1=1
		AND DATEDIFF(DAY, @FROMDATE , A.WorkDate) >= 0
		AND DATEDIFF(DAY , A.WorkDate, @TODATE) >= 0
	ORDER BY A.WorkDate DESC
END

GO
/****** Object:  StoredProcedure [GATE].[SP_VISITOR_WORKINGDAILY_INSERT]    Script Date: 22/06/2018 5:10:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NGUYEN NHAN NGHIA
-- Create date: 2017.12.17
-- Description:	MOOD LIKE SHIT
-- =============================================
CREATE PROCEDURE [GATE].[SP_VISITOR_WORKINGDAILY_INSERT]
	-- Add the parameters for the stored procedure here
	@VisitorId int, 
	@UserId varchar(20),
	@VisitorCard varchar(15),
	@Remark nvarchar(500),
	@IsCheckIn bit,
	@ApplicationType int = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @GATEID UNIQUEIDENTIFIER = (SELECT TOP 1 Gate FROM GATE.Guard WHERE GuardId = @UserId AND DeleteUid IS NULL)
	

	INSERT INTO GATE.VisitorWorkingDaily(VisitorId, WorkDate, ScanTime, IsCheckIn, GateId, Remark, VisitorCard, CreateUid, CreateDate, ApplicationType)
	VALUES(@VisitorId, GETDATE(), CONVERT(VARCHAR(5), GETDATE(), 108), @IsCheckIn, @GATEID, @Remark, @VisitorCard, @UserId, GETDATE(), @ApplicationType)

END

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Loại approval line: order hoặc parallel' , @level0type=N'SCHEMA',@level0name=N'EApproval', @level1type=N'TABLE',@level1name=N'ApplicationConfig', @level2type=N'COLUMN',@level2name=N'ApprovalKind'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Loại approval line: order hay là paraller' , @level0type=N'SCHEMA',@level0name=N'EApproval', @level1type=N'TABLE',@level1name=N'ApplicationMaster', @level2type=N'COLUMN',@level2name=N'ApprovalKind'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Loại approval line: order hay là paraller' , @level0type=N'SCHEMA',@level0name=N'GATE', @level1type=N'TABLE',@level1name=N'PassingGoodsMaster', @level2type=N'COLUMN',@level2name=N'ApprovalKind'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Loại approval line: order hay là paraller' , @level0type=N'SCHEMA',@level0name=N'GATE', @level1type=N'TABLE',@level1name=N'Violation', @level2type=N'COLUMN',@level2name=N'ApprovalKind'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Loại approval line: order hay là paraller' , @level0type=N'SCHEMA',@level0name=N'GATE', @level1type=N'TABLE',@level1name=N'VisitorApplicationMaster', @level2type=N'COLUMN',@level2name=N'ApprovalKind'
GO
USE [master]
GO
ALTER DATABASE [Portal] SET  READ_WRITE 
GO
