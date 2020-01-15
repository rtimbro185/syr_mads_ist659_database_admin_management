/*
HW-8
*/
-- Declare a variable, @ is mandatory at the beginning of the variable name in SQL Server
declare @isThisNull varchar(30)  -- starts out as NULL
Select @isThisNull, ISNULL(@isThisNull,'Yep, it is NULL')

-- Set the variable to something
SET @isThisNull = 'Nope, It is not Null'
SELECT @isThisNull, ISNULL(@isThisNull, 'Yep, it is null')

GO
/*
First User Defined Function
*/
CREATE FUNCTION dbo.AddTwoInts(@firstNumber int, @secondNumber int)
RETURNS int AS -- AS is the keyword that ends the CREATE FUNCTION clause
BEGIN
	-- First, delcare the variable to temporarily hold the results
	DECLARE @returnValue int -- the data type matches the "RETURN" clause

	-- Set the variable to the correct value
	SET @returnValue = @firstNumber + @secondNumber

	-- Return the value to the calling statement
	RETURN @returnValue
END
GO

-- TODO: Execute SQL Select statement against new function
SELECT dbo.AddTwoInts(5,10)

-- TODO: Code a function that counts the number of VidCasts made by a given user and returns the count to the calling code
SELECT * FROM dbo.vc_VidCast