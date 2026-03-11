-- BỔ SUNG BOOK COPY (nhiều bản sao hơn cho mỗi sách hiện có)


INSERT INTO book_copy (book_copy_id, book_id) VALUES
('BC21', 'B01'), ('BC22', 'B01'), ('BC23', 'B01'),           -- Harry Potter 1: 4 bản
('BC24', 'B02'), ('BC25', 'B02'),                             -- Harry Potter 2: 3 bản
('BC26', 'B11'), ('BC27', 'B11'), ('BC28', 'B11');            -- The Hobbit: 4 bản


-- Clean Code & các sách Computing phổ biến → nhiều bản sao
INSERT INTO book_copy (book_copy_id, book_id) VALUES
('BC29', 'B03'), ('BC30', 'B03'), ('BC31', 'B03'), ('BC32', 'B03'),  -- Clean Code: 5 bản
('BC33', 'B07'), ('BC34', 'B07'),                                    -- Java Design Patterns: 3 bản
('BC35', 'B08'), ('BC36', 'B08');                                    -- Python Basics: 3 bản




-- Các sách khác: 2–3 bản sao
INSERT INTO book_copy (book_copy_id, book_id) VALUES
('BC37', 'B05'), ('BC38', 'B05'),          -- 1984
('BC39', 'B06'),                           -- The Shining
('BC40', 'B09'), ('BC41', 'B09'),          -- World War II
('BC42', 'B10'),                           -- SpaceX History
('BC43', 'B12'), ('BC44', 'B12'),          -- Data Structures
('BC45', 'B13'),                           -- AI Revolution
('BC46', 'B14'), ('BC47', 'B14'),          -- Cyber Security
('BC48', 'B15'),                           -- Digital Marketing
('BC49', 'B16'), ('BC50', 'B16'),          -- Chemistry 101
('BC51', 'B17'),                           -- Modern Physics
('BC52', 'B18'), ('BC53', 'B18'),          -- Database Internals
('BC54', 'B19'),                           -- Economics Today
('BC55', 'B20');



-- Thêm sách Science (chưa mượn)
INSERT INTO book (book_id, publisher_id, librarian_id, name_book, release) VALUES
('B21', 'P5', 'L02', 'Quantum Mechanics Fundamentals', '2022-08-15'),
('B22', 'P1', 'L03', 'Biology of the Cell 7th Ed', '2021-11-20'),
('B23', 'P3', 'L01', 'Introduction to Astrophysics', '2024-03-10');


----Thêm sách History & Fiction ít phổ biến (chưa mượn)

INSERT INTO book (book_id, publisher_id, librarian_id,name_book, release) VALUES
('B24', 'P4', 'L02', 'The Fall of Rome', '2018-06-05'),                -- History
('B25', 'P5', 'L03', 'Ancient Egypt Mysteries', '2019-09-12'),         -- History
('B26', 'P2', 'L01', 'Dune Messiah', '1969-01-01'),                    -- Fiction / Fantasy (ít mượn)
('B27', 'P1', 'L02', 'Foundation and Empire', '1952-01-01');           -- Fiction / Science Fiction


-- Gán tác giả cho sách mới
INSERT INTO book_of_author (author_id, book_id) VALUES
('A5', 'B21'),          -- giả sử Elon Musk viết về khoa học (hoặc thay bằng tác giả khác nếu muốn)
('A4', 'B26'),          -- Stephen King phong cách → nhưng ta gán cho vui
('A1', 'B27');          -- J.K. Rowling phong cách giả tưởng



-- Gán category cho sách mới (chủ yếu Science + ít History/Fiction)
INSERT INTO book_category (book_id, category_id) VALUES
('B21', 'C4'), ('B22', 'C4'), ('B23', 'C4'),     -- Science
('B24', 'C3'), ('B25', 'C3'),                    -- History (chưa có ai mượn)
('B26', 'C5'), ('B27', 'C5'),                    -- Fantasy
('B21', 'C2'), ('B23', 'C2');                    -- một số sách Science kiêm Computing


-- Thêm book_copy cho các sách mới (2–3 bản mỗi quyển)
INSERT INTO book_copy (book_copy_id, book_id) VALUES
('BC56', 'B21'), ('BC57', 'B21'), ('BC58', 'B21'),
('BC59', 'B22'), ('BC60', 'B22'),
('BC61', 'B23'), ('BC62', 'B23'), ('BC63', 'B23'),
('BC64', 'B24'), ('BC65', 'B24'),
('BC66', 'B25'), ('BC67', 'B25'),
('BC68', 'B26'), ('BC69', 'B26'),
('BC70', 'B27'), ('BC71', 'B27'), ('BC72', 'B27');




-- Thêm 5 loan mới (tháng 2/2026)
INSERT INTO loan (loan_id, member_id, librarian_id, policy_id, loan_date) VALUES
('LN11', 'M01', 'L01', 'POL1', '2026-02-05'),   -- James Bond mượn tiếp
('LN12', 'M03', 'L02', 'POL2', '2026-02-10'),   -- Bruce Wayne mượn tiếp
('LN13', 'M11', 'L03', 'POL1', '2026-02-15'),   -- Thor mượn
('LN14', 'M04', 'L01', 'POL1', '2026-02-20'),   -- Peter Parker mượn tiếp
('LN15', 'M19', 'L02', 'POL2', '2026-02-25');   -- Lucifer mượn



-- Loan detail mới (mượn thêm Harry Potter, Clean Code, và vài cuốn khác)
INSERT INTO loan_detail (loan_id, book_copy_id, overdue_date, return_date, sum_of_fine) VALUES
-- LN11 - James Bond mượn thêm Harry Potter
('LN11', 'BC22', '2026-02-19', '2026-02-18', 0),     -- trả đúng hạn
('LN11', 'BC30', '2026-02-19', NULL, 0),             -- chưa trả (Clean Code)
-- LN12 - Bruce Wayne mượn muộn → phạt
('LN12', 'BC05', '2026-02-24', '2026-03-01', 35.0),  -- 1984 trả muộn (POL2: 5$/ngày × 7 ngày)
('LN12', 'BC31', '2026-02-24', '2026-02-22', 0),     -- Clean Code đúng hạn
-- LN13 - Thor mượn Fantasy & Science
('LN13', 'BC26', '2026-03-01', NULL, 0),             -- The Hobbit (chưa trả)
('LN13', 'BC47', '2026-03-01', '2026-02-28', 0),     -- SpaceX History
-- LN14 - Peter Parker mượn Computing
('LN14', 'BC33', '2026-03-06', '2026-03-04', 0),     -- Java Design Patterns
-- LN15 - Lucifer mượn Fiction
('LN15', 'BC44', '2026-03-11', NULL, 0);             -- The Shining (chưa trả)



-- Thêm 8 loan mới (tháng 2-3/2026)




INSERT INTO loan (loan_id, member_id, librarian_id, policy_id, loan_date) VALUES
('LN16', 'M12', 'L01', 'POL1', '2026-02-01'),   -- Loki mượn
('LN17', 'M14', 'L02', 'POL1', '2026-02-03'),   -- Barry Allen
('LN18', 'M17', 'L03', 'POL2', '2026-02-07'),   -- Oliver Queen
('LN19', 'M08', 'L01', 'POL1', '2026-02-12'),   -- Natasha Romanoff mượn lại
('LN20', 'M15', 'L02', 'POL1', '2026-02-18'),   -- Hal Jordan
('LN21', 'M20', 'L03', 'POL2', '2026-02-22'),   -- Mazikeen Smith
('LN22', 'M06', 'L01', 'POL1', '2026-03-01'),   -- Diana Prince
('LN23', 'M02', 'L02', 'POL1', '2026-03-05');   -- Tony Stark mượn lại


-- Thêm loan_detail - ưu tiên mượn B01 (Harry Potter 1) nhiều lần, dùng các bản sao khác nhau
INSERT INTO loan_detail (loan_id, book_copy_id, overdue_date, return_date, sum_of_fine) VALUES
-- LN16 - Loki
('LN16', 'BC01', '2026-02-15', '2026-02-14', 0),          -- trả đúng hạn

-- LN17 - Barry
('LN17', 'BC21', '2026-02-17', NULL, 0),                  -- chưa trả (đang mượn)

-- LN18 - Oliver (POL2: 5$/ngày, trả muộn)
('LN18', 'BC22', '2026-02-21', '2026-02-25', 20.0),       -- muộn 4 ngày → 20$

-- LN19 - Natasha
('LN19', 'BC23', '2026-02-26', '2026-02-24', 0),          -- trả sớm

-- LN20 - Hal
('LN20', 'BC01', '2026-03-04', '2026-03-03', 0),          -- trả đúng (mượn lại bản cũ)

-- LN21 - Mazikeen (POL2, trả muộn nặng)
('LN21', 'BC21', '2026-03-08', '2026-03-15', 35.0),       -- muộn 7 ngày → 35$

-- LN22 - Diana
('LN22', 'BC22', '2026-03-15', NULL, 0),                  -- chưa trả

-- LN23 - Tony Stark
('LN23', 'BC23', '2026-03-19', '2026-03-18', 0);          -- trả đúng hạn


-- (Tùy chọn) Thêm 1-2 loan nữa nếu muốn Harry Potter 1 vượt trội hẳn

INSERT INTO loan (loan_id, member_id, librarian_id, policy_id, loan_date) VALUES
('LN24', 'M13', 'L03', 'POL1', '2026-03-08'),   -- Arthur Curry
('LN25', 'M07', 'L01', 'POL1', '2026-03-10');   -- Steve Rogers

INSERT INTO loan_detail (loan_id, book_copy_id, overdue_date, return_date, sum_of_fine) VALUES
('LN24', 'BC01', '2026-03-22', NULL, 0),                  -- Arthur đang mượn
('LN25', 'BC21', '2026-03-24', '2026-03-22', 0);          -- Steve trả đúng
