CREATE TABLE MATHANG (
  mahang INT PRIMARY KEY,
  tenhang VARCHAR(50) NOT NULL,
  soluong INT NOT NULL
);

CREATE TABLE NHATKYBANHANG (
  stt INT PRIMARY KEY,
  ngay DATE NOT NULL,
  nguoimua VARCHAR(50) NOT NULL,
  mahang INT NOT NULL,
  soluong INT NOT NULL,
  giaban FLOAT NOT NULL,
);

-- Chèn dữ liệu vào bảng MATHANG
INSERT INTO MATHANG (mahang, tenhang, soluong)
VALUES 
  (1, 'Sữa tươi Vinamilk', 100),
  (2, 'Bánh mì phô mai', 50),
  (3, 'Nước suối Lavie', 200),
  (4, 'Kẹo mút Chupa Chups', 300),
  (5, 'Bánh quy Oreo', 150);

-- Chèn dữ liệu vào bảng NHATKYBANHANG
INSERT INTO NHATKYBANHANG (stt, ngay, nguoimua, mahang, soluong, giaban)
VALUES
  (1, '2022-04-19', 'Nguyễn Văn A', 1, 2, 15000),
  (2, '2022-04-20', 'Trần Thị B', 2, 1, 12000),
  (3, '2022-04-20', 'Lê Văn C', 3, 3, 5000),
  (4, '2022-04-21', 'Phạm Thị D', 4, 5, 2000),
  (5, '2022-04-21', 'Đỗ Văn E', 5, 2, 10000);
