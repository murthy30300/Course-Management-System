<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Random Time Table</title>
    <style>
        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
            text-align: center;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
<a href="studenthome.jsp" class="con-anchor" style="text-decoration: none;"><svg
			xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24"
			height="24" color="#000000" fill="none">
    <path
				d="M4.80823 9.44118L6.77353 7.46899C8.18956 6.04799 8.74462 5.28357 9.51139 5.55381C10.4675 5.89077 10.1528 8.01692 10.1528 8.73471C11.6393 8.73471 13.1848 8.60259 14.6502 8.87787C19.4874 9.78664 21 13.7153 21 18C19.6309 17.0302 18.2632 15.997 16.6177 15.5476C14.5636 14.9865 12.2696 15.2542 10.1528 15.2542C10.1528 15.972 10.4675 18.0982 9.51139 18.4351C8.64251 18.7413 8.18956 17.9409 6.77353 16.5199L4.80823 14.5477C3.60275 13.338 3 12.7332 3 11.9945C3 11.2558 3.60275 10.6509 4.80823 9.44118Z"
				stroke="currentColor" stroke-width="1.5" stroke-linecap="round"
				stroke-linejoin="round" />
</svg> back to home</a>
    <h1>Random Time Table</h1>
    <table>
        <tr>
            <th>Day / Period</th>
            <% 
                int numPeriods = 12;
                String[] daysOfWeek = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday"};

                // Randomly decide which rows (days) to fill
                List<Integer> filledRows = new ArrayList<>();
                Random random = new Random();
                while (filledRows.size() < 5) {
                    int randomRow = random.nextInt(5);
                    if (!filledRows.contains(randomRow)) {
                        filledRows.add(randomRow);
                    }
                }

                // Dummy data for demonstration, replace with actual data retrieval from database
                String[][] timetable = new String[5][numPeriods]; // 5 days, 12 periods

                int studentId = 5; // Assume this is retrieved from session or login context

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    //Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
        String dbUser = "avnadmin";
        String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                    // Prepare SQL query to retrieve registered courses for the student
                    String query = "SELECT c.course_code, c.course_name, c.instructor_name " +
                                   "FROM courses c " +
                                   "JOIN registrations r ON c.course_id = r.course_id " +
                                   "WHERE r.student_id = ?";
                    PreparedStatement pstmt = conn.prepareStatement(query);
                    pstmt.setInt(1, studentId);
                    ResultSet rs = pstmt.executeQuery();

                    // Process the result set and populate the timetable randomly
                    while (rs.next()) {
                        // Randomly distribute courses among selected rows (days)
                        int randomRow = filledRows.get(random.nextInt(filledRows.size()));
                        int randomPeriod = random.nextInt(numPeriods);
                        timetable[randomRow][randomPeriod] = rs.getString("course_name");
                    }

                    // Close JDBC objects
                    rs.close();
                    pstmt.close();
                    conn.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }

                // Display timetable in the HTML table
                for (int i = 0; i < numPeriods; i++) {
            %>
            <th><%= "Period " + (i + 1) %></th>
            <% } %>
        </tr>
        <% 
            for (int day = 0; day < 5; day++) { // Iterate over days
        %>
        <tr>
            <td><%= daysOfWeek[day] %></td>
            <% 
                for (int period = 0; period < numPeriods; period++) { // Iterate over periods
            %>
            <td><%= timetable[day][period] != null ? timetable[day][period] : "" %></td>
            <% } %>
        </tr>
        <% } %>
    </table>
</body>
</html>
