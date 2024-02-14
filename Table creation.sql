-- Create tables
CREATE TABLE Customer (
    name VARCHAR(50) PRIMARY KEY,
    address VARCHAR(255),
    category INT
);

CREATE TABLE Assembly (
    assembly_id INT PRIMARY KEY,
    date_ordered DATE,
    assembly_details VARCHAR(255)
);

CREATE TABLE Orders (
    assembly_id INT,
    name VARCHAR(50),
    PRIMARY KEY (assembly_id),
    FOREIGN KEY (assembly_id) REFERENCES Assembly(assembly_id),
    FOREIGN KEY (name) REFERENCES Customer(name)
);



CREATE TABLE Process (
    process_id INT PRIMARY KEY,
    process_data VARCHAR(255)
);

CREATE TABLE Fit (
    process_id INT PRIMARY KEY,
    fit_type VARCHAR(255),
    FOREIGN KEY (process_id) REFERENCES Process(process_id)
);

CREATE TABLE Paint (
    process_id INT PRIMARY KEY,
    paint_type VARCHAR(255),
    painting_method VARCHAR(255),
    FOREIGN KEY (process_id) REFERENCES Process(process_id)
);

CREATE TABLE Cut (
    process_id INT PRIMARY KEY,
    cutting_type VARCHAR(255),
    machine_type VARCHAR(255),
    FOREIGN KEY (process_id) REFERENCES Process(process_id)
);


CREATE TABLE Job (
    job_no INT PRIMARY KEY,
    date_started DATE,
    date_completed DATE
);

CREATE TABLE Fit_Job (
    job_no INT PRIMARY KEY,
    labour_time INT,
    FOREIGN KEY (job_no) REFERENCES Job(job_no)
);

CREATE TABLE Paint_Job (
    job_no INT PRIMARY KEY,
    color VARCHAR(50),
    volume VARCHAR(20),
    labour_time INT,
    FOREIGN KEY (job_no) REFERENCES Job(job_no)
);

CREATE TABLE Cut_Job (
    job_no INT PRIMARY KEY,
    machine_used VARCHAR(50),
    time_machine_used VARCHAR(20),
    material_used VARCHAR(50),
    labour_time INT,
    FOREIGN KEY (job_no) REFERENCES Job(job_no)
);

CREATE TABLE Manufacture (
    assembly_id INT,
    process_id INT,
    job_no INT,
    PRIMARY KEY (assembly_id, process_id, job_no),
    FOREIGN KEY (assembly_id) REFERENCES Assembly(assembly_id),
    FOREIGN KEY (process_id) REFERENCES Process(process_id),
    FOREIGN KEY (job_no) REFERENCES Job(job_no)
);

CREATE TABLE Supervise (
    process_id INT,
    department_no INT,
    PRIMARY KEY (process_id, department_no),
    FOREIGN KEY (process_id) REFERENCES Process(process_id)
);

CREATE TABLE Department (
    department_no INT PRIMARY KEY,
    department_data VARCHAR(255)
);

CREATE TABLE Process_acc (
    process_acc_num INT PRIMARY KEY,
    details_1 INT,
    date_established DATE,
    process_id INT,
    FOREIGN KEY (process_id) REFERENCES Process(process_id)
);

CREATE TABLE Assembly_acc (
    assembly_acc_num INT PRIMARY KEY,
    details_2 INT,
    assembly_id INT,
    date_established DATE,
    FOREIGN KEY (assembly_id) REFERENCES Assembly(assembly_id)
);

CREATE TABLE Department_acc (
    depart_acc_num INT PRIMARY KEY,
    details_3 INT,
    date_established DATE,
    department_no INT,
    FOREIGN KEY (department_no) REFERENCES Department(department_no)
);


CREATE TABLE Transact (
    transaction_num INT PRIMARY KEY,
    sup_cost INT
);

CREATE TABLE Records (
    transaction_num INT PRIMARY KEY,
    job_no INT,
    FOREIGN KEY (job_no) REFERENCES Job(job_no),
    FOREIGN KEY (transaction_num) REFERENCES Transact(transaction_num)
);

CREATE TABLE Updates (
    transaction_num INT PRIMARY KEY,
    process_acc_num INT,
    assembly_acc_num INT,
    dept_acc_num INT,
    FOREIGN KEY (process_acc_num) REFERENCES Process_acc(process_acc_num),
    FOREIGN KEY (assembly_acc_num) REFERENCES Assembly_acc(assembly_acc_num),
    FOREIGN KEY (dept_acc_num) REFERENCES Department_acc(depart_acc_num),
    FOREIGN KEY (transaction_num) REFERENCES Transact(transaction_num)
);