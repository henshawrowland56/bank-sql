create table AccountUsers
(
cAuId char(200) constraint cauk unique,
nEmail nvarchar(200)constraint nemailpk primary key,
nPassword nvarchar(200) not null,
nPasswordSalt nvarchar(200) not null
)

select *
from AccountUsers

create table StaffDetails
(
staffId char(4) constraint pkstaffid primary key,
staffName varchar(25) not null,
staffLastName varchar(25) not null,
cPhoneNO char(16) not null,
iAge int,
cSex char (7) not null

)

insert into StaffDetails (staffId, staffName, staffLastName, cPhoneNO, iAge, cSex)
values ('001', 'rowland', 'henshaw','017914106','20','male')

select*
from StaffDetails

update StaffDetails
set staffLastName = 'henshawrow', staffName = 'okoro'
where staffId = '001'

delete StaffDetails
where staffId = '002'

create table CustomerAcct
(
iAcNo int IDENTITY(100000000,1) constraint pkiAcNo primary key,
vCusName varchar(25) NOT NULL,
vCusSurname varchar(25) NOT NULL,
cSex char(7),
vAddress varchar(30) NOT NULL,
cPhoneNo varchar(16) NOT NULL,
dDate datetime CONSTRAINT def DEFAULT getDate(),
mBal money not null CONSTRAINT chkmonez CHECK (mBal>=1000),
staffId char(4) CONSTRAINT fkidNo Foreign Key
references StaffDetails(staffId) on delete set NULL
)

insert into CustomerAcct (vCusName, vCusSurname, cSex, vAddress, cPhoneNo, mBal, staffId )
values (' rowland', 'henshaw', 'male', 'no 7 association st.', '01791406', '9000', '001')

select *
from CustomerAcct

create table Withdrawals 
(
SlipNo int IDENTITY(100001,1) CONSTRAINT pkslipNo primary key,
iAcNo int constraint fkiAcNo foreign key references CustomerAcct (iAcNo),
Anywithdrawn money NOT NULL, 
Amtinwords char (35),
DateOfWith datetime constraint def3 DEFAULT getDate()
)

select *
from Withdrawals



create table Deposits
(
DSlipNo int IDENTITY(50001,1) CONSTRAINT pkDSlipNo primary key,
iAcNo int constraint fkiAcNo2 foreign key references CustomerAcct (iAcNo),
Anydeposited money not null,
dAmtinwords char(35),
DateOfDep datetime constraint def4 DEFAULT getDate(),
DepName varchar(25) Not null,
DepLastName varchar(25) Not null
)

select *
from Deposits

insert into Deposits (iAcNo, Anydeposited, dAmtinwords,DepName,DepLastName)
values (100000000,5000,'five thousand naira','henshaw','frank')


select *
from CustomerAcct


declare @x int
select @x = 23
print @x

create trigger trgDeposit 
on Deposits 
for insert 
as
declare @iaccno int
declare @amt money
select @iaccno = iAcNo, @amt = Anydeposited
from inserted
begin
update CustomerAcct
set mBal = mBal + @amt
where iAcNo = @iaccno
end

drop trigger trgWithdrawals

select *
from Withdrawals

select *
from CustomerAcct

insert into Withdrawals(iAcNo, AnyWithdrawn, Amtinwords)
values (100000000,2000,'two thousand naira')

create trigger trgWithdrawals
on Withdrawals
for insert 
as
declare @iaccno int
declare @amt money
select @iaccno = iAcNo, @amt = Anywithdrawn
from inserted
begin
update CustomerAcct
set mBal = mBal - @amt
where iAcNo = @iaccno
end

create Table Transactions
(
	TransId int identity (1000000001, 1) constraint pktrandId primary key,
	iacno int constraint fkTranIacno foreign key references CustomerAcct(iAcno) on delete set null,
	amount money not null,
	AmtInWords char(35),
	transTYpe varchar(15) constraint chkTransType check(TransType in ('Deposit', 'Withdrawals')),
	TransDate datetime constraint DeftransDate default getDate()
)
create Trigger trgTrans
on Transactions
for insert
as
declare @transtype varchar(15)
declare @iacno int
declare @amt money
select @iacno = inserted.iacno, @amt = amount,
@transtype = transType
from inserted
begin 
	if @transtype = 'Deposit'
	begin
			update CustomerAcct
			set mbal = mbal + @amt
			where iAcNo = @iacno
	end
	else if @transtype = 'Withdrawals'
	begin
			update CustomerAcct
			set mbal = mbal - @amt
			where iAcNo = @iacno
	end
end

select * from CustomerAcct

insert into Transactions(iacno, amount, AmtInWords, TransType)
values (100000000,12000,'twelve thousand naira','Deposit') 

select * from Transactions