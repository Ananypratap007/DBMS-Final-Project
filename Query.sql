
--CREATE PROCEDURE <Procedure_Name>
--AS
--BEGIN
--<SQL Statement(s)>
--END
--GO


-- 1. Enter a new customer
DROP PROCEDURE IF EXISTS EnterNewCustomer;
GO
CREATE PROCEDURE EnterNewCustomer
    @p_name VARCHAR(255),
    @p_address VARCHAR(255),
    @p_category INT
AS
BEGIN
    INSERT INTO Customer (name, address, category) VALUES (@p_name, @p_address, @p_category);
END;
--GO
--EXEC EnterNewCustomer @p_name = 'test', @p_address = "test address", @p_category = 3;

-- 2. Enter a new department
DROP PROCEDURE IF EXISTS EnterNewDepartment;
GO
CREATE PROCEDURE EnterNewDepartment
    @p_department_no INT,
    @p_department_data VARCHAR(255)
AS
BEGIN
    INSERT INTO Department (department_no, department_data) VALUES (@p_department_no, @p_department_data);
END;
--GO
--EXEC EnterNewDepartment @p_department_no = 1, @p_department_data = "test1";


-- 3. Enter a new process-id and its department together with its type and information relevant to the type
DROP PROCEDURE IF EXISTS EnterNewProcess;
GO
CREATE PROCEDURE EnterNewProcess
    @p_process_id INT,
    @p_process_data VARCHAR(255),
    @p_department_no INT,
    @p_type VARCHAR(10),
    @p_fit_type VARCHAR(255),
    @p_paint_type VARCHAR(255),
    @p_paint_method VARCHAR(255),
    @p_cutting_type VARCHAR(255),
    @p_machine_type VARCHAR(255)
AS
BEGIN
    INSERT INTO Process (process_id, process_data) VALUES (@p_process_id, @p_process_data);
    
    IF @p_type = 'Fit' 
    BEGIN
        INSERT INTO Fit (process_id, fit_type) VALUES (@p_process_id, @p_fit_type);

    END
    ELSE IF @p_type = 'Paint' 
    BEGIN
        INSERT INTO Paint (process_id, paint_type, painting_method) VALUES (@p_process_id, @p_paint_type, @p_paint_method);
    END
    ELSE IF @p_type = 'Cut' 
    BEGIN
        INSERT INTO Cut (process_id, cutting_type, machine_type) VALUES (@p_process_id, @p_cutting_type, @p_machine_type);
    END
    
    INSERT INTO Supervise (process_id, department_no) VALUES (@p_process_id, @p_department_no);
END;
--GO
--EXEC EnterNewProcess  @p_process_id = 2,  @p_process_data = 'Process 2',  @p_department_no = 10,  @p_type = 'Fit',  @p_fit_type = 'test_fit', @p_paint_type = NULL, @p_paint_method = NULL,  @p_cutting_type = NULL,  @p_machine_type = NULL;

-- 4. Enter a new assembly with its customer-name, assembly-details, assembly-id, and dateordered
DROP PROCEDURE IF EXISTS EnterNewAssembly;
GO
CREATE PROCEDURE EnterNewAssembly
    @p_assembly_id INT,
    @p_date_ordered DATE,
    @p_assembly_details VARCHAR(255),
    @p_customer_name VARCHAR(255)
AS
BEGIN
    -- Insert into Assembly
    INSERT INTO Assembly (assembly_id, date_ordered, assembly_details) VALUES (@p_assembly_id, @p_date_ordered, @p_assembly_details);

    -- Insert into Orders
    INSERT INTO Orders (assembly_id, name) VALUES (@p_assembly_id, @p_customer_name);

END;
--GO
--EXEC EnterNewAssembly @p_assembly_id = 3, @p_date_ordered = '2023-01-01', @p_assembly_details = 'Assembly 2', @p_customer_name = 'Test';

-- 5. Create a new account and associate it with the process, assembly, or department
DROP PROCEDURE IF EXISTS CreateNewAccount;
GO
CREATE PROCEDURE CreateNewAccount
    @account_type VARCHAR(15),
    @process_account_num INT,
    @assembly_account_num INT,
    @department_account_num INT,
    @date_established DATE,
    @p_details_1 INT,
    @p_details_2 INT,
    @p_details_3 INT,
    @p_process_id INT,
    @p_assembly_id INT,
    @p_department_no INT

AS
BEGIN

    IF @account_type = 'Process' 
    BEGIN
        INSERT INTO Process_acc (process_acc_num, details_1, date_established, process_id) VALUES (@process_account_num, @p_details_1, @date_established, @p_process_id);

    END
    ELSE IF @account_type = 'Assembly' 
    BEGIN
         INSERT INTO Assembly_acc (assembly_acc_num, details_2, date_established, assembly_id) VALUES (@assembly_account_num, @p_details_2, @date_established, @p_assembly_id);
    END
    ELSE IF @account_type = 'Department' 
    BEGIN
        INSERT INTO Department_acc (depart_acc_num, details_3, date_established, department_no) VALUES (@department_account_num, @p_details_3, @date_established, @p_department_no);
    END
END;

--GO
--EXEC CreateNewAccount @account_type = 'Assembly', @process_account_num = NULL, @assembly_account_num = 1, @department_account_num = NULL, @date_established = '2023-11-14', @p_details_1 = NULL, @p_details_2 = 'test_details 1', @p_details_3 = NULL,  @p_process_id = NULL, @p_assembly_id = 1, @p_department_no = NULL;


-- 6. Enter a new job, given its job-no, assembly-id, process-id, and date the job commenced
DROP PROCEDURE IF EXISTS EnterNewJob;
GO
CREATE PROCEDURE EnterNewJob
    @p_job_no INT,
    @p_assembly_id INT,
    @p_process_id INT,
    @p_date_started DATE
AS
BEGIN
    INSERT INTO Job (job_no, date_started) VALUES (@p_job_no, @p_date_started);
    
    -- Insert into Assigned
    INSERT INTO Manufacture(assembly_id, process_id, job_no) VALUES (@p_assembly_id, @p_process_id, @p_job_no);
END;
--GO
--EXEC EnterNewJob @p_job_no = 1, @p_assembly_id = 1, @p_process_id = '1', @p_date_started = '2023-01-01';


-- 7. At the completion of a job, enter the date it completed and the information relevant to the type of job
DROP PROCEDURE IF EXISTS CompleteJob;
GO
CREATE PROCEDURE CompleteJob
    @job_type VARCHAR(15),
    @p_job_no INT,
    @p_date_completed DATE,
    @labour_time VARCHAR(20),
    @color VARCHAR(50),
    @volume VARCHAR(20),
    @machine_used VARCHAR(50),
    @time_machine_used VARCHAR(50),
    @material_used VARCHAR(50)
AS
BEGIN
    UPDATE Job SET date_completed = @p_date_completed WHERE job_no = @p_job_no;

    IF @job_type = 'Fit' 
    BEGIN
        INSERT INTO Fit_Job (job_no, labour_time)
        VALUES (@p_job_no, @labour_time);
    END
    ELSE IF @job_type = 'Paint' 
    BEGIN
        INSERT INTO Paint_Job (job_no, labour_time, color, volume)
        VALUES (@p_job_no, @labour_time, @color, @volume);
    END
    ELSE IF @job_type = 'Cut' 
    BEGIN
        INSERT INTO Cut_Job (job_no, time_machine_used, machine_used, material_used, labour_time)
        VALUES (@p_job_no, @time_machine_used, @machine_used, @material_used, @labour_time);
    END
END;
--GO
--EXEC CompleteJob @job_type = 'Fit', @p_job_no = 1, @p_date_completed = '2023-02-02', @labour_time = "1 hour", @color = NULL, @volume = NULL,  @machine_used = 'your-machine', @time_machine_used = NULL, @material_used = 'your-material';








-- 8.	Enter a transaction-no and its sup-cost and update all the costs (details) of the affected accounts by adding sup-cost to their current values of details
DROP PROCEDURE IF EXISTS UpdateAccountDetailsWithInsert;
GO

-- Create the procedure
CREATE PROCEDURE UpdateAccountDetailsWithInsert
    @p_transaction_num INT,
    @p_sup_cost INT,
    @p_assembly_acc_num INT,
    @p_dept_acc_num INT,
    @p_process_acc_num INT
AS
BEGIN
    -- 1. Insert into Transact table
    INSERT INTO Transact (transaction_num, sup_cost)
    VALUES (@p_transaction_num, @p_sup_cost);

    -- 5. Insert into Updates table
    INSERT INTO Updates (transaction_num, process_acc_num, assembly_acc_num, dept_acc_num)
    VALUES (@p_transaction_num, @p_process_acc_num, @p_assembly_acc_num, @p_dept_acc_num);

    -- 2. Update Assembly Account details
    UPDATE Assembly_acc
    SET details_2 = details_2 + @p_sup_cost
    WHERE assembly_acc_num = @p_assembly_acc_num;

    -- 3. Update Department Account details
    UPDATE Department_acc
    SET details_3 = details_3 + @p_sup_cost
    WHERE depart_acc_num = @p_dept_acc_num;

    -- 4. Update Process Account details
    UPDATE Process_acc
    SET details_1 = details_1 + @p_sup_cost
    WHERE process_acc_num = @p_process_acc_num;

    
END;


--9.	Retrieve the total cost incurred on an assembly-id (200/day). 

DROP PROCEDURE IF EXISTS GetTotalCostForAssembly;
GO

-- Create the procedure
CREATE PROCEDURE GetTotalCostForAssembly
    @p_assembly_id INT
AS
BEGIN
    SELECT a.assembly_id,
           COALESCE(SUM(p.details_1), 0) + COALESCE(SUM(a.details_2), 0) + COALESCE(SUM(d.details_3), 0) AS total_cost
    FROM Assembly_acc a
    LEFT JOIN Updates u ON a.assembly_acc_num = u.assembly_acc_num
    LEFT JOIN Transact t ON u.transaction_num = t.transaction_num
    LEFT JOIN Process_acc p ON u.process_acc_num = p.process_acc_num
    LEFT JOIN Department_acc d ON u.dept_acc_num = d.depart_acc_num -- Corrected column name
    WHERE a.assembly_id = @p_assembly_id
    GROUP BY a.assembly_id;
END;



-- 10. Retrieve the total labor time within a department for all completed jobs in the department.
DROP PROCEDURE IF EXISTS GetTotalLaborTimeInDepartment;
GO
CREATE PROCEDURE GetTotalLaborTimeInDepartment
    @p_department_no INT
AS
BEGIN
    -- Step 1: Select all processes connected to the given department number
    SELECT p.process_id
    INTO #TempProcesses
    FROM Process p
    JOIN Supervise s ON p.process_id = s.process_id
    WHERE s.department_no = @p_department_no;

    -- Step 2: Select all jobs connected to the selected processes
    SELECT j.job_no
    INTO #TempJobs
    FROM Job j
    JOIN Manufacture m ON j.job_no = m.job_no
    WHERE m.process_id IN (SELECT process_id FROM #TempProcesses);

    -- Step 3: Select completed jobs
    SELECT job_no, labour_time
    INTO #CompletedJobs
    FROM Fit_Job
    WHERE job_no IN (SELECT job_no FROM #TempJobs)
    UNION
    SELECT job_no, labour_time
    FROM Paint_Job
    WHERE job_no IN (SELECT job_no FROM #TempJobs)
    UNION
    SELECT job_no, labour_time
    FROM Cut_Job
    WHERE job_no IN (SELECT job_no FROM #TempJobs)
    AND job_no IN (
        SELECT job_no
        FROM Job
        WHERE date_completed IS NOT NULL
    );

    -- Step 4: Calculate and retrieve the total labor time
    SELECT SUM(labour_time) AS total_labor_time
    FROM #CompletedJobs;

    -- Clean up temporary tables
    DROP TABLE #TempProcesses;
    DROP TABLE #TempJobs;
    DROP TABLE #CompletedJobs;
END;
--GO
--EXEC GetTotalLaborTimeInDepartment @p_department_no = 1;


-- 11. Retrieve the processes and departments for a given assembly-id
DROP PROCEDURE IF EXISTS GetProcessesAndDepartmentsForAssembly;
GO
CREATE PROCEDURE GetProcessesAndDepartmentsForAssembly
    @p_assembly_id INT
AS
BEGIN
    -- Step 1: Select all processes connected to the given assembly-id
    SELECT p.process_id, p.process_data, s.department_no, d.department_data
    INTO #AssemblyProcesses
    FROM Process p
    JOIN Supervise s ON p.process_id = s.process_id
    JOIN Manufacture m ON p.process_id = m.process_id
    JOIN Department d ON s.department_no = d.department_no
    WHERE m.assembly_id = @p_assembly_id
    ORDER BY m.date_started; -- Order by date commenced

    -- Step 2: Return the result
    SELECT * FROM #AssemblyProcesses;

    -- Clean up temporary table
    DROP TABLE #AssemblyProcesses;
END;
--GO
--EXEC GetProcessesAndDepartmentsForAssembly @p_assembly_id = 1;







--12.	Retrieve the customers (in name order) whose category is in a given range (100/day). 
DROP PROCEDURE IF EXISTS GetCustomersInCategoryRange;
GO
CREATE PROCEDURE GetCustomersInCategoryRange
    @p_lower_range INT,
    @p_upper_range INT
AS
BEGIN
    SELECT name, address, category
    FROM Customer
    WHERE category BETWEEN @p_lower_range AND @p_upper_range
    ORDER BY name;
END;

--13.	Delete all cut-jobs whose job-no is in a given range (1/month). 
DROP PROCEDURE IF EXISTS DeleteCutJobsInRange;
GO
CREATE PROCEDURE DeleteCutJobsInRange
    @p_lower_range INT,
    @p_upper_range INT
AS
BEGIN
    DELETE FROM Cut_Job
    WHERE job_no BETWEEN @p_lower_range AND @p_upper_range;
END;

--14.	Change the color of a given paint job (1/week). 

DROP PROCEDURE IF EXISTS ChangePaintJobColor;
GO
CREATE PROCEDURE ChangePaintJobColor
    @p_job_no INT,
    @p_new_color VARCHAR(50)
AS
BEGIN
    UPDATE Paint_Job
    SET color = @p_new_color
    WHERE job_no = @p_job_no;
END;
