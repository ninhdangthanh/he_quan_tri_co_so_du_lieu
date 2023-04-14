-----Câu 1------
CREATE TABLE Khoa (
    Makhoa INT PRIMARY KEY,
    Tenkhoa VARCHAR(50) NOT NULL,
    Dienthoai VARCHAR(20) NOT NULL
);

CREATE TABLE Lop (
    Malop INT PRIMARY KEY,
    Tenlop VARCHAR(50) NOT NULL,
    Khoa VARCHAR(50) NOT NULL,
    Hedt VARCHAR(50) NOT NULL,
    Namnhaphoc INT NOT NULL,
    Makhoa INT NOT NULL,
    FOREIGN KEY (Makhoa) REFERENCES Khoa(Makhoa)
);

CREATE PROCEDURE ThemKhoa
    @makhoa INT,
    @tenkhoa VARCHAR(50),
    @dienthoai VARCHAR(20)
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM Khoa WHERE Tenkhoa = @tenkhoa)
    BEGIN
        INSERT INTO Khoa (Makhoa, Tenkhoa, Dienthoai)
        VALUES (@makhoa, @tenkhoa, @dienthoai)
        PRINT N'Thêm khoa thành công.'
    END
    ELSE
    BEGIN
        PRINT N'Khoa đã tồn tại trong cơ sở dữ liệu.'
    END
END
EXEC ThemKhoa 1, 'Khoa Toan-Tin', '0772269999'
EXEC ThemKhoa 2, 'Khoa Thương Mại Điện Tử', '0369944444'
-------Câu 2-------
go
CREATE PROCEDURE ThemLop
    @malop INT,
    @tenlop VARCHAR(50),
    @khoa VARCHAR(50),
    @hedt VARCHAR(50),
    @namnhaphoc INT,
    @makhoa INT
AS
BEGIN
    DECLARE @count INT
    SELECT @count = COUNT(*) FROM Lop WHERE Tenlop = @tenlop
    IF (@count > 0)
    BEGIN
        PRINT N'Lớp đã tồn tại trong cơ sở dữ liệu.'
    END
    ELSE
    BEGIN
        SELECT @count = COUNT(*) FROM Khoa WHERE Makhoa = @makhoa
        IF (@count = 0)
        BEGIN
            PRINT N'Mã Khoa Không tồn tại trong cơ sở dữ liệu.'
        END
        ELSE
        BEGIN
            INSERT INTO Lop (Malop, Tenlop, Khoa, Hedt, Namnhaphoc, Makhoa)
            VALUES (@malop, @tenlop, @khoa, @hedt, @namnhaphoc, @makhoa)
            PRINT N'Thêm lớp thành công.'
        END
    END
END
go
DECLARE @malop INT, @tenlop VARCHAR(50), @khoa VARCHAR(50), @hedt VARCHAR(50), @namnhaphoc INT, @makhoa INT
SET @malop = 1
SET @tenlop = 'Lop 1A'
SET @khoa = 'Khoa Toan-Tin'
SET @hedt = 'Đại Học '
SET @namnhaphoc = 2022
SET @makhoa = 1
EXEC ThemLop @malop, @tenlop, @khoa, @hedt, @namnhaphoc, @makhoa