-- create a database library 

create database library;
use library;
-- create a publisher table 
use library; 
create table publisher(publisher_name varchar(50) not null primary key,
publisher_address varchar(255),
publisher_phone varchar(255) NOT NULL);

select * from publisher;

create table books(book_ID tinyint primary key auto_increment,
book_title varchar(50) NOT NULL,
publisher_name varchar(50),
foreign key(publisher_name) references publisher(publisher_name));

select * from books;

-- create a table of authors 
 create table authors(author_ID tinyint primary key auto_increment,
 book_ID tinyint,
 foreign key(book_ID) references books(book_ID),
 author_name varchar(255));
 
 select * from authors;
 
 
 -- create a table of borrower 
 create table borrowers(card_No bigint primary key,
 borrower_name varchar(50) NOT NULL, 
 borrower_address varchar(255), 
 borrower_phone varchar(255));
 
 select * from borrowers; 
 
 
 -- create a table of library branch address 
 create table library_branch(branch_ID int primary key auto_increment,
 branch_name varchar(255) not null,
 branch_address varchar(255));
 
 select * from library_branch;
 
 
 -- create a table of loans 
create table books_loan(loan_ID int primary key auto_increment,
 book_ID tinyint, foreign key(book_ID) references books(book_ID),
 branch_ID int, foreign key(branch_ID) references library_branch(branch_id),
 card_No bigint, foreign key(card_No) references borrowers(card_No),
 Date_out date,
 due_date date);
 
 select * from books_loan;
 
 -- create a table of copies 
 create table copies(copies_ID tinyint primary key auto_increment,
 book_ID tinyint, foreign key(book_ID) references books(book_ID),
 branch_ID int, foreign key(branch_ID) references library_branch(branch_ID),
 No_of_copies int);

select * from copies;

-- 1.how many copies of book titled "the lost Tribe" are owned by the library branch whose name is "sharpstown"
select library_branch.branch_name,
book_title As title,
sum(copies.No_of_copies) as total_copies
from books 
left join copies using (book_id)
left join library_branch using (branch_id)
where book_title = "The Lost Tribe" and library_branch.branch_name = "sharpstown"
group by library_branch.branch_name, book_title;

-- 2.How many copies of the book titled "The Lost Tribe" are owned by each library branch?
select library_branch.branch_name,
book_title As title,
sum(copies.No_of_copies) as total_copies
from books 
left join copies using (book_id)
left join library_branch using (branch_id)
where book_title = "The Lost Tribe" 
group by library_branch.branch_name, book_title;

-- 3.Retrieve the names of all borrowers who do not have any books checked out.
SELECT borrowers.borrower_name
FROM borrowers
LEFT JOIN books_loan ON borrowers.card_No = books_loan.card_No
WHERE books_loan.loan_ID IS NULL;


/* 4. for each book that is located out from the "sharpstown" branch and whose Due date is 2/3/18, retrieve the book title, the borrowers name,
and the borrowers address */

select book_title as title, 
borrower_name as nameb,
borrower_address as addr
from books
left join books_loan using(book_id)
left join borrowers using(card_No)
left join library_branch using(branch_ID)
where library_branch.branch_name = "sharpstown" 
AND books_loan.Due_date = "2/3/18"
group by book_title, borrower_name,borrower_Address;

-- 5.For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
SELECT library_branch.branch_name, COUNT(books_loan.loan_ID) AS TotalBooksLoaned
FROM books_loan
JOIN library_branch ON books_loan.branch_ID = library_branch.branch_ID
GROUP BY library_branch.branch_name;


-- 6.Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
SELECT borrowers.borrower_name, borrowers.borrower_address, COUNT(books_loan.loan_ID) AS BooksCheckedOut
FROM borrowers
JOIN books_loan ON borrowers.card_No = books_loan.card_No
GROUP BY borrowers.card_No
HAVING COUNT(books_loan.loan_ID) > 5;


-- 7.For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
SELECT books.book_title, SUM(copies.no_of_copies) AS TotalCopies
FROM books
JOIN authors ON books.book_ID = authors.book_ID
JOIN copies ON books.book_ID = copies.book_ID
JOIN library_branch ON copies.branch_ID = library_branch.branch_ID
WHERE authors.author_name = 'Stephen King' AND library_branch.branch_name = 'Central'
GROUP BY books.book_title;
