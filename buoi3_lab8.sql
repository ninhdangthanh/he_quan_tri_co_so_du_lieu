-- cau 1
CREATE PROCEDURE lab_7_1
    @mahangsx INT,
    @tenhang VARCHAR(50),
    @diachi VARCHAR(100),
    @sodt VARCHAR(20),
    @email VARCHAR(50)
AS
BEGIN
    -- Kiểm tra xem tenhang đã tồn tại hay chưa
    IF EXISTS (SELECT 1 FROM Hangsx WHERE tenhang = @tenhang)
    BEGIN
        PRINT 'Tên hãng sản xuất đã tồn tại. Vui lòng nhập tên khác!'
        RETURN
    END

    -- Nếu tenhang chưa tồn tại, thực hiện thêm dữ liệu vào bảng Hangsx
    INSERT INTO Hangsx (mahangsx, tenhang, diachi, sodt, email)
    VALUES (@mahangsx, @tenhang, @diachi, @sodt, @email)

    PRINT 'Thêm hãng sản xuất thành công!'
END

--cau 2
CREATE PROCEDURE lab7_2
    @masp INT,
    @mahangsx INT,
    @tensp VARCHAR(50),
    @soluong INT,
    @mausac VARCHAR(20),
    @giaban MONEY,
    @donvitinh VARCHAR(20),
    @mota VARCHAR(100)
AS
BEGIN
    -- Kiểm tra xem masp đã tồn tại hay chưa
    IF EXISTS (SELECT 1 FROM Sanpham WHERE masp = @masp)
    BEGIN
        -- Nếu masp đã tồn tại, thực hiện cập nhật thông tin sản phẩm theo mã
        UPDATE Sanpham
        SET mahangsx = @mahangsx,
            tensp = @tensp,
            soluong = @soluong,
            mausac = @mausac,
            giaban = @giaban,
            donvitinh = @donvitinh,
            mota = @mota
        WHERE masp = @masp

        PRINT 'Cập nhật thông tin sản phẩm thành công!'
    END
    ELSE
    BEGIN
        -- Nếu masp chưa tồn tại, thực hiện thêm mới sản phẩm vào bảng Sanpham
        INSERT INTO Sanpham (masp, mahangsx, tensp, soluong, mausac, giaban, donvitinh, mota)
        VALUES (@masp, @mahangsx, @tensp, @soluong, @mausac, @giaban, @donvitinh, @mota)

        PRINT 'Thêm mới sản phẩm thành công!'
    END
END


-- cau 3
CREATE PROCEDURE lab7_3
    @tenhang VARCHAR(50)
AS
BEGIN
    -- Kiểm tra xem tenhang có tồn tại trong bảng Hangsx hay không
    IF NOT EXISTS (SELECT 1 FROM Hangsx WHERE tenhang = @tenhang)
    BEGIN
        PRINT 'Hãng sản xuất không tồn tại!'
    END
    ELSE
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION

            -- Xóa các sản phẩm cung ứng của hãng đó
            DELETE FROM Sanpham WHERE mahangsx = (SELECT mahangsx FROM Hangsx WHERE tenhang = @tenhang)

            -- Xóa hãng sản xuất đó
            DELETE FROM Hangsx WHERE tenhang = @tenhang

            COMMIT TRANSACTION

            PRINT 'Xóa hãng sản xuất và các sản phẩm cung ứng thành công!'
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION

            PRINT 'Xóa hãng sản xuất và các sản phẩm cung ứng không thành công!'
        END CATCH
    END
END


--cau 4
CREATE PROCEDURE lab7_4
    @manv VARCHAR(10),
    @tennv NVARCHAR(50),
    @gioitinh NVARCHAR(10),
    @diachi NVARCHAR(100),
    @sodt VARCHAR(20),
    @email VARCHAR(50),
    @phong NVARCHAR(50),
    @flag INT
AS
BEGIN
    -- Kiểm tra xem manv đã tồn tại trong bảng Nhân viên hay chưa
    IF EXISTS (SELECT 1 FROM Nhanvien WHERE manv = @manv)
    BEGIN
        -- Nếu flag = 0, cập nhật dữ liệu cho Nhân viên có mã manv
        IF (@flag = 0)
        BEGIN
            BEGIN TRY
                BEGIN TRANSACTION

                UPDATE Nhanvien SET 
                    tennv = @tennv,
                    gioitinh = @gioitinh,
                    diachi = @diachi,
                    sodt = @sodt,
                    email = @email,
                    phong = @phong
                WHERE manv = @manv

                COMMIT TRANSACTION

                PRINT 'Cập nhật thông tin nhân viên thành công!'
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION

                PRINT 'Cập nhật thông tin nhân viên không thành công!'
            END CATCH
        END
        -- Ngược lại, thông báo lỗi cho người dùng
        ELSE
        BEGIN
            PRINT 'Mã nhân viên đã tồn tại!'
        END
    END
    -- Nếu manv chưa tồn tại, thêm mới Nhân viên
    ELSE
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION

            INSERT INTO Nhanvien(manv, tennv, gioitinh, diachi, sodt, email, phong)
            VALUES (@manv, @tennv, @gioitinh, @diachi, @sodt, @email, @phong)

            COMMIT TRANSACTION

            PRINT 'Thêm mới nhân viên thành công!'
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION

            PRINT 'Thêm mới nhân viên không thành công!'
        END CATCH
    END
END

-- cau 5
CREATE PROCEDURE lab7_5
(
    @sohdn VARCHAR(20),
    @masp VARCHAR(20),
    @manv VARCHAR(20),
    @ngaynhap DATE,
    @soluongN INT,
    @dongiaN FLOAT
)
AS
BEGIN
    -- Kiểm tra mã sản phẩm có tồn tại trong bảng Sanpham hay không?
    IF NOT EXISTS(SELECT * FROM Sanpham WHERE masp = @masp)
    BEGIN
        PRINT 'Mã sản phẩm không tồn tại!'
        RETURN
    END
    
    -- Kiểm tra mã nhân viên có tồn tại trong bảng Nhanvien hay không?
    IF NOT EXISTS(SELECT * FROM Nhanvien WHERE manv = @manv)
    BEGIN
        PRINT 'Mã nhân viên không tồn tại!'
        RETURN
    END
    
    -- Kiểm tra nếu số hóa đơn nhập đã tồn tại thì cập nhật thông tin
    IF EXISTS(SELECT * FROM Nhap WHERE sohdn = @sohdn)
    BEGIN
        UPDATE Nhap
        SET masp = @masp, manv = @manv, ngaynhap = @ngaynhap, soluongN = @soluongN, dongiaN = @dongiaN
        WHERE sohdn = @sohdn
    END
    ELSE -- Ngược lại thêm mới hóa đơn nhập
    BEGIN
        INSERT INTO Nhap (sohdn, masp, manv, ngaynhap, soluongN, dongiaN)
        VALUES (@sohdn, @masp, @manv, @ngaynhap, @soluongN, @dongiaN)
    END
END

--cau 6
CREATE PROCEDURE lab7_6
    @sohdx INT,
    @masp INT,
    @manv INT,
    @ngay DATE,
    @soluongX INT
AS
BEGIN
    -- Kiểm tra xem sản phẩm tồn tại trong bảng Sanpham hay không
    IF NOT EXISTS (SELECT 1 FROM Sanpham WHERE masp = @masp)
    BEGIN
        PRINT 'Sản phẩm không tồn tại trong bảng Sanpham.'
        RETURN
    END

    -- Kiểm tra xem nhân viên tồn tại trong bảng Nhanvien hay không
    IF NOT EXISTS (SELECT 1 FROM Nhanvien WHERE manv = @manv)
    BEGIN
        PRINT 'Nhân viên không tồn tại trong bảng Nhanvien.'
        RETURN
    END

    -- Kiểm tra số lượng xuất có vượt quá số lượng hiện có của sản phẩm hay không
    DECLARE @soluong INT
    SELECT @soluong = soluong FROM Sanpham WHERE masp = @masp

    IF @soluongX > @soluong
    BEGIN
        PRINT 'Số lượng xuất vượt quá số lượng hiện có của sản phẩm.'
        RETURN
    END

    -- Kiểm tra nếu sohdx đã tồn tại thì cập nhật bảng Xuat, ngược lại thêm mới bảng Xuat
    IF EXISTS (SELECT 1 FROM Xuat WHERE sohdx = @sohdx)
    BEGIN
        UPDATE Xuat SET 
            masp = @masp,
            manv = @manv,
            ngay = @ngay,
            soluongX = @soluongX
        WHERE sohdx = @sohdx
    END
    ELSE
    BEGIN
        INSERT INTO Xuat (sohdx, masp, manv, ngay, soluongX)
        VALUES (@sohdx, @masp, @manv, @ngay, @soluongX)
    END
END
