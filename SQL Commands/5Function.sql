USE Group4
GO

-- Xóa các procedure nếu đã tồn tại
IF OBJECT_ID('sp_MuonSach') IS NOT NULL DROP PROCEDURE sp_MuonSach;
IF OBJECT_ID('sp_TraSach') IS NOT NULL DROP PROCEDURE sp_TraSach;
IF OBJECT_ID('sp_ThemThanhVien') IS NOT NULL DROP PROCEDURE sp_ThemThanhVien;
IF OBJECT_ID('sp_ThemSachVaoDanhMuc') IS NOT NULL DROP PROCEDURE sp_ThemSachVaoDanhMuc;
IF OBJECT_ID('sp_XoaSach') IS NOT NULL DROP PROCEDURE sp_XoaSach;
GO

-- 1. Cho phép mượn sách (Kiểm tra xem độc giả có bị quá hạn không)
CREATE PROCEDURE sp_MuonSach 
    @member_id VARCHAR(20),
    @librarian_id VARCHAR(20),
    @policy_id VARCHAR(20),
    @loan_id VARCHAR(20)
AS
BEGIN
    DECLARE @SoSachQuaHan INT;
    
    -- Đếm số sách đang quá hạn của thành viên này
    SELECT @SoSachQuaHan = COUNT(*)
    FROM loan l 
    JOIN loan_detail ld ON l.loan_id = ld.loan_id
    WHERE l.member_id = @member_id 
      AND ld.return_date IS NULL 
      AND ld.overdue_date < GETDATE();
    
    IF @SoSachQuaHan > 0
    BEGIN
        PRINT N'Từ chối: Độc giả này đang có sách quá hạn, không được phép mượn thêm!';
    END
    ELSE
    BEGIN
        -- Nếu không có sách quá hạn thì cho phép mượn
        INSERT INTO loan (loan_id, member_id, librarian_id, policy_id, loan_date) 
        VALUES (@loan_id, @member_id, @librarian_id, @policy_id, GETDATE());
        PRINT N'Thành công: Đã tạo phiếu mượn sách mới!';
    END
END
GO

-- 2. Trả sách và tự động tính tiền phạt nếu trễ hạn
CREATE PROCEDURE sp_TraSach
    @loan_id VARCHAR(20),
    @book_copy_id VARCHAR(20)
AS
BEGIN
    DECLARE @NgayQuaHan DATE;
    DECLARE @SoNgayTre INT;
    DECLARE @TienPhat FLOAT;
    
    -- Lấy mốc thời gian phải trả của cuốn sách này
    SELECT @NgayQuaHan = overdue_date
    FROM loan_detail 
    WHERE loan_id = @loan_id AND book_copy_id = @book_copy_id;
    
    -- Kiểm tra trễ hạn
    IF GETDATE() > @NgayQuaHan
    BEGIN
        SET @SoNgayTre = DATEDIFF(DAY, @NgayQuaHan, GETDATE());
        SET @TienPhat = @SoNgayTre * 5000; -- Phạt 5,000 VND cho mỗi ngày trễ
        PRINT N'Thành công: Trả sách trễ hạn. Bạn bị phạt ' + CAST(@TienPhat AS VARCHAR) + N' VND';
    END
    ELSE
    BEGIN
        SET @TienPhat = 0;
        PRINT N'Thành công: Trả sách đúng hạn, không bị phạt tiền.';
    END
    
    -- Cập nhật ngày trả và tiền phạt vào bảng chi tiết mượn
    UPDATE loan_detail 
    SET return_date = GETDATE(), sum_of_fine = @TienPhat
    WHERE loan_id = @loan_id AND book_copy_id = @book_copy_id;
END
GO

-- 3. Thêm người dùng mới (Kiểm tra tránh trùng lặp mã)
CREATE PROCEDURE sp_ThemThanhVien
    @member_id VARCHAR(20),
    @name NVARCHAR(50),
    @address NVARCHAR(100),
    @phone_number VARCHAR(15)
AS
BEGIN
    DECLARE @TonTai INT;

    -- Kiểm tra xem member_id đã tồn tại hay chưa
    SELECT @TonTai = COUNT(*) FROM member WHERE member_id = @member_id;

    IF @TonTai > 0
    BEGIN
        PRINT N'Thiếu: Mã thành viên này đã tồn tại trong hệ thống. Vui lòng thử mã khác!';
    END
    ELSE
    BEGIN
        INSERT INTO member (member_id, name, address, phone_number)
        VALUES (@member_id, @name, @address, @phone_number);
        PRINT N'Thành công: Đã thêm thành viên mới!';
    END
END
GO

-- 4. Gắn thể loại cho sách (Phải kiểm tra xem sách/thể loại có thật không)
CREATE PROCEDURE sp_ThemSachVaoDanhMuc
    @book_id VARCHAR(20),
    @category_id VARCHAR(20)
AS
BEGIN
    DECLARE @KiemTraSach INT;
    DECLARE @KiemTraDanhMuc INT;

    SELECT @KiemTraSach = COUNT(*) FROM book WHERE book_id = @book_id;
    SELECT @KiemTraDanhMuc = COUNT(*) FROM category WHERE category_id = @category_id;

    IF @KiemTraSach = 0
    BEGIN
        PRINT N'Từ chối: Quyển sách này không tồn tại trong hệ thống!';
    END
    ELSE IF @KiemTraDanhMuc = 0
    BEGIN
        PRINT N'Từ chối: Thể loại danh mục này không tồn tại!';
    END
    ELSE
    BEGIN
        INSERT INTO book_category (book_id, category_id) VALUES (@book_id, @category_id);
        PRINT N'Thành công: Đã gắn thể loại cho sách!';
    END
END
GO

-- 5. Xóa sách khỏi hệ thống (Kiểm tra xem có đang bị mượn không)
CREATE PROCEDURE sp_XoaSach
    @book_id VARCHAR(20)
AS
BEGIN
    DECLARE @SoNguoiDangMuon INT;

    -- Đếm xem có bao nhiêu bản sao của quyển sách này đang được mượn nhưng chưa trả
    SELECT @SoNguoiDangMuon = COUNT(*)
    FROM book_copy bc
    JOIN loan_detail ld ON bc.book_copy_id = ld.book_copy_id
    WHERE bc.book_id = @book_id AND ld.return_date IS NULL;

    IF @SoNguoiDangMuon > 0
    BEGIN
        PRINT N'Từ chối: Không thể xóa sách này vì đang có độc giả mượn chưa trả!';
    END
    ELSE
    BEGIN
        -- Nếu không có ai mượn mới bắt đầu xóa các khóa ngoại và khóa chính
        DELETE FROM book_category WHERE book_id = @book_id;
        DELETE FROM book_of_author WHERE book_id = @book_id;
        DELETE FROM book_copy WHERE book_id = @book_id;
        DELETE FROM book WHERE book_id = @book_id;
        PRINT N'Thành công: Đã xóa sách khỏi hệ thống an toàn!';
    END
END
GO
