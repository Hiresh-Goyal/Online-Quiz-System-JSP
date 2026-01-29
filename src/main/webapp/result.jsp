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
    <title>Quiz Result</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f8;
        }

        .container {
            width: 60%;
            margin: 50px auto;
        }

        .score-card {
            background: #ffffff;
            padding: 30px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }

        .username {
            font-size: 22px;
            margin-bottom: 10px;
        }

        .score {
            font-size: 60px;
            color: #28a745;
            margin: 15px 0;
        }

        .total {
            font-size: 18px;
            color: #555;
        }

        .wrong-card {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 15px;
            box-shadow: 0 0 8px rgba(0,0,0,0.08);
            border-left: 5px solid #dc3545;
        }

        .wrong-card h4 {
            color: #dc3545;
            margin-bottom: 8px;
        }

        .correct {
            color: #28a745;
            font-weight: bold;
        }

        .btn {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 20px;
            background: #007bff;
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
        }

        .btn:hover {
            background: #0056b3;
        }
    </style>
</head>

<body>

<div class="container">

<%
    String name = request.getParameter("username");


    int score = 0;
    int num_questions = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(url, username, pass);
        Statement st = con.createStatement(
        	    ResultSet.TYPE_SCROLL_INSENSITIVE,
        	    ResultSet.CONCUR_READ_ONLY
        	);

        ResultSet rs = st.executeQuery("SELECT * FROM questions");
%>

    <div class="score-card">
        <div class="username">👋 Hello, <b><%= name %></b></div>

<%
        while (rs.next()) {
            num_questions++;
            int correct_option = rs.getInt("correct_option");
            int option_selected = Integer.parseInt(request.getParameter("q" + num_questions));

            if (option_selected == correct_option) {
                score++;
            }
        }
%>

        <div class="score"><%= score %></div>
        <div class="total">out of <b><%= num_questions %></b></div>
    </div>

<%
        // Re-run to show wrong answers
        rs.beforeFirst();
        int q = 0;

        while (rs.next()) {
            q++;
            int correct_option = rs.getInt("correct_option");
            int option_selected = Integer.parseInt(request.getParameter("q" + q));

            if (option_selected != correct_option) {
%>

    <div class="wrong-card">
        <h4>❌ Wrong Answer</h4>
        <p><b>Question:</b> <%= rs.getString("question") %></p>
        <p class="correct">
            Correct Answer:
            <%= rs.getString("option" + correct_option) %>
        </p>
    </div>

<%
            }
        }

        // Insert result into DB
        String insert_query = "INSERT INTO results(username, score, max_score) VALUES (?, ?, ?)";
        PreparedStatement insert = con.prepareStatement(insert_query);
        insert.setString(1, name);
        insert.setInt(2, score);
        insert.setInt(3, num_questions);
        insert.executeUpdate();

        con.close();
    } catch (Exception e) {
        out.println("Error: " + e);
    }
%>

    <a href="index.html" class="btn">Go to Home Page</a>

</div>

</body>
</html>
