CREATE TRIGGER dbo.TR_Basket_insert_update
ON dbo.Basket
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @InsertedSKUCount INT
    DECLARE @ID_SKU INT

    SELECT
        @ID_SKU = ID_SKU,
        @InsertedSKUCount = COUNT(*)
    FROM
        inserted
    GROUP BY
        ID_SKU

    IF @InsertedSKUCount >= 2
    BEGIN
        UPDATE
            b
        SET
            b.DiscountValue = b.Value * 0.05
        FROM
            dbo.Basket AS b
        INNER JOIN
            inserted AS i
        ON
            b.ID_SKU = i.ID_SKU
    END
    ELSE
    BEGIN
        UPDATE
            b
        SET
            b.DiscountValue = 0
        FROM
            dbo.Basket AS b
        INNER JOIN
            inserted AS i
        ON
            b.ID_SKU = i.ID_SKU
    END
END
