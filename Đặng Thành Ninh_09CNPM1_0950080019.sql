-- cau 1 a
create table GiaoVien (
	MaGV nvarchar(10) primary key not null,
	TenGV nvarchar(50) not null
);

create table Lop (
	MaLop nvarchar(10) primary key not null,
	TenLop nvarchar(50) not null,
	Phong nvarchar(10) not null,
	SiSo int not null,
	MaGV nvarchar(10) foreign key references GiaoVien(MaGV)	
);

create table SinhVien (
	MaSV nvarchar(10) primary key not null,
	TenSV nvarchar(50) not null,
	GioiTinh nvarchar(10) not null,
	quequan nvarchar(200) not null,
	malop nvarchar(10) foreign key references Lop(MaLop)	
);

--cau 1 b
INSERT INTO GiaoVien(MaGV, TenGV) VALUES
('GV001', 'Đàm Thị Diễm'),
('GV002', 'Nguyễn Xuân Sang'),
('GV003', 'Võ Thị Kim Yến');

INSERT INTO Lop(MaLop, TenLop, Phong, SiSo, MaGV) VALUES
('LP001', 'Lớp Văn', 'A101', 30, 'GV001'),
('LP002', 'Lớp Toán', 'B102', 35, 'GV002'),
('LP003', 'Lớp Hóa', 'C103', 40, 'GV003');


INSERT INTO SinhVien(MaSV, TenSV, GioiTinh, quequan, malop) VALUES
('SV001', 'Trần Thị Thanh Trúc', 'Nữ', 'Hà Nội', 'LP001'),
('SV002', 'Lê Văn Đại', 'Nam', 'Đà Nẵng', 'LP001'),
('SV003', 'Võ Thị Hoa', 'Nữ', 'Hồ Chí Minh', 'LP002'),
('SV004', 'Nguyễn Duy Phương', 'Nam', 'Quãng Trị', 'LP002'),
('SV005', 'Phạm Thị Thảo', 'Nữ', 'Bắc Ninh', 'LP003');

select * from GiaoVien;

select * from Lop;

select * from SinhVien;


--cau 2
CREATE FUNCTION DanhSachSinhVien(@tenLop NVARCHAR(50), @tenGV NVARCHAR(50))
RETURNS TABLE
AS
RETURN (
    SELECT sv.MaSV, sv.TenSV, l.TenLop, gv.TenGV
    FROM SinhVien sv
    INNER JOIN Lop l ON sv.malop = l.MaLop
    INNER JOIN GiaoVien gv ON l.MaGV = gv.MaGV
    WHERE l.TenLop = @tenLop AND gv.TenGV = @tenGV
);

SELECT * FROM DanhSachSinhVien('Lớp Văn', 'Đàm Thị Diễm');


--cau 3
CREATE PROCEDURE NhapSinhVien
    @MaSV NVARCHAR(10),
    @TenSV NVARCHAR(50),
    @GioiTinh NVARCHAR(10),
    @quequan NVARCHAR(200),
    @TenLop NVARCHAR(50)
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM Lop WHERE TenLop = @TenLop)
    BEGIN
        RAISERROR('Lớp %s không tồn tại!', 16, 1, @TenLop);
        RETURN;
    END;

    INSERT INTO SinhVien (MaSV, TenSV, GioiTinh, quequan, malop)
    VALUES (@MaSV, @TenSV, @GioiTinh, @quequan, (SELECT MaLop FROM Lop WHERE TenLop = @TenLop));
END;

EXECUTE NhapSinhVien 'SV006', 'Nguyễn Tuấn Sơn', 'Nam', 'Quãng Ngãi', 'Lớp Văn'


-- cau 4
CREATE TRIGGER UpdateMaLop
ON SinhVien
AFTER UPDATE
AS
BEGIN
    DECLARE @old_ma_lop VARCHAR(10), @new_ma_lop VARCHAR(10);

    SELECT @old_ma_lop = deleted.MaLop, @new_ma_lop = inserted.MaLop
    FROM deleted, inserted
    WHERE deleted.MaSV = inserted.MaSV;

    IF (@old_ma_lop <> @new_ma_lop)
    BEGIN
        UPDATE Lop SET siso = siso - 1 WHERE maLop = @old_ma_lop;
        UPDATE Lop SET siso = siso + 1 WHERE maLop = @new_ma_lop;
    END;
END;
