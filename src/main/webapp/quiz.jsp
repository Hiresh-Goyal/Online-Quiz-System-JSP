<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.Properties, java.io.InputStream" %>

<%
Properties prop = new Properties();
InputStream in = application.getResourceAsStream("/WEB-INF/db.properties");
prop.load(in);

String url = prop.getProperty("db.url");
String username = prop.getProperty("db.username");
String pass = prop.getProperty("db.password");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Quiz</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f8;
        }

        .quiz-container {
            width: 60%;
            margin: 40px auto;
            background: #ffffff;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        .question {
            margin-bottom: 25px;
        }

        .question h3 {
            margin-bottom: 10px;
        }

        .option {
        	display: block;		
            margin: 6px 0;
            padding: 8px;
            background: #f1f1f1;
            border-radius: 5px;
            cursor: pointer;
        }

        .option input {
            margin-right: 10px;
        }

        .submit-btn {
            margin-top: 20px;
            padding: 12px 20px;
            background: #007bff;
            border: none;
            color: white;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
        }

        .submit-btn:hover {
            background: #0056b3;
        }
        
        .option input[type="text"]
        {
		    font-size: 15px;
		}
        
    </style>
</head>

<body>

<div class="quiz-container">
    <h2>Online Quiz</h2>

    <form action="result.jsp" method="post">

		<h3>Student Details</h3>

		<label class="option">
			<input type="text"
				name="username"
				placeholder="Enter username"
				required
		        style="width: 100%; border: none; background: transparent; outline: none;">
		    </label>
		    
        <%

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection(url, username, pass);
                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery("SELECT * FROM questions");

                int i = 1;
                while (rs.next()) {
        %>

        <div class="question">
        	
        	
        
        
            <h3>Question <%= i %></h3>
            <p><%= rs.getString("question") %></p>

            <label class="option">
                <input type="radio" name="q<%= i %>" value="1" required>
                <%= rs.getString("option1") %>
            </label>

            <label class="option">
                <input type="radio" name="q<%= i %>" value="2">
                <%= rs.getString("option2") %>
            </label>

            <label class="option">
                <input type="radio" name="q<%= i %>" value="3">
                <%= rs.getString("option3") %>
            </label>

            <label class="option">
                <input type="radio" name="q<%= i %>" value="4">
                <%= rs.getString("option4") %>
            </label>
        </div>

        <%
                    i++;
                }
                con.close();
            } catch (Exception e) {
                out.println("Error: " + e);
            }
        %>

        <button type="submit" class="submit-btn">Submit Quiz</button>
    </form>
</div>

</body>
</html>
