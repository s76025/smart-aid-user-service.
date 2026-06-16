package com.lab.controller;

import com.lab.bean.StudentBean;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;

/**
 * Name : Noor Izza Hazira bt Norddin 
 * Matric no : S76025
 */
import javax.servlet.http.HttpServletResponse;

public class StudentListServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

// Create a list to hold student objects
        List<StudentBean> stdList = new ArrayList<>();

// Adding sample data
        StudentBean s1 = new StudentBean();
        s1.setName("Ali bin Abu");
        s1.setMatricNo("S111");
        StudentBean s2 = new StudentBean();
        s2.setName("Siti Aminah");
        s2.setMatricNo("S222");
        StudentBean s3 = new StudentBean();
        s3.setName("Muthusamy");
        s3.setMatricNo("S333");
        stdList.add(s1);
        stdList.add(s2);
        stdList.add(s3);
// Share data with JSP
        request.setAttribute("listData", stdList);
// Forward to View
        RequestDispatcher rd = request.getRequestDispatcher("displayList.jsp");
        rd.forward(request, response);
    }
}
