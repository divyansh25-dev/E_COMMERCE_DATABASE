--Commands to create tables in the database named E-Commerce--

create table admin(
E_ID SERIAL PRIMARY KEY,
username varchar(55),	
roles varchar(55),
permissions varchar(55)
);

create table product(
P_ID SERIAL PRIMARY KEY,
p_name varchar(55),
catagory varchar(55)	
);

create table orders(
 
	O_ID serial primary key,
	P_ID INT REFERENCES product(p_id),
	p_name varchar(30),
	order_made TIMESTAMP
);

create table changes(

	C_ID SERIAL PRIMARY KEY,
	O_ID INT NOT NULL,
	O_name varchar(55),
	det TIMESTAMP NOT NULL
);


-- COMMANDS FOR INSERTING THE DATA IN VARIOUS TABLES --


insert into admin (username,roles,permissions) values ('Himanshu','Software Engineer','Database read and write');
insert into product(p_name,catagory) values ('Samsung Galaxy A32','Mobiles');
insert into product(p_name,catagory) values ('Samsung Galaxy A72','Mobiles');
insert into product(p_name,catagory) values ('Macbook Pro','Laptops');
insert into product(p_name,catagory) values ('Hot Wheels','Toys');
insert into orders(P_ID,p_name,order_made) values (1,'Samsung Galaxy A32',NOW());
insert into orders(P_ID,p_name,order_made) values (2,'Samsung Galaxy A72',NOW());
insert into orders(P_ID,p_name,order_made) values (3,'Macbook Pro',NOW());

--COMMAND TO CREATING VIEW --

Create or replace view category as
SELECT orders.o_id,product.catagory
FROM orders
INNER JOIN product
ON orders.P_ID = product.P_ID;


--WRITING TRIGGERS FOR UPDATION OF ORDERS TABLE-- 

Create or replace function inserting_trig()
 RETURNS TRIGGER
 LANGUAGE PLPGSQL
 as $$
     BEGIN 
	    
		IF NEW.p_name <> OLD.p_name THEN
		     insert into changes(O_ID,O_name,det) values( OLD.o_id,OLD.p_name,NOW());
	    END IF;
		RETURN NEW;
	
	 END;
	$$
	
	
	CREATE TRIGGER ins
	
	     BEFORE UPDATE
		 ON orders
		 FOR EACH ROW
		      EXECUTE PROCEDURE inserting_trig();




--CREATING TRIGGER FOR DELETION FROM ORDERS TABLE--


Create or replace function deleting_trig()
 RETURNS TRIGGER
 LANGUAGE PLPGSQL
 as $$
     BEGIN 
	    
		insert into changes(O_ID,O_name,det) values( OLD.o_id,OLD.p_name,OLD.order_made);
		
        
	    RETURN OLD;
	 END;
	$$
	

CREATE TRIGGER del
	
	     BEFORE DELETE
		 ON orders
		 FOR EACH ROW
		      EXECUTE PROCEDURE deleting_trig();




----TRIGGERS FOR BOTH ADMIN AND PRODUCT TABLE FOR UPDATION AND DELETION-----
create table one_change(
one_id SERIAL PRIMARY KEY,
e_id INT NOT NULL,
username varchar(55),
roles varchar(55),
permissions varchar(55)
)
create table two_change(
two_id SERIAL PRIMARY KEY,
p_id INT NOT NULL,
	p_name varchar(55),
catagory varchar(55)
)



CREATE OR REPLACE FUNCTION fn_adm()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
	AS
	$$
		BEGIN
			IF (TG_OP = 'UPDATE') THEN
				IF NEW.username <> OLD.username OR 
				   NEW.roles <> OLD.roles OR 
				   NEW.permissions <> OLD.permissions THEN
					
					INSERT INTO one_change(e_id,username,roles,permissions)
					VALUES(OLD.e_id,OLD.username,OLD.roles,OLD.permissions);
				
				END IF;
				RETURN NEW;
			ELSEIF (TG_OP = 'DELETE') THEN
				INSERT INTO one_change(e_id,username,roles,permissions)
				VALUES(OLD.e_id,OLD.username,OLD.roles,OLD.permissions);
			RETURN OLD;
			END IF;
		END;
	$$

CREATE TRIGGER xy
BEFORE UPDATE OR DELETE 
ON admin
FOR EACH ROW
EXECUTE PROCEDURE fn_adm();



CREATE OR REPLACE FUNCTION fn_pro()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
	AS
	$$
		BEGIN
			IF (TG_OP = 'UPDATE') THEN
				IF NEW.p_name <> OLD.p_name OR  
				   NEW.catagory <> OLD.catagory THEN
					
					INSERT INTO two_change(p_id,p_name,catagory)
					VALUES(OLD.p_id,OLD.p_name,OLD.catagory);
				
				END IF;
				RETURN NEW;
			ELSEIF (TG_OP = 'DELETE') THEN
				INSERT INTO two_change(p_id,p_name,catagory)
				VALUES(OLD.p_id,OLD.p_name,OLD.catagory);
			RETURN OLD;
			END IF;
		END;
	$$

CREATE TRIGGER yz
BEFORE UPDATE OR DELETE 
ON product
FOR EACH ROW
EXECUTE PROCEDURE fn_pro();



 

 ------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX---------------------------------



---Queries for Mongodb Assignment---

db.Enrollment.insertMany([{
     admin : "Divyansh",
    session:"Physics",
    assignment:"Unit-2"
},
     {
     admin : "Piyush",
    session:"Mathematics",
    assignment:"Unit-3"
         },
     {
         admin : "Abhay",
    session:"History",
    assignment:"Unit-3"
        },
        {     
    admin : "Shuchita",
    session:"Accounts",
    assignment:"Unit-6"
        }])



		------Command for Updating data ------

		db.Enrollment.updateMany({admin:'Piyush'},{
    $set : {admin : 'Raghvendra'
        }})


		----Command for deleting the data-----

		 db.orders.deleteMany( { admin : "Abhay"} );