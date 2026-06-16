<%-- 
    Document   : insertAuthor
    Created on : 17 May 2026, 9:29:04?pm
    Author     : Acer
--%>


<html>
    <head>
        <title>Insert Author</title>
    </head>
    <body>

        <h1>Author Registration Form</h1>

        <form action="processAuthor.jsp" method="post">

            <table border="1" cellpadding="5">

                <tr>
                    <td>Author No</td>
                    <td>
                        <input type="text" name="authno">
                    </td>
                </tr>

                <tr>
                    <td>Name</td>
                    <td>
                        <input type="text" name="name">
                    </td>
                </tr>

                <tr>
                    <td>Address</td>
                    <td>
                        <input type="text" name="address">
                    </td>
                </tr>
                <tr>
                    <td>City</td>
                    <td>
                        <input type="text" name="city">
                    </td>
                </tr>

                <tr>
                    <td>State</td>
                    <td>
                        <input type="text" name="state">
                    </td>
                </tr>

                <tr>
                    <td>Zip</td>
                    <td>
                        <select name="zip">
                            <option value="21000">21000</option>
                            <option value="22000">22000</option>
                            <option value="23000">23000</option>
                            <option value="24000">24000</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <input type="submit" value="Submit">
                        <input type="reset" value="Cancel">
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>