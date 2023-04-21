--A
CREATE DATABASE QLNV;


--B
CREATE TABLE Chucvu (
  MaCV NVARCHAR(2)  PRIMARY KEY,
  TenCV NVARCHAR(30) NOT NULL
);

 CREATE TABLE NhanVien (
  MaNV NVARCHAR(4) PRIMARY KEY,
  MaCV NVARCHAR(2) NOT NULL,
  TenNV NVARCHAR(30) NOT NULL,
  NgaySinh DATETIME NOT NULL,
  LuongCanBan FLOAT NOT NULL,
  NgayCong INT NOT NULL,
  PhuCap FLOAT NOT NULL,
  CONSTRAINT fk_ChucVu_NhanVien FOREIGN KEY (MaCV) REFERENCES Chucvu(MaCV)
);


--C
insert into Chucvu values ('BV', 'Bảo vệ');
insert into Chucvu values ('GD', 'Giám đốc');
insert into Chucvu values ('HC', 'Hành chính');
insert into Chucvu values ('KT', 'Kế toán');
insert into Chucvu values ('TQ', 'Thủ quỹ');
insert into Chucvu values ('VS', 'Vệ sinh');

insert into NhanVien values ('NV01', 'GD', 'Nguyễn Văn An', '12/12/1977 12:00:00', 700000, 25, 500000);
insert into NhanVien values ('NV02', 'BV', 'Bùi Văn Tí', '10/10/1978 12:00:00', 400000, 24, 100000);
insert into NhanVien values ('NV03', 'KT', 'Trần Thanh Nhật', '9/9/1977 12:00:00', 600000, 26, 400000);
insert into NhanVien values ('NV04', 'VS', 'Nguyễn Thị Út', '10/10/1980 12:00:00', 300000, 26, 300000);
insert into NhanVien values ('NV05', 'HC', 'Lê Thị Hà', '10/10/1979 12:00:00', 500000, 27, 200000);

--D
--a
CREATE PROCEDURE SP_Them_Nhan_Vien 
  @MaNV VARCHAR(10),
  @MaCV VARCHAR(2),
  @TenNV VARCHAR(50),
  @NgaySinh DATE,
  @LuongCanBan DECIMAL(18,2),
  @NgayCong INT,
  @PhuCap DECIMAL(18,2)
AS
BEGIN
  IF EXISTS (SELECT * FROM tblChucvu WHERE MaCV = @MaCV) AND DATEDIFF(YEAR, @NgaySinh, GETDATE()) <= 30
  BEGIN
    INSERT INTO tblSinhVien (MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap)
    VALUES (@MaNV, @MaCV, @TenNV, @NgaySinh, @LuongCanBan, @NgayCong, @PhuCap);
    SELECT 'Thêm nhân viên thành công.' AS ThongBao;
  END
  ELSE
  BEGIN
    SELECT 'Không thể thêm nhân viên.' AS ThongBao;
  END
END

--b
CREATE PROCEDURE SP_CapNhat_Nhan_Vien 
  @MaNV VARCHAR(10),
  @MaCV VARCHAR(2),
  @TenNV VARCHAR(50),
  @NgaySinh DATE,
  @LuongCanBan DECIMAL(18,2),
  @NgayCong INT,
  @PhuCap DECIMAL(18,2)
AS
BEGIN
  IF EXISTS (SELECT * FROM tblChucvu WHERE MaCV = @MaCV) AND DATEDIFF(YEAR, @NgaySinh, GETDATE()) <= 30
  BEGIN
    UPDATE tblSinhVien
    SET MaCV = @MaCV, TenNV = @TenNV, NgaySinh = @NgaySinh, LuongCanBan = @LuongCanBan, NgayCong = @NgayCong, PhuCap = @PhuCap
    WHERE MaNV = @MaNV;
    SELECT 'Cập nhật nhân viên thành công.' AS ThongBao;
  END
  ELSE
  BEGIN
    SELECT 'Không thể cập nhật nhân viên.' AS ThongBao;
  END
END

--c
CREATE PROCEDURE SP_LuongLN
AS
BEGIN
  SELECT MaNV, TenNV, LuongCanBan*NgayCong+PhuCap AS Luong
  FROM tblSinhVien;
END

--d
CREATE FUNCTION TBL_LuongTB
RETURNS TABLE 
AS
RETURN
(
  SELECT tblSinhVien.MaNV, tblSinhVien.TenNV, tblChucvu.TenCV, tblSinhVien.LuongCanBan*CASE WHEN NgayCong >= 25 THEN NgayCong*2 ELSE NgayCong END + PhuCap AS Luong
  FROM tblSinhVien
  INNER JOIN tblChucvu ON tblSinhVien.MaCV = tblChucvu.MaCV
  GROUP BY tblSinhVien.MaNV, tblSinhVien.TenNV, tblChucvu.TenCV, tblSinhVien.LuongCanBan, tblSinhVien.NgayCong, tblSinhVien.PhuCap
)

--1
CREATE PROCEDURE SP_ThemNhanVien
  @MaNV VARCHAR(10),
  @MaCV VARCHAR(2),
  @TenNV NVARCHAR(50),
  @NgaySinh DATE,
  @LuongCB FLOAT,
  @NgayCong INT,
  @PhucCap FLOAT
AS
BEGIN
  DECLARE @Count INT;
  SELECT @Count = COUNT(*) FROM ChucVu WHERE MaCV = @MaCV;
  IF @Count = 0
  BEGIN
    SELECT 'Mã chức vụ không tồn tại' AS ThongBao;
  END
  ELSE
  BEGIN
    SELECT @Count = COUNT(*) FROM NhanVien WHERE MaNV = @MaNV;
    IF @Count > 0
    BEGIN
      SELECT 'Mã nhân viên đã tồn tại' AS ThongBao;
    END
    ELSE
    BEGIN
      INSERT INTO NhanVien(MaNV, MaCV, TenNV, NgaySinh, LuongCB, NgayCong, PhucCap)
      VALUES (@MaNV, @MaCV, @TenNV, @NgaySinh, @LuongCB, @NgayCong, @PhucCap);
      SELECT 'Thêm thành công' AS ThongBao;
    END
  END
END

--2
CREATE PROCEDURE SP_ThemNhanVienn
  @MaNV VARCHAR(10),
  @MaCV VARCHAR(2),
  @TenNV NVARCHAR(50),
  @NgaySinh DATE,
  @LuongCB FLOAT,
  @NgayCong INT,
  @PhucCap FLOAT
AS
BEGIN
  DECLARE @Count INT;
  SELECT @Count = COUNT(*) FROM ChucVu WHERE MaCV = @MaCV;
  IF @Count = 0
  BEGIN
    SELECT 'Mã chức vụ không tồn tại' AS ThongBao;
  END
  ELSE
  BEGIN
    SELECT @Count = COUNT(*) FROM NhanVien WHERE MaNV = @MaNV;
    IF @Count > 0
    BEGIN
      SELECT 'Mã nhân viên đã tồn tại' AS ThongBao;
    END
    ELSE
    BEGIN
      INSERT INTO NhanVien(MaNV, MaCV, TenNV, NgaySinh, LuongCB, NgayCong, PhucCap)
      VALUES (@MaNV, @MaCV, @TenNV, @NgaySinh, @LuongCB, @NgayCong, @PhucCap);
      SELECT 'Thêm thành công' AS ThongBao;
    END
  END
END

--3
CREATE PROCEDURE SP_CapNhatNgaySinh
  @MaNV VARCHAR(10),
  @NgaySinh DATE
AS
BEGIN
  DECLARE @Count INT;
  SELECT @Count = COUNT(*) FROM NhanVien WHERE MaNV = @MaNV;
  IF @Count = 0
  BEGIN
    SELECT 'Không tìm thấy bản ghi cần cập nhật' AS ThongBao;
  END
  ELSE
  BEGIN
    UPDATE NhanVien SET NgaySinh = @NgaySinh WHERE MaNV = @MaNV;
    SELECT 'Cập nhật thành công' AS ThongBao;
  END
END

--4
CREATE PROCEDURE SP_TongSoNhanVienTheoNgayCong
  @NgayCong1 INT,
  @NgayCong2 INT
AS
BEGIN
  SELECT COUNT(*) AS TongSoNhanVien
  FROM NhanVien
  WHERE NgayCong BETWEEN @NgayCong1 AND @NgayCong2;
END

--5
CREATE PROCEDURE SP_TongSoNhanVienTheoChucVu
  @TenCV NVARCHAR(50)
AS
BEGIN
  SELECT COUNT(*) AS TongSoNhanVien
  FROM NhanVien
  WHERE MaCV IN (SELECT MaCV FROM ChucVu WHERE TenCV = @TenCV);
END