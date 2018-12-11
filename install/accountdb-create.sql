CREATE TABLE payments (
	id integer NOT NULL AUTO_INCREMENT,
	invoiceDate DATE,
	bookedDate DATE,
	beneficiary VARCHAR(50),
	description VARCHAR(50),
	nettAmount DOUBLE, 
	vatAmount DOUBLE,
	vatPercentage DOUBLE,
	deductablePercentage DOUBLE,
	nrOfYearsToDeduct INT,
	PRIMARY KEY (id)
) ENGINE=InnoDB;

CREATE TABLE users (
	
	user_id integer NOT NULL AUTO_INCREMENT,
	username VARCHAR(50),
	PRIMARY KEY (user_id),
    UNIQUE KEY (username)

) ENGINE=InnoDB;

CREATE TABLE taxreturn (
	
    taxreturn_id integer NOT NULL AUTO_INCREMENT,
	user_id integer NOT NULL,
	taxyear DATE,
	PRIMARY KEY (taxreturn_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT uc_taxreturn UNIQUE (user_id,taxyear)

) ENGINE=InnoDB;

CREATE TABLE expenses (
	expense_id integer NOT NULL AUTO_INCREMENT,
	invoiceDate DATE,
	bookedDate DATE,
	beneficiary VARCHAR(50),
	description VARCHAR(50),
	nettAmount DOUBLE, 
	vatAmount DOUBLE,
	vatPercentage DOUBLE,
	deductablePercentage DOUBLE,
	nrOfYearsToDeduct INT,
    taxreturn_id integer NOT NULL,
	PRIMARY KEY (expense_id),
    FOREIGN KEY (taxreturn_id) REFERENCES taxreturn(taxreturn_id)
) ENGINE=InnoDB;

CREATE TABLE bankaccounts (
	
    account_id integer NOT NULL AUTO_INCREMENT,
    accountNumber VARCHAR(50),
    bic VARCHAR(10),
	user_id integer NOT NULL,	
	PRIMARY KEY (account_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT uc_account UNIQUE (accountNumber,bic)

) ENGINE=InnoDB;

CREATE TABLE mutations (
	mutation_id integer NOT NULL AUTO_INCREMENT,
	bookedDate DATE,
	bookedAmount DOUBLE, 
	debitCredit VARCHAR(1),
	counterParty VARCHAR(50),
	counterAccountNumber VARCHAR(50),
	bookedCode VARCHAR(10),
	description VARCHAR(50),
    account_id integer NOT NULL,
	PRIMARY KEY (mutation_id),
    FOREIGN KEY (account_id) REFERENCES bankaccounts(account_id)
) ENGINE=InnoDB;

CREATE TABLE expensemutation (
	expense_id integer NOT NULL,
	mutation_id integer NOT NULL,
	bookedDate DATE,
	bookedAmount DOUBLE, 
	debitCredit VARCHAR(1),
	counterParty VARCHAR(50),
	counterAccountNumber VARCHAR(50),
	bookedCode VARCHAR(10),
	description VARCHAR(50),
    account_id integer NOT NULL,
	PRIMARY KEY (expense_id,mutation_id),
    FOREIGN KEY (expense_id) REFERENCES expenses(expense_id),
    FOREIGN KEY (mutation_id) REFERENCES mutations(mutation_id)
) ENGINE=InnoDB;
