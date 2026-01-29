<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>Add Question</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f8;
        }

        .container {
            width: 50%;
            margin: 60px auto;
            background: #ffffff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
        }

        .field {
            margin-bottom: 15px;
        }

        .field label {
            font-weight: bold;
            display: block;
            margin-bottom: 5px;
        }

        .field input,
        .field textarea,
        .field select {
            width: 100%;
            padding: 10px;
            font-size: 15px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        textarea {
            resize: none;
            height: 80px;
        }

        .btn {
            width: 100%;
            padding: 12px;
            font-size: 17px;
            background: #007bff;
            border: none;
            color: white;
            border-radius: 6px;
            cursor: pointer;
            margin-top: 10px;
        }

        .btn:hover {
            background: #0056b3;
        }

        .success {
            background: #d4edda;
            color: #155724;
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 15px;
            text-align: center;
        }

        .error {
            background: #f8d7da;
            color: #721c24;
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 15px;
            text-align: center;
        }
    </style>
</head>

<body>

<div class="container">
    <h2>Add New Question</h2>

<%
    String submitted = request.getParameter("submit");

    if (submitted != null) {

        String question = request.getParameter("question");
        String option_1 = request.getParameter("option_1");
        String option_2 = request.getParameter("option_2");
        String option_3 = request.getParameter("option_3");
        String option_4 = request.getParameter("option_4");
        int correct_op = Integer.parseInt(request.getParameter("correct_op"));

        String url = "jdbc:mysql://localhost:3306/quizdb";
        String dbUser = "root";
        String dbPass = "Hiresh@2007";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(url, dbUser, dbPass);

            String sql = "INSERT INTO questions(question, option1, option2, option3, option4, correct_option) VALUES (?,?,?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, question);
            ps.setString(2, option_1);
            ps.setString(3, option_2);
            ps.setString(4, option_3);
            ps.setString(5, option_4);
            ps.setInt(6, correct_op);

            int rows = ps.executeUpdate();

            if (rows > 0) {
%>
                <div class="success">✅ Question added successfully!</div>
<%
            }

            con.close();
        } catch (Exception e) {
%>
            <div class="error">❌ Error: <%= e.getMessage() %></div>
<%
        }
    }
%>

    <form method="post">
        <div class="field">
            <label>Question</label>
            <textarea name="question" required></textarea>
        </div>

        <div class="field">
            <label>Option 1</label>
            <input type="text" name="option_1" required>
        </div>

        <div class="field">
            <label>Option 2</label>
            <input type="text" name="option_2" required>
        </div>

        <div class="field">
            <label>Option 3</label>
            <input type="text" name="option_3" required>
        </div>

        <div class="field">
            <label>Option 4</label>
            <input type="text" name="option_4" required>
        </div>

        <div class="field">
            <label>Correct Option</label>
            <select name="correct_op" required>
                <option value="">-- Select --</option>
                <option value="1">Option 1</option>
                <option value="2">Option 2</option>
                <option value="3">Option 3</option>
                <option value="4">Option 4</option>
            </select>
        </div>

        <button class="btn" name="submit">Add Question</button>
    </form>
    <form action="index.html">
    	<button class="btn" name="submit">Go to Home Page</button>
    </form>
</div>

</body>
</html>
