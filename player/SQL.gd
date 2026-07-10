extends NinePatchRect

var SQL_chapter_list = [
	{
		"title": "What is SQL?",
		"description": "Structured Query Language (SQL) is the standard programming language specifically engineered to communicate with and manipulate relational databases. Imagine it as a standardized bridge allowing users, applications, and frameworks to directly interface with complex collections of structured data.\n\nCore Purpose: It permits users to create databases, organize internal architecture, insert records, change properties, and selectively pull out specific information based on intricate filters."
	},
	{
		"title": "What is a Database?",
		"description": "A database is an organized collection of structured information, or data, stored electronically in a computer system. Unlike a simple text document or a flat spreadsheet, a relational database holds data structured into distinct tables, linking relevant tables together to prevent redundancies."
	},
	{
		"title": "SQL Syntax Basics",
		"description": "SQL relies on a predictable clause structure composed of declarative keywords. Writing SQL mirrors building readable logical instructions using standard English-like vocabulary.\n\nCrucial Rules:\n1. Case Insensitivity: Keywords (SELECT, FROM) are case-insensitive, but capitalizing them is best practice.\n2. Statement Termination: A semicolon (;) explicitly marks the end of an execution chain.\n3. Whitespace Agnostic: Line breaks and spaces are structurally ignored.\n\nExample:\nSELECT * FROM students;"
	},
	{
		"title": "The SELECT Statement",
		"description": "The SELECT statement functions as the primary mechanism for retrieving specific data columns out of tables.\n\nSyntax:\nSELECT column1, column2 FROM table_name;\n\nExample:\nSELECT name FROM students;\n\n(The asterisk * acts as a catch-all wildcard telling the engine to extract every single column available inside the target table.)"
	},
	{
		"title": "The FROM Clause",
		"description": "The FROM clause tells the query planner exactly which table repository should be pulled from to extract the requested columns.\n\nSyntax:\nSELECT * FROM target_table;\n\nExample:\nSELECT * FROM students;"
	},
	{
		"title": "The WHERE Clause",
		"description": "The WHERE clause allows you to filter records by specifying conditional criteria. The engine will inspect rows and only return rows where the statement resolves to TRUE.\n\nComparison Operators: =, >, <, >=, <=\n\nExample:\nSELECT * FROM students WHERE age > 18;"
	},
	{
		"title": "Logical Operators",
		"description": "Logical operators are used to combine multiple filters inside a single WHERE clause, or to negate a condition entirely.\n\n• AND: Returns records only if ALL conditions are completely satisfied.\n• OR: Returns records if ANY of the conditions are satisfied.\n• NOT: Inverts the logic; returns records where criteria is false.\n\nExample:\nSELECT * FROM employees WHERE salary > 5000 AND department = 'IT';"
	},
	{
		"title": "The ORDER BY Clause",
		"description": "The ORDER BY clause is used to sort the fetched result set in either ascending or descending order.\n\nSorting Keywords:\n• ASC: Sorts results in ascending order (default behavior).\n• DESC: Sorts results in descending order (highest to lowest, Z to A).\n\nExample:\nSELECT * FROM products ORDER BY price DESC;"
	},
	{
		"title": "The DISTINCT Keyword",
		"description": "The DISTINCT keyword is used inside a SELECT statement to filter out duplicate rows, returning only unique values from the specified column.\n\nExample:\nSELECT DISTINCT city FROM customers;"
	},
	{
		"title": "Aggregate Functions",
		"description": "Aggregate functions perform mathematical calculations on a set of column values and return a single summarizing value.\n\nSupported Primary Aggregates:\n• COUNT(): Returns the total number of rows matching criteria.\n• SUM(): Calculates the total combined sum of a numeric column.\n• AVG(): Determines the calculated arithmetic mean.\n• MAX() / MIN(): Pulls the absolute largest or lowest values.\n\nExample:\nSELECT COUNT(*) FROM orders;\nSELECT AVG(salary) FROM employees;"
	},
	{
		"title": "The GROUP BY Clause",
		"description": "The GROUP BY clause groups rows that have the same values into summary rows. It is frequently combined with aggregate functions to calculate metrics across categories.\n\nExample:\nSELECT customer_id, COUNT(*) FROM orders GROUP BY customer_id;"
	},
	{
		"title": "The HAVING Clause",
		"description": "The HAVING clause acts exactly like a WHERE filter, but is evaluated AFTER groups are formed. It was added because the WHERE keyword cannot be applied to aggregate function values.\n\nKey Structural Difference:\n• WHERE: Filters individual raw records BEFORE grouping occurs.\n• HAVING: Filters aggregated group summaries AFTER grouping occurs.\n\nExample:\nSELECT customer_id, COUNT(*) FROM orders GROUP BY customer_id HAVING COUNT(*) > 5;"
	},
	{
		"title": "JOIN Operations",
		"description": "A JOIN clause is used to combine rows from two or more tables, based on a related common column between them.\n\nJoin Variations:\n• INNER JOIN: Returns records that have matching values in both connected tables.\n• LEFT JOIN: Returns all records from the left table, and the matched records from the right table (returns NULL if no match exists).\n\nExample:\nSELECT c.name, o.order_id FROM customers c INNER JOIN orders o ON c.id = o.customer_id;"
	},
	{
		"title": "The LIKE Operator",
		"description": "The LIKE operator is used in a WHERE clause to search for a specific text pattern within a column.\n\nStandard Pattern Wildcards:\n• % (Percent Sign): Represents zero, one, or multiple arbitrary characters.\n• _ (Underscore): Represents exactly one single character placeholder.\n\nExample:\nSELECT * FROM users WHERE name LIKE 'A%';"
	},
	{
		"title": "BETWEEN & IN Operators",
		"description": "These operators provide shorthand structures to check sets of ranges or explicit list values without stacking messy, repetitive OR blocks.\n\n• BETWEEN: Selects values within an inclusive range (numbers, text, or dates).\n• IN: Allows you to specify multiple alternative values inside a matching set container.\n\nExample:\nSELECT * FROM students WHERE age BETWEEN 18 AND 25;\nSELECT * FROM customers WHERE city IN ('Manila', 'Cebu');"
	},
	{
		"title": "Subqueries",
		"description": "A subquery is a nested inner query nested inside a larger outer SQL query statement block. The inner query passes its results directly up to the outer parent instruction.\n\nExample:\nSELECT * FROM employees WHERE salary > (SELECT AVG(salary) FROM employees);"
	},
	{
		"title": "The LIMIT Clause",
		"description": "The LIMIT clause restricts the total number of rows returned by the query. This helps optimize application performance and pagination workflows.\n\nExample:\nSELECT * FROM employees LIMIT 5;"
	}
]

func _ready():
	_on_Button1_pressed()

func _on_Button1_pressed():
	var chapter = SQL_chapter_list[0]
	$"Content panel/Contents".scroll_vertical = 0
	$"Content panel/Contents/VBoxContainer/Title".text = chapter["title"]
	$"Content panel/Contents/VBoxContainer/Description".text = chapter["description"]


func _on_Button2_pressed():
	var chapter = SQL_chapter_list[1]
	$"Content panel/Contents".scroll_vertical = 0
	$"Content panel/Contents/VBoxContainer/Title".text = chapter["title"]
	$"Content panel/Contents/VBoxContainer/Description".text = chapter["description"]


func _on_Button3_pressed():
	var chapter = SQL_chapter_list[2]
	$"Content panel/Contents".scroll_vertical = 0
	$"Content panel/Contents/VBoxContainer/Title".text = chapter["title"]
	$"Content panel/Contents/VBoxContainer/Description".text = chapter["description"]


func _on_Button4_pressed():
	var chapter = SQL_chapter_list[3]
	$"Content panel/Contents".scroll_vertical = 0
	$"Content panel/Contents/VBoxContainer/Title".text = chapter["title"]
	$"Content panel/Contents/VBoxContainer/Description".text = chapter["description"]


func _on_Button5_pressed():
	var chapter = SQL_chapter_list[4]
	$"Content panel/Contents".scroll_vertical = 0
	$"Content panel/Contents/VBoxContainer/Title".text = chapter["title"]
	$"Content panel/Contents/VBoxContainer/Description".text = chapter["description"]


func _on_Button6_pressed():
	var chapter = SQL_chapter_list[5]
	$"Content panel/Contents".scroll_vertical = 0
	$"Content panel/Contents/VBoxContainer/Title".text = chapter["title"]
	$"Content panel/Contents/VBoxContainer/Description".text = chapter["description"]


func _on_Button7_pressed():
	var chapter = SQL_chapter_list[6]
	$"Content panel/Contents".scroll_vertical = 0
	$"Content panel/Contents/VBoxContainer/Title".text = chapter["title"]
	$"Content panel/Contents/VBoxContainer/Description".text = chapter["description"]

func _on_Button8_pressed():
	var chapter = SQL_chapter_list[7]
	$"Content panel/Contents".scroll_vertical = 0
	$"Content panel/Contents/VBoxContainer/Title".text = chapter["title"]
	$"Content panel/Contents/VBoxContainer/Description".text = chapter["description"]


func _on_Button9_pressed():
	var chapter = SQL_chapter_list[8]
	$"Content panel/Contents".scroll_vertical = 0
	$"Content panel/Contents/VBoxContainer/Title".text = chapter["title"]
	$"Content panel/Contents/VBoxContainer/Description".text = chapter["description"]


func _on_Button10_pressed():
	var chapter = SQL_chapter_list[9]
	
	$"Content panel/Contents/VBoxContainer/Title".text = chapter["title"]
	$"Content panel/Contents/VBoxContainer/Description".text = chapter["description"]


func _on_Button11_pressed():
	var chapter = SQL_chapter_list[10]
	$"Content panel/Contents".scroll_vertical = 0
	$"Content panel/Contents/VBoxContainer/Title".text = chapter["title"]
	$"Content panel/Contents/VBoxContainer/Description".text = chapter["description"]


func _on_Button12_pressed():
	var chapter = SQL_chapter_list[11]
	$"Content panel/Contents".scroll_vertical = 0
	$"Content panel/Contents/VBoxContainer/Title".text = chapter["title"]
	$"Content panel/Contents/VBoxContainer/Description".text = chapter["description"]


func _on_Button13_pressed():
	var chapter = SQL_chapter_list[12]
	$"Content panel/Contents".scroll_vertical = 0
	$"Content panel/Contents/VBoxContainer/Title".text = chapter["title"]
	$"Content panel/Contents/VBoxContainer/Description".text = chapter["description"]


func _on_Button14_pressed():
	var chapter = SQL_chapter_list[13]
	$"Content panel/Contents".scroll_vertical = 0
	$"Content panel/Contents/VBoxContainer/Title".text = chapter["title"]
	$"Content panel/Contents/VBoxContainer/Description".text = chapter["description"]


func _on_Button15_pressed():
	var chapter = SQL_chapter_list[14]
	$"Content panel/Contents".scroll_vertical = 0
	$"Content panel/Contents/VBoxContainer/Title".text = chapter["title"]
	$"Content panel/Contents/VBoxContainer/Description".text = chapter["description"]


func _on_Button16_pressed():
	var chapter = SQL_chapter_list[15]
	$"Content panel/Contents".scroll_vertical = 0
	$"Content panel/Contents/VBoxContainer/Title".text = chapter["title"]
	$"Content panel/Contents/VBoxContainer/Description".text = chapter["description"]


func _on_Button17_pressed():
	var chapter = SQL_chapter_list[16]
	$"Content panel/Contents".scroll_vertical = 0
	$"Content panel/Contents/VBoxContainer/Title".text = chapter["title"]
	$"Content panel/Contents/VBoxContainer/Description".text = chapter["description"]
